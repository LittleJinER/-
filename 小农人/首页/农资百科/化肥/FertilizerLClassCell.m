//
//  FertilizerLClassCell.m
//  小农人
//
//  Created by tomusng on 2017/9/29.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "FertilizerLClassCell.h"

#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

@interface FertilizerLClassCell ()

@property (nonatomic, strong) UILabel *textLab;

@end

@implementation FertilizerLClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        CGFloat space = 10*DISTANCE_WIDTH;
        CGFloat imgHeight = 15*DISTANCE_HEIGHT;
        
        UILabel *textLab = [[UILabel alloc] init];
        textLab.frame = CGRectMake(space, 0, self.frame.size.width - space, self.frame.size.height);
//        textLab.backgroundColor = [UIColor blackColor];
        textLab.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
        
        textLab.textColor = [UIColor blackColor];
        _textLab = textLab;
        
        [self.contentView addSubview:textLab];
        
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.frame = CGRectMake(CGRectGetMaxX(textLab.frame) + space, (self.frame.size.height - imgHeight)/2, imgHeight, imgHeight);
        imgV.image = [UIImage imageNamed:@"ReturnHistoryNW"];
        [self.contentView addSubview:imgV];
        
        
    }
    
    return self;
    
}


- (void)setTitle:(NSString *)title{
    
    _title = title;
    _textLab.text = title;
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
