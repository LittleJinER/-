//
//  MineHttpRequestManager.m
//  小农人
//
//  Created by tomusng on 2017/9/19.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "MineHttpRequestManager.h"

#import "MJExtension.h"
#import "AFNetworking.h"
//#import "myCollectModel.h"
#import "SABookModel.h"
#import "QuestionModel.h"


@implementation MineHttpRequestManager

+ (void)myFavoriteListCollectionWithUrl:(NSString *)urlStr WithBlock:(void(^)(NSArray *array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"%@",responseObject);
        
        NSMutableArray *dataArr = [NSMutableArray array];
        
        
        for (NSDictionary *dic in responseObject) {
//            NSDictionary *author = dic[@"author_info"];
//            NSLog(@"%@",author);
            [dataArr addObject:[QuestionModel mj_objectWithKeyValues:dic]];
        }
        
        NSArray *array = [NSArray arrayWithArray:dataArr];
        if (array) {
            myBlock(array);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
        
    }];

    
}

+ (void)myFavoriteListCollectTechniqueWithUrl:(NSString *)urlStr WithBlock:(void (^)(NSArray *array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
   
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//                NSLog(@"Technique   %@",responseObject);
        
        NSMutableArray *dataArr = [NSMutableArray array];
        
        
        for (NSDictionary *dic in responseObject) {
            //            NSDictionary *author = dic[@"author_info"];
            //            NSLog(@"%@",author);
            [dataArr addObject:[QuestionModel mj_objectWithKeyValues:dic]];
        }
        
        NSArray *array = [NSArray arrayWithArray:dataArr];
        if (array) {
            myBlock(array);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
        
    }];
    
    
    
}

+ (void)myFavoriteListConcernWithUrl:(NSString *)urlStr WithBlock:(void (^)(NSArray *array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"concern   %@",responseObject);
        
        NSMutableArray *dataArr = [NSMutableArray array];
        
        
        for (NSDictionary *dic in responseObject) {
            //            NSDictionary *author = dic[@"author_info"];
            //            NSLog(@"%@",author);
            [dataArr addObject:[SABookModel mj_objectWithKeyValues:dic]];
        }
        
        NSArray *array = [NSArray arrayWithArray:dataArr];
        if (array) {
            myBlock(array);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
        
    }];

    
    
    
}


#pragma mark --    获取我的回答里面我的问题信息
+ (void)MyQuestionInfoWithUrl:(NSString *)urlStr WithBlock:(void (^)(NSArray *array))myBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
                NSLog(@"question   %@",responseObject);
        
//        NSMutableArray *dataArr = [NSMutableArray array];
//        
//        
//        for (NSDictionary *dic in responseObject) {
//            //            NSDictionary *author = dic[@"author_info"];
//            //            NSLog(@"%@",author);
//            [dataArr addObject:[SABookModel mj_objectWithKeyValues:dic]];
//        }
//        
//        NSArray *array = [NSArray arrayWithArray:dataArr];
//        if (array) {
//            myBlock(array);
//        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
        
    }];

}


#pragma mark --    获取我的回答里面我的问题信息
+ (void)MyCommentsInfoWithUrl:(NSString *)urlStr WithBlock:(void (^)(NSArray *array))myBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
                NSLog(@"comments   %@",responseObject);
        
//        NSMutableArray *dataArr = [NSMutableArray array];
//        
//        
//        for (NSDictionary *dic in responseObject) {
//            //            NSDictionary *author = dic[@"author_info"];
//            //            NSLog(@"%@",author);
//            [dataArr addObject:[SABookModel mj_objectWithKeyValues:dic]];
//        }
//        
//        NSArray *array = [NSArray arrayWithArray:dataArr];
//        if (array) {
//            myBlock(array);
//        }
//        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
        
    }];

}
























@end
