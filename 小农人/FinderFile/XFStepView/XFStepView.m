//
//  XFStepView.m
//  SCPay
//
//  Created by weihongfang on 2017/6/26.
//  Copyright © 2017年 weihongfang. All rights reserved.
//

#import "XFStepView.h"

@interface XFStepView()

@property (nonatomic, strong)UIView *lineUndo;
//@property (nonatomic, strong)UIView *lineDone;

@property (nonatomic, retain)NSMutableArray *cricleMarks;
@property (nonatomic, retain)NSMutableArray *titleLabels;

//@property (nonatomic, strong)UILabel *lblIndicator;

@property (nonatomic, strong)UIImageView *selectedImageV;


@end


@implementation XFStepView

- (instancetype)initWithFrame:(CGRect)frame Titles:(nonnull NSArray *)titles
{
    if ([super initWithFrame:frame])
    {
        _stepIndex = 2;
        
        _titles = titles;
        
        _lineUndo = [[UIView alloc]init];
        _lineUndo.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_lineUndo];
        
//        _lineDone = [[UIView alloc]init];
//        _lineDone.backgroundColor = TINTCOLOR;
//        [self addSubview:_lineDone];
        
        for (NSString *title in _titles)
        {
            UILabel *lbl = [[UILabel alloc]init];
            lbl.text = title;
            lbl.textColor = [UIColor lightGrayColor];
            lbl.font = [UIFont systemFontOfSize:14];
            lbl.textAlignment = NSTextAlignmentCenter;
            [self addSubview:lbl];
            [self.titleLabels addObject:lbl];
//            
//            UIView *cricle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 13, 13)];
//            cricle.backgroundColor = [UIColor lightGrayColor];
//            cricle.layer.cornerRadius = 13.f / 2;
//            [self addSubview:cricle];
            
            UIImageView *passedImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
//            passedImageV.image = [UIImage imageNamed:@""];
            passedImageV.layer.cornerRadius = 13.0f/2;
            passedImageV.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:passedImageV];
            [self.cricleMarks addObject:passedImageV];
//            [self.cricleMarks addObject:cricle];
        }
        
//        _lblIndicator = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
//        _lblIndicator.textAlignment = NSTextAlignmentCenter;
//        _lblIndicator.textColor = TINTCOLOR;
//        _lblIndicator.backgroundColor = [UIColor whiteColor];
//        _lblIndicator.layer.cornerRadius = 23.f / 2;
//        _lblIndicator.layer.borderColor = [TINTCOLOR CGColor];
//        _lblIndicator.layer.borderWidth = 1;
//        _lblIndicator.layer.masksToBounds = YES;
        
        _selectedImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)] ;
        _selectedImageV.backgroundColor = [UIColor whiteColor];
        _selectedImageV.image = [UIImage imageNamed:@"Finder_point"];
        _selectedImageV.layer.cornerRadius = 23.0f/2;
        _selectedImageV.layer.borderColor = [TINTCOLOR CGColor];
        _selectedImageV.layer.borderWidth = 1;
        _selectedImageV.layer.masksToBounds = YES;
        [self addSubview:_selectedImageV];
        
        
//        [self addSubview:_lblIndicator];
    }
    return self;
}

#pragma mark - method

- (void)layoutSubviews
{
//    下面汉字的label
    NSInteger perWidth = self.frame.size.width / self.titles.count;
    
//    已过步骤的line的颜色
    _lineUndo.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    _lineUndo.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 4);
    
    CGFloat startX = _lineUndo.frame.origin.x + perWidth/2;
    
    for (int i = 0; i < _titles.count; i++)
    {
        UIView *cricle = [_cricleMarks objectAtIndex:i];
        if (cricle != nil)
        {
            cricle.center = CGPointMake(i * perWidth + startX, _lineUndo.center.y);
        }
        
        UILabel *lbl = [_titleLabels objectAtIndex:i];
        if (lbl != nil)
        {
            lbl.frame = CGRectMake(perWidth * i, self.frame.size.height / 2, self.frame.size.width / _titles.count, self.frame.size.height / 2);
        }
    }
    
    self.stepIndex = _stepIndex;
}

- (NSMutableArray *)cricleMarks
{
    if (_cricleMarks == nil)
    {
        _cricleMarks = [NSMutableArray arrayWithCapacity:self.titles.count];
    }
    return _cricleMarks;
}

- (NSMutableArray *)titleLabels
{
    if (_titleLabels == nil)
    {
        _titleLabels = [NSMutableArray arrayWithCapacity:self.titles.count];
    }
    return _titleLabels;
}

#pragma mark - public method

- (void)setStepIndex:(int)stepIndex
{
    if (stepIndex >= 0 && stepIndex < self.titles.count)
    {
        _stepIndex = stepIndex;
        
//        CGFloat perWidth = self.frame.size.width / _titles.count;
        
//        _lblIndicator.text = [NSString stringWithFormat:@"%d", _stepIndex + 1];
//        _lblIndicator.center = ((UIView *)[_cricleMarks objectAtIndex:_stepIndex]).center;
        _selectedImageV.center = ((UIView *)[_cricleMarks objectAtIndex:_stepIndex]).center;
        
        
//        _lineDone.frame = CGRectMake(_lineUndo.frame.origin.x, _lineUndo.frame.origin.y, perWidth * _stepIndex+perWidth/2, _lineUndo.frame.size.height);
        
        NSLog(@"gg  %@",_cricleMarks);
        
        for (int i = 0; i < _titles.count; i++)
        {
            UIImageView *imageV = [_cricleMarks objectAtIndex:i];
//            UIView *cricle = [_cricleMarks objectAtIndex:i];
//            if (cricle != nil)
            if (imageV != nil){
               
                if (i <= _stepIndex)
                {
//                    cricle.backgroundColor = TINTCOLOR;
                    imageV.image = [UIImage imageNamed:@"login_btn_selected"];
                    imageV.bounds = CGRectMake(0, 0, 18, 18);
                    imageV.layer.cornerRadius = 9;
                }
                else
                {
//                    cricle.backgroundColor = [UIColor lightGrayColor];
                    imageV.backgroundColor = [UIColor lightGrayColor];
                    imageV.image = [UIImage imageNamed:@""];
                    imageV.bounds = CGRectMake(0, 0, 13.0f, 13.0f);
                    imageV.layer.cornerRadius = 13.0f/2;
                }
            }
            
            UILabel *lbl = [_titleLabels objectAtIndex:i];
            if (lbl != nil)
            {
                if (i <= stepIndex)
                {
                    lbl.textColor = TINTCOLOR;
                }
                else
                {
                    lbl.textColor = [UIColor lightGrayColor];
                }
            }
        }
    }
}

- (void)setStepIndex:(int)stepIndex Animation:(BOOL)animation
{
    if (stepIndex >= 0 && stepIndex < self.titles.count)
    {
        if (animation)
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.stepIndex = stepIndex;
            }];
        }
        else
        {
            self.stepIndex = stepIndex;
        }
    }
}


@end
