//
//  LoginViewController.m
//  小农人
//
//  Created by tomusng on 2017/10/13.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "LoginViewController.h"
#import "PlaceholderTextView.h"
#import "RegistrationViewController.h"

#define KScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height


#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]


#define MyDefaults [NSUserDefaults standardUserDefaults]

#define KHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYSearchhistories.plist"]

#define KColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]

#define BG_COLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]



@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) PlaceholderTextView *textView;
@property (nonatomic, strong) PlaceholderTextView *passText;

@property (nonatomic, strong) UITextField *myTextField;

@property (nonatomic, assign) CGFloat btnOriginH;
@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = BG_COLOR;
    
    
    [self createTextViewUI];
    [self createBtnUI];
    

    
}

- (void)createTextViewUI{
    
    self.textView = [[PlaceholderTextView alloc] init];
    _textView.placeholderLabel.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
    _textView.placeholder = @"请输入手机号码";
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = LINEVIEW_COLOR;
    lineView.frame = CGRectMake(0, 30*DISTANCE_HEIGHT, K_WIDTH - 60*DISTANCE_WIDTH, 1*DISTANCE_HEIGHT);
    [_textView addSubview:lineView];
    _textView.backgroundColor = BG_COLOR;
    _textView.frame = (CGRect){30*DISTANCE_WIDTH, 120*DISTANCE_HEIGHT, K_WIDTH - 60*DISTANCE_WIDTH, 60*DISTANCE_HEIGHT};
    _textView.maxLength = 11;
    _textView.keyboardType = UIKeyboardTypeNumberPad;
//    _textView.layer.cornerRadius = 5*DISTANCE_HEIGHT;
//    _textView.layer.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.3].CGColor;
//    _textView.layer.borderWidth = 0.5*DISTANCE_HEIGHT;
    _textView.font = [UIFont systemFontOfSize:17*DISTANCE_WIDTH];
    [self.view addSubview:_textView];
    
    [_textView didChangeText:^(PlaceholderTextView *textView) {
        
        NSLog(@"%@",_textView.text);
    }];
    
    
    
    PlaceholderTextView *passText = [[PlaceholderTextView alloc] init];
    passText.placeholderLabel.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
    passText.placeholder = @"请输入密码";
    
//    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, K_WIDTH - 60*DISTANCE_WIDTH, 30*DISTANCE_HEIGHT)];
//    text.borderStyle = UITextBorderStyleRoundedRect;
//    text.backgroundColor = [UIColor whiteColor];
//    text.placeholder = @"password";
//    text.font = [UIFont fontWithName:@"Arial" size:20.0f];
//    text.clearButtonMode = UITextFieldViewModeAlways;
//    text.secureTextEntry = YES;
//    [self.view addSubview:text];
//
//    text.hidden = YES;
    
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = LINEVIEW_COLOR;
    lineV.frame = CGRectMake(0, 30*DISTANCE_HEIGHT, K_WIDTH - 60*DISTANCE_WIDTH, 1*DISTANCE_HEIGHT);
    [passText addSubview:lineV];
    passText.backgroundColor = BG_COLOR;
    passText.frame = (CGRect){30*DISTANCE_WIDTH, 200*DISTANCE_HEIGHT, K_WIDTH - 60*DISTANCE_WIDTH, 60*DISTANCE_HEIGHT};
    passText.maxLength = 20;
    //    _textView.layer.cornerRadius = 5*DISTANCE_HEIGHT;
    //    _textView.layer.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.3].CGColor;
    //    _textView.layer.borderWidth = 0.5*DISTANCE_HEIGHT;
    _passText = passText;
    [self.view addSubview:passText];
    passText.secureTextEntry = YES;
    
    
    [passText didChangeText:^(PlaceholderTextView *passText) {
        
//        NSLog(@"%@",passText.text);
    }];
    
    
    _btnOriginH = CGRectGetMaxY(passText.frame) + 50*DISTANCE_HEIGHT;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_textView endEditing:YES];
    [_passText endEditing:YES];
    
}

#pragma mark  创建登录及注册按钮
- (void)createBtnUI{
    
    CGFloat space = 10*DISTANCE_WIDTH;
    CGFloat btnHeight = 40*DISTANCE_HEIGHT;
    
    NSArray *array = @[@"立即登录",@"注册"];
    
    for ( int i = 0 ; i < 2; i ++ ) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    button.frame = CGRectMake(2*space, + _btnOriginH + 10*space*i, K_WIDTH - 4*space, btnHeight);
    
    [button setTitle:array[i] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button.layer setBorderWidth:1*DISTANCE_HEIGHT];
    
    button.layer.cornerRadius = btnHeight/2;
    
    button.clipsToBounds = YES;
    
//    [self.btnArr addObject:button];
    
    [button.layer setMasksToBounds:YES];
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){200.0/255, 200.0/255, 200.0/255, 1});
    [button.layer setBorderColor:color];
    
    if (i == 0) {
        
        [button setBackgroundColor:DE_RED_Color];
        
        UIButton *forgetPBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        forgetPBtn.frame = CGRectMake(K_WIDTH - 10*space, CGRectGetMaxY(button.frame) + space, 8*space, 2*space);
        [forgetPBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [forgetPBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [forgetPBtn addTarget:self action:@selector(forgetPBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:forgetPBtn];
        
        
       
    }else{
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){231.0/255, 86.0/255, 71.0/255, 1});
        [button.layer setBorderColor:color];
    }
    
    
    
    button.tag = 10000 + i;
    
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    
}


}

#pragma mark  -- 登录注册两个个button的点击事件
- (void)buttonClick:(UIButton *)sender{
    
    switch (sender.tag) {
        case 10000:
        {
            
        }
            break;
        case 10001:
        {
            RegistrationViewController *registrationVC = [[RegistrationViewController alloc] init];
            [self.navigationController pushViewController:registrationVC animated:YES];
            
        }
            break;
        default:
            break;
    }
    
    
}

#pragma mark  -- 忘记密码
- (void)forgetPBtnClick:(UIButton *)sender{
    
    NSLog(@"我忘记密码了");
    
    
    
}
    


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    
    if ([string isEqualToString:@"n"])
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.myTextField == textField)
    {
        if ([toBeString length] > 20)
        {   //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:20];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return YES;
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
