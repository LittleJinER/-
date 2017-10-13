//
//  SettingUpVC.m
//  小农人
//
//  Created by tomusng on 2017/9/15.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "SettingUpVC.h"
#import "FeedbackViewController.h"
#import "SPClearCacheTool.h"
//#import "Header.h"



#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]

#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]

#define LINE_HEIGHT 0.5*DISTANCE_WIDTH



@interface SettingUpVC ()

@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, strong) UILabel *verLab;
@property (nonatomic, copy) NSString *memorySize;
@property (nonatomic, strong) UILabel *memoryLab;

@end

@implementation SettingUpVC

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:@"home_navigation_back_btn"];
    leftBtn.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [leftBtn setImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self checkAppVersion];
    [self getMemory];
    [self setUpUI];
  
}




- (void)leftBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkAppVersion{
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];
    _appVersion = app_Version;
    
    
}

- (void)getMemory{
    NSString *memorySize = [SPClearCacheTool getCacheSize];
    _memorySize = memorySize;
}



- (void)setUpUI{
    
    CGFloat labHeigh = 20*DISTANCE_HEIGHT;
    CGFloat labWidth = 100 * DISTANCE_WIDTH;
    CGFloat lineHeight = 0.5*DISTANCE_HEIGHT;
    CGFloat viewHeight = 50*DISTANCE_HEIGHT;
    CGFloat imgWidth = 25*DISTANCE_HEIGHT;
    
    
    NSArray *nameArr = @[@"意见反馈",@"查看版本",@"清空缓存"];
    for (int i = 0 ; i < 3; i ++ ) {
        UIView *bgView = [[UIView alloc] init];
        
        bgView.frame = CGRectMake(0, 64 + (viewHeight + lineHeight)*i, K_WIDTH, viewHeight);
        bgView.tag = 10000 + i;
        [self.view addSubview:bgView];
        UILabel *lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(10*DISTANCE_WIDTH, (viewHeight - labHeigh)/2, labWidth, labHeigh);
        lab.text = nameArr[i];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont systemFontOfSize:17*DISTANCE_HEIGHT];
        [bgView addSubview:lab];
        if (i == 0) {
            UIImageView *img = [[UIImageView alloc] init];
            
            img.frame = CGRectMake(K_WIDTH - 10*DISTANCE_WIDTH - imgWidth, (viewHeight - imgWidth)/2, imgWidth, imgWidth);
            
            img.image = [UIImage imageNamed:@"ReturnHistoryNW"];
            [bgView addSubview:img];
            
        }else if (i == 1){
            UILabel *verLab = [[UILabel alloc] init];
            verLab.frame = CGRectMake(K_WIDTH - labWidth - 10*DISTANCE_WIDTH, (viewHeight - labHeigh)/2, labWidth, labHeigh);
            verLab.text = _appVersion;
            verLab.textAlignment = NSTextAlignmentRight;
            _verLab = verLab;
            verLab.font = [UIFont systemFontOfSize:17*DISTANCE_WIDTH];
            [bgView addSubview:verLab];
            
            
        }else if (i == 2){
            UILabel *memoryLab = [[UILabel alloc] init];
            memoryLab.frame = CGRectMake(K_WIDTH - labWidth - 10*DISTANCE_WIDTH, (viewHeight - labHeigh)/2, labWidth, labHeigh);
            memoryLab.text = _appVersion;
            memoryLab.textAlignment = NSTextAlignmentRight;
            memoryLab.text = _memorySize;
            _memoryLab = memoryLab;
            memoryLab.font = [UIFont systemFontOfSize:17*DISTANCE_WIDTH];
            
            [bgView addSubview:memoryLab];
        }
        
        [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)]];
        bgView.userInteractionEnabled = YES;
        
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(10 * DISTANCE_WIDTH, 64 + viewHeight + (viewHeight + lineHeight)*i, K_WIDTH, lineHeight);
        lineView.backgroundColor = LINEVIEW_COLOR;
        [self.view addSubview:lineView];
        
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:CGRectMake(10*DISTANCE_WIDTH, 64 + (viewHeight + lineHeight)*3 + 10*DISTANCE_HEIGHT, K_WIDTH - 20*DISTANCE_WIDTH, viewHeight)];
    [button setBackgroundColor:DE_RED_Color];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setClipsToBounds:YES];
    button.layer.cornerRadius = 5*DISTANCE_WIDTH;
    button.titleLabel.font = [UIFont systemFontOfSize:17*DISTANCE_HEIGHT];
    [button addTarget:self action:@selector(logOutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)viewTapClick:(UITapGestureRecognizer *)recognizer{
    
    UIView *view = recognizer.view;
    NSInteger teger = view.tag;
    NSLog(@"%ld",teger);
    
    switch (teger) {
        case 10000:
        {
            FeedbackViewController *feedBVC = [[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedBVC animated:YES];
        }
            break;
        case 10001:
        {
            [self checkAppVersion];
            _verLab.text = _appVersion;
        }
            break;
        case 10002:
        {
            
            UIAlertController *alert = [[UIAlertController alloc] init];
           
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
           UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [SPClearCacheTool clearCaches];
                [self getMemory];
                _memoryLab.text = _memorySize;
            }];
            
            [alert addAction:cancelAction];
            [alert addAction:sureAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
           
        }
            break;
            
        default:
            break;
    }
    
    
    
    
}





- (void)logOutBtnClick:(UIButton *)sender{
    NSLog(@"退出登录");
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
