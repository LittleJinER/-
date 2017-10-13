//
//  PictureRotate.m
//  PictureRotate
//
//  Created by lm on 2017/5/13.
//  Copyright © 2017年 CocaCola. All rights reserved.
//

#import "PictureRotate.h"
#import "AgriViewModel.h"
#import "UIImageView+WebCache.h"

#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0




@interface PictureRotate () < UIScrollViewDelegate >

@property (nonatomic, strong) UIScrollView *scrollView;


// 左中右三个视图
@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UIPageControl *pageControl;

//左中右三个label
@property (nonatomic, strong) UILabel *leftLab;
@property (nonatomic, strong) UILabel *midLab;
@property (nonatomic, strong) UILabel *rightLab;


@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *textArr;


@property (nonatomic, strong) NSTimer *timer;// 定时器



@end

@implementation PictureRotate

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}


- (NSMutableArray *)imageArr{
    
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
    
}
- (NSMutableArray *)textArr{
    
    if (!_textArr) {
        _textArr = [NSMutableArray array];
    }
    return _textArr;
    
}

- (void)setupUI {

    
    
    if (self.images.count == 2) {
        
        
        [self.imageArr addObjectsFromArray:self.images[0]];
        [self.textArr addObjectsFromArray:self.images[1]];
        
        
    }else{
        
        [self.imageArr addObjectsFromArray:self.images];
        
        NSLog(@"%ld",self.imageArr.count);
        
        _leftImageView.image = [UIImage imageNamed:self.imageArr[_images.count - 1]];
        _middleImageView.image = [UIImage imageNamed:_imageArr[_currentPage]];
        _rightImageView.image = [UIImage imageNamed:_imageArr[_currentPage + 1]];
    }
    
    
    NSLog(@" image --- %@",self.imageArr);
    
    
    
    
    
    
    
    
    NSLog(@"    22     %ld",_imageArr.count);
    

    
    
    
    
    CGFloat viewW = self.frame.size.width;
    CGFloat viewH = self.frame.size.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
    scrollView.contentSize = CGSizeMake(viewW * 3, viewH);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    leftImageView.frame = CGRectMake(viewW * 0, 0, viewW, viewH);
    [scrollView addSubview:leftImageView];
    _leftImageView = leftImageView;
    
    UIImageView *middleImageView = [[UIImageView alloc] init];
    middleImageView.frame = CGRectMake(viewW * 1, 0, viewW, viewH);
    [scrollView addSubview:middleImageView];
    _middleImageView = middleImageView;
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    rightImageView.frame = CGRectMake(viewW * 2, 0, viewW, viewH);
    [scrollView addSubview:rightImageView];
    _rightImageView = rightImageView;
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(viewW - 70*DISTANCE_WIDTH, viewH - 20*DISTANCE_HEIGHT, 60, 20*DISTANCE_HEIGHT)];
    pageControl.numberOfPages = self.imageArr.count;
    pageControl.currentPage = _currentPage;
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self bringSubviewToFront:pageControl];
    [self addSubview:pageControl];
    _pageControl = pageControl;
    
    // 默认显示中间的视图
    _scrollView.contentOffset = CGPointMake(viewW, 0);
    _scrollView.delegate = self;
    
    _currentPage = 0;// 默认是第一张图片
    
    
    if (self.images.count == 2) {
        NSURL *leftImgUrl = [NSURL URLWithString:self.imageArr[_imageArr.count - 1]];
        [_leftImageView sd_setImageWithURL:leftImgUrl placeholderImage:[UIImage imageNamed:@""]];
        //    [_leftImageView sd_setImageWithURL:leftImgUrl];
        NSURL *midImgUrl = [NSURL URLWithString:self.imageArr[_currentPage]];
        [_middleImageView sd_setImageWithURL:midImgUrl placeholderImage:[UIImage imageNamed:@""]];
        NSURL *rightImgUrl = [NSURL URLWithString:self.imageArr[_currentPage + 1]];
        [_rightImageView sd_setImageWithURL:rightImgUrl placeholderImage:[UIImage imageNamed:@""]];
        
        
        
        
        UILabel *leftLab = [[UILabel alloc] init];
        leftLab.frame = CGRectMake(viewW*0+10*DISTANCE_WIDTH, viewH - 30*DISTANCE_HEIGHT, viewW - (10 + 80)*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
        _leftLab = leftLab;
        [scrollView addSubview:leftLab];
        
        UILabel *midLab = [[UILabel alloc] init];
        midLab.frame = CGRectMake(viewW*1+10*DISTANCE_WIDTH, viewH - 30*DISTANCE_HEIGHT, viewW - (10 + 80)*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
        _midLab = midLab;
        [scrollView addSubview:midLab];
        
        UILabel *rightLab = [[UILabel alloc] init];
        rightLab.frame = CGRectMake(viewW*2+10*DISTANCE_WIDTH, viewH - 30*DISTANCE_HEIGHT, viewW - (10 + 80)*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
        _rightLab = rightLab;
        [scrollView addSubview:rightLab];
        
        
        _leftLab.text = self.textArr[_textArr.count - 1];
        _midLab.text = self.textArr[_currentPage];
        _rightLab.text = self.textArr[_currentPage + 1];
    }
    
    
    
    
    
    
    
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 拖拽的时候需要暂停定时器，以免在拖拽过程中出现轮转
    [self resumeTimer];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidEndDecelerating:%f",scrollView.contentOffset.x);
    CGPoint contentOffset = scrollView.contentOffset;
    [self changeCurrent:contentOffset];
    // 减速结束的时候开启定时器
    [self addTimerLoop];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
//    NSLog(@"scrollViewDidEndDragging:%f",scrollView.contentOffset.x);
    CGPoint contentOffset = scrollView.contentOffset;
//    NSLog(@"%f", contentOffset.x);
    [self changeCurrent:contentOffset];
    
    // 结束拖拽的时候开启定时器
    [self addTimerLoop];
}

#pragma maark 视图切换   -----     拖拽方法      -----
- (void)changeCurrent:(CGPoint)contentOffset {
    
    CGFloat viewW = self.frame.size.width;
    // 停止拖拽的时候还原ScrollView的偏移量
    _scrollView.contentOffset = CGPointMake(viewW, 0);

    // 当拖拽的位置大于视图一半的时候，应该切换图片，否则还是保留原来的图片
    if (contentOffset.x > viewW + viewW / 2) { // 向 <-- 拖拽视图超过一半
        _currentPage++;
        // 如果是最后的图片，让其成为第一个
        if (_currentPage >= _imageArr.count) {
            _currentPage = 0;
        }
        NSLog(@"切换下一张:%ld", _currentPage);
    } else if (contentOffset.x < viewW / 2) {// 向 --> 拖拽视图超过一半
        _currentPage--;
        // 如果是开始的图片，让其成为最后一个
        if (_currentPage < 0) {
            _currentPage = _imageArr.count - 1;
        }
        NSLog(@"切换上一张:%ld", _currentPage);
    } else {
        NSLog(@"不变:%ld", _currentPage);
    }
    [self showImageView:_currentPage];
}

#pragma mark 添加定时器
- (void)addTimerLoop {
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(changeContentOffset) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
}

#pragma mark 暂停定时器
- (void)resumeTimer {
    
    // 释放定时器
    [_timer invalidate];
    _timer = nil;
    
}

#pragma mark 私有方法   ------   定时器方法
- (void)changeContentOffset {
    
    _currentPage++;
    // 如果是最后的图片，让其成为第一个
    if (_currentPage >= _imageArr.count) {
        _currentPage = 0;
    }
    [self showImageView:_currentPage];
    
    NSLog(@"定时器在走");
}

- (void)showImageView:(NSInteger)currentPage {
    
    
    NSInteger down = currentPage + 1;
    NSInteger up = currentPage - 1;
    // 如果是最后的图片，让其成为第一个
    if (down >= _imageArr.count) {
        down = 0;
    }
    // 如果是开始的图片，让其成为最后一个
    if (up < 0) {
        up = _imageArr.count - 1;
    }
    
    
    if (self.images.count == 2) {
      
        NSURL *leftImgUrl = [NSURL URLWithString:self.imageArr[up]];
        [_leftImageView sd_setImageWithURL:leftImgUrl placeholderImage:[UIImage imageNamed:@""]];
        NSURL *midImgUrl = [NSURL URLWithString:self.imageArr[currentPage]];
        [_middleImageView sd_setImageWithURL:midImgUrl placeholderImage:[UIImage imageNamed:@""]];
        NSURL *rightImgUrl = [NSURL URLWithString:self.imageArr[down]];
        [_rightImageView sd_setImageWithURL:rightImgUrl placeholderImage:[UIImage imageNamed:@""]];
        
        _leftLab.text = self.textArr[up];
        _midLab.text = self.textArr[currentPage];
        _rightLab.text = self.textArr[down];

        
    }else{
        
    _leftImageView.image = [UIImage imageNamed:self.imageArr[up]];
    _middleImageView.image = [UIImage imageNamed:self.imageArr[currentPage]];
    _rightImageView.image = [UIImage imageNamed:self.imageArr[down]];
    
    }
       
    
    
    _pageControl.currentPage = currentPage;
}

#pragma mark setter
- (void)setImages:(NSArray *)images {
    
    _images = images;
    
    
    
    [self setupUI];
    
}





- (void)setTimeInterval:(NSTimeInterval)timeInterval {

    _timeInterval = timeInterval;
    [self addTimerLoop];
}
@end
