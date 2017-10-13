//
//  BaiKeMiniClassCell.h
//  小农人
//
//  Created by tomusng on 2017/9/29.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiKeClassViewModel.h"

@interface BaiKeMiniClassCell : UITableViewCell

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) BaiKeClassViewModel *baiDVM;

@end
