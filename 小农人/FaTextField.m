//
//  FaTextField.m
//  小农人
//
//  Created by tomusng on 2017/8/26.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "FaTextField.h"

#define DIS_WIDTH [UIScreen mainScreen].bounds.size.width/667.0
// 7 375

@implementation FaTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//667

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    
    
    if ([UIScreen mainScreen].bounds.size.width < 375) {
       iconRect.origin.x = (super.bounds.size.width - 180*DIS_WIDTH)/2;
    }else if ([UIScreen mainScreen].bounds.size.width > 375){
        iconRect.origin.x = (super.bounds.size.width - 160*DIS_WIDTH)/2;
    }else{
        iconRect.origin.x = (super.bounds.size.width - 170*DIS_WIDTH)/2;
    }
    
    
    
    return iconRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    
    CGRect textRect = [super textRectForBounds:bounds];
    textRect.origin.x = 120*DIS_WIDTH;
    if ([UIScreen mainScreen].bounds.size.width < 375) {
        textRect.origin.x = 115*DIS_WIDTH;
    }

    
    return textRect;
    
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    CGRect rect = [super editingRectForBounds:bounds];
    rect.origin.x = 120*DIS_WIDTH;
    if ([UIScreen mainScreen].bounds.size.width < 375) {
        rect.origin.x = 115*DIS_WIDTH;
    }

    
    return rect;
    
    
}

@end
