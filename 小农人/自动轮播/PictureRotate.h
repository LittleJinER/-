//
//  PictureRotate.h
//  PictureRotate
//
//  Created by lm on 2017/5/13.
//  Copyright © 2017年 CocaCola. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PictureRotate : UIView

// 图片数组（网络图片）
@property (nonatomic, strong) NSArray *images;

//// 图片数组（本地图片数组）
//@property (nonatomic, strong) NSArray *locationImages;
// 时间间隔
@property (nonatomic, assign) NSTimeInterval timeInterval;

//中间那张图片 即 显示的那张图片
@property (nonatomic, strong) UIImageView *middleImageView;

// 当前页数
@property (nonatomic, assign) NSInteger currentPage;



#pragma mark 添加定时器
- (void)addTimerLoop;
#pragma mark 暂停定时器
- (void)resumeTimer;

@end
