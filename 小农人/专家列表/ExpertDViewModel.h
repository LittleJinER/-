//
//  ExpertDViewModel.h
//  小农人
//
//  Created by tomusng on 2017/9/4.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RACCommand;
@class Model;
@class QuestionModel;
@class UserDataModel;

@interface ExpertDViewModel : NSObject

@property (strong, nonatomic) RACCommand *command;

@property (strong, nonatomic) Model *model;

@property (strong, nonatomic) QuestionModel *queModel;


/**
 *  标题
 */
@property (assign, nonatomic) CGRect titleLabelFrame;
/**
 *  图
 */
@property (assign, nonatomic) CGRect imageView0Frame;

@property (assign, nonatomic) CGRect imageView1Frame;

@property (assign, nonatomic) CGRect imageView2Frame;
/**
 *  时间
 */
@property (assign, nonatomic) CGRect timeLabelFrame;
/**
 *  来源
 */
@property (assign, nonatomic) CGRect authorLabelFrame;

@property (assign, nonatomic) CGFloat rowHeight;





@property (assign,nonatomic)CGRect headImageFrame;

@property (assign,nonatomic)CGRect categoryLabFrame;
@property (assign,nonatomic)CGRect afterLabFrame;


- (void)setqueModel:(QuestionModel *)queModel;


@end
