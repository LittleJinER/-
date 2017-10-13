//
//  SkilledCropsVC.h
//  小农人
//
//  Created by tomusng on 2017/9/11.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropsDetailSpeciesModel.h"

@protocol SkilledCropsVCDelegate <NSObject>

- (void)sendDataSource:(NSMutableArray *)dataSource;

@end

@interface SkilledCropsVC : UIViewController

@property (nonatomic,assign) id <SkilledCropsVCDelegate>dataSourceDelegate;


@end
