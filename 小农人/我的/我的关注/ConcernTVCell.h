//
//  ConcernTVCell.h
//  小农人
//
//  Created by tomusng on 2017/9/21.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SABookModel.h"


@interface ConcernTVCell : UITableViewCell

@property (nonatomic, strong) SABookModel *bookModel;

@property (nonatomic, strong) UIButton *questionBtn;

@end
