//
//  ExpertTypeVC.h
//  小农人
//
//  Created by tomusng on 2017/9/11.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExpertTypeVCDelegate <NSObject>

- (void)transferExpType:(NSArray *)expTypeArr;

@end

@interface ExpertTypeVC : UIViewController

@property (nonatomic, assign)id<ExpertTypeVCDelegate> delegate;


@end
