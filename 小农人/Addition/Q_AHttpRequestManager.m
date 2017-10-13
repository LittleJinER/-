//
//  Q_AHttpRequestManager.m
//  小农人
//
//  Created by tomusng on 2017/8/26.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "Q_AHttpRequestManager.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "DataSource.h"
#import "CropsClassificationModel.h"
#import "CropsDetailSpeciesModel.h"
#import "QuestionModel.h"
#import "HeadModel.h"
#import "SABookModel.h"
#import "ExpertCategoryModel.h"


@implementation Q_AHttpRequestManager

#pragma mark - 获取关注农作的种类
+ (void)getSelectedCrop:(NSString *)urlStr withBlock:(void(^)(NSMutableArray *array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       
        NSLog(@"数据请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
             [array addObject:[DataSource mj_objectWithKeyValues:dic]];
        }
    
        if (myBlock) {
            myBlock(array);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
    
}
#pragma mark - 获取农作物的分类
+ (void)getAllCropsWithUrl:(NSString *)urlStr withBlock:(void (^)(NSArray *))myBlock{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"数据请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"%@",responseObject);
        NSArray *categoryArr = responseObject[@"category"];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in categoryArr) {
            [dataArray addObject:[CropsClassificationModel mj_objectWithKeyValues:dic]];
        }
        NSArray *array = [NSArray arrayWithArray:dataArray];
        if (myBlock) {
            myBlock(array);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}

#pragma mark - 获取指定农作物的详细种类
+ (void)getDesignatedCropsWithUrl:(NSString *)urlStr withBlock:(void(^)(NSArray *array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"数据请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"everyCrops: %@",responseObject);
        NSArray *dataArr = responseObject[@"data"];
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        for (NSDictionary *dic in dataArr) {
            [dataArray addObject:[CropsDetailSpeciesModel mj_objectWithKeyValues:dic]];
        }
        NSArray *array = [NSArray arrayWithArray:dataArray];
        if (myBlock) {
            myBlock(array);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}


#pragma mark - 关注或取消关注农作物
+ (void)followCreateOrDestoryWithUrl:(NSString *)urlStr WithBlock:(void(^)(NSArray *array))myBlock{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
//    NSLog(@"%@",urlStr);
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"数据请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"    嘎嘎嘎  %@",responseObject);

        NSMutableArray *dataArray = [NSMutableArray array];
        
        NSArray *array = [NSArray arrayWithArray:dataArray];
        if (myBlock) {
            myBlock(array);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}

#pragma mark - 获取问答页面信息
+ (void)getQuestionInfoWithUrl:(NSString *)urlStr WithBlock:(void (^)(NSArray * _Nullable))myBlock{
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];//设置相应内容类型
   
    
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//                NSLog(@"%@",responseObject);
        
        
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            
            [dataArray addObject:[QuestionModel mj_objectWithKeyValues:dic]];
            
        }
        
        for (int i = 0; i < dataArray.count; i ++) {
//            QuestionModel *model = dataArray[i];
//            NSLog(@"%@",model.author_info.tag);
        }
        NSArray *array = [NSArray arrayWithArray:dataArray];
        
        if (array) {
            myBlock(array);
        }
        
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             
         }];
}

#pragma mark - 获取指定问题页面论坛列表
+ (void)getAppointedQuestionDetailedInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock{
    
    
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];//设置相应内容类型
    
    
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
                NSLog(@"appointed_Question_list %@",responseObject);
        
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject) {
                
                [dataArray addObject:[HeadModel mj_objectWithKeyValues:dic]];
                
            }

        }
        
        
        for (int i = 0; i < dataArray.count; i ++) {
                        HeadModel *model = dataArray[i];
                        NSLog(@"%@",model.author_info.uname);
        }
        NSArray *array = [NSArray arrayWithArray:dataArray];
//        
        if (array) {
            myBlock(array);
        }
        
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             
         }];

    
}

#pragma mark - 获取专家  -  类别  -   页面信息
+ (void)getExpertCategoryInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"数据请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        NSMutableArray *array = [NSMutableArray array];
         NSArray *category = responseObject[@"category"];
        for (NSDictionary *dic in category) {
            [array addObject:[ExpertCategoryModel mj_objectWithKeyValues:dic]];
        }
        
        if (myBlock) {
            myBlock(array);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
  
    
}

#pragma mark - 获取专家  -  列表  -   页面信息
+ (void)getExpertListInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"数据请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//                NSLog(@"%@",responseObject);
        NSMutableArray *dataArray = [NSMutableArray array];
       
//        NSArray *dataArr = responseObject[@"data"];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject) {
                [dataArray addObject:[SABookModel mj_objectWithKeyValues:dic]];
            }

        }
        
        NSArray *array = [NSArray arrayWithArray:dataArray];
        if (myBlock) {
            myBlock(array);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
    
    }];
    
}

#pragma mark - 关注或者取消关注专家
+ (void)followFollowingOrCancleUserWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)( NSDictionary* _Nullable dictionary))myBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"数据请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
//        NSMutableArray *dataArray = [NSMutableArray array];
//        
//        //        NSArray *dataArr = responseObject[@"data"];
//        for (NSDictionary *dic in responseObject) {
//            [dataArray addObject:[SABookModel mj_objectWithKeyValues:dic]];
//        }
//        NSArray *array = [NSArray arrayWithArray:dataArray];
        NSDictionary *dic = responseObject;
        if (dic) {
            myBlock(dic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
        
    }];

}


#pragma mark - 发表自己的问题
+ (void)ExpressOnesProblemsWithUrl:(NSString *_Nullable)urlStr WithDic:(NSDictionary *)dic WithBlock:(void(^_Nullable)(NSString * _Nullable string))myBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    
    [manager POST:urlStr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"tttt   %@",responseObject);
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (string) {
            myBlock(string);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

#pragma mark - 的问题
+ (void)ProblemsWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSString * _Nullable string))myBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        NSLog(@"数据请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       
        NSLog(@"%@",responseObject);
        NSLog(@"chngggg gong  lelele ");
        //        NSMutableArray *dataArray = [NSMutableArray array];
        //
        //        //        NSArray *dataArr = responseObject[@"data"];
        //        for (NSDictionary *dic in responseObject) {
        //            [dataArray addObject:[SABookModel mj_objectWithKeyValues:dic]];
        //        }
        //        NSArray *array = [NSArray arrayWithArray:dataArray];
        
        
//        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        NSString * str2 = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//        
//        str2 = [str2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        
//        str2 = [str2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//        
//        
//        
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[str2 dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//        
//        NSLog(@"%@",dict);
       
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (string) {
                    myBlock(string);
                }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
        
    }];
    
    
//    [manager POST:urlStr parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];

}
+ (void)ProblemsWithUrl:(NSString *_Nullable)urlStr WithDic:(NSDictionary *)dic WithBlock:(void(^_Nullable)(NSString * _Nullable string))myBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager POST:urlStr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject   %@",responseObject);
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (string) {
            myBlock(string);
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



#pragma mark  - 问题的收藏
+ (void)colletFavoriteWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSString * _Nullable string))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        NSLog(@"数据请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSLog(@"  dd  %@",responseObject);
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (string) {
            myBlock(string);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
        
    }];
    

    
    
    
    
    
    
    
    
    
    
    
}




@end
