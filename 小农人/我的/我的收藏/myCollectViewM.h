//
//  myCollectViewM.h
//  小农人
//
//  Created by tomusng on 2017/9/19.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "myCollectModel.h"
#import "QuestionModel.h"

@interface myCollectViewM : NSObject

@property (nonatomic, strong) QuestionModel *myCollModel;


@property (nonatomic, assign) CGRect textLabFrame;
@property (nonatomic, assign) CGRect image0ViewFrame;
@property (nonatomic, assign) CGRect image1ViewFrame;
@property (nonatomic, assign) CGRect image2ViewFrame;
@property (nonatomic, assign) CGRect headImgFrame;
@property (nonatomic, assign) CGRect nameLabFrame;
@property (nonatomic, assign) CGRect answerBtnFrame;
@property (nonatomic, assign) CGRect timeLabFrame;
@property (nonatomic, assign) CGRect lineViewFrame;

@property (nonatomic, assign)CGFloat cellHeight;

@end
