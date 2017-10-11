//
//  ViewModel.m
//  RAC+MVVM自适应高度cell
//
//  Created by 王子翰 on 2017/3/3.
//  Copyright © 2017年 王子翰. All rights reserved.
//

#import "ViewModel.h"
#import "DataTool.h"
#import "NSObject+Model.h"
#import "NSObject+Properity.h"
#import "Model.h"
#import "FontModel.h"
#import "QuestionModel.h"
#import "MJExtension.h"

@implementation ViewModel


- (instancetype)init {
    if (self = [super init]) {
        
    }
                
       return self;
}

- (void)setqueModel:(QuestionModel *)queModel {
    
    NSLog(@"dddddddd"  );
    
    _queModel = queModel;
    //设置frame 与高度
    CGFloat const marginX = 10.00f;
    CGFloat const marginY = 5.00f;
    
    CGFloat titleLabelWidth = DEF_Screen_Width - marginX * 2;
    
    CGSize titleSize = [queModel.text boundingRectWithSize:CGSizeMake(titleLabelWidth, DEF_Screen_Height / 2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:titleFont + 1]} context:nil].size;
    //titleLabelFrame
    _titleLabelFrame = CGRectMake(marginX, marginY, titleLabelWidth, titleSize.height);
//    _categoryViewFrame
    _categoryViewFrame = CGRectMake(marginX, CGRectGetMaxY(_titleLabelFrame) + marginY, 200, 20);
    
    NSLog(@" text       88888        %f",titleSize.height);
    //imageView0Frame
    CGFloat imgWidth = (DEF_Screen_Width - marginX * 4) / 3;
    CGFloat imgHeight = imgWidth;
    _imageView0Frame = CGRectMake(marginX, CGRectGetMaxY(_categoryViewFrame) + marginY, imgWidth, imgHeight);
    //imageView1Frame
    _imageView1Frame = CGRectMake(CGRectGetMaxX(_imageView0Frame) + marginX, CGRectGetMaxY(_categoryViewFrame) + marginY, imgWidth, imgHeight);
    //imageView2Frame
    _imageView2Frame = CGRectMake(CGRectGetMaxX(_imageView1Frame) + marginX, CGRectGetMaxY(_categoryViewFrame) + marginY, imgWidth, imgHeight);
    //timeLabelFrame
    _timeLabelFrame = CGRectMake(20 + marginX, CGRectGetMaxY(_imageView2Frame) + marginY, DEF_Screen_Width / 2, 20.00);
    //authorLabelFrame
    _authorLabelFrame = CGRectMake(DEF_Screen_Width / 2 + (DEF_Screen_Width / 2 - marginX)/2.0, CGRectGetMaxY(_imageView2Frame) + marginY, (DEF_Screen_Width / 2 - marginX)/2.0, 20.00);
    
    
//    answerButtonFrame
    _answerButtonFrame = CGRectMake(DEF_Screen_Width / 2, CGRectGetMaxY(_imageView2Frame) + marginY, (DEF_Screen_Width / 2 - marginX)/2.0, 20.00);
    
    _headImageFrame = CGRectMake(marginX, CGRectGetMaxY(_imageView2Frame) + marginY, 20, 20.00f);
    
    
    //rowHeight
    _rowHeight = CGRectGetMaxY(_authorLabelFrame) + marginY;
}

@end
