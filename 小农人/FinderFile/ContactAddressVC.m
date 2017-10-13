//
//  ContactAddressVC.m
//  小农人
//
//  Created by tomusng on 2017/9/11.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "ContactAddressVC.h"
#import "PlaceholderTextView.h"


#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1]
#define BGVIEW_COLOR     [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]


@interface ContactAddressVC ()

@property (nonatomic,strong)PlaceholderTextView *textView;


@end

@implementation ContactAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"联系地址";
    self.view.backgroundColor = BGVIEW_COLOR;
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 70, 30);
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setTitleColor:[UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1] forState:UIControlStateNormal];
  
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [self createContactAddressUI];
}

- (void)createContactAddressUI{
    self.textView = [[PlaceholderTextView alloc]init];
    _textView.placeholderLabel.font = [UIFont systemFontOfSize:15];
    _textView.placeholder = @"您的从业经历，所获荣誉等信息（200字以内）";
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.frame = (CGRect){10*DISTANCE_WIDTH,74*DISTANCE_HEIGHT,K_WIDTH - 20*DISTANCE_WIDTH,200*DISTANCE_HEIGHT};
    _textView.maxLength = 200;
    _textView.layer.cornerRadius = 5.f*DISTANCE_HEIGHT;
    _textView.layer.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.3].CGColor;
    _textView.layer.borderWidth = 0.5f*DISTANCE_HEIGHT;
  
    [self.view addSubview:_textView];
    
    
    [_textView didChangeText:^(PlaceholderTextView *textView) {
        NSLog(@"%@",_textView.text);
        
    }];
}


- (void)rightButtonClick:(UIButton *)sender{
    
    NSString *str = _textView.text;
    
    if ([_delegate respondsToSelector:@selector(sendContactAddress:)]) {
        [_delegate sendContactAddress:str];
    }
    
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
