//
//  FeedbackViewController.m
//  小农人
//
//  Created by tomusng on 2017/9/13.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "FeedbackViewController.h"
#import "PlaceholderTextView.h"
#import "DiscoveryHttpRequestManager.h"


#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define DEFAULT_COLOR [UIColor colorWithRed:252/255.f green:86/255.f blue:56/255.f alpha:1]

@interface FeedbackViewController ()

@property (nonatomic, strong)PlaceholderTextView *textView;

@property (nonatomic, strong)UITextField *textField;

@end

@implementation FeedbackViewController

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self setUpUI];
    
}

- (void)setUpUI{
    
    
    self.textView = [[PlaceholderTextView alloc] init];
    _textView.placeholderLabel.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
    _textView.placeholder = @"请至少输入10个字符的意见反馈";
    _textView.frame = (CGRect){15*DISTANCE_WIDTH, 100*DISTANCE_HEIGHT, WIDTH - 30*DISTANCE_WIDTH, 200*DISTANCE_HEIGHT};
    _textView.maxLength = 200;
    _textView.layer.cornerRadius = 5*DISTANCE_HEIGHT;
    _textView.layer.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.3].CGColor;
    _textView.layer.borderWidth = 0.5*DISTANCE_HEIGHT;
    [self.view addSubview:_textView];
    
    [_textView didChangeText:^(PlaceholderTextView *textView) {
        
        NSLog(@"%@",_textView.text);
    }];
    
    
    self.textField = [[UITextField alloc] init];
    _textField.placeholder = @"请输入11位的手机号码（必填）";
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.layer.borderWidth = 0.5*DISTANCE_HEIGHT;
    _textField.layer.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.3].CGColor;
    _textField.layer.cornerRadius = 5*DISTANCE_HEIGHT;
    _textField.frame = CGRectMake(15*DISTANCE_WIDTH, CGRectGetMaxY(_textView.frame)+15*DISTANCE_HEIGHT, WIDTH - 30*DISTANCE_WIDTH, 30*DISTANCE_HEIGHT);
    [self.view addSubview:_textField];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(15*DISTANCE_WIDTH, CGRectGetMaxY(_textField.frame)+15*DISTANCE_HEIGHT, WIDTH-30*DISTANCE_WIDTH, 30);
    button.layer.cornerRadius = 5*DISTANCE_HEIGHT;
    button.clipsToBounds = YES;
    [button setBackgroundColor:DEFAULT_COLOR];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)buttonClick:(UIButton *)sender{
    
//    NSString *str;
//    if (_tex) {
//        <#statements#>
//    }
//    [DiscoveryHttpRequestManager submitFeedbackWithUrl:str WithBlock:^(NSString *string) {
    
        
        
        
        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"gf" message:@"发送成功" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ff" style:UIAlertActionStyleDefault handler:nil];
//        [alert addAction:action];
//        [self presentViewController:alert animated:YES completion:nil];
    
//        [self performSelector:@selector(dismiss:) withObject:alert afterDelay:2];
    
//    }];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"dd" message:@"dddd" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [self performSelector:@selector(dismiss:) withObject:alert afterDelay:1.0];
    
    
}

- (void)dismiss:(UIAlertView *)alert{
//    [alert dismissViewControllerAnimated:YES completion:nil];
    [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
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
