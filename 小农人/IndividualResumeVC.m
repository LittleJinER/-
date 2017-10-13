//
//  IndividualResumeVC.m
//  小农人
//
//  Created by tomusng on 2017/9/9.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "IndividualResumeVC.h"
#import "XFStepView.h"
#import "PlaceholderTextView.h"
#import "DiscoveryHttpRequestManager.h"

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1]
#define BGVIEW_COLOR     [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]
#define TINTCOLOR [UIColor colorWithRed:252/255.f green:86/255.f blue:56/255.f alpha:1]
/* tabbar 高度*/
#define TABBAR_HEIGHT 49

@interface IndividualResumeVC ()

@property (nonatomic, strong) XFStepView *stepView;
@property (nonatomic, assign) CGFloat setViewOriginHeight;
@property (nonatomic, strong) PlaceholderTextView *textView;
@end

@implementation IndividualResumeVC

- (void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBar.shadowImage = nil;
    
    self.navigationController.navigationBar.barTintColor = nil;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"专家资料";
    [self.navigationItem setHidesBackButton:YES];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(leftReturnClick:)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 70, 30);
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setTitle:@"暂时略过" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 64, K_WIDTH, 90*DISTANCE_HEIGHT);
    _stepView = [[XFStepView alloc] initWithFrame:CGRectMake(0, 10*DISTANCE_HEIGHT, K_WIDTH, 60*DISTANCE_HEIGHT) Titles:[NSArray arrayWithObjects:@"基本信息", @"身份证", @"个人照片", @"个人简介", nil] WithNum:3];
    _stepView.backgroundColor = BGVIEW_COLOR;
    bgView.backgroundColor = BGVIEW_COLOR;
    [bgView addSubview:_stepView];
    [self.view addSubview:bgView];
    
    //    设置下面分类的初始高度
    _setViewOriginHeight = CGRectGetMaxY(bgView.frame);
    
    [self createLastAndNextStepButton];
    
    
    [self createCardViewUI];
}

