//
//  AgriInfoModel.h
//  小农人
//
//  Created by tomusng on 2017/9/13.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AttachModel.h"

@interface AgriInfoModel : NSObject


@property (nonatomic, strong)NSMutableArray *attach;
@property (nonatomic, copy)NSString *content;

@property (nonatomic, assign)NSInteger has_attach;

//@property (nonatomic, assign)CGRect titleLFrame;
//
//@property (nonatomic, assign)CGRect imgV0Frame;
//@property (nonatomic, assign)CGRect imgV1Frame;
//@property (nonatomic, assign)CGRect imgV2Frame;
//
//@property (nonatomic, assign)CGRect signLFrame;
//
//@property (nonatomic, assign)CGRect timeLFrame;
//
//
//@property (nonatomic, assign)CGFloat cellHeight;

@end
