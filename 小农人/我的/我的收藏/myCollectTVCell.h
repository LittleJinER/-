//
//  myCollectTVCell.h
//  小农人
//
//  Created by tomusng on 2017/9/19.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myCollectViewM.h"


@interface myCollectTVCell : UITableViewCell

@property (nonatomic, strong) myCollectViewM *myCollViewMod;


@property (weak,nonatomic)UIButton *answerBtn;

@end
