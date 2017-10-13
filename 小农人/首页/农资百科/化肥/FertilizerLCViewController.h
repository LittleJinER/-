//
//  FertilizerLCViewController.h
//  小农人
//
//  Created by tomusng on 2017/9/29.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FertilizerLCViewController : UIViewController

@property (nonatomic, assign) NSInteger bigCid;
@property (nonatomic, assign) NSInteger litCid;
@property (nonatomic, copy) NSString *titleName;

//搜索
@property (nonatomic, assign) NSInteger search_cid;
@property (nonatomic, copy) NSString *keyWords;

@end
