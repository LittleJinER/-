//
//  SABookModel.h
//  01-购物车
//
//  Created by Shenao on 2017/5/17.
//  Copyright © 2017年 hcios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SABookModel : NSObject

@property (nonatomic,copy) NSString * icon;

@property (nonatomic,copy) NSString * name;

@property (nonatomic,copy) NSString * price;

@property (nonatomic,assign) NSInteger  count;

//年龄
@property (nonatomic, assign) NSInteger age;
//头像
@property (nonatomic, copy) NSString *avatar_tiny; //30 * 30
@property (nonatomic, copy) NSString *avatar_small;//50 * 50
@property (nonatomic, copy) NSString *avatar_original;
@property (nonatomic, copy) NSString *avatar_middle;//100 * 100
@property (nonatomic, copy) NSString *avatar_big;  //200 * 200
//位置
@property (nonatomic, copy)NSString *location;
//性别
@property (nonatomic, assign)NSInteger sex;
//擅长类别
@property (nonatomic, strong)NSMutableArray *tag;
//专家名字
@property (nonatomic, copy)NSString *uname;
//粉丝数
@property (nonatomic, assign)NSInteger following_count;
//被采纳数
@property (nonatomic, assign)NSInteger adopt_count;

@property (nonatomic, copy)NSString *official_category;


@property (nonatomic, assign)NSInteger Following;



@property (nonatomic, assign)NSInteger uid;

@end
