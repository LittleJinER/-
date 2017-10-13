//
//  FertilizerDetailViewController.m
//  小农人
//
//  Created by tomusng on 2017/9/29.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "FertilizerDetailViewController.h"
#import "BaiKeMiniClassModel.h"
#import "FirstHttpRequestManager.h"
#import "LLSearchView.pch"
#import "BaiKeClassViewModel.h"
#import "BaiKeMiniClassCell.h"
#import "BaiKeMiniClassModel.h"

#define ViewWidth [[UIScreen mainScreen] bounds].size.width
#define ViewHeight [[UIScreen mainScreen] bounds].size.height - 64 - MENU_HEIGHT - LINE_HEIGHT

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]
#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]
#define BG_COLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]
#define LIGHT_TITLE_COLOR [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1]

#define CUSTOM_COLOR(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]

#define LINE_HEIGHT 0.5*DISTANCE_WIDTH

#define MENU_BUTTON_WIDTH  [UIScreen mainScreen].bounds.size.width/4.0
#define MENU_HEIGHT 44*DISTANCE_WIDTH
#define ITEM_HEIGHT 38*DISTANCE_WIDTH


@interface FertilizerDetailViewController ()

@property (nonatomic, strong) NSMutableArray *basisArr;

@property (nonatomic, strong) UILabel *textLab;

@property (nonatomic, strong) UIScrollView *bgScroll;

@property (nonatomic, copy) NSMutableArray *textArr;

@property (nonatomic, strong) NSMutableArray *extendedArr;

@property (nonatomic, assign) CGFloat segmentOriginH;

@end

@implementation FertilizerDetailViewController


- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = self.titleName;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:@"home_navigation_back_btn"];
    leftBtn.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [leftBtn setImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
//    创建scrollview
    UIScrollView *bgScroll = [[UIScrollView alloc] init];

    bgScroll.frame = CGRectMake(0, 64, K_WIDTH, K_HETGHT - 64);
    bgScroll.showsVerticalScrollIndicator = NO;
    _bgScroll = bgScroll;
    [self.view addSubview:bgScroll];
    [self getClassDetailData];
    
}

#pragma mark   --- 创建类别label
- (void)createViewUI{
    
    CGFloat space = 10*DISTANCE_WIDTH;
    
    UIView *colorView = [[UIView alloc] init];
//    colorView.backgroundColor = DE_RED_Color;
    colorView.frame = CGRectMake(space/2, 1.1*space, 0.3*space, 1.8*space);
    [_bgScroll addSubview:colorView];
    UILabel *nameLab = [[UILabel alloc] init];
    
    colorView.backgroundColor = CUSTOM_COLOR(70, 161, 236);
    switch (self.colorID) {
        case 100:
        {
            colorView.backgroundColor = CUSTOM_COLOR(252, 86, 56);
        }
            break;
        case 101:
        {
            colorView.backgroundColor = CUSTOM_COLOR(91, 207, 85);
        }
            break;
        case 102:
        {
            colorView.backgroundColor = CUSTOM_COLOR(70, 161, 236);
        }
            break;
            
        default:
            break;
    }
    
    CGRect nameLRect = [self.titleName boundingRectWithSize:CGSizeMake(K_WIDTH - 2*space, 100*DISTANCE_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*DISTANCE_HEIGHT weight:0.5*DISTANCE_HEIGHT]} context:nil];
    
    nameLab.frame = CGRectMake(1.3*space, space, K_WIDTH - 2*space, nameLRect.size.height);
    nameLab.numberOfLines = 0;
    nameLab.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT weight:0.4*DISTANCE_HEIGHT];
    nameLab.text = self.titleName;
    [_bgScroll addSubview:nameLab];
    
    
//    创建类别label
    CGFloat labOriginH = CGRectGetMaxY(nameLab.frame) + space;
    
    for (int i = 0; i < self.basisArr.count; i ++) {
    
        BaiKeMiniClassModel *basisM = _basisArr[i];
        UILabel *basisLab = [[UILabel alloc] init];
        basisLab.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
//        basisLab.text = [NSString stringWithFormat:@"%@%@",basisM.key,basisM.value];
        
        NSString *textStr = [NSString stringWithFormat:@"%@ %@",basisM.key,basisM.value];
        
        NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:textStr];
        
        NSRange markRange = [textStr rangeOfString:basisM.key];
        
        [strAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*DISTANCE_HEIGHT weight:0.3*DISTANCE_HEIGHT] range:markRange];
        basisLab.attributedText = strAtt;
        
        
    
        CGRect basisRect = [basisLab.text boundingRectWithSize:CGSizeMake(K_WIDTH - 2*space, 500*DISTANCE_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*DISTANCE_HEIGHT]} context:nil];
        basisLab.numberOfLines = 0;
       
        basisLab.frame = CGRectMake(space, labOriginH, K_WIDTH - 2*space, basisRect.size.height);
        
        labOriginH += basisRect.size.height + space;
        
        [_bgScroll addSubview:basisLab];
        
        if (i == self.basisArr.count - 1) {
            _segmentOriginH = labOriginH;
        }
    }
    
    [self createSegmentedUI];
    
}


