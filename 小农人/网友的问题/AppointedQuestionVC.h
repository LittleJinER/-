//
//  AppointedQuestionVC.h
//  小农人
//
//  Created by tomusng on 2017/8/31.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

@interface AppointedQuestionVC : UIViewController

@property (assign, nonatomic)NSInteger post_id;
@property (nonatomic, strong)QuestionModel *headModel;

@end
