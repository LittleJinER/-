//
//  AgricultMaClassView.m
//  小农人
//
//  Created by tomusng on 2017/9/26.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "AgricultMaClassView.h"

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


#define LINE_HEIGHT 0.5*DISTANCE_WIDTH

#define MENU_BUTTON_WIDTH  [UIScreen mainScreen].bounds.size.width/7.0
#define MENU_HEIGHT 44*DISTANCE_WIDTH





@implementation AgricultMaClassView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        CGFloat space = 10*DISTANCE_WIDTH;
        
        CGFloat heightSpace = 12.5*DISTANCE_HEIGHT;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 0, width, 45*DISTANCE_HEIGHT);
        _bgView = bgView;
        [self addSubview:bgView];
//      headImg
        UIImageView *headImg = [[UIImageView alloc] init];
        headImg.frame = CGRectMake(space, space, 2.5*space, 2.5*space);
        _headImg = headImg;
        [bgView addSubview:headImg];
        
//      classLab
        UILabel *classLab = [[UILabel alloc] init];
        classLab.frame = CGRectMake(CGRectGetMaxX(headImg.frame) + space, heightSpace, 50*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
        classLab.font = [UIFont systemFontOfSize:16*DISTANCE_HEIGHT];
        _classLab = classLab;
        [bgView addSubview:classLab];
        
//      查看全部label
        
        UILabel *detailLab = [[UILabel alloc] init];
        detailLab.frame = CGRectMake(width - 100*DISTANCE_WIDTH, heightSpace, 60*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
        detailLab.font = [UIFont systemFontOfSize:13*DISTANCE_HEIGHT];
        detailLab.text = @"查看全部";
        detailLab.textColor = LIGHT_TITLE_COLOR;
        detailLab.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:detailLab];
        
//        arrowImg
        UIImageView *arrowImg = [[UIImageView alloc] init];
        arrowImg.frame = CGRectMake( CGRectGetMaxX(detailLab.frame) + space, 12*DISTANCE_HEIGHT, 2*space, 2*space);
        
        arrowImg.image = [UIImage imageNamed:@"ReturnHistoryNW"];
        
        [bgView addSubview:arrowImg];
        
        _bgView = bgView;
        
        
        
//        lineView
        UIView *lineView = [[UIView alloc] init];
        
        lineView.frame = CGRectMake(space, CGRectGetMaxY(bgView.frame), frame.size.width - 2*space, 0.5*DISTANCE_HEIGHT);
        lineView.backgroundColor = LINEVIEW_COLOR;
        
        [self addSubview:lineView];
        
        UIView *detailBgView = [[UIView alloc] init];
        detailBgView.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame), width, height - CGRectGetMaxY(lineView.frame));
        _detailBgView = detailBgView;
        [self addSubview:detailBgView];
        
        
        
//        circleView
        UIView *circleView = [[UIView alloc] init];
        circleView.frame = CGRectMake(space, 2*space, space/2, space/2);
        circleView.backgroundColor = LINEVIEW_COLOR;
        [detailBgView addSubview:circleView];
        circleView.clipsToBounds = YES;
        circleView.layer.cornerRadius = space/4;
        
        
        
//      nameLab
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.frame = CGRectMake(CGRectGetMaxX(circleView.frame) + space, 1.3*space, width - 2.5*space, 2*space);
        nameLab.font = [UIFont systemFontOfSize:16*DISTANCE_HEIGHT];
        _nameLab = nameLab;
        [detailBgView addSubview:nameLab];
        
//        textLab
        UILabel *textLab = [[UILabel alloc] init];
        textLab.frame = CGRectMake(space, CGRectGetMaxY(nameLab.frame) + space/2, width - 2*space, 45*DISTANCE_HEIGHT);
//        textLab.backgroundColor = [UIColor greenColor];
        textLab.font = [UIFont systemFontOfSize:14*DISTANCE_HEIGHT];
        textLab.numberOfLines = 0;
//        textLab.textColor = LIGHT_TITLE_COLOR;
        _textLab = textLab;
        [detailBgView addSubview:textLab];
        
        
        
        
        
        
    }
    
    
    return self;
    
    
}


- (void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    
    
    NSDictionary *childDic = [NSDictionary dictionaryWithDictionary:dict[@"child"]];
//    NSLog(@"wwww   :   %@",childDic);
    
    _nameLab.text = childDic[@"title"];
    
    NSArray *textArr = [self separateString:childDic[@"description"]] ;
    
    if (textArr.count >= 1) {
        _textLab.text = [NSString stringWithFormat:@"%@",textArr[0]];
    }
    
    
    
    if (textArr.count >= 2) {
        _textLab.text = [NSString stringWithFormat:@"%@\n%@",textArr[0],textArr[1]];
    }
    
    
}

#pragma mark -- 去掉HTML里面的标签并且分组
- (NSArray *)separateString:(NSString *)string{
    
    //    NSLog(@"");
    
    
    NSArray *firstArr = [string componentsSeparatedByString:@"<br/>"];
    
    //    NSLog(@"%@",firstArr);
    
    NSMutableArray *strArr = [NSMutableArray array];
    
    for (int i = 0 ; i < firstArr.count; i ++) {
        
        NSString *textStr = [self filterHTML:firstArr[i]];
        
        
        
        [strArr addObject:textStr];
    }
    
    NSArray *array = [NSArray arrayWithArray:strArr];
    
    return array;
    
}
#pragma mark -- 去掉HTML里面的标签
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    //    NSLog(@"html:   %@",html);
    
    return html;
}







@end
