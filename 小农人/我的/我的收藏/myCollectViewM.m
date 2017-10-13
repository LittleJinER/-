//
//  myCollectViewM.m
//  小农人
//
//  Created by tomusng on 2017/9/19.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "myCollectViewM.h"

#define LINE_WIDTH 0.5*DISTANCE_WIDTH
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0
#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height

#define textFont 17*DISTANCE_HEIGHT

@implementation myCollectViewM


- (void)setMyCollModel:(QuestionModel *)myCollModel{
    
    
    _myCollModel = myCollModel;
    
    CGFloat space = 10*DISTANCE_HEIGHT;
    CGFloat imgSpace = 5*DISTANCE_WIDTH;
//    text
    CGRect textRect = [_myCollModel.text boundingRectWithSize:CGSizeMake(K_WIDTH - 2*space, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textFont]} context:nil];
    CGSize textSize = textRect.size;
    _textLabFrame = CGRectMake(space, space, textSize.width, textSize.height);
    
    
    
    
//    image0
    
    CGFloat imgOriginH = 0.0;
    
    CGFloat imgWidth = (K_WIDTH - 4*imgSpace)/3;
    
    
    if (textSize.height > 0 ) {
        
        imgOriginH = CGRectGetMaxY(_textLabFrame) + space;
    }else{
        imgOriginH = space;
        
    }
    
    
    
     CGFloat headImgOriginH = 0.0;
    
    if (myCollModel.picArr.count > 0 ) {
        
       _image0ViewFrame = CGRectMake(imgSpace, imgOriginH, imgWidth, imgWidth);
        if (myCollModel.picArr.count > 1) {
            _image1ViewFrame = CGRectMake( CGRectGetMaxX(_image0ViewFrame) + imgSpace, imgOriginH, imgWidth, imgWidth);
        }
        
        if (myCollModel.picArr.count > 2) {
            _image2ViewFrame = CGRectMake(CGRectGetMaxX(_image1ViewFrame) + imgSpace, imgOriginH, imgWidth, imgWidth);
        }
        
        headImgOriginH = imgOriginH + space + CGRectGetMaxY(_image0ViewFrame);
        
        
    }else{
        
        headImgOriginH = imgOriginH;
        
    }
    
   
//    headImg
    CGFloat headImgHeight = 20*DISTANCE_HEIGHT;
    CGFloat labWidth = 100*DISTANCE_WIDTH;
    
    _headImgFrame = CGRectMake(space, headImgOriginH, headImgHeight, headImgHeight);
    _nameLabFrame = CGRectMake(CGRectGetMaxX(_headImgFrame) + space, headImgOriginH, 150*DISTANCE_WIDTH, headImgHeight);
    _answerBtnFrame = CGRectMake( K_WIDTH - LINE_WIDTH - labWidth - 60*DISTANCE_WIDTH, headImgOriginH, 60*DISTANCE_WIDTH, headImgHeight);
    
    _lineViewFrame = CGRectMake(CGRectGetMaxX(_answerBtnFrame), headImgOriginH, LINE_WIDTH, headImgHeight);
    _timeLabFrame = CGRectMake(CGRectGetMaxX(_lineViewFrame), headImgOriginH, labWidth, headImgHeight);
    
    
    _cellHeight = CGRectGetMaxY(_timeLabFrame) + space;

    
}




@end
