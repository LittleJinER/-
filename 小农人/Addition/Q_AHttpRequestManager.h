//
//  Q_AHttpRequestManager.h
//  小农人
//
//  Created by tomusng on 2017/8/26.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void (^AFNFailurePost) (id _Nullable result);


@interface Q_AHttpRequestManager : NSObject

#pragma mark - 获取关注农作的种类
+ (void)getSelectedCrop:(NSString *_Nullable)urlStr withBlock:(void(^_Nullable)(NSMutableArray * _Nullable array))myBlock;

#pragma mark - 获取农作物的分类
+ (void)getAllCropsWithUrl:(NSString *_Nullable)urlStr withBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;

#pragma mark - 获取指定农作物的详细种类
+ (void)getDesignatedCropsWithUrl:(NSString *_Nullable)urlStr withBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;

#pragma mark - 关注或取消关注农作物
+ (void)followCreateOrDestoryWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;

#pragma mark - 获取问答页面信息

+ (void)getQuestionInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;


#pragma mark - 获取指定问题页面论坛列表
+ (void)getAppointedQuestionDetailedInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;


#pragma mark - 获取专家  -  类别  -   页面信息
+ (void)getExpertCategoryInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;

#pragma mark - 获取专家  -  列表  -   页面信息
+ (void)getExpertListInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;


#pragma mark - 关注或者取消关注专家
+ (void)followFollowingOrCancleUserWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSDictionary * _Nullable dictionary))myBlock;


#pragma mark - 发表自己的问题
+ (void)ExpressOnesProblemsWithUrl:(NSString *_Nullable)urlStr  WithDic:(NSDictionary *_Nullable)dic WithBlock:(void(^_Nullable)(NSString * _Nullable string))myBlock;

#pragma mark - 的问题
+ (void)ProblemsWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSString * _Nullable string))myBlock;

+ (void)ProblemsWithUrl:(NSString *_Nullable)urlStr WithDic:(NSDictionary *_Nullable)dic WithBlock:(void(^_Nullable)(NSString * _Nullable string))myBlock;


#pragma mark  - 问题的收藏
+ (void)colletFavoriteWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSString * _Nullable string))myBlock;













@end
