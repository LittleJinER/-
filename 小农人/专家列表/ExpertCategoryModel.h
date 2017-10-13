//
//  ExpertCategoryModel.h
//  小农人
//
//  Created by tomusng on 2017/9/2.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpertCategoryModel : NSObject

@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, assign) NSInteger sort;
//专家类别
@property (nonatomic, copy) NSString *title;
//专家类别ID
@property (nonatomic, assign) NSInteger user_official_category_id;


@end
