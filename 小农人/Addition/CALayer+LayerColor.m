//
//  CALayer+LayerColor.m
//  BreadTrip
//
//  Created by Vivitickey on 2017/4/21.
//  Copyright © 2017年 test. All rights reserved.
//

#import "CALayer+LayerColor.h"

@implementation CALayer (LayerColor)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}


@end
