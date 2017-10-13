//
//  ExpertDetailsTCell.h
//  小农人
//
//  Created by tomusng on 2017/9/4.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExpertDViewModel;

@interface ExpertDetailsTCell : UITableViewCell




@property (strong, nonatomic) ExpertDViewModel *eVm;

@property (weak,nonatomic)UIButton *replyButton;

@property (weak,nonatomic)UIButton *answerButton;



- (void)setCellWithEvm:(ExpertDViewModel *)eVm;

@end
