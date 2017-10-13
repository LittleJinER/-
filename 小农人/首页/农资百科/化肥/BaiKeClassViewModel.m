//
//  BaiKeClassViewModel.m
//  小农人
//
//  Created by tomusng on 2017/9/29.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "BaiKeClassViewModel.h"

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

@implementation BaiKeClassViewModel


- (void)setBaiKDModel:(BaiKeMiniClassModel *)baiKDModel{
    
    _baiKDModel = baiKDModel;
    
    CGFloat space = 10*DISTANCE_WIDTH;
    
    NSString *str = [NSString stringWithFormat:@"%@%@",baiKDModel.key,baiKDModel.value];
    
    
    CGRect basisRect = [str boundingRectWithSize:CGSizeMake(K_WIDTH - 2*space, 500*DISTANCE_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*DISTANCE_HEIGHT]} context:nil];
    
    _textLabFrame = CGRectMake(space, 0, K_WIDTH - 2*space, basisRect.size.height);

    _cellHeight = CGRectGetMaxY(_textLabFrame) + space;
    
}


@end
