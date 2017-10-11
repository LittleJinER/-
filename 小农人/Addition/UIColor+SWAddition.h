//
//  UIColor+HMAddition.h
//  02-生活圈
//
//  Created by itcast on 16/12/22.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HMAddition)
+ (instancetype)sw_colorWithR:(int)red G:(int)green B:(int)blue;
+ (instancetype)sw_randmColor;
+ (instancetype)sw_colorWithHex:(int32_t)hex;
@end
