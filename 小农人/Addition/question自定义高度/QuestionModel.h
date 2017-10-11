//
//  QuestionModel.h
//  Text
//
//  Created by tomusng on 2017/8/29.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

//@property (nonatomic, strong)NSString *user_group_name;// 个人认证

@property (nonatomic, strong)NSString *avatar_big;   // 用户头像   大
@property (nonatomic, strong)NSString *avatar_middle;// 用户头像   中
@property (nonatomic, strong)NSString *avatar_tiny;  // 用户头像   小
@property (nonatomic, strong)NSString *group_icon;
@property (nonatomic, strong)NSString *location;//地理位置
@property (nonatomic, strong)NSString *uname; //用户名字
@property (nonatomic, strong)NSString *content; //正文内容

@property (nonatomic, assign)NSInteger identity;

@property (nonatomic, strong)NSString *text;
@property (nonatomic, strong)NSMutableArray *picArr;

//@property (nonatomic, assign)NSInteger ;
//@property (nonatomic, assign)NSInteger ;
//@property (nonatomic, assign)NSInteger ;
//@property (nonatomic, assign)NSInteger ;
//@property (nonatomic, assign)NSInteger ;
//@property (nonatomic, assign)NSInteger ;
//@property (nonatomic, assign)NSInteger ;
//@property (nonatomic, assign)NSInteger ;
//@property (nonatomic, assign)NSInteger ;
//@property (nonatomic, assign)NSInteger ;




@end
