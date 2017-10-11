//
//  UIColor+HMAddition.m
//  02-生活圈
//
//  Created by itcast on 16/12/22.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "UIColor+SWAddition.h"

@implementation UIColor (HMAddition)
+ (instancetype)sw_colorWithR:(int)red G:(int)green B:(int)blue{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}
+ (instancetype)sw_randmColor{
    return [UIColor sw_colorWithR:arc4random_uniform(256) G:arc4random_uniform(256) B:arc4random_uniform(256)];
}
+ (instancetype)sw_colorWithHex:(int32_t)hex{
    int red = (hex & 0xff0000) >> 16;  // (1+2)÷3
    int green = (hex & 0x00ff00) >> 8;
    int blue = hex & 0x0000ff;
    
    return [UIColor sw_colorWithR:red G:green B:blue];
}
@end
