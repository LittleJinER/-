//
//  MineHttpRequestManager.h
//  小农人
//
//  Created by tomusng on 2017/9/19.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineHttpRequestManager : NSObject


#pragma mark ----  获取我的收藏   --  问题   --- 列表信息
+ (void)myFavoriteListCollectionWithUrl:(NSString *)urlStr WithBlock:(void(^)(NSArray *array))myBlock;


#pragma mark ----  获取我的收藏   --  技术   --- 列表信息
+ (void)myFavoriteListCollectTechniqueWithUrl:(NSString *)urlStr WithBlock:(void (^)(NSArray *array))myBlock;

#pragma mark ----  获取我的关注列表信息
+ (void)myFavoriteListConcernWithUrl:(NSString *)urlStr WithBlock:(void (^)(NSArray *array))myBlock;

#pragma mark --    获取我的回答里面我的问题信息
+ (void)MyQuestionInfoWithUrl:(NSString *)urlStr WithBlock:(void (^)(NSArray *array))myBlock;


#pragma mark --    获取我的回答里面我的问题信息
+ (void)MyCommentsInfoWithUrl:(NSString *)urlStr WithBlock:(void (^)(NSArray *array))myBlock;



@end
