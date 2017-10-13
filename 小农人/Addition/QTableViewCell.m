//
//  QTableViewCell.m
//  小农人
//
//  Created by tomusng on 2017/8/30.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "QTableViewCell.h"
#import "ViewModel.h"
#import "UIImageView+WebCache.h"
#import "FontModel.h"
#import "QuestionModel.h"
#import "AuthorInfoModel.h"
#import "SQPhotosManager.h"



#define DEF_Screen_Width [UIScreen mainScreen].bounds.size.width

#define DEF_Screen_Height [UIScreen mainScreen].bounds.size.height


@interface QTableViewCell ()


/**
 *  图
 */
@property (weak, nonatomic) UIImageView *imageView0;

@property (weak, nonatomic) UIImageView *imageView1;

@property (weak, nonatomic) UIImageView *imageView2;


/**
 *  标题
 */
@property (weak, nonatomic) UILabel *titleLabel;

/**
 *  时间
 */
@property (weak, nonatomic) UILabel *timeLabel;
/**
 *  来源
 */
@property (weak, nonatomic) UILabel *authorLabel;

@property (nonatomic,weak) UILabel *categoryLabel;



@property (weak,nonatomic)UIView *categoryView;
@property (weak,nonatomic)UIImageView *headImage;

@property (nonatomic, strong)NSArray *urlImages;


@end

