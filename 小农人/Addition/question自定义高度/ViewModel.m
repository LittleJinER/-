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

#import "FontModel.h"
#import "QuestionModel.h"
#import "MJExtension.h"

#define DEF_Screen_Width [UIScreen mainScreen].bounds.size.width

#define DEF_Screen_Height [UIScreen mainScreen].bounds.size.height

@implementation ViewModel


- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)setqueModel:(QuestionModel *)queModel {
    
    _queModel = queModel;
    //设置frame 与高度
    CGFloat const marginX = 10.00f;
    CGFloat const marginY = 10.00f;
    
    CGFloat titleLabelWidth = DEF_Screen_Width - marginX * 2;
    
    CGSize titleSize = [queModel.text boundingRectWithSize:CGSizeMake(titleLabelWidth, DEF_Screen_Height / 2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:titleFont + 1]} context:nil].size;
    //titleLabelFrame  正文label
    _titleLabelFrame = CGRectMake(marginX, 2*marginY, titleLabelWidth, titleSize.height);
    //    _categoryViewFrame 作物种类 label
    _categoryViewFrame = CGRectMake(marginX, CGRectGetMaxY(_titleLabelFrame) + marginY, 200, 20);
    
    
    //imageView0Frame   三张图片
    CGFloat imgWidth = (DEF_Screen_Width - marginX * 4) / 3;
    CGFloat imgHeight = imgWidth;

    CGFloat timeOriginHeigth;
    
    if (queModel.picArr.count > 0) {
        
        _imageView0Frame = CGRectMake(marginX, CGRectGetMaxY(_categoryViewFrame) + marginY, imgWidth, imgHeight);
        //imageView1Frame
        if (queModel.picArr.count > 1) {
            _imageView1Frame = CGRectMake(CGRectGetMaxX(_imageView0Frame) + marginX, CGRectGetMaxY(_categoryViewFrame) + marginY, imgWidth, imgHeight);
        }
        if (queModel.picArr.count > 2) {
            //imageView2Frame
            _imageView2Frame = CGRectMake(CGRectGetMaxX(_imageView1Frame) + marginX, CGRectGetMaxY(_categoryViewFrame) + marginY, imgWidth, imgHeight);
        }
        
        timeOriginHeigth = CGRectGetMaxY(_imageView0Frame) + marginY;
        
    }else{
        timeOriginHeigth = CGRectGetMaxY(_categoryViewFrame) + marginY;
    }
    
    
    
    //    用户头像imageview
    _headImageFrame = CGRectMake(marginX, timeOriginHeigth, 20, 20);
    
    //   authorLabelFrame  用户名label
    _authorLabelFrame = CGRectMake(CGRectGetMaxX(_headImageFrame) + marginX, timeOriginHeigth, 120, 20);
    
    //timeLabelFrame  地理信息label
    _timeLabelFrame = CGRectMake(CGRectGetMaxX(_authorLabelFrame)+ marginX, timeOriginHeigth, 100, 20);
    
    //    answerButtonFrame（解答按钮）button
    _answerButtonFrame = CGRectMake(DEF_Screen_Width - 130,timeOriginHeigth, 60, 20);
    
//     解答按钮  replyButtonFrame
    _replyButtonFrame = CGRectMake(DEF_Screen_Width - 60, timeOriginHeigth, 60, 20);
    
    //    cell的高度
    //rowHeight
    _rowHeight = CGRectGetMaxY(_authorLabelFrame) + marginY;
    
    
    
    
    
}

@end