- (NSMutableArray *)textArr{
    
    if (!_textArr) {
        _textArr = [NSMutableArray array];
    }
    return _textArr;
    
}
#pragma mark   -- 创建segmentedUI
- (void)createSegmentedUI{
    
    
    CGFloat space = 10*DISTANCE_WIDTH;
    NSMutableArray *segmentedArray = [NSMutableArray array];
    
//   给segmentedArray  textArr  填充数据
    for (BaiKeMiniClassModel *classModel in self.extendedArr) {
        [segmentedArray addObject:classModel.key];
        [self.textArr addObject:classModel.value];
    }
    
//  初始化UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(space,_segmentOriginH + 0.5*space,K_WIDTH - 2*space,3.5*space);
// 设置默认选择项索引
    segmentedControl.selectedSegmentIndex = 0;
    
    [segmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15*DISTANCE_HEIGHT]} forState:UIControlStateNormal];
    
    switch (self.colorID) {
        case 100:
        {
           segmentedControl.tintColor = CUSTOM_COLOR(252, 86, 56);
        }
            break;
        case 101:
        {
          segmentedControl.tintColor = CUSTOM_COLOR(91, 207, 85);
        }
            break;
        case 102:
        {
            segmentedControl.tintColor = CUSTOM_COLOR(70, 161, 236);
        }
            break;
            
        default:
            break;
    }
//    classView.classLab.textColor = CUSTOM_COLOR(252, 86, 56);
//    classView.classLab.textColor = CUSTOM_COLOR(91, 207, 85);
//    classView.classLab.textColor = CUSTOM_COLOR(70, 161, 236);
//
//    segmentedControl.tintColor = DE_RED_Color;
    
    [segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    
    [_bgScroll addSubview:segmentedControl];
    
    //    百科种类三个叙述label
    UILabel *textLab = [[UILabel alloc] init];

    CGRect textLabRect = [_textArr[0] boundingRectWithSize:CGSizeMake(K_WIDTH - 2*space, K_WIDTH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*DISTANCE_HEIGHT]} context:nil];
    
    CGFloat textLabHeight = textLabRect.size.height;
    textLab.text = _textArr[0];
    textLab.frame = CGRectMake(space, _segmentOriginH + 5.5*space, K_WIDTH - 2*space, textLabHeight);
    textLab.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
    textLab.numberOfLines = 0;
    textLab.textColor = [UIColor blackColor];
    textLab.textAlignment = NSTextAlignmentLeft;
    textLab.text = _textArr[0];
    [_bgScroll addSubview:textLab];
    
    _textLab = textLab;
    
    _bgScroll.contentSize = CGSizeMake(K_WIDTH, CGRectGetMaxY(textLab.frame) + space);

}



- (NSMutableArray *)basisArr{
    
    if (!_basisArr) {
        _basisArr = [NSMutableArray array];
    }
    return _basisArr;
}

- (NSMutableArray *)extendedArr{
    
    if (!_extendedArr) {
        _extendedArr = [NSMutableArray array];
    }
    return _extendedArr;
}


#pragma mark   --  segmented的点击方法
-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger index = Seg.selectedSegmentIndex;
    //    NSLog(@"Index %li", (long)index);
    
    CGFloat space = 10*DISTANCE_WIDTH;
    switch (index) {
        case 0:
        {
            _textLab.text = _textArr[0];
            
        }
            break;
        case 1:
            
        {
            _textLab.text = _textArr[1];
        }
            break;
        case 2:{
            
            _textLab.text = _textArr[2];
            
        }
            break;
            
        default:
            break;
    }
    
    CGRect textLabRect = [_textLab.text boundingRectWithSize:CGSizeMake(K_WIDTH - 2*space, K_WIDTH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*DISTANCE_HEIGHT]} context:nil];
    
    CGFloat textLabHeight = textLabRect.size.height;
    
    _textLab.frame = CGRectMake(space, _segmentOriginH + 5.5*space, K_WIDTH - 2*space, textLabHeight);
    
    _bgScroll.contentSize = CGSizeMake(K_WIDTH, CGRectGetMaxY(_textLab.frame) + space);
    
    
}


#pragma mark   --  网络请求方法

- (void)getClassDetailData{
    
    NSString *str = [NSString stringWithFormat:C_HOST_API,@"/wiki/get_detail"];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = @{@"aid":@(self.aid)};
    
    __weak FertilizerDetailViewController *weakSelf = self;
    [FirstHttpRequestManager postChildEverySpeciesDetailedInfoWithUrl:encode WithDic:dic WithBlock:^(NSArray * _Nullable array) {
        
      [weakSelf.basisArr addObjectsFromArray:array[0]];
//        for (BaiKeMiniClassModel *baiKDModel in array[0]) {
//            BaiKeClassViewModel *baiKVM = [[BaiKeClassViewModel alloc] init];
//            
//            baiKVM.baiKDModel = baiKDModel;
        
//            NSLog(@"");
            
//            [weakSelf.basisArr addObject:baiKVM];
//        }
        
        [weakSelf.extendedArr addObjectsFromArray:array[1]];
        
        [weakSelf createViewUI];
    }];
    
}

- (void)leftBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
