//
//  DiscoveryViewController.m
//  小农人
//
//  Created by tomusng on 2017/8/14.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "ExpertInformationVC.h"
#import "AgriculturalInformationVC.h"
#import "FeedbackViewController.h"


#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]


@interface DiscoveryViewController ()

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发现";
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
    
    
    [self createUI];
    
    
}

- (void)createUI{
    
//    创建顶部视图
    UIImageView *playView= [[UIImageView alloc] init];
    UIImage *playImage = [UIImage imageNamed:@"find"];
    
    CGFloat playViewH =  (playImage.size.height * K_WIDTH)/ playImage.size.width;
    playView.image = playImage;
    playView.frame = CGRectMake(0, 64, K_WIDTH, playViewH);
    [self.view addSubview:playView];
    
//    playView的最大高度
    CGFloat playMaxY = CGRectGetMaxY(playView.frame);
//    每个类别label的高度
    CGFloat bgViewHeight = 50.0f*DISTANCE_HEIGHT;
    
//    图片数组
    NSArray *imageArr = @[@"Finder_shenqing",@"Finder_baike"];
//    字符数组
    NSArray *strArr = @[@"申请专家",@"农业资讯"];
    
//    第三条线的最大高度
    CGFloat thirdLindMaxH = playMaxY + bgViewHeight *2 + 0.5*3*DISTANCE_HEIGHT;
    
  
    
    
//    创建三条横线
    for (int i = 0; i < 5; i ++) {
        
        
        
        if (i < 3) {
            UIView *lineView = [[UIView alloc] init];
            
            lineView.backgroundColor = LINEVIEW_COLOR;
            lineView.frame = CGRectMake(0, playMaxY + 10*DISTANCE_HEIGHT + i * (bgViewHeight + 0.5 *DISTANCE_HEIGHT), K_WIDTH, 0.5*DISTANCE_HEIGHT);
            
            [self.view addSubview:lineView];
            
            if (i < 2) {
                UIView *bgView = [[UIView alloc] init];
                
                bgView.backgroundColor = [UIColor whiteColor];
                bgView.frame = CGRectMake(0, playMaxY + 10.5*DISTANCE_HEIGHT + i * (bgViewHeight + 0.5 *DISTANCE_HEIGHT), K_WIDTH, bgViewHeight);
                [self.view addSubview:bgView];
                
                UIImageView *img = [[UIImageView alloc] init];
                img.frame = CGRectMake(10*DISTANCE_WIDTH, 15*DISTANCE_HEIGHT, 20*DISTANCE_HEIGHT, 20*DISTANCE_HEIGHT);
                img.image = [UIImage imageNamed:imageArr[i]];
                
                UILabel *lab = [[UILabel alloc] init];
                lab.frame = CGRectMake(40*DISTANCE_WIDTH, 15*DISTANCE_HEIGHT, 100*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
                lab.text = strArr[i];
                
                UIImageView *arrowView = [[UIImageView alloc] init];
                arrowView.frame = CGRectMake(K_WIDTH - 30*DISTANCE_WIDTH, 15*DISTANCE_HEIGHT, 20*DISTANCE_HEIGHT, 20*DISTANCE_HEIGHT);
                arrowView.image = [UIImage imageNamed:@"ReturnHistoryNW"];
                
                
                
                [bgView addSubview:img];
                [bgView addSubview:lab];
                [bgView addSubview:arrowView];
                
//                添加bgView的点击事件
                [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewDidClick:)]];
                bgView.tag = i + 1000;
                
            }

        }else{
            
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(0, thirdLindMaxH + 50*DISTANCE_HEIGHT+ (i - 3)*(bgViewHeight + 0.5*DISTANCE_HEIGHT), K_WIDTH , 0.5*DISTANCE_HEIGHT);
            lineView.backgroundColor = LINEVIEW_COLOR;
            [self.view addSubview:lineView];
            
            if (i == 3) {
                UIView *bgView = [[UIView alloc] init];
                 bgView.backgroundColor = [UIColor whiteColor];
                
                bgView.frame = CGRectMake(0, thirdLindMaxH + 50.5*DISTANCE_HEIGHT, K_WIDTH, bgViewHeight);
                UIImageView *img = [[UIImageView alloc] init];
                img.frame = CGRectMake(10*DISTANCE_WIDTH, 15*DISTANCE_HEIGHT, 20*DISTANCE_HEIGHT, 20*DISTANCE_HEIGHT);
                img.image = [UIImage imageNamed:@"Finder_yijian"];
                
                UILabel *lab = [[UILabel alloc] init];
                lab.frame = CGRectMake(40*DISTANCE_WIDTH, 15*DISTANCE_HEIGHT, 100*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
                lab.text = @"意见反馈";
                
                UIImageView *arrowView = [[UIImageView alloc] init];
                arrowView.frame = CGRectMake(K_WIDTH - 30*DISTANCE_WIDTH, 15*DISTANCE_HEIGHT, 20*DISTANCE_HEIGHT, 20*DISTANCE_HEIGHT);
                arrowView.image = [UIImage imageNamed:@"ReturnHistoryNW"];
                
                [bgView addSubview:img];
                [bgView addSubview:lab];
                [bgView addSubview:arrowView];
                [self.view addSubview:bgView];
//                添加bgView的点击事件
                [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewDidClick:)]];
                
                bgView.tag = i + 1000;
                }
            }
        }
    }

#pragma mark - bgView 的点击事件
- (void)bgViewDidClick:(UITapGestureRecognizer *)recognizer{
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)recognizer;
    
    NSInteger tag = tap.view.tag;
    
    switch (tag) {
        case 1000:
        {
            NSLog(@"0");
            ExpertInformationVC *exInfoVC = [[ExpertInformationVC alloc]init];
            [self.navigationController pushViewController:exInfoVC animated:YES];
            
        }
            break;
        case 1001:
        {
            NSLog(@"1");
            
            AgriculturalInformationVC *agriInfoVC = [[AgriculturalInformationVC alloc] init];
            [self.navigationController pushViewController:agriInfoVC animated:YES];
            
            
        }
            break;
        case 1003:
        {
            NSLog(@"3");
            FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedbackVC animated:YES];

        
        }
            break;
            
        default:
            break;
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
