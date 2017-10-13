//
//  TechniqueCell.m
//  小农人
//
//  Created by tomusng on 2017/9/20.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "TechniqueCell.h"
#import "UIImageView+WebCache.h"



#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]
#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]

#define LIGHT_TITLE_COLOR [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1]

#define LINE_HEIGHT 0.5*DISTANCE_WIDTH

#define TEXT_FONT   [UIFont systemFontOfSize:14*DISTANCE_HEIGHT]
#define TITLE_FONT  [UIFont systemFontOfSize:17*DISTANCE_HEIGHT]

@interface TechniqueCell ()



@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong)UILabel *textLab;

@property (nonatomic, strong)UILabel *browseCountLab;

@property (nonatomic, strong) UIImageView *imgV;


@end

@implementation TechniqueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //      作物名字
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.font = TITLE_FONT;
        [self addSubview:titleLab];
        
        _titleLab = titleLab;

        
        //      正文
        UILabel *textLab = [[UILabel alloc] init];
//        textLab.numberOfLines = 0;
        textLab.numberOfLines = 0;
        textLab.font = TEXT_FONT;
        textLab.textColor = LIGHT_TITLE_COLOR;
        [self addSubview:textLab];
        _textLab = textLab;
        
        
        //      浏览数
        UILabel *browseCountLab = [[UILabel alloc] init];
        browseCountLab.font = [UIFont systemFontOfSize:13.0f*DISTANCE_HEIGHT];
        browseCountLab.textColor = LIGHT_TITLE_COLOR;
        browseCountLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:browseCountLab];
        _browseCountLab = browseCountLab;

        
        //      图片
        UIImageView *imgV = [[UIImageView alloc] init];
        [self addSubview:imgV];
        _imgV = imgV;
        [self addSubview:imgV];
        
        
        
        CGFloat space = 10*DISTANCE_HEIGHT;
        CGFloat imgWidth = 80*DISTANCE_WIDTH;
        CGFloat imgHeight = 60*DISTANCE_HEIGHT;
        
        
        titleLab.frame = CGRectMake(space, space, 200*DISTANCE_WIDTH, 20*DISTANCE_WIDTH);
        browseCountLab.frame = CGRectMake(K_WIDTH - 2*space - imgWidth - 50*DISTANCE_WIDTH, space, 50*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
        textLab.frame = CGRectMake(space, CGRectGetMaxY(titleLab.frame) + space, K_WIDTH - 3*space - imgWidth, 40*DISTANCE_HEIGHT);
        imgV.frame = CGRectMake(CGRectGetMaxX(browseCountLab.frame) + space, space, imgWidth, imgHeight);
        
        
    }
    return self;
    
}



- (void)setMyCollM:(QuestionModel *)myCollM{
    
    _myCollM = myCollM;
    
//    NSLog(@"****  title   *** %@",myCollM.title);
    
    
    _titleLab.text = myCollM.title;
    _browseCountLab.text = [NSString stringWithFormat:@"%ld浏览",myCollM.read_count];
    
    _textLab.text = myCollM.text;
    
    if ([myCollM.text isEqualToString:@""]) {
        _textLab.text = myCollM.fbwh;
    }
    
    if (myCollM.picArr.count > 0) {
        NSString *imgStr = myCollM.picArr[0];
        [_imgV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@""]];
        _imgV.contentMode = UIViewContentModeScaleToFill;
    }
    
}








- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
