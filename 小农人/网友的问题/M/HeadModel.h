//
//  HeadModel.h
//  仿微信朋友圈
//
//  Created by 苗建浩 on 2017/5/31.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "BasicModel.h"

@interface HeadModel : BasicModel
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, strong) NSArray *image;
@property (nonatomic, assign)NSInteger oppose;
@property (nonatomic, assign)NSInteger approve;
@property (nonatomic, copy)NSString *authentication;
@property (nonatomic, copy)NSString *comment;

@end
