//
//  MakeData.h
//  专家列表
//
//  Created by tomusng on 2017/9/5.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MakeData : NSObject



+ (void)makeData:(void(^)(NSArray *array))myBlock;


@end
