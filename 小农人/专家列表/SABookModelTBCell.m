//
//  SABookModelTBCell.m
//  01-购物车
//
//  Created by Shenao on 2017/5/17.
//  Copyright © 2017年 hcios. All rights reserved.
//

#import "SABookModelTBCell.h"
#import "SABookModel.h"
#import "UIImageView+WebCache.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height



@interface SABookModelTBCell ()

@property (nonatomic, strong) UIImageView * iconImg;
@property (strong, nonatomic) UILabel *classificationLab;
@property (strong, nonatomic) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailedClassificationLab;



//@property (weak, nonatomic) IBOutlet UIButton *minusBtu;
//@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end


@implementation SABookModelTBCell
//- (IBAction)plusButton {
//    
//    self.bookModel.count++;
//    
//    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.bookModel.count];
//    self.minusBtu.enabled = YES;
//    
//    [self.delegate bookCellDidClickPlusButton:self];
//    
//}
//- (IBAction)minusButton {
//    
//    self.bookModel.count--;
//    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.bookModel.count];
//    if (self.bookModel.count == 0) {
//        self.minusBtu.enabled = NO;
//    }
//    
//    [self.delegate bookCellDidClickMinusButton:self];
//    
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
        _iconImg.clipsToBounds = YES;
        _iconImg.layer.cornerRadius = 35.0f;
        [self addSubview:_iconImg];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImg.frame) + 10, 10, 100, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:_nameLabel];
        
        _classificationLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame) + 10 , 100, 20)];
        _classificationLab.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:_classificationLab];

        _detailedClassificationLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_classificationLab.frame) + 10, WIDTH - CGRectGetMinX(_nameLabel.frame) , 20)];
        
        _detailedClassificationLab.textColor = [UIColor colorWithRed:152.0/255 green:152.0/255 blue:152.0/255 alpha:1];
        _detailedClassificationLab.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:_detailedClassificationLab];

        _questionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _questionBtn.frame = CGRectMake(WIDTH - 70, 10, 60, 30);
        [_questionBtn setTitleColor:[UIColor colorWithRed:231.0/255 green:86.0/255 blue:71.0/255 alpha:1] forState:UIControlStateNormal];
        [_questionBtn setTitle:@"提问" forState:UIControlStateNormal];
        
        [_questionBtn.layer setMasksToBounds:YES];
        [_questionBtn.layer setCornerRadius:15.0f];
        [_questionBtn.layer setBorderWidth:1.0f];
        
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){231.0/255, 86.0/255, 71.0/255, 1});
        [_questionBtn.layer setBorderColor:color];
        
//        _questionBtn.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:231.0/255 green:86.0/255 blue:71.0/255 alpha:1]);

        _questionBtn.layer.borderWidth = 1.0f;
        [self addSubview:_questionBtn];
        
        
    }
    
    return self;
}



- (void)setBookModel:(SABookModel *)bookModel{
    _bookModel = bookModel;
    
    self.iconImg.image = [UIImage imageNamed:bookModel.icon];
    
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:bookModel.avatar_middle] placeholderImage:[UIImage imageNamed:@""]];
    
    self.nameLabel.text = bookModel.uname;

//    NSMutableString *crops = [[NSMutableString alloc] init];

//    for (NSString *str  in bookModel.tag) {
//        [crops stringByAppendingString:str];
//    }
    
    NSString *crops = [bookModel.tag componentsJoinedByString:@","];
    NSLog(@"tttttttt %@",bookModel.tag);
    self.detailedClassificationLab.text = crops;
//    self.classificationLab.text = [NSString stringWithFormat:@"¥%@",bookModel.tag];
    // 根据count决定countLabel显示文字
//    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.bookModel.count];
    // 根据count决定减号按钮是否能够被点击（如果不写这一行代码，会出现cell复用)
//    self.minusBtu.enabled = (bookModel.count > 0);
}

@end