#pragma mark -    创建下一步 button      ----  nextStB  --
- (void)createLastAndNextStepButton{
    UIView *bgView = [[UIView alloc] init];
    
    bgView.frame = CGRectMake(0, K_HETGHT - TABBAR_HEIGHT, K_WIDTH, TABBAR_HEIGHT);
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    lineView.frame = CGRectMake(0, 0, K_WIDTH, 1);
    [bgView addSubview:lineView];
    
    
    UIButton *lastStB = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [lastStB setTitle:@"上一步" forState:UIControlStateNormal];
    [lastStB.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [lastStB setTitleColor:TINTCOLOR forState:UIControlStateNormal];
    lastStB.layer.borderWidth = 1;
    lastStB.layer.masksToBounds = YES;
    lastStB.layer.borderColor = [TINTCOLOR CGColor];
    [lastStB setBackgroundColor:[UIColor whiteColor]];
    [lastStB setFrame:CGRectMake(10, 10, K_WIDTH/2 - 20, TABBAR_HEIGHT - 20)];
    lastStB.clipsToBounds = YES;
    lastStB.layer.cornerRadius = 5.0f;
    
    [lastStB addTarget:self action:@selector(lastStepClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:lastStB];
    
    
    UIButton *submitAuditB = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [submitAuditB setTitle:@"提交审核" forState:UIControlStateNormal];
    [submitAuditB.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [submitAuditB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [submitAuditB setBackgroundColor:TINTCOLOR];
    [submitAuditB setFrame:CGRectMake(K_WIDTH/2 + 10, 10, K_WIDTH/2 - 20, TABBAR_HEIGHT - 20)];
    submitAuditB.clipsToBounds = YES;
    submitAuditB.layer.cornerRadius = 5.0f;
    
    [submitAuditB addTarget:self action:@selector(submitAuditClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:submitAuditB];
    
}

#pragma mark - 创建证件照UI
- (void)createCardViewUI{
    
    UIView *bigView = [[UIView alloc] init];
    bigView.frame = CGRectMake(0, _setViewOriginHeight, K_WIDTH, K_HETGHT - _setViewOriginHeight - TABBAR_HEIGHT);
    [self.view addSubview:bigView];
    bigView.backgroundColor = BGVIEW_COLOR;
  
    //    label的高度和宽度
    CGFloat labWidth = 200*DISTANCE_WIDTH;
    CGFloat labHeight = 15*DISTANCE_HEIGHT;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10*DISTANCE_WIDTH, 10*DISTANCE_HEIGHT, labWidth, labHeight);
    label.text = @"个人简介";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:15*DISTANCE_WIDTH];
    
    [bgView addSubview:label];
    
    //    个人简介描述
    
    self.textView = [[PlaceholderTextView alloc]init];
    _textView.placeholderLabel.font = [UIFont systemFontOfSize:15];
    _textView.placeholder = @"您的从业经历，所获荣誉等信息（200字以内）";
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.frame = (CGRect){10*DISTANCE_WIDTH,CGRectGetMaxY(label.frame)+10*DISTANCE_HEIGHT,K_WIDTH - 20*DISTANCE_WIDTH,200*DISTANCE_HEIGHT};
    _textView.maxLength = 200;
    _textView.layer.cornerRadius = 5.f*DISTANCE_HEIGHT;
    _textView.layer.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.3].CGColor;
    _textView.layer.borderWidth = 0.5f*DISTANCE_HEIGHT;
    [bgView addSubview:_textView];
    
    NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:@"reason"];
    if (![text isEqualToString:@""]) {
        _textView.text = text;
    }
    
    [_textView didChangeText:^(PlaceholderTextView *textView) {
        NSLog(@"%@",_textView.text);
        
    }];
    
    
    
    //    设置bgView的高度
    
    CGFloat bgViewHeight = CGRectGetMaxY(_textView.frame) + 20*DISTANCE_HEIGHT;
    
    bgView.frame = CGRectMake(0, 0, K_WIDTH, bgViewHeight);
    
    [bigView addSubview:bgView];
    
//    UILabel *annotationLab = [[UILabel alloc] init];
//    annotationLab.text = @"*头像审核通过后不可修复";
//    annotationLab.frame = CGRectMake(10*DISTANCE_WIDTH, CGRectGetMaxY(bgView.frame) + 10, K_WIDTH - 100*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
//    annotationLab.font = [UIFont systemFontOfSize:13*DISTANCE_WIDTH];
//    
//    [bigView addSubview:annotationLab];
    
}


#pragma mark  - 点击上一步button lastStepClick   --
- (void)lastStepClick:(UIButton *)sender{
    
    NSLog(@"上一步");
    NSInteger num = self.navigationController.viewControllers.count;
    //    NSLog(@"fffff   %ld",(long)num);
    UIViewController *viewC = self.navigationController.viewControllers[num - 2];
    [self.navigationController popToViewController:viewC animated:YES];

    
}

#pragma mark - 点击  下一步button -----nextStepClick  --
- (void)submitAuditClick:(UIButton *)sender{
    NSLog(@"submit audit");
    
    
    if ([_textView.text isEqualToString:@""]) {
        NSString *tips = [NSString stringWithFormat:@"请输入您的个人简介"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:tips preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
                                    }];
        [alert addAction:action];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
   
    }else{
        
        NSString *idcard = [[NSUserDefaults standardUserDefaults] objectForKey:@"idcard"];
        NSString *tag = [[NSUserDefaults standardUserDefaults] objectForKey:@"tag"];
        NSString *user_official_category_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_official_category_id"];
//        NSString *reason = [[NSUserDefaults standardUserDefaults] objectForKey:@"reason"];
        NSString *reason = self.textView.text;
        NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
        NSString *realname = [[NSUserDefaults standardUserDefaults] objectForKey:@"realname"];
        NSString *age = [[NSUserDefaults standardUserDefaults] objectForKey:@"age"];
        NSString *company = [[NSUserDefaults standardUserDefaults] objectForKey:@"company"];
        NSString *location = [[NSUserDefaults standardUserDefaults] objectForKey:@"location"];
        NSString *urlStr = [NSString stringWithFormat:@"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=do_authenticate&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&idcard=%@&tag=%@&user_official_category_id=%@&reason=%@&phone=%@&realname=%@&age=%@&company=%@&location=%@",idcard,tag,user_official_category_id,reason,phone,realname,age,company,location];
        NSLog(@"%@",urlStr);
        NSString *encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [DiscoveryHttpRequestManager submitAuditWithUrlString:encodedString WithBlock:^(NSString *string){
            
            NSString *text;
            if ([string isEqualToString:@"1"]) {
                text = @"您的申请已提交，稍后会给您通知";
            }else if ([string isEqualToString:@"0"]){
                text = @"您的申请提交失败，请稍后再试，如果您之前申请过，请勿重复提交";
                
            }else{
                text = [self replaceUnicode:string];
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                提交成功后，返回发现页面首页
                if ([string isEqualToString:@"1"]) {
                    
                    UIViewController *VC = self.navigationController.viewControllers[0];
                    [self.navigationController popToViewController:VC animated:YES];
                    
                }
            }]];
            
//            弹出提示框
            [self presentViewController:alert animated:YES completion:nil];
             
        }];
        
    }
    
}
#pragma mark   -  点击保存按钮

- (void)rightBtnClick:(UIButton *)sender{
    
//    IndividualResumeVC *indivVC = [[IndividualResumeVC alloc] init];
//    
//    [self.navigationController pushViewController:indivVC animated:YES];
    
    NSLog(@"next step");
    
    [[NSUserDefaults standardUserDefaults] setObject:self.textView.text forKey:@"reason"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//- (void)leftReturnClick:(UIBarButtonItem *)item{
//    
//}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textView endEditing:YES];
}

#pragma mark - 将unicode转化为string
- (NSString*) replaceUnicode:(NSString*)TransformUnicodeString

{
    
    NSString*tepStr1 = [TransformUnicodeString stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    
    NSString*tepStr2 = [tepStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    
    NSString*tepStr3 = [[@"\"" stringByAppendingString:tepStr2]stringByAppendingString:@"\""];
    
    NSData*tepData = [tepStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString*axiba = [NSPropertyListSerialization propertyListWithData:tepData options:NSPropertyListMutableContainers format:NULL error:NULL];
    
    return [axiba stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    
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
