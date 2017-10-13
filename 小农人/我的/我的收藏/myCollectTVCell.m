//
//  myCollectTVCell.m
//  小农人
//
//  Created by tomusng on 2017/9/19.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "myCollectTVCell.h"

#import "myCollectViewM.h"
#import "UIImageView+WebCache.h"

#import "SQPhotosManager.h"

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]
#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]

#define LINE_HEIGHT 0.5*DISTANCE_WIDTH

#define TEXT_FONT   [UIFont systemFontOfSize:15*DISTANCE_HEIGHT]
#define TITLE_FONT  [UIFont systemFontOfSize:13*DISTANCE_HEIGHT]

@interface myCollectTVCell ()

@property (nonatomic, strong) UILabel *textLab;

@property (nonatomic, strong) UIImageView *image0View;
@property (nonatomic, strong) UIImageView *image1View;
@property (nonatomic, strong) UIImageView *image2View;

@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *nameLab;


@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong)UILabel *timeLab;

@property (nonatomic, strong)NSArray *urlImages;

@end



@implementation myCollectTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//      正文
        UILabel *textLab = [[UILabel alloc] init];
        textLab.numberOfLines = 0;
        textLab.font = TEXT_FONT;
        [self addSubview:textLab];
        _textLab = textLab;

//      三张图 最好不用循环
        UIImageView *image0View = [[UIImageView alloc] init];
        image0View.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:image0View];
        _image0View = image0View;
        UIImageView *image1View = [[UIImageView alloc] init];
        image1View.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:image1View];
        _image1View = image1View;
        UIImageView *image2View = [[UIImageView alloc] init];
        image2View.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:image2View];
        _image2View = image2View;
        
//      用户头像
        UIImageView *headImg = [[UIImageView alloc] init];
        [self addSubview:headImg];
        _headImg = headImg;
        [self addSubview:headImg];

//      用户名
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.textAlignment = NSTextAlignmentLeft;
        nameLab.font = TITLE_FONT;
        [self addSubview:nameLab];
        _nameLab = nameLab;
        
        
//        问题解答按钮
        UIButton *answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [answerBtn setImage:[UIImage imageNamed:@"my_answer"] forState:UIControlStateNormal];
        [answerBtn setTitle:@"00" forState:UIControlStateNormal];
        [answerBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [answerBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        answerBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:answerBtn];
        _answerBtn = answerBtn;

//        lineView分割线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = LINEVIEW_COLOR;
        _lineView = lineView;
        [self addSubview:lineView];
        
        
//      时间信息
        UILabel *timeLab = [[UILabel alloc] init];
        timeLab.font = [UIFont systemFontOfSize:13.0f];
        timeLab.textColor = [UIColor grayColor];
        [self addSubview:timeLab];
        _timeLab = timeLab;
        
    }
    
    return self;
    
}

- (void)setMyCollViewMod:(myCollectViewM *)myCollViewMod{
    
    _myCollViewMod = myCollViewMod;
    
    _textLab.frame = myCollViewMod.textLabFrame;
    _image0View.frame = myCollViewMod.image0ViewFrame;
    _image1View.frame = myCollViewMod.image1ViewFrame;
    _image2View.frame = myCollViewMod.image2ViewFrame;
    
    _headImg.frame = myCollViewMod.headImgFrame;
    _nameLab.frame = myCollViewMod.nameLabFrame;
    _answerBtn.frame = myCollViewMod.answerBtnFrame;
    _lineView.frame = myCollViewMod.lineViewFrame;
    _timeLab.frame = myCollViewMod.timeLabFrame;
    
    _textLab.text = myCollViewMod.myCollModel.text;
    if (myCollViewMod.myCollModel.picArr.count > 0) {
        [_image0View sd_setImageWithURL:[NSURL URLWithString:myCollViewMod.myCollModel.picArr[0]] placeholderImage:[UIImage imageNamed:@""]];
        _image0View.contentMode = UIViewContentModeScaleToFill;
    }
    if (myCollViewMod.myCollModel.picArr.count > 1){
         [_image1View sd_setImageWithURL:[NSURL URLWithString:myCollViewMod.myCollModel.picArr[1]] placeholderImage:[UIImage imageNamed:@""]];
        _image1View.contentMode = UIViewContentModeScaleToFill;
    }
    if (myCollViewMod.myCollModel.picArr.count > 2){
        [_image2View sd_setImageWithURL:[NSURL URLWithString:myCollViewMod.myCollModel.picArr[2]] placeholderImage:[UIImage imageNamed:@""]];
        _image2View.contentMode = UIViewContentModeScaleToFill;
    }

    [_headImg sd_setImageWithURL:[NSURL URLWithString:myCollViewMod.myCollModel.author_info.avatar_tiny] placeholderImage:[UIImage imageNamed:@""]];
    _headImg.clipsToBounds = YES;
    CGFloat headImgHeight = CGRectGetWidth(_headImg.frame);
    _headImg.layer.cornerRadius = headImgHeight/2;
    _nameLab.text = myCollViewMod.myCollModel.author_info.uname;
//    _nameLab.backgroundColor = [UIColor greenColor];
    NSInteger time = myCollViewMod.myCollModel.post_time;
    
    NSInteger replyCount = myCollViewMod.myCollModel.reply_count;
    [_answerBtn setTitle:[NSString stringWithFormat:@"%ld",replyCount] forState:UIControlStateNormal];
    _timeLab.text = [NSString stringWithFormat:@"%ld",time];
    _timeLab.textAlignment = NSTextAlignmentCenter;
    
    _image0View.userInteractionEnabled = YES;
    _image1View.userInteractionEnabled = YES;
    _image2View.userInteractionEnabled = YES;
    
    _image0View.tag = 101;
    _image1View.tag = 102;
    _image2View.tag = 102;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_image0View addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_image1View addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_image1View addGestureRecognizer:tap3];
    
    
    _urlImages = myCollViewMod.myCollModel.picArr;

    
    
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    switch (tap.view.tag) {
        case 101:
        {
            [[SQPhotosManager sharedManager]showPhotosWithfromViews:nil images:nil imageUrls:_urlImages index:0];
        }
            break;
        case 102:
        {
            [[SQPhotosManager sharedManager]showPhotosWithfromViews:nil images:nil imageUrls:_urlImages index:1];
            
        }
            break;
        case 103:
        {
            [[SQPhotosManager sharedManager]showPhotosWithfromViews:nil images:nil imageUrls:_urlImages index:2];
            
        }
            break;
            
        default:
            break;
    }
    
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
