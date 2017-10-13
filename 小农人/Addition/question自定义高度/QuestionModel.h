//
//  QuestionModel.h
//  Text
//
//  Created by tomusng on 2017/8/29.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AuthorInfoModel.h"


@interface QuestionModel : NSObject

//@property (nonatomic, strong)NSString *user_group_name;// 个人认证


@property (nonatomic, strong)NSString *content; //正文内容

@property (nonatomic, assign)NSInteger identity;

@property (nonatomic, strong)NSString *title;

@property (nonatomic, strong)NSString *text;

@property (nonatomic, strong)NSMutableArray *picArr;

@property (nonatomic, strong)AuthorInfoModel *author_info;

@property (nonatomic, assign)NSInteger read_count;
@property (nonatomic, assign)NSInteger weiba_id;
@property (nonatomic, assign)NSInteger post_time;
@property (nonatomic, assign)NSInteger post_id;
@property (nonatomic, assign)NSInteger reply_count;


//技术详情
@property (nonatomic, copy) NSString *longText;
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *lbzp;//图片
@property (nonatomic, copy) NSString *fbwh;//类别
@property (nonatomic, copy) NSString *whtz;
@property (nonatomic, copy) NSString *fsgl;
@property (nonatomic, copy) NSString *fzff;









//@property (nonatomic, assign)NSInteger ;
//@property (nonatomic, assign)NSInteger ;
//@property (nonatomic, assign)NSInteger ;
//@property (nonatomic, assign)NSInteger ;
//@property (nonatomic, assign)NSInteger ;
//@property (nonatomic, assign)NSInteger ;
//@property (nonatomic, assign)NSInteger ;
//@property (nonatomic, assign)NSInteger ;

//get_weibas    8



//http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=get_posts&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&id=8
@end
