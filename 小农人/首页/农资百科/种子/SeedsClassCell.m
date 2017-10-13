//
//  SeedsClassCell.m
//  小农人
//
//  Created by tomusng on 2017/9/29.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "SeedsClassCell.h"
#import "UIImageView+WebCache.h"

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]
#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]
#define BG_COLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]
#define LIGHT_TITLE_COLOR [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1]

#define CUSTOM_COLOR(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]

#define LINE_HEIGHT 0.5*DISTANCE_WIDTH

#define VIEW_HEIGHT  55*DISTANCE_HEIGHT
#define VIEW_WIDTH 80*DISTANCE_WIDTH

@interface SeedsClassCell ()

@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UILabel *nameLab;


@end



@implementation SeedsClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat space = 10*DISTANCE_HEIGHT;
        
        
        
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.frame = CGRectMake(4*space, 1.25*space, 3.0*space, 3.0*space);
        _imgV = imgV;
        [self addSubview:imgV];
        
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.frame = CGRectMake(CGRectGetMaxX(imgV.frame) + 1.5*space, 2*space, 10*space, 1.5*space);
        nameLab.textAlignment = NSTextAlignmentLeft;
        nameLab.font = [UIFont systemFontOfSize:16*DISTANCE_HEIGHT];
        _nameLab = nameLab;
        [self addSubview:nameLab];
        
        
    }
    
    return self;
    
    
}

- (void)setLitModel:(LittleClassModel *)litModel{
    
    _litModel = litModel;
    [_imgV sd_setImageWithURL:[NSURL URLWithString:litModel.image] placeholderImage:[UIImage imageNamed:@""]];
    
    _nameLab.text = litModel.cat_name;
    
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
