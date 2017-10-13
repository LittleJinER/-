//
//  CropsDetailSpeciesModel.h
//  小农人
//
//  Created by tomusng on 2017/8/28.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CropsDetailSpeciesModel : NSObject


@property (nonatomic, assign)NSInteger admin_uid;
@property (nonatomic, assign)NSInteger cid;

@property (nonatomic, strong)NSString *ctime;

@property (nonatomic, assign)NSInteger follower_count;
@property (nonatomic, assign)NSInteger following;

@property (nonatomic, strong)NSString *intro;

@property (nonatomic, assign)NSInteger is_del;

@property (nonatomic, strong)NSString *logo;
@property (nonatomic, strong)NSString *notify;

@property (nonatomic, assign)NSInteger recommend;
@property (nonatomic, assign)NSInteger status;

@property (nonatomic, assign)NSInteger thread_count;

@property (nonatomic, assign)NSInteger uid;
@property (nonatomic, assign)NSInteger weiba_id;

@property (nonatomic, strong)NSString *weiba_name;

@property (nonatomic, assign)NSInteger who_can_post;
@property (nonatomic, assign)NSInteger who_can_reply;


@end
