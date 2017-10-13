//
//  LLSearchView.h
//  LLSearchView
//
//  Created by 王龙龙 on 2017/7/25.
//  Copyright © 2017年 王龙龙. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LLSearchViewDelegate <NSObject>

- (void)selectedCropClassificationWithCrop:(NSString *)cropStr;

@end



typedef void(^TapActionBlock)(NSString *str);
@interface LLSearchView : UIView

@property (nonatomic, copy) TapActionBlock tapAction;

@property (nonatomic, assign) id<LLSearchViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame hotArray:(NSMutableArray *)hotArr historyArray:(NSMutableArray *)historyArr;

@end
