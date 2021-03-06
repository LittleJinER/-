//
//  SPClearCacheTool.h
//  小农人
//
//  Created by tomusng on 2017/9/19.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface SPClearCacheTool : NSObject

/**
 *  获取缓存大小
 */
+ (NSString *)getCacheSize;


/**
 *  清理缓存
 */
+ (BOOL)clearCaches;

@end
