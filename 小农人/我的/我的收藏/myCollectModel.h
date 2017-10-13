//
//  myCollectModel.h
//  小农人
//
//  Created by tomusng on 2017/9/19.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthorInfoModel.h"


@interface myCollectModel : NSObject

//@property (nonatomic, copy)NSString *avatar_middle;
//@property (nonatomic, copy)NSString *avatar_original;
//@property (nonatomic, copy)NSString *avatar_small;
//@property (nonatomic, copy)NSString *avatar_tiny;
//@property (nonatomic, copy)NSString *avatar_url;
//@property (nonatomic, copy)NSString *location;
//@property (nonatomic, copy)NSString *realname;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *title;

@property (nonatomic, assign)NSInteger sex;
@property (nonatomic, assign)NSInteger reply_count;
@property (nonatomic, assign)NSInteger post_time;
@property (nonatomic, assign)NSInteger read_count;

//自定义的变量
@property (nonatomic, copy)NSString *text;
@property (nonatomic, strong)NSMutableArray *imgArr;

@property (nonatomic, strong)AuthorInfoModel *author_info;

@end
