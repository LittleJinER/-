//
//  CollectionViewHeaderView.m
//  UItableView联动UICollectionView
//
//  Created by 嚼华先森 on 2017/6/1.
//  Copyright © 2017年 嚼华. All rights reserved.
//

#import "CollectionViewHeaderView.h"

@implementation CollectionViewHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, self.frame.size.width, 30)];
        self.label.font = [UIFont systemFontOfSize:20.0];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
        [self addSubview:self.label];
    }
    return self;
}

@end
