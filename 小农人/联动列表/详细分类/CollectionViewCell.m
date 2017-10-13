//
//  CollectionViewCell.m
//  UItableView联动UICollectionView
//
//  Created by 嚼华先森 on 2017/6/1.
//  Copyright © 2017年 嚼华. All rights reserved.
//

#import "CollectionViewCell.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define DISTANCE_HEIGHT   [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH    [UIScreen mainScreen].bounds.size.width/375.0

@interface CollectionViewCell ()

@end

@implementation CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, self.bounds.size.width-4, self.bounds.size.width-4)];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imgView];
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(2, CGRectGetMaxY(self.imgView.frame)+5, self.bounds.size.width-4, 15)];
        self.name.font = [UIFont systemFontOfSize:12.0];
        self.name.numberOfLines = 0;
        self.name.textAlignment = NSTextAlignmentCenter;
//        self.name.backgroundColor = [UIColor yellowColor];
        [self .contentView addSubview:self.name];
        
        self.selectedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected"]];
        _selectedView.frame = CGRectMake(0, 2*DISTANCE_WIDTH, self.frame.size.width, self.frame.size.height - 20*DISTANCE_HEIGHT);
        _selectedView.alpha = 0;
        [self.contentView addSubview:_selectedView];
        [self bringSubviewToFront:_selectedView];
        
        
    }
    return self;
}

@end
