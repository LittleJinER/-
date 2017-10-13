//
//  SeedsDetailViewController.m
//  小农人
//
//  Created by tomusng on 2017/9/29.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "SeedsDetailViewController.h"

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

#define MENU_BUTTON_WIDTH  [UIScreen mainScreen].bounds.size.width/4.0
#define MENU_HEIGHT 44*DISTANCE_WIDTH
#define ITEM_HEIGHT 38*DISTANCE_WIDTH
@interface SeedsDetailViewController ()

@end

@implementation SeedsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    
//    [];
//    [];
    
    
    
    
}

- (void)createLabUI{
    
    UIScrollView *bgScroll = [[UIScrollView alloc] init];
    
    
    
    
    
    CGFloat space = 10*DISTANCE_WIDTH;
    
    CGFloat labOriginH = 64 + 50*DISTANCE_HEIGHT;
    
    CGFloat labHeight = 20*DISTANCE_HEIGHT;
    
    NSArray *nameArr = @[@"作物种类",@"审定（登记）编号",@"审定（登记）时间",@"审定（登记）单位",@"",@"",];
    
    for (int i = 0 ; i < 6; i ++) {
        UILabel *nameLab = [[UILabel alloc] init];
        
        
        nameLab.frame = CGRectMake(space, labOriginH + (labHeight + space)*i, 100*DISTANCE_WIDTH, labHeight);
        
        
        
    }
    
    
    
    
    
    
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
