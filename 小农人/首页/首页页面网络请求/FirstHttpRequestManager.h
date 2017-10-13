//
//  FirstHttpRequestManager.h
//  小农人
//
//  Created by tomusng on 2017/9/22.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirstHttpRequestManager : NSObject


#pragma mark ---  搜索商品

+ (void)searchGoodsInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;

#pragma mark ---  搜索技术
+ (void)searchTechniqueInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;


#pragma mark ---  搜索问题
+ (void)searchQuestionsInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;

#pragma mark ---  搜索专家
+ (void)searchExpertInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;

#pragma mark -- 技术详情
+ (void)techniqueDetailInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;

#pragma mark   --   请求关注的农作物

+ (void)getAttentionCropsInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;



#pragma mark  --- 农资百科顶级页面信息
+ (void)getAgriculturaMEncyInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;


#pragma mark  --- 农资百科子级页面信息   农药   种子   肥料
+ (void)postChildAllSpeciesWithUrl:(NSString *_Nullable)urlStr WithDic:(NSDictionary *_Nullable)dic WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;

#pragma mark  --- 农资百科子级页面信息   农药   最小化分类
+ (void)postChildEverySpeciesWithUrl:(NSString *_Nullable)urlStr WithDic:(NSDictionary *_Nullable)dic WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;

#pragma mark  -- 农资百科子级页面信息   农药   种子   肥料分类的详细内容
+ (void)postChildEverySpeciesDetailedInfoWithUrl:(NSString *_Nullable)urlStr WithDic:(NSDictionary *_Nullable)dic WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;


#pragma mark  --- 农资百科子级页面信息   农药   最小化分类 搜索
+ (void)searchPostChildEverySpeciesWithUrl:(NSString *_Nullable)urlStr WithDic:(NSDictionary *_Nullable)dic WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock;


@end










