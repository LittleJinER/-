//
//  FirstHttpRequestManager.m
//  小农人
//
//  Created by tomusng on 2017/9/22.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "FirstHttpRequestManager.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "QuestionModel.h"
#import "TechniqueDetaModel.h"
#import "AttentionCropModel.h"
#import "SBJson4Writer.h"
#import "BigClassModel.h"
#import "LittleClassModel.h"
#import "MiniClassModel.h"
#import "BaiKeMiniClassModel.h"


@implementation FirstHttpRequestManager


#pragma mark ---  搜索商品

+ (void)searchGoodsInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"数据请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"goods  %@",responseObject);
        
//        NSMutableArray *array = [NSMutableArray array];
//        for (NSDictionary *dic in responseObject) {
//            [array addObject:[QuestionModel mj_objectWithKeyValues:dic]];
//        }
//        
//        if (myBlock) {
//            myBlock(array);
//        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    

    
    
    
    
}

#pragma mark ---  搜索技术   ----   学技术里面病虫草害列表信息
+ (void)searchTechniqueInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"数据请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Technique:  %@",responseObject);
        
        
        
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dic in responseObject) {
                    
                    [array addObject:[QuestionModel mj_objectWithKeyValues:dic]];
                }
        
                if (myBlock) {
                    myBlock(array);
                }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    

    
    
}


#pragma mark ---  搜索问题
+ (void)searchQuestionsInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"数据请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"questions:  %@",responseObject);
        
        
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
        NSLog(@"%@",error.localizedDescription);
    }];
    

    
    
    
    
}

#pragma mark ---  搜索专家
+ (void)searchExpertInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"数据请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"expert:  %@",responseObject);
        
        //        NSMutableArray *array = [NSMutableArray array];
        //        for (NSDictionary *dic in responseObject) {
        //            [array addObject:[QuestionModel mj_objectWithKeyValues:dic]];
        //        }
        //
        //        if (myBlock) {
        //            myBlock(array);
        //        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    

    
    
    
    
    
}


#pragma mark -- 技术详情
+ (void)techniqueDetailInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"数据请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"techniqueDetail:  %@",responseObject);
        
//                NSMutableArray *array = [NSMutableArray array];
//                for (NSDictionary *dic in responseObject) {
//                    [array addObject:[TechniqueDetaModel mj_objectWithKeyValues:dic]];
//                }
//        
//                if (myBlock) {
//                    myBlock(array);
//                }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    

    
    
    
    
    
    
    
}





#pragma mark   --   请求关注的农作物

+ (void)getAttentionCropsInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"数据请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"attentionCrops:  %@",responseObject);
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dic in responseObject) {
        
            [array addObject:[AttentionCropModel mj_objectWithKeyValues:dic]];
        }
        
        if (myBlock){
            
            myBlock(array);
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];

}



#pragma mark  --- 农资百科顶级页面信息
+ (void)getAgriculturaMEncyInfoWithUrl:(NSString *_Nullable)urlStr WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"数据请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"AgriculturaMEncyInfo:  %@",responseObject);
        
        
//        reading
//        NSMutableArray *readArray = [NSMutableArray array];
        
        NSDictionary *dataDic = responseObject[@"data"];
        NSDictionary *readDic = dataDic[@"reading"];
//        NSLog(@"222222  %@",readDic);
        
//        for (NSDictionary *dic in readDic) {
//            
//            
//            [readArray addObject:[AgricultMaReadModel mj_objectWithKeyValues:dic]];
//        }
//        
        
//        root
//        NSMutableArray *rootArr = [NSMutableArray array];

//        for (NSDictionary *dic in responseObject[@"data"][@"root"]) {
//            [rootArr addObject:[AgricultMaClDataModel mj_objectWithKeyValues:dic]];
//        }
//
        NSDictionary *rootDic = dataDic[@"root"];
//        NSLog(@"222222  %@",rootDic);
        
        NSMutableArray *dataArr = [NSMutableArray array];
        
        [dataArr addObject:readDic];
        [dataArr addObject:rootDic];
        NSArray *array = [NSArray arrayWithArray:dataArr];
        
        if (myBlock){
            
            myBlock(array);
            
        }
