//
//  DetailedClassificationViewController.h
//  小农人
//
//  Created by tomusng on 2017/8/26.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"

@protocol DetailCategoryDelegate <NSObject>

- (void)sendDataSource:(NSMutableArray <DataSource *> *)dataSource;

@end


@interface DetailedClassificationViewController : UIViewController


@property (nonatomic,assign) id <DetailCategoryDelegate>dataSourceDelegate;



@end
