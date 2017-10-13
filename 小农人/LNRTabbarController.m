//
//  LNRTabbarController.m
//  小农人
//
//  Created by tomusng on 2017/8/14.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "LNRTabbarController.h"

#import "FirstPageViewController.h"
#import "Q_ATableViewController.h"
#import "DiscoveryViewController.h"
#import "MineViewController.h"

//#import "ZLTabbar.h"

@interface LNRTabbarController ()

@end

@implementation LNRTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.tabBar.backgroundColor = [UIColor whiteColor];
    

   
    
    [self setupTabbar];
    
}

#pragma mark -----设置tabbar
- (void)setupTabbar{
    
//    创建首页视图控制器
    FirstPageViewController *firstPageVC = [[FirstPageViewController alloc] init];
    
    [self createChildrenVC:firstPageVC childrenVCTitle:@"首页" image:[UIImage imageNamed:@"home_n"] selectedImage:[UIImage imageNamed:@"home_p"]];
//    创建问答页面视图控制器
    Q_ATableViewController *q_aVC = [[Q_ATableViewController alloc] init];
    [self createChildrenVC:q_aVC childrenVCTitle:@"问答" image:[UIImage imageNamed:@"question_n"] selectedImage:[UIImage imageNamed:@"question_p"]];
    
//    创建发现页面视图控制器
    DiscoveryViewController *discoveryVC = [[DiscoveryViewController alloc] init];
    [self createChildrenVC:discoveryVC childrenVCTitle:@"发现" image:[UIImage imageNamed:@"discover_n"] selectedImage:[UIImage imageNamed:@"discover_p"]];
//    创建我的页面视图控制器
    MineViewController *mineVC = [[MineViewController alloc] init];
    [self createChildrenVC:mineVC childrenVCTitle:@"我的" image:[UIImage imageNamed:@"mine_n"] selectedImage:[UIImage imageNamed:@"mine_p"]];
    
}



#pragma mark 添加子控制器
- (void)createChildrenVC:(UIViewController *)childViewController
         childrenVCTitle:(NSString *)title
                   image:(UIImage *)image
           selectedImage:(UIImage *)selectedImg
{
    //设置选中时item的字体颜色
    UIColor *selectedTinColor = [UIColor colorWithRed:252.0/255
                                                green:86.0/255
                                                 blue:56.0/255
                                                alpha:1.0f];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:NSForegroundColorAttributeName
                                                                                  forKey:selectedTinColor]
                                             forState:UIControlStateSelected];
    
    //设置未选中的image
    UIImage *deselectedImage = image;
    deselectedImage = [deselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childViewController.tabBarItem.image = deselectedImage;
    
    //设置选中的image
    UIImage *selectedImage = selectedImg;
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childViewController.tabBarItem.selectedImage = selectedImage;
    
    
    //设置tabbarItem文字和图标 之间的距离
    childViewController.tabBarItem.title = title;
    
    NSMutableDictionary *textDic = [NSMutableDictionary dictionary];
    textDic[NSForegroundColorAttributeName] = selectedTinColor;
    
    [childViewController.tabBarItem setTitleTextAttributes:textDic forState:UIControlStateSelected];
    //    childViewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, MAXFLOAT);
    
    //添加控制器对象
    UINavigationController *childNavigationContorller  = [[UINavigationController alloc]initWithRootViewController:childViewController];
    [self addChildViewController:childNavigationContorller];
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
