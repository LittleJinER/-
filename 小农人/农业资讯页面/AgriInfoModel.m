//
//  AgriInfoModel.m
//  小农人
//
//  Created by tomusng on 2017/9/13.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "AgriInfoModel.h"
#import "MJExtension.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0


@implementation AgriInfoModel


+ (NSDictionary *)mj_objectClassInArray{
   
    return @{
             @"attach":@"AttachModel"
             };
    
}



//- (id)init{
//    
//    self = [super init];
//    if (self) {
//        
//        
////        self.titleLFrame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
////        self.imgV0Frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
////        self.imgV1Frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
////        self.imgV2Frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
////        self.timeLFrame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
////        self.signLFrame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
////        NSLog(@"set方法     0000000   %lu",(unsigned long)attach.count);
////        _attach = attach;
//        
//    
//    }
//    
//    return self;
//    
//    
//}
//
//
//- (void)setAttach:(NSMutableArray *)attach{
//    
////    NSLog(@"set方法     0000000   %lu",(unsigned long)attach.count);
//    _attach = attach;
////
////    CGFloat spaceHeight = 10*DISTANCE_HEIGHT;
////    CGFloat spaceWidth = 10*DISTANCE_WIDTH;
////    CGFloat imageWidth = (WIDTH - 4*spaceWidth)/3;
////    
////    
////    CGRect titleRect = [self.content boundingRectWithSize:CGSizeMake(WIDTH - spaceWidth * 2*DISTANCE_WIDTH, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16*DISTANCE_HEIGHT]} context:nil];
////    CGSize titleSize = titleRect.size;
////    
////    _titleLFrame = CGRectMake(spaceWidth, spaceHeight, titleSize.width, titleSize.height);
////    
////    
////    
////    NSLog(@" ***   %f     ===   %f",titleSize.width,titleSize.height);
////    
////    if (attach.count > 0) {
////        
////        if (attach.count == 2) {
////            
////        }
////        if (attach.count == 4) {
////            
////            _imgV0Frame = CGRectMake(spaceWidth, CGRectGetMaxY(_titleLFrame)+ spaceHeight, imageWidth, imageWidth);
////            
////             _imgV1Frame = CGRectMake(CGRectGetMaxX(_imgV0Frame) + spaceWidth, CGRectGetMaxY(_titleLFrame)+ spaceHeight, imageWidth, imageWidth);
////            
////             _imgV2Frame = CGRectMake( CGRectGetMaxX(_imgV2Frame) + spaceWidth, CGRectGetMaxY(_titleLFrame)+ spaceHeight, imageWidth, imageWidth);
////            
////        }
////    }
////    
////    _signLFrame = CGRectMake(spaceWidth, CGRectGetMaxY(_imgV0Frame)+spaceHeight, 100*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
////    
////    _timeLFrame = CGRectMake(CGRectGetMaxX(_signLFrame)+spaceWidth, CGRectGetMinX(_signLFrame), 150*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
////    
////    _cellHeight = CGRectGetMaxY(_timeLFrame);
////    NSLog(@" ***   %f",_cellHeight);
//    
//}
//
//- (void)setContent:(NSString *)content{
//    NSLog(@" ***      ---------   %@",_content);
//    _content = content;
//    NSLog(@" ***      +++++++   %@",_content);
//}
//- (void)setHas_attach:(NSInteger)has_attach{
//    _has_attach = has_attach;
//}
//

@end
