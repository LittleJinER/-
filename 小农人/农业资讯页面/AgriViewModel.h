//
//  AgriViewModel.h
//  小农人
//
//  Created by tomusng on 2017/9/14.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AgriInfoModel.h"

@interface AgriViewModel : NSObject


@property (nonatomic, strong)AgriInfoModel *agriModel;

@property (nonatomic, assign)CGRect titleLFrame;

@property (nonatomic, assign)CGRect imgV0Frame;
@property (nonatomic, assign)CGRect imgV1Frame;
@property (nonatomic, assign)CGRect imgV2Frame;

@property (nonatomic, assign)CGRect signLFrame;

@property (nonatomic, assign)CGRect timeLFrame;


@property (nonatomic, assign)CGFloat cellHeight;



@end
