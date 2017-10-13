//
//  QTableViewCell.h
//  小农人
//
//  Created by tomusng on 2017/8/30.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewModel;

//@protocol QTableViewCellDelegate <NSObject>


//- (void)choseQItem:(UIButton *)button;


//@end


@interface QTableViewCell : UITableViewCell


@property (strong, nonatomic) ViewModel *vm;

@property (weak,nonatomic)UIButton *replyButton;

@property (weak,nonatomic)UIButton *answerButton;



//@property (assign,nonatomic)id<QTableViewCellDelegate> delegate;



- (void)setCellWithVm:(ViewModel *)vm;

@end
