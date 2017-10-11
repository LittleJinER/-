//
//  MineViewController.m
//  小农人
//
//  Created by tomusng on 2017/8/14.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "MineViewController.h"

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]



@interface MineViewController ()

@property (nonatomic, strong) NSMutableArray *viewClickArr;



@end

@implementation MineViewController


- (void)viewWillDisappear:(BOOL)animated{
    
    //    self.navigationController.navigationBar.backgroundColor = [];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.barTintColor = nil;
    
//    [self.statusBarView removeFromSuperview];
    
    self.navigationController.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    
    
    //    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"我的";
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self setUpUI];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
}


- (NSMutableArray *)viewClickArr{
    
    if (!_viewClickArr) {
        _viewClickArr = [NSMutableArray arrayWithCapacity:6];
    }
    return _viewClickArr;
    
}








- (void)setUpUI{
    
//    床架背景view
//    UIView *bgView = [[UIView alloc] init];
    
//    初始化bgView的高度
//    CGFloat bgViewHeight = 0.0;
//    bgView.frame = CGRectMake(0, 0, K_WIDTH, K_HETGHT);
//    [self.view addSubview:bgView];
//    创建背景图片
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"mine_back_image"];
    CGFloat bgImgHeight = 0.0;
    [self.view addSubview:bgImgV];
    
//    创建头像
    UIImageView *headImgV = [[UIImageView alloc] init];
    headImgV.frame = CGRectMake((K_WIDTH-100*DISTANCE_WIDTH)/2, 50*DISTANCE_HEIGHT, 100*DISTANCE_WIDTH, 100*DISTANCE_WIDTH);
    headImgV.image = [UIImage imageNamed:@"mine_about_btn_nm"];
    headImgV.layer.cornerRadius = 50*DISTANCE_WIDTH;
    headImgV.clipsToBounds = YES;
    [self.view addSubview:headImgV];
    
//    创建名字label
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.frame = CGRectMake((K_WIDTH - 100*DISTANCE_WIDTH)/2, CGRectGetMaxY(headImgV.frame)+15*DISTANCE_HEIGHT, 100*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
    nameLab.font = [UIFont systemFontOfSize:18*DISTANCE_HEIGHT];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.textColor = [UIColor whiteColor];
    nameLab.text = @"ddf";
    [self.view addSubview:nameLab];
    
    
//    农人币 采纳数 邀请码 留个label的宽度
    CGFloat sixFWidth = 80*DISTANCE_WIDTH;
    CGFloat sixFHeight = 15*DISTANCE_HEIGHT;
//    创建六个label
    for (int i = 0 ; i < 6; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(K_WIDTH/3*(i%3) + (K_WIDTH/3-sixFWidth)/2 ,CGRectGetMaxY(nameLab.frame)+ 15*DISTANCE_HEIGHT + i/3 * (sixFHeight + 10*DISTANCE_HEIGHT), sixFWidth, sixFHeight);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:label];
        if (i < 3) {
            label.font = [UIFont systemFontOfSize:17*DISTANCE_HEIGHT];
        }else{
            label.font = [UIFont systemFontOfSize:14*DISTANCE_HEIGHT];
        }
        switch (i) {
            case 0:{
                label.text = @"12343124";
                
                UIView *line = [[UIView alloc] init];
                line.backgroundColor = [UIColor whiteColor];
                line.frame = CGRectMake(K_WIDTH/3, CGRectGetMaxY(nameLab.frame) + 22*DISTANCE_HEIGHT, 0.5*DISTANCE_WIDTH, 28*DISTANCE_HEIGHT);
                [self.view addSubview:line];
                
            }
                
                break;
                
            case 1:{
                label.text = @"2323223";
                UIView *line = [[UIView alloc] init];
                line.backgroundColor = [UIColor whiteColor];
                line.frame = CGRectMake(K_WIDTH/3 * 2, CGRectGetMaxY(nameLab.frame) + 22*DISTANCE_HEIGHT, 0.5*DISTANCE_WIDTH, 28*DISTANCE_HEIGHT);
                [self.view addSubview:line];
            }
                
                break;
                
            case 2:{
                label.text = @"343434";
            }
                
                break;
                
            case 3:{
                label.text = @"农人币";
            }
                
                break;
                
            case 4:{
                label.text = @"采纳数";
            }
                
                break;
                
            case 5:{
                label.text = @"邀请码";
                bgImgHeight = CGRectGetMaxY(label.frame) + 20*DISTANCE_HEIGHT;
            }
                
                break;
                
            default:
                break;
        }
        
        
    }
    
    
    
    
    bgImgV.frame = CGRectMake(0, 0, K_WIDTH, bgImgHeight);
    
//    设置下面四个view的初始高度
    CGFloat originHeight = 0.0;
    
//    设置收藏和关注view的宽高
    CGFloat collecWidth = K_WIDTH/2;
    CGFloat collectHeight = 60*DISTANCE_HEIGHT;
