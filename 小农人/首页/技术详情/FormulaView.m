//
//  FormulaView.m
//  小农人
//
//  Created by tomusng on 2017/9/23.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "FormulaView.h"

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]



@implementation FormulaView

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
        
        CGFloat viewHeight = 30*DISTANCE_HEIGHT;
        
        CGFloat btnViewWidth = 50*DISTANCE_HEIGHT;
        
        CGFloat viewWidth = K_WIDTH - btnViewWidth;
        CGFloat labHeight = 20*DISTANCE_HEIGHT;
        CGFloat lineHeight = 0.5*DISTANCE_HEIGHT;
        CGFloat labWidth = 80*DISTANCE_WIDTH;
        CGFloat space = 10*DISTANCE_HEIGHT;
        CGFloat btnWidth = 40*DISTANCE_HEIGHT;
        
        CGFloat maxHeight = 0.0;
        NSArray *nameArray = @[@"成分名称：",@"含        量：",@"稀释倍数："];
        NSArray *placehArr = @[@"例阿维菌素",@"例1.8%",@"例1800 - 2400倍"];
        
//        self.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0 ; i < 3; i ++) {
            
            
            
            
            UIView *bgView = [[UIView alloc] init];
            bgView.frame = CGRectMake(0, 10*DISTANCE_HEIGHT + (viewHeight + lineHeight)*i, viewWidth, 30*DISTANCE_HEIGHT);
            bgView.backgroundColor = [UIColor whiteColor];
            
            UILabel *nameLab = [[UILabel alloc] init];
            nameLab.text = nameArray[i];
            nameLab.frame = CGRectMake(space, space/2, labWidth, labHeight);
            nameLab.textColor = [UIColor blackColor];
            nameLab.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
            nameLab.textAlignment = NSTextAlignmentRight;
            [bgView addSubview:nameLab];
            
            UITextField *textF = [[UITextField alloc] init];
            textF.frame = CGRectMake(CGRectGetMaxX(nameLab.frame) + space, space/2, viewWidth - labWidth - 3*space, labHeight);
            textF.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
            //        textF.backgroundColor = [UIColor greenColor];
            textF.placeholder = placehArr[i];
            [bgView addSubview:textF];
            
            
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(space, 10*DISTANCE_HEIGHT + (viewHeight + lineHeight)*(i + 1), viewWidth - space, lineHeight);
            
            lineView.backgroundColor = LINEVIEW_COLOR;
            
            [self addSubview:lineView];
            
            [self addSubview:bgView];
            
            [self bringSubviewToFront:lineView];
            
            if (i == 0) {
                maxHeight = CGRectGetMaxY(lineView.frame);
            }
            
            
            
            
        }
        
        UIButton *subtractionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        subtractionBtn.frame = CGRectMake(viewWidth + (btnViewWidth - btnWidth)/2, frame.size.height - ((3*viewHeight + 3*lineHeight) - btnWidth)/2 - btnWidth, btnWidth, btnWidth);
        
        _subtractionBtn = subtractionBtn;
        
//        [subtractionBtn setTitle:@"减" forState:UIControlStateNormal];

        [subtractionBtn setImage:[UIImage imageNamed:@"Study_writeDel"] forState:UIControlStateNormal];
        [self addSubview:subtractionBtn];
        
    }
    
    
    return self;
    
}









@end
