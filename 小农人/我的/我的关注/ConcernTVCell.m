//
//  ConcernTVCell.m
//  小农人
//
//  Created by tomusng on 2017/9/21.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "ConcernTVCell.h"
#import "UIImageView+WebCache.h"


#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height

#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]
#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]

#define LINE_HEIGHT 0.5*DISTANCE_WIDTH

#define TEXT_FONT   [UIFont systemFontOfSize:15*DISTANCE_HEIGHT]
#define TITLE_FONT  [UIFont systemFontOfSize:13*DISTANCE_HEIGHT]



@interface ConcernTVCell ()

@property (nonatomic, strong) UIImageView *headImg;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *official_categoryLab;

@property (nonatomic, strong) UILabel *adeptLab;//擅长作物



@end







@implementation ConcernTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat space = 10*DISTANCE_WIDTH;
//        头像
        UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, 80*DISTANCE_WIDTH, 80*DISTANCE_WIDTH)];
        headImg.clipsToBounds = YES;
        headImg.layer.cornerRadius = 40.0f*DISTANCE_WIDTH;
        _headImg = headImg;
        [self addSubview:headImg];
//        姓名
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImg.frame) + space, space, 100*DISTANCE_WIDTH, 20*DISTANCE_WIDTH)];
        nameLabel.font = [UIFont systemFontOfSize:15.0f*DISTANCE_WIDTH];
        _nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        UILabel *official_categoryLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame) + space , 100*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT)];
        official_categoryLab.font = [UIFont systemFontOfSize:13.0f*DISTANCE_HEIGHT];
        _official_categoryLab = official_categoryLab;
        [self addSubview:official_categoryLab];
        
        
        UILabel *adeptLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(official_categoryLab.frame) + space, K_WIDTH - CGRectGetMinX(nameLabel.frame) - space , 20*DISTANCE_HEIGHT)];
        adeptLab.textColor = [UIColor colorWithRed:152.0/255 green:152.0/255 blue:152.0/255 alpha:1];
        adeptLab.font = [UIFont systemFontOfSize:13.0f*DISTANCE_HEIGHT];
        _adeptLab = adeptLab;
        [self addSubview:adeptLab];
        
        
        
        UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        questionBtn.frame = CGRectMake(K_WIDTH - 70*DISTANCE_WIDTH, 2*space, 60*DISTANCE_WIDTH, 30*DISTANCE_HEIGHT);
        [questionBtn setTitleColor:[UIColor colorWithRed:231.0/255 green:86.0/255 blue:71.0/255 alpha:1] forState:UIControlStateNormal];
        [questionBtn setTitle:@"提问" forState:UIControlStateNormal];
        
        [questionBtn.layer setMasksToBounds:YES];
        [questionBtn.layer setCornerRadius:15.0f*DISTANCE_HEIGHT];
        [questionBtn.layer setBorderWidth:1.0f*DISTANCE_HEIGHT];
        
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){231.0/255, 86.0/255, 71.0/255, 1});
        _questionBtn = questionBtn;
        [questionBtn.layer setBorderColor:color];
        
        //        _questionBtn.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:231.0/255 green:86.0/255 blue:71.0/255 alpha:1]);
    
        [self addSubview:questionBtn];
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    return self;
    
    
}






- (void)setBookModel:(SABookModel *)bookModel{
    
    _bookModel = bookModel;
    
    [_headImg sd_setImageWithURL:[NSURL URLWithString:bookModel.avatar_original] placeholderImage:[UIImage imageNamed:@""]];
    _nameLabel.text = bookModel.uname;
    
    if ([bookModel.uname isEqualToString:@""]) {
        _nameLabel.text = @"柳瑾";
    }
    
    _official_categoryLab.text = bookModel.official_category;
    
    NSString *crops = [bookModel.tag componentsJoinedByString:@","];
    _adeptLab.text = crops;
    if ([crops isEqualToString:@""]) {
        _adeptLab.text = @"小麦，黄瓜，番茄";
    }
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
