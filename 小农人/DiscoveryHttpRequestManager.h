//
//  DiscoveryHttpRequestManager.h
//  小农人
//
//  Created by tomusng on 2017/9/12.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DiscoveryHttpRequestManager : NSObject

// 申请专家，提交审核
+ (void)submitAuditWithUrlString:(NSString *)url WithBlock:(void(^)(NSString *string))myBlock;

//获取农业资讯页面信息
+ (void)getAgriInfomationWithUrl:(NSString *)urlStr WithBlock:(void(^)(NSArray *array))myBlock;

//提交意见反馈
+ (void)submitFeedbackWithUrl:(NSString *)urlStr WithBlock:(void(^)(NSString *string))myBlock;


@end
