//
//  TechniqueDetailCell.m
//  小农人
//
//  Created by tomusng on 2017/9/23.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "TechniqueDetailCell.h"

@implementation TechniqueDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"我是来了啦啦啦";
        lab.frame = CGRectMake(10, 10, 100, 20);
        [self addSubview:lab];
        
    }
    
    
    
    return self;
    
    
}



//
//comment_list Tom








- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
