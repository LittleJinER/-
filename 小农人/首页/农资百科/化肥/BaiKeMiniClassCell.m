//
//  BaiKeMiniClassCell.m
//  小农人
//
//  Created by tomusng on 2017/9/29.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "BaiKeMiniClassCell.h"
#import <UIKit/UIKit.h>


#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0


@interface BaiKeMiniClassCell ()

@property (nonatomic, strong) UILabel *textLab;

@end

@implementation BaiKeMiniClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UILabel *textLab = [[UILabel alloc] init];
        
        _textLab = textLab;
        textLab.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
        textLab.numberOfLines = 0;
        [self addSubview:_textLab];
    }
    
    return self;
    
    
}

- (void)setTitle:(NSString *)title{
    
    CGFloat space = 10*DISTANCE_WIDTH;
    
    _title = title;
    _textLab.text = title;
    
    
    CGRect basisRect = [_textLab.text boundingRectWithSize:CGSizeMake(K_WIDTH - 2*space, 500*DISTANCE_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*DISTANCE_HEIGHT]} context:nil];
    
    _textLab.frame = CGRectMake(space, 0, K_WIDTH - 2*space, basisRect.size.height);
    
    
}

- (void)setBaiDVM:(BaiKeClassViewModel *)baiDVM{
    
    _baiDVM = baiDVM;
    _textLab.text = [NSString stringWithFormat:@"%@%@",baiDVM.baiKDModel.key,baiDVM.baiKDModel.value];
    
    _textLab.frame = baiDVM.textLabFrame;
    
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
