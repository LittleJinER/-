//
//  AgricultMaClassView.h
//  小农人
//
//  Created by tomusng on 2017/9/26.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgricultMaClassView : UIView


@property (nonatomic, strong)UIImageView *headImg;
@property (nonatomic, strong)UILabel *classLab;
@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)UILabel *classNameLab;
@property (nonatomic, strong)UILabel *textLab;
@property (nonatomic, strong)UIView *bgView;

@property (nonatomic, strong)UIView *detailBgView;

@property (nonatomic, strong)NSDictionary *dict;

@end
