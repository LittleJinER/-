//
//  BigClassModel.h
//  小农人
//
//  Created by tomusng on 2017/9/28.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LittleClassModel.h"


@interface BigClassModel : NSObject


@property (nonatomic, strong) NSMutableArray *child;

@property (nonatomic, copy) NSString *cat_name;

@property (nonatomic, assign) NSInteger cat_id;

@property (nonatomic, assign) BOOL selected;

@end