//    创建收藏和关注view
    for (int j = 0; j < 2; j ++) {
        UIView *collecView = [[UIView alloc] init];
        collecView.frame = CGRectMake(K_WIDTH/2 * j, CGRectGetMaxY(bgImgV.frame), collecWidth, collectHeight);
        collecView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:collecView];
        
        [self.viewClickArr addObject:collecView];
        
        collecView.tag = 10000 + j;
        collecView.userInteractionEnabled = YES;
        [collecView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickWithSender:)]];
        
        
        
        UIImageView *collImaV = [[UIImageView alloc] init];
        collImaV.frame = CGRectMake(30*DISTANCE_WIDTH, 10*DISTANCE_HEIGHT, 40*DISTANCE_HEIGHT, 40*DISTANCE_HEIGHT);
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(CGRectGetMaxX(collImaV.frame) + 15*DISTANCE_WIDTH, 15*DISTANCE_HEIGHT, 100*DISTANCE_WIDTH, 30*DISTANCE_HEIGHT);
        label.font = [UIFont systemFontOfSize:18*DISTANCE_HEIGHT];
        [collecView addSubview:collImaV];
        [collecView addSubview:label];
    
        
        
        switch (j) {
            case 0:{
                
                collImaV.image = [UIImage imageNamed:@"mine_save"];
                label.text = @"我的收藏";
                
               
            }
                
                break;
            case 1:{
                
                collImaV.image = [UIImage imageNamed:@"mine_focust_people"];
                 label.text = @"关注的人";
                UIView *line = [[UIView alloc] init];
                line.backgroundColor = LINEVIEW_COLOR;
                line.frame = CGRectMake(K_WIDTH/2 - 0.5*DISTANCE_WIDTH, CGRectGetMaxY(bgImgV.frame) + 20*DISTANCE_HEIGHT, 0.5*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
                [self.view addSubview:line];
                originHeight = CGRectGetMaxY(collecView.frame);
            }
                
                break;
                
            default:
                break;
        }
        
        
    }
    
    
//    设置lineview的高度和下面四个view的高度
    CGFloat lineHeight = 0.5*DISTANCE_HEIGHT;
    CGFloat fourVHeight = 50*DISTANCE_HEIGHT;
    
//    创建下面四个view
    for (int k = 0; k < 4; k ++) {
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = LINEVIEW_COLOR;
         [self.view addSubview:lineView];
      
        
        UIView *fourView = [[UIView alloc] init];
        fourView.backgroundColor = [UIColor whiteColor];
        UIImageView *img = [[UIImageView alloc] init];
        img.frame = CGRectMake(15*DISTANCE_WIDTH, 15*DISTANCE_HEIGHT, 20*DISTANCE_HEIGHT, 20*DISTANCE_HEIGHT);
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(CGRectGetMaxX(img.frame) + 15*DISTANCE_WIDTH, 15*DISTANCE_HEIGHT, 120*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
        label.font = [UIFont systemFontOfSize:17*DISTANCE_HEIGHT];
        [fourView addSubview:img];
        [fourView addSubview:label];
        [self.view addSubview:fourView];
        
        [self.viewClickArr addObject:fourView];
        
        fourView.tag = 10002 + k;
        fourView.userInteractionEnabled = YES;
       
        [fourView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickWithSender:)]];
        
        
        
        
        
        if (k < 2) {
        
            fourView.frame = CGRectMake(0, originHeight + lineHeight + 15*DISTANCE_HEIGHT + k*(lineHeight+fourVHeight), K_WIDTH, fourVHeight);
            lineView.frame = CGRectMake(0, originHeight + 15*DISTANCE_HEIGHT + k*(lineHeight+fourVHeight), K_WIDTH, lineHeight);
            
            
            
            if (k == 0) {
                img.image = [UIImage imageNamed:@"mine_response_btn_nm"];
                label.text = @"我的回答";
            }else{
                img.image = [UIImage imageNamed:@"my_money"];
                label.text = @"我的订单";
            }
            
        }
        
        else if (k >= 2){
            
            
            lineView.frame = CGRectMake(0, originHeight + 2*15*DISTANCE_HEIGHT + 3*lineHeight + 2*fourVHeight + (k - 2)*(2*lineHeight + fourVHeight + 15*DISTANCE_HEIGHT), K_WIDTH, lineHeight);
            
            fourView.frame = CGRectMake(0, originHeight + 2*15*DISTANCE_HEIGHT+4*lineHeight+2*fourVHeight + (k-2)*(fourVHeight+2*lineHeight + 15*DISTANCE_HEIGHT), K_WIDTH, fourVHeight);
            if (k == 2) {
                img.image = [UIImage imageNamed:@"my_recipe"];
                label.text = @"我的农人币";
            }else{
                img.image = [UIImage imageNamed:@"invite_code"];
                label.text = @"填写邀请码";
                
            }
        }
     }
 
    
    for (int m = 0; m < 3; m ++) {
        UIView *line = [[UIView alloc] init];
        
        line.frame = CGRectMake(0, originHeight + 15*DISTANCE_HEIGHT + 2*(lineHeight+fourVHeight) + m*(2*lineHeight + 15*DISTANCE_HEIGHT+fourVHeight), K_WIDTH, lineHeight);
        line.backgroundColor = LINEVIEW_COLOR;
        [self.view addSubview:line];
        
        
    }





}


- (void)viewClickWithSender:(UITapGestureRecognizer *)recognizer{
    
    NSInteger teger = recognizer.view.tag - 10000;
    switch (teger) {
        case 0:
        {
            NSLog(@"    0000000   %ld",teger);
        }
            break;
        case 1:
        {
            NSLog(@"    1111111   %ld",teger);
        }
            break;
        case 2:
        {
            NSLog(@"    222222222   %ld",teger);
        }
            break;
        case 3:
        {
            NSLog(@"    333333333333   %ld",teger);
        }
            break;
        case 4:
        {
            NSLog(@"    44444444444   %ld",teger);
        }
            break;
        case 5:
        {
            NSLog(@"    5555555555   %ld",teger);
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
