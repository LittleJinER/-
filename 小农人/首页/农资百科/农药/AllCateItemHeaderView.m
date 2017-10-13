//
//  AllCateItemHeaderView.m
//  小农人
//
//  Created by tomusng on 2017/9/28.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "AllCateItemHeaderView.h"

#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

@interface AllCateItemHeaderView ()
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation AllCateItemHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat space = 10*DISTANCE_WIDTH;
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(space, (frame.size.height - 20*DISTANCE_HEIGHT)/2, 200*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT)];
        
        titleLab.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
        _titleLab = titleLab;
        [self addSubview:titleLab];
        
    }
    
    return self;
    
}

- (void)setTitle:(NSString *)title{
    
    _title = title;
    _titleLab.text = title;
    
}




@end
