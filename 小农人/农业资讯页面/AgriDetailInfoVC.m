//
//  AgriDetailInfoVC.m
//  小农人
//
//  Created by tomusng on 2017/9/14.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "AgriDetailInfoVC.h"
#import <WebKit/WebKit.h>

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define BGVIEW_COLOR     [UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1]

@interface AgriDetailInfoVC ()
@property (nonatomic, strong) UIView *statusView;
@end

@implementation AgriDetailInfoVC


- (void)viewWillAppear:(BOOL)animated{

    self.tabBarController.tabBar.hidden = YES;
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [self.statusView removeFromSuperview];
    self.tabBarController.tabBar.hidden = NO;
//    self.navigationController.navigationBar.backgroundColor = nil;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"农业资讯详情";
    self.tabBarController.tabBar.hidden = YES;
    self.statusView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, WIDTH, 20)];
//    _statusView.alpha = 0.1;
    _statusView.backgroundColor = BGVIEW_COLOR;
    self.navigationController.navigationBar.backgroundColor = BGVIEW_COLOR;
    [self.navigationController.navigationBar addSubview:_statusView];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    NSURL *url = [NSURL URLWithString:self.html];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
    
    
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
