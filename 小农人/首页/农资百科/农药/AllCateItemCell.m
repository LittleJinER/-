//
//  AllCateItemCell.m
//  小农人
//
//  Created by tomusng on 2017/9/28.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "AllCateItemCell.h"

#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]

#define LIGHT_TITLE_COLOR [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1]


@interface AllCateItemCell ()



@end

@implementation AllCateItemCell


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        CGFloat space = 2*DISTANCE_WIDTH;
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(space, space, frame.size.width - 2*space, frame.size.height - 2*space);
        titleLab.textColor = LIGHT_TITLE_COLOR;
        titleLab.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
        titleLab.textAlignment = NSTextAlignmentCenter;
//        titleLab.text = @"菜青虫颗粒体病毒";
        _titleLab = titleLab;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, frame.size.height - 0.5*DISTANCE_HEIGHT, frame.size.width, 0.5*DISTANCE_HEIGHT);
        _lineView = lineView;
        lineView.backgroundColor = LINEVIEW_COLOR;
        
        [self addSubview:titleLab];
        [self addSubview:lineView];
        
        
    }
    
    
    return self;
    
}


- (void)setTitle:(NSString *)title{
    
    _title = title;
    _titleLab.text = title;
    
}






@end
