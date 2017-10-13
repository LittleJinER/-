//
//  AgriInfoCell.m
//  小农人
//
//  Created by tomusng on 2017/9/13.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "AgriInfoCell.h"
#import "UIImageView+WebCache.h"
#import "AttachModel.h"


#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define TITLE_FONT       17*DISTANCE_HEIGHT



@interface AgriInfoCell ()

/**
 *  标题
 */
@property (weak, nonatomic) UILabel *titleLabel;

//中间的三张图片
@property (weak, nonatomic) UIImageView *imageView0;
@property (nonatomic, weak) UIImageView *imageView1;
@property (nonatomic, weak) UIImageView *imageView2;

//标志label
@property (nonatomic, weak) UILabel *signLabel;

//时间label
@property (nonatomic, weak) UILabel *timeLabel;



@end


@implementation AgriInfoCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT];
        _titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        UIImageView *imageView0 = [[UIImageView alloc] init];
        imageView0.contentMode = UIViewContentModeScaleAspectFit;
        _imageView0 = imageView0;
        [self addSubview:imageView0];
        
        UIImageView *imageView1 = [[UIImageView alloc] init];
        imageView1.contentMode = UIViewContentModeScaleAspectFit;
        _imageView1 = imageView1;
        [self addSubview:imageView1];
        
        UIImageView *imageView2 = [[UIImageView alloc] init];
        imageView2.contentMode = UIViewContentModeScaleAspectFit;
        _imageView2 = imageView2;
        [self addSubview:imageView2];
        
        UILabel *signLabel = [[UILabel alloc] init];
        signLabel.font = [UIFont systemFontOfSize:13*DISTANCE_WIDTH];
        [self addSubview:signLabel];
        _signLabel = signLabel;
        
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:13*DISTANCE_WIDTH];
        [self addSubview:timeLabel];
        _timeLabel = timeLabel;
        
        
    }
    return self;
}

- (void)setAgriViewModel:(AgriViewModel *)agriViewModel{
    
    _agriViewModel = agriViewModel;
    
    _titleLabel.frame = agriViewModel.titleLFrame;
    _imageView0.frame = agriViewModel.imgV0Frame;
    _imageView1.frame = agriViewModel.imgV1Frame;
    _imageView2.frame = agriViewModel.imgV2Frame;
    _signLabel.frame = agriViewModel.signLFrame;
    _timeLabel.frame = agriViewModel.timeLFrame;

    
    _titleLabel.text = agriViewModel.agriModel.content;
    if (agriViewModel.agriModel.attach.count > 0) {
        if (agriViewModel.agriModel.attach.count == 2) {
            
        }else if (agriViewModel.agriModel.attach.count == 4){
            for (int i = 1; i < 4; i ++) {
                AttachModel *attModel = agriViewModel.agriModel.attach[i];
                NSURL *imgUrl = [NSURL URLWithString:attModel.attach_url];
                switch (i) {
                    case 1:{
                        [_imageView0 sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@""]];
                        _imageView0.contentMode = UIViewContentModeScaleToFill;
                    }
                        break;
                        
                    case 2:{
                        [_imageView1 sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@""]];
                        _imageView1.contentMode = UIViewContentModeScaleToFill;
                    }
                        break;
                        
                    case 3:{
                        [_imageView2 sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@""]];
                        _imageView2.contentMode = UIViewContentModeScaleToFill;
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
  
        }
    }
    
    _signLabel.text = [NSString stringWithFormat:@"%ld",agriViewModel.agriModel.has_attach];
    _timeLabel.text = [NSString stringWithFormat:@"%ld",agriViewModel.agriModel.has_attach];
    
    
    
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
