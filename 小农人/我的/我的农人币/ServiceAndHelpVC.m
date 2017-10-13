//
//  ServiceAndHelpVC.m
//  小农人
//
//  Created by tomusng on 2017/9/15.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "ServiceAndHelpVC.h"

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]

@interface ServiceAndHelpVC ()

@end

@implementation ServiceAndHelpVC



- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"客服与服务";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:@"home_navigation_back_btn"];
    leftBtn.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [leftBtn setImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    
    [self setUpUI];
    
    
    
}

- (void)setUpUI{
    
    
//    CGFloat firstViewHeight = 64* DISTANCE_HEIGHT;
    CGFloat viewHeight = 50* DISTANCE_HEIGHT;
    CGFloat labHeight = 20*DISTANCE_HEIGHT;
//    CGFloat labWidth = 100 * DISTANCE_WIDTH;
    CGFloat phoneImgHeight = 30*DISTANCE_HEIGHT;
    CGFloat arrowHeight = 25*DISTANCE_HEIGHT;
    
    UIImageView *imgV = [[UIImageView alloc] init];
    UIImage *helpImage = [UIImage imageNamed:@"help.png"];
    
    CGFloat imgVHeight = helpImage.size.height * K_WIDTH/helpImage.size.width;
    imgV.frame = CGRectMake(0, 64, K_WIDTH, imgVHeight);
    imgV.image = helpImage;
    [self.view addSubview:imgV];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, CGRectGetMaxY(imgV.frame) + 10*DISTANCE_HEIGHT, K_WIDTH, viewHeight);
    
    [self.view addSubview:bgView];
    
    UIImageView *phoneImg = [[UIImageView alloc] init];
    phoneImg.frame = CGRectMake(10*DISTANCE_WIDTH, (viewHeight - phoneImgHeight)/2, phoneImgHeight, phoneImgHeight);
    phoneImg.image = [UIImage imageNamed:@"phone"];
    [bgView addSubview:phoneImg];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(CGRectGetMaxX(phoneImg.frame) + 10*DISTANCE_WIDTH, (viewHeight - labHeight)/2, 250*DISTANCE_WIDTH, labHeight);
    lab.text = @"拨打热线----13259866502";
    lab.font = [UIFont systemFontOfSize:17*DISTANCE_HEIGHT];
    [bgView addSubview:lab];
    
    UIImageView *arrowImg = [[UIImageView alloc] init];
    arrowImg.frame = CGRectMake(K_WIDTH - 10*DISTANCE_HEIGHT - arrowHeight, (viewHeight - arrowHeight)/2, arrowHeight, arrowHeight);
    arrowImg.image = [UIImage imageNamed:@"ReturnHistoryNW"];
    [bgView addSubview:arrowImg];
    
    
    
    bgView.userInteractionEnabled = YES;
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTapClick:)]];
    
    
    
}

- (void)bgViewTapClick:(UITapGestureRecognizer *)recognizer{
    
    
    NSLog(@"拨打热线电话");
    UIWebView *callWebView = [[UIWebView alloc] init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:13259866502"]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebView];
}










- (void)leftBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
