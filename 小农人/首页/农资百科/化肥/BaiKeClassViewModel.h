//
//  BaiKeClassViewModel.h
//  小农人
//
//  Created by tomusng on 2017/9/29.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaiKeMiniClassModel.h"


@interface BaiKeClassViewModel : NSObject

@property (nonatomic, strong) BaiKeMiniClassModel *baiKDModel;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGRect textLabFrame;

@end
