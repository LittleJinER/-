//
//  SearchBarView.m
//  小农人
//
//  Created by tomusng on 2017/9/27.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "SearchBarView.h"
#import "FaTextField.h"


#define ViewWidth [[UIScreen mainScreen] bounds].size.width
#define ViewHeight [[UIScreen mainScreen] bounds].size.height - 64 - MENU_HEIGHT - LINE_HEIGHT

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]
#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]
#define BG_COLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]
#define LIGHT_TITLE_COLOR [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1]

#define CUSTOM_COLOR(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]

#define LINE_HEIGHT 0.5*DISTANCE_WIDTH

#define MENU_BUTTON_WIDTH  [UIScreen mainScreen].bounds.size.width/7.0
#define MENU_HEIGHT 44*DISTANCE_WIDTH

@interface SearchBarView ()<UITextFieldDelegate>

@end

@implementation SearchBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
       
        //    设置搜索框
//            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10*DISTANCE_WIDTH, 64+10*DISTANCE_HEIGHT, K_WIDTH - 20*DISTANCE_WIDTH, 30*DISTANCE_HEIGHT)];
       
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            
        //设置圆角效果
        bgView.layer.cornerRadius = 14;
            bgView.layer.masksToBounds = YES;
        _bgView = bgView;
        bgView.backgroundColor = [UIColor whiteColor];
        //    bgView.backgroundColor = BG_COLOR;
            
        [self addSubview:bgView];
            
        FaTextField *textField = [[FaTextField alloc] initWithFrame:CGRectMake(40*DISTANCE_WIDTH, 0, CGRectGetWidth(bgView.frame) - 120*DISTANCE_WIDTH, CGRectGetHeight(bgView.frame))];
        textField.font = [UIFont systemFontOfSize:12.8*DISTANCE_HEIGHT];
            
        //清除按钮
        textField.clearButtonMode =UITextFieldViewModeWhileEditing;
            
        textField.delegate = self;
        //键盘属性
        //    _textField.returnKeyType = UIReturnKeySearch;
            
        //为textField设置属性占位符
        //    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索问题" attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
        textField.placeholder = @"有效成分、作物";
        _textField = textField;
        textField.textColor = [UIColor blackColor];
        textField.textAlignment = NSTextAlignmentCenter;
            
        [bgView addSubview:textField];
            
        UIImage *searchImage = [UIImage imageNamed:@"commen_search"];
        UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, searchImage.size.width*DISTANCE_WIDTH,  searchImage.size.height*DISTANCE_HEIGHT)];
        searchImageView.image = searchImage;
        searchImageView.contentMode = UIViewContentModeCenter;
        textField.leftView = searchImageView;
        textField.leftViewMode = UITextFieldViewModeAlways;
            
            
            
        

    }
    return self;
    
    
}





@end
