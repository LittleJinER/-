//
//  DiscoveryHttpRequestManager.m
//  小农人
//
//  Created by tomusng on 2017/9/12.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "DiscoveryHttpRequestManager.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "AgriInfoModel.h"


@implementation DiscoveryHttpRequestManager


// 申请专家，提交审核
+ (void)submitAuditWithUrlString:(NSString *)url WithBlock:(void (^)(NSString *string))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
//        NSLog(@"%@",responseObject);
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@" ddd  %@",string);
//        将结果返回
        if (string) {
            myBlock(string);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        错误描述
        NSLog(@"%@",error.localizedDescription);
        
        
    }];
    
}


//获取农业资讯页面信息
+ (void)getAgriInfomationWithUrl:(NSString *)urlStr WithBlock:(void(^)(NSArray *array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"  agriInfo   %@     ",responseObject);
        
        NSMutableArray *dataArr = [NSMutableArray array];
        
        
        for (NSDictionary *dic in responseObject) {
            [dataArr addObject:[AgriInfoModel mj_objectWithKeyValues:dic]];
        }
        
        NSArray *array = [NSArray arrayWithArray:dataArr];
        if (array) {
            myBlock(array);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
        
    }];
    
    
    
}


//提交意见反馈
+ (void)submitFeedbackWithUrl:(NSString *)urlStr WithBlock:(void(^)(NSString *string))myBlock{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}






@end
