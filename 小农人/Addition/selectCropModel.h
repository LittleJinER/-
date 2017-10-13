//
//  selectCropModel.h
//  小农人
//
//  Created by tomusng on 2017/8/26.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface selectCropModel : NSObject

@property (nonatomic, assign) NSInteger admin_uid;
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, assign) NSInteger follower_count;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, assign) BOOL is_del;
@property (nonatomic, assign) NSInteger logo;
@property (nonatomic, copy) NSString *logo_url;
@property (nonatomic, copy) NSString *notify;
@property (nonatomic, assign) NSInteger recommend;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger thread_count;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger weiba_id;
@property (nonatomic, copy) NSString *weiba_name;
@property (nonatomic, assign) NSInteger who_can_post;
@property (nonatomic, assign) NSInteger who_can_reply;







@end
