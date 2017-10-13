//
//  ExpertDViewModel.m
//  小农人
//
//  Created by tomusng on 2017/9/4.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "ExpertDViewModel.h"

#import "DataTool.h"
#import "NSObject+Model.h"
#import "NSObject+Properity.h"

#import "FontModel.h"
#import "QuestionModel.h"
#import "MJExtension.h"

#define DEF_Screen_Width [UIScreen mainScreen].bounds.size.width

#define DEF_Screen_Height [UIScreen mainScreen].bounds.size.height

@implementation ExpertDViewModel


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
    _titleLabelFrame = CGRectMake(marginX, marginY, titleLabelWidth, titleSize.height);
    
    //imageView0Frame   三张图片
    CGFloat imgWidth = (DEF_Screen_Width - marginX * 4) / 3;
    CGFloat imgHeight = imgWidth;
    
    CGFloat titleOriginHeigth;
    
    if (queModel.picArr.count > 0) {
        
        _imageView0Frame = CGRectMake(marginX, CGRectGetMaxY(_titleLabelFrame) + marginY, imgWidth, imgHeight);
        //imageView1Frame
        if (queModel.picArr.count > 1) {
            _imageView1Frame = CGRectMake(CGRectGetMaxX(_imageView0Frame) + marginX, CGRectGetMaxY(_titleLabelFrame) + marginY, imgWidth, imgHeight);
        }
        if (queModel.picArr.count > 2) {
            //imageView2Frame
            _imageView2Frame = CGRectMake(CGRectGetMaxX(_imageView1Frame) + marginX, CGRectGetMaxY(_titleLabelFrame) + marginY, imgWidth, imgHeight);
        }
        
        titleOriginHeigth = CGRectGetMaxY(_imageView0Frame) + marginY;
        
    }else{
        titleOriginHeigth = CGRectGetMaxY(_titleLabelFrame) + marginY;
    }
    
    
    
    //    用户头像imageview
    _headImageFrame = CGRectMake(marginX, titleOriginHeigth, 20, 20);
    
    //   authorLabelFrame  用户名label
    _authorLabelFrame = CGRectMake(CGRectGetMaxX(_headImageFrame) + marginX, titleOriginHeigth, 50, 20);
    
    //timeLabelFrame  地理信息label
    _timeLabelFrame = CGRectMake(CGRectGetMaxX(_authorLabelFrame)+ marginX, titleOriginHeigth, 100, 20);
    
    //    categoryLab 类别
    _categoryLabFrame = CGRectMake(DEF_Screen_Width - 150,titleOriginHeigth, 60, 20);
    
    //     afterLab  时间
    _afterLabFrame = CGRectMake(DEF_Screen_Width - 90, titleOriginHeigth, 90, 20);
    
    //    cell的高度
    //rowHeight
    _rowHeight = CGRectGetMaxY(_authorLabelFrame) + marginY;
    
    
    
    
    
}

@end