@implementation QTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:titleFont];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        //三张图 最好不用循环
        UIImageView *imageView0 = [[UIImageView alloc] init];
        imageView0.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView0];
        _imageView0 = imageView0;
        UIImageView *imageView1 = [[UIImageView alloc] init];
        imageView1.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView1];
        _imageView1 = imageView1;
        UIImageView *imageView2 = [[UIImageView alloc] init];
        imageView2.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView2];
        _imageView2 = imageView2;
        //位置信息
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:timeFont];
        timeLabel.font = [UIFont systemFontOfSize:13.0f];
        timeLabel.textColor = [UIColor grayColor];
        [self addSubview:timeLabel];
        _timeLabel = timeLabel;
        //用户名
        UILabel *authorLabel = [[UILabel alloc] init];
        authorLabel.textAlignment = NSTextAlignmentLeft;
        authorLabel.font = [UIFont systemFontOfSize:authorFont];
        [self addSubview:authorLabel];
        _authorLabel = authorLabel;
        
        //        问题解答按钮
        UIButton *answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [answerButton setImage:[UIImage imageNamed:@"my_answer"] forState:UIControlStateNormal];
        [answerButton setTitle:@"00" forState:UIControlStateNormal];
        [answerButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [answerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        answerButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:answerButton];
        _answerButton = answerButton;
        
        //    用户头像
        UIImageView *headImage = [[UIImageView alloc] init];
        [self addSubview:headImage];
        _headImage = headImage;
        //        headImage.image = [UIImage imageNamed:@"10-45-7"];
        //        创建一个类别的view
        UIView *categoryView = [[UIView alloc] init];
        [self addSubview:categoryView];
        //        类别(label)
        UILabel *categoryLabel = [[UILabel alloc] init];
        //        z竖直的线
        UIView *uprightLine = [[UIView alloc] init];
        //    aftertime label
        UILabel *afterTLabel = [[UILabel alloc] init];
        _categoryLabel = categoryLabel;
        categoryLabel.frame = CGRectMake(0, 0, 50, 20);
        categoryLabel.textColor = [UIColor grayColor];
        categoryLabel.backgroundColor = [UIColor whiteColor];
        //        categoryLabel.text = @"桃树";
        categoryLabel.font = [UIFont systemFontOfSize:13.0f];
        uprightLine.frame = CGRectMake(50, 5, 1, 10);
        uprightLine.backgroundColor = [UIColor lightGrayColor];
        afterTLabel.font = [UIFont systemFontOfSize:13.0f];
        afterTLabel.text = @"21一小时前";
        afterTLabel.textColor = [UIColor grayColor];
        afterTLabel.textAlignment = NSTextAlignmentCenter;
        afterTLabel.frame = CGRectMake(51, 0, 100, 20);
        afterTLabel.backgroundColor = [UIColor whiteColor];
        [categoryView addSubview:uprightLine];
        [categoryView addSubview:categoryLabel];
        [categoryView addSubview:afterTLabel];
        _categoryView = categoryView;
        
        
//        解答按钮replyButton
        UIButton *replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [replayButton setImage:[UIImage imageNamed:@"home_btn_myanswer_nm"] forState:UIControlStateNormal];
        [replayButton setTitle:@"解答" forState:UIControlStateNormal];
        _replyButton = replayButton;
        [self addSubview:replayButton];
        [replayButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [replayButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [replayButton setTitleColor:[UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1] forState:UIControlStateNormal];
        replayButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        
        
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, DEF_Screen_Width, 10.0f);
        view.backgroundColor =  [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        [self addSubview:view];
    }
    return self;
}

- (void)setCellWithVm:(ViewModel *)vm {
    _vm = vm;
    //frame
    
    _titleLabel.frame = vm.titleLabelFrame;
    _imageView0.frame = vm.imageView0Frame;
    _imageView1.frame = vm.imageView1Frame;
    _imageView2.frame = vm.imageView2Frame;
    _timeLabel.frame = vm.timeLabelFrame;
    _authorLabel.frame = vm.authorLabelFrame;
    _answerButton.frame = vm.answerButtonFrame;
    _categoryView.frame = vm.categoryViewFrame;
    _headImage.frame = vm.headImageFrame;
    _replyButton.frame = vm.replyButtonFrame;
    //data
    _titleLabel.text = vm.queModel.text;
    [_headImage sd_setImageWithURL:[NSURL URLWithString:vm.queModel.author_info.avatar_tiny] placeholderImage:[UIImage imageNamed:@"10-45-7"]];
    _headImage.clipsToBounds = YES;
    _headImage.layer.cornerRadius = 10.0f;
    _categoryLabel.text = vm.queModel.title;
    
    //    NSLog(@"touxiang    %@     66    %@",vm.queModel.title,_categoryLabel.text);
    
    if (vm.queModel.picArr.count > 0) {
        [_imageView0 sd_setImageWithURL:[NSURL URLWithString:vm.queModel.picArr[0]] placeholderImage:[UIImage imageNamed:@""]];
        _imageView0.contentMode = UIViewContentModeScaleToFill;
        if (vm.queModel.picArr.count > 1) {
            [_imageView1 sd_setImageWithURL:[NSURL URLWithString:vm.queModel.picArr[1]] placeholderImage:[UIImage imageNamed:@""]];
            _imageView1.contentMode = UIViewContentModeScaleToFill;
        }
        if (vm.queModel.picArr.count > 2) {
            NSLog(@"ddfdfdfdfdfdf  imgae222  %@",vm.queModel.picArr[2]);
            [_imageView2 sd_setImageWithURL:[NSURL URLWithString:vm.queModel.picArr[2]] placeholderImage:[UIImage imageNamed:@""]];
            _imageView2.contentMode = UIViewContentModeScaleToFill;
        }
        
    }
    
    _timeLabel.text = vm.queModel.author_info.location;
    _authorLabel.text = vm.queModel.author_info.uname;
    NSString *ansTitle = [NSString stringWithFormat:@"%ld",vm.queModel.reply_count];
    [_answerButton setTitle:ansTitle forState:UIControlStateNormal];
    
    _imageView0.userInteractionEnabled = YES;
    _imageView1.userInteractionEnabled = YES;
    _imageView2.userInteractionEnabled = YES;
    
    _imageView0.tag = 101;
    _imageView1.tag = 102;
    _imageView2.tag = 102;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_imageView0 addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_imageView1 addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_imageView1 addGestureRecognizer:tap3];
    
    
    _urlImages = _vm.queModel.picArr;
    
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
