//
//  DataSource.h
//  YANScrollMenu
//
//  Created by Yan. on 2017/7/4.
//  Copyright © 2017年 Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YANScrollMenu.h"

@interface DataSource : NSObject<YANMenuObject>
/**
 *  text
 */
@property (nonatomic, copy) NSString *text;
/**
 *  image(eg.NSURL ,NSString ,UIImage)
 */
@property (nonatomic, strong) id image;
@property (nonatomic, copy)NSString *imageStr;
/**
 *  placeholderImage
 */
@property (nonatomic, strong) UIImage *placeholderImage;








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
