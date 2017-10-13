//
//  NicknameVC.m
//  小农人
//
//  Created by tomusng on 2017/9/19.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "NicknameVC.h"

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]
#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]

#define LINE_HEIGHT 0.5*DISTANCE_WIDTH




@interface NicknameVC ()<UITextFieldDelegate>

@property (nonatomic, strong)UITextField *textF;
@property (nonatomic, strong)UIButton *rightBtn;


@end

@implementation NicknameVC

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"昵称";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:@"home_navigation_back_btn"];
    leftBtn.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [leftBtn setImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(0, 0, 60*DISTANCE_WIDTH, 30*DISTANCE_HEIGHT)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17*DISTANCE_HEIGHT];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17*DISTANCE_HEIGHT];
    _rightBtn = rightBtn;
    rightBtn.clipsToBounds = YES;
    rightBtn.layer.cornerRadius = 5.0f*DISTANCE_HEIGHT;
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    [self setUpUI];
    
    
    
}

- (void)setUpUI{
    
    UITextField *textF = [[UITextField alloc] init];
    textF.frame = CGRectMake(15*DISTANCE_WIDTH, 64 + 15*DISTANCE_HEIGHT, K_WIDTH - 30*DISTANCE_WIDTH, 40*DISTANCE_HEIGHT);
    textF.backgroundColor = [UIColor whiteColor];
    _textF = textF;
    [self.view addSubview:textF];
    textF.clipsToBounds = YES;
    textF.layer.cornerRadius = 5.0f*DISTANCE_HEIGHT;
    [textF addTarget:self action:@selector(textfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}





- (void)leftBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick:(UIButton *)sender{
    
    if ([_textF.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"昵称不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismiss:) withObject:alert afterDelay:1.0];
        
        
    }else{
    [[NSUserDefaults standardUserDefaults] setObject:_textF.text forKey:@"nickname"];
    NSLog(@"      nickname     %@",_textF.text);
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    NSLog(@"保存");
    }
    
}
- (void)dismiss:(UIAlertView *)alert{
    //    [alert dismissViewControllerAnimated:YES completion:nil];
    [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_textF endEditing:YES];
    
    
}

- (void)textfieldDidChange:(UITextField *)textField{
    
    if ([textField.text isEqualToString:@""]) {
        
        [_rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_rightBtn setBackgroundColor:[UIColor clearColor]];
        
    }else{
        
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn setBackgroundColor:DE_RED_Color];
        
        
        
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
