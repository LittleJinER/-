//
//  AttentionCropModel.h
//  小农人
//
//  Created by tomusng on 2017/9/25.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttentionCropModel : NSObject

@property (nonatomic, copy) NSString *weiba_name;//关注作物名字
@property (nonatomic, assign) NSInteger weiba_id;//关注作物ID
@property (nonatomic, copy) NSString *logo_url;//关注作物图像

@end