//
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
    
    
}



#pragma mark  --- 农资百科子级页面信息   农药   种子   肥料

+ (void)postChildAllSpeciesWithUrl:(NSString *_Nullable)urlStr WithDic:(NSDictionary *_Nullable)dic WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    NSLog(@"urlStr:%@",urlStr);
    NSLog(@"Dic:%@",dic);
    
    [manager POST:urlStr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"ChildAllSpecies: %@",responseObject);
        
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            
            [dataArr addObject:[BigClassModel mj_objectWithKeyValues:dic]];
            
        }
        
        if (dataArr) {
            myBlock(dataArr);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
        
    }];

    
    
    
    
}


#pragma mark  --- 农资百科子级页面信息   农药   最小化分类
+ (void)postChildEverySpeciesWithUrl:(NSString *_Nullable)urlStr WithDic:(NSDictionary *_Nullable)dic WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
//    NSLog(@"urlStr:%@",urlStr);
//    NSLog(@"Dic:%@",dic);
//    
    [manager POST:urlStr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"ChildEverySpecies: %@",responseObject);
        
        NSMutableArray *dataArr = [NSMutableArray array];
//        for (NSDictionary *dic in responseObject[@"data"]) {
//            
//            [dataArr addObject:[MiniClassModel mj_objectWithKeyValues:dic]];
//            
//        }
        NSArray *data = responseObject[@"data"];
        
//        NSDictionary *dic = data[2];
        
        
        
        for (NSDictionary *miniDic in data) {
            [dataArr addObject:[LittleClassModel mj_objectWithKeyValues:miniDic]];
        }
        
        
        if (dataArr) {
            myBlock(dataArr);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
        
    }];

}

#pragma mark  -- 农资百科子级页面信息   农药   种子   肥料分类的详细内容
+ (void)postChildEverySpeciesDetailedInfoWithUrl:(NSString *_Nullable)urlStr WithDic:(NSDictionary *_Nullable)dic WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    NSLog(@"urlStr:%@",urlStr);
    NSLog(@"Dic:%@",dic);
    
    [manager POST:urlStr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"ChildEverySpecies: %@",responseObject);
        
        NSMutableArray *dataArr = [NSMutableArray array];
    
        NSDictionary *data = responseObject[@"data"];
        NSDictionary *basis = data[@"basis"];
        NSDictionary *extended = data[@"extended"];
        
        NSMutableArray *basisArr = [NSMutableArray array];
        NSMutableArray *extendedArr = [NSMutableArray array];
        for (NSDictionary *miniDic in basis) {
            [basisArr addObject:[BaiKeMiniClassModel mj_objectWithKeyValues:miniDic]];
        }
        for (NSDictionary *miniDic in extended) {
            [extendedArr addObject:[BaiKeMiniClassModel mj_objectWithKeyValues:miniDic]];
        }

        [dataArr addObject:basisArr];
        [dataArr addObject:extendedArr];
        
        if (dataArr) {
            myBlock(dataArr);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
        
    }];

    
}

#pragma mark  --- 农资百科子级页面信息   农药   最小化分类 搜索
+ (void)searchPostChildEverySpeciesWithUrl:(NSString *_Nullable)urlStr WithDic:(NSDictionary *_Nullable)dic WithBlock:(void(^_Nullable)(NSArray * _Nullable array))myBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", nil];
    
    //    NSLog(@"urlStr:%@",urlStr);
    //    NSLog(@"Dic:%@",dic);
    //
    [manager POST:urlStr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Search----ChildEverySpecies: %@",responseObject);
//        
        NSMutableArray *dataArr = [NSMutableArray array];
        //        for (NSDictionary *dic in responseObject[@"data"]) {
        //
        //            [dataArr addObject:[MiniClassModel mj_objectWithKeyValues:dic]];
        //
        //        }
        NSArray *data = responseObject[@"data"];
        
        //        NSDictionary *dic = data[2];
        
        
        
        for (NSDictionary *miniDic in data) {
            [dataArr addObject:[MiniClassModel mj_objectWithKeyValues:miniDic]];
        }
        
        
        if (dataArr) {
            myBlock(dataArr);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
        
    }];

    
    
}








@end
