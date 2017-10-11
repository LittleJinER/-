//
//  MakeData.m
//  专家列表
//
//  Created by tomusng on 2017/9/5.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "MakeData.h"

@implementation MakeData

+ (void)makeData:(void(^)(NSArray *array))myBlock{
    
    NSArray *array = [NSArray arrayWithObjects:@"金",@"木",@"水",@"火", nil];
    
    myBlock(array);
    
    
}




@end
