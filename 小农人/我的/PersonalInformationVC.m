//
//  PersonalInformationVC.m
//  小农人
//
//  Created by tomusng on 2017/9/19.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "PersonalInformationVC.h"
#import "NicknameVC.h"

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]
#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]

#define LINE_HEIGHT 0.5*DISTANCE_WIDTH


@interface PersonalInformationVC ()

@end

@implementation PersonalInformationVC


- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人信息";
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



- (void)leftBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setUpUI{
    
    CGFloat firstViewHeight = 64* DISTANCE_HEIGHT;
    CGFloat viewHeight = 50* DISTANCE_HEIGHT;
    CGFloat labHeight = 20*DISTANCE_HEIGHT;
    CGFloat labWidth = 100 * DISTANCE_WIDTH;
    CGFloat headImgHeight = 50*DISTANCE_HEIGHT;
    CGFloat arrowHeight = 25*DISTANCE_HEIGHT;
    
    
    NSArray *labArr = [NSArray arrayWithObjects:@"头像",@"昵称", nil];
    
    for (int i = 0 ; i < 2; i ++) {
        UIView *bgView = [[UIView alloc] init];
        UILabel *lab = [[UILabel alloc] init];
        UIImageView *arrowImg = [[UIImageView alloc] init];
        arrowImg.image = [UIImage imageNamed:@"ReturnHistoryNW"];
        [bgView addSubview:lab];
        [bgView addSubview:arrowImg];
        lab.text = labArr[i];
        lab.font = [UIFont systemFontOfSize:17*DISTANCE_HEIGHT];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = LINEVIEW_COLOR;
        [self.view addSubview:lineView];
        
        if (i == 0) {
            bgView.frame = CGRectMake(0, 64, K_WIDTH - 10*DISTANCE_WIDTH, firstViewHeight);
            lab.frame = CGRectMake(10*DISTANCE_WIDTH, (firstViewHeight - labHeight)/2, labWidth, labHeight);
            arrowImg.frame = CGRectMake(K_WIDTH - arrowHeight - 10*DISTANCE_WIDTH, (firstViewHeight - arrowHeight)/2, arrowHeight, arrowHeight);
            lineView.frame = CGRectMake(10*DISTANCE_WIDTH, 64 + firstViewHeight, K_WIDTH - 10*DISTANCE_WIDTH, LINE_HEIGHT);
            
            
            
            UIImageView *headImg = [[UIImageView alloc] init];
            headImg.image = [UIImage imageNamed:@"mine_about_btn_nm"];
            headImg.frame = CGRectMake(K_WIDTH - headImgHeight - arrowHeight - 20*DISTANCE_WIDTH, (firstViewHeight - headImgHeight)/2, headImgHeight, headImgHeight);
            [bgView addSubview:headImg];
            
            
        }else{
        
            bgView.frame = CGRectMake(0, 64 + firstViewHeight + LINE_HEIGHT + (viewHeight + LINE_HEIGHT)*(i - 1), K_WIDTH, viewHeight);
            lab.frame = CGRectMake(10*DISTANCE_WIDTH, (viewHeight - labHeight)/2, labWidth, labHeight);
            arrowImg.frame = CGRectMake(K_WIDTH - arrowHeight - 10*DISTANCE_WIDTH, (viewHeight - arrowHeight)/2, arrowHeight, arrowHeight);
            lineView.frame = CGRectMake(10*DISTANCE_WIDTH, 64 + firstViewHeight + LINE_HEIGHT + (viewHeight + LINE_HEIGHT)* i, K_WIDTH - 10*DISTANCE_WIDTH, LINE_HEIGHT);
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.frame = CGRectMake(K_WIDTH - labWidth - arrowHeight - 20*DISTANCE_WIDTH, (viewHeight - labHeight)/2, labWidth, labHeight);
            nameLabel.text = @"ddf";
            nameLabel.textAlignment = NSTextAlignmentRight;
            [bgView addSubview:nameLabel];
            
            
        }
        
        [self.view addSubview:bgView];
        
        bgView.tag = 1000 + i;
        bgView.userInteractionEnabled = YES;
        [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTapClick:)]];
        
    }
    
}

- (void)bgViewTapClick:(UITapGestureRecognizer *)recognizer{
    
    
    UIView *view = recognizer.view;
    NSInteger teger = view.tag;
    switch (teger) {
        case 1000:
        {
            NSLog(@"000000   %ld",teger);
        }
            break;
        case 1001:
        {
            NSLog(@"111111   %ld",teger);
            
            NicknameVC *nickVC = [[NicknameVC alloc] init];
            [self.navigationController pushViewController:nickVC animated:YES];
            
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
