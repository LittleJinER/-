//
//  AgriViewModel.m
//  小农人
//
//  Created by tomusng on 2017/9/14.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "AgriViewModel.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define TITLE_FONT       17*DISTANCE_HEIGHT

@implementation AgriViewModel


- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setAgriModel:(AgriInfoModel *)agriModel{
    
    _agriModel = agriModel;
    
    CGFloat spaceHeight = 10*DISTANCE_HEIGHT;
    CGFloat spaceWidth = 10*DISTANCE_WIDTH;
    CGFloat imageWidth = (WIDTH - 4*spaceWidth)/3;
    
    
    CGRect titleRect = [agriModel.content boundingRectWithSize:CGSizeMake(WIDTH - spaceWidth * 2*DISTANCE_WIDTH, HEIGHT/2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TITLE_FONT]} context:nil];
    CGSize titleSize = titleRect.size;
    
    _titleLFrame = CGRectMake(spaceWidth, spaceHeight, titleSize.width, titleSize.height);
    
    
    
//    NSLog(@" ***   %f     ===   %f",titleSize.width,titleSize.height);
    
    if (agriModel.attach.count > 0) {
        
        if (agriModel.attach.count == 2) {
            
        }
        if (agriModel.attach.count == 4) {
            
            _imgV0Frame = CGRectMake(spaceWidth, CGRectGetMaxY(_titleLFrame)+ spaceHeight, imageWidth, imageWidth*3/5.0);
            
            _imgV1Frame = CGRectMake(CGRectGetMaxX(_imgV0Frame) + spaceWidth, CGRectGetMaxY(_titleLFrame)+ spaceHeight, imageWidth, imageWidth*3/5.0);
            
            _imgV2Frame = CGRectMake( CGRectGetMaxX(_imgV1Frame) + spaceWidth, CGRectGetMaxY(_titleLFrame)+ spaceHeight, imageWidth, imageWidth*3/5.0);
            
        }
    }
    
    _signLFrame = CGRectMake(spaceWidth, CGRectGetMaxY(_imgV0Frame)+spaceHeight, 100*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
    
    _timeLFrame = CGRectMake(CGRectGetMaxX(_signLFrame)+spaceWidth, CGRectGetMaxY(_imgV0Frame)+spaceHeight, 150*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
    
    _cellHeight = CGRectGetMaxY(_timeLFrame);
//    NSLog(@" ***   %f",_cellHeight);
    
    
    
    
    
    
    
}











@end
