//
//  LLSearchView.m
//  LLSearchView
//
//  Created by 王龙龙 on 2017/7/25.
//  Copyright © 2017年 王龙龙. All rights reserved.
//


#define KScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

#define KHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYSearchhistories.plist"]

#define KColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]




#import "LLSearchView.h"

#import "Q_AppointedCropViewControllerViewController.h"


@interface LLSearchView ()

//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) UIView *searchHistoryView;
@property (nonatomic, strong) UIView *hotSearchView;

@end
@implementation LLSearchView

- (instancetype)initWithFrame:(CGRect)frame hotArray:(NSMutableArray *)hotArr historyArray:(NSMutableArray *)historyArr
{
    if (self = [super initWithFrame:frame]) {
        self.historyArray = historyArr;
        self.hotArray = hotArr;
        [self addSubview:self.searchHistoryView];
        [self addSubview:self.hotSearchView];
    }
    return self;
}


- (UIView *)hotSearchView
{
    if (!_hotSearchView) {
        self.hotSearchView = [self setViewWithOriginY:CGRectGetHeight(_searchHistoryView.frame) title:@"热门搜索" textArr:self.hotArray];
    }
    return _hotSearchView;
}

#pragma mark - 设置搜索历史页面 -
- (UIView *)searchHistoryView
{
    if (!_searchHistoryView) {
        if (_historyArray.count > 0) {
            _searchHistoryView = [self setViewWithOriginY:0 title:@"最近搜索" textArr:self.historyArray];
        } else {
            _searchHistoryView = [self setNoHistoryView];
        }
    }
    return _searchHistoryView;
}



- (UIView *)setViewWithOriginY:(CGFloat)riginY title:(NSString *)title textArr:(NSMutableArray *)textArr
{
    UIView *view = [[UIView alloc] init];
    
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, KScreenWidth - 30 - 45, 30)];
    titleL.text = title;
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleL];
    
    if ([title isEqualToString:@"最近搜索"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(KScreenWidth - 45, 10, 28, 30);
        [btn setImage:[UIImage imageNamed:@"sort_recycle"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearnSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    CGFloat y = 10 + 40;
    CGFloat letfWidth = 15;
    for (int i = 0; i < textArr.count; i++) {
        NSString *text = textArr[i];
        CGFloat width = [self getWidthWithStr:text] + 30;
        if (letfWidth + width + 15 > KScreenWidth) {
            if (y >= 130 && [title isEqualToString:@"最近搜索"]) {
                [self removeTestDataWithTextArr:textArr index:i];
                break;
            }
            y += 40;
            letfWidth = 15;
        }
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(letfWidth, y, width, 30)];
        label.userInteractionEnabled = YES;
        label.font = [UIFont systemFontOfSize:12];
        label.text = text;
        label.layer.borderWidth = 0.5;
        label.layer.cornerRadius = 5;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 10000 + i;
        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setFrame:CGRectMake(letfWidth, y, width, 30)];
//        [btn setTitle:text forState:UIControlStateNormal];
//        btn.layer.cornerRadius = 5;
//        btn.clipsToBounds = YES;
//        [view addSubview:btn];
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        btn.tag = 10000 + i;
        
        
        if (i % 2 == 0 && [title isEqualToString:@"热门搜索"]) {
            label.layer.borderColor = KColor(255, 148, 153).CGColor;
            label.textColor = KColor(255, 148, 153);
        } else {
            label.textColor = KColor(111, 111, 111);
            label.layer.borderColor = KColor(227, 227, 227).CGColor;
        }
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [view addSubview:label];
        letfWidth += width + 10;
    }
    view.frame = CGRectMake(0, riginY, KScreenWidth, y + 40);
    return view;
}


//- (void)btnClick:(UIButton *)sender{
//    
//    
//    NSLog(@" dianjil   e     %@",self.historyArray[sender.tag - 10000]);
//}




- (UIView *)setNoHistoryView
{
    UIView *historyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 80)];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, KScreenWidth - 30, 30)];
    titleL.text = @"最近搜索";
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    
    UILabel *notextL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleL.frame) + 10, 100, 20)];
    notextL.text = @"无搜索历史";
    notextL.font = [UIFont systemFontOfSize:12];
    notextL.textColor = [UIColor blackColor];
    notextL.textAlignment = NSTextAlignmentLeft;
    [historyView addSubview:titleL];
    [historyView addSubview:notextL];
    return historyView;
}

- (void)tagDidCLick:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    if (self.tapAction) {
        self.tapAction(label.text);
    }
    
    NSString *cropStr;
    if (label.tag - 10000 > 1) {
        cropStr = self.hotArray[label.tag - 10000];
//        NSLog(@" dfdfdfdfd     %@",self.hotArray[label.tag - 10000]);
    }else{
    
        cropStr = self.historyArray[label.tag - 10000];
//    NSLog(@" dfdfdfdfd     %@",self.historyArray[label.tag - 10000]);
    
        [self.delegate selectedCropClassificationWithCrop:cropStr];
    
    }
    
}




- (CGFloat)getWidthWithStr:(NSString *)text
{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(KScreenWidth, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.width;
    return width;
}


- (void)clearnSearchHistory:(UIButton *)sender
{
    [self.searchHistoryView removeFromSuperview];
    self.searchHistoryView = [self setNoHistoryView];
    [_historyArray removeAllObjects];
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
    [self addSubview:self.searchHistoryView];
    CGRect frame = _hotSearchView.frame;
    frame.origin.y = CGRectGetHeight(_searchHistoryView.frame);
    _hotSearchView.frame = frame;
}

- (void)removeTestDataWithTextArr:(NSMutableArray *)testArr index:(int)index
{
    NSRange range = {index, testArr.count - index - 1};
    [testArr removeObjectsInRange:range];
    [NSKeyedArchiver archiveRootObject:testArr toFile:KHistorySearchPath];
}



@end
