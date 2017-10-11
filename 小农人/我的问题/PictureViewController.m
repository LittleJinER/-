//
//  PictureViewController.m
//  Camera
//
//  Created by tomusng on 2017/9/5.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "PictureViewController.h"
#import "PlaceholderTextView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height


@interface PictureViewController ()

@property (nonatomic, copy) NSString *corpsName;
@property (nonatomic, copy) NSString *cropsContent;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) PlaceholderTextView *textView;
@property (nonatomic, strong) PlaceholderTextView *cropsView;

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:CGRectMake(0, 0, 40, 20)];
    
    [button setTitle:@"提交" forState:UIControlStateNormal];
    
    [button setBackgroundColor:[UIColor greenColor]];
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *comItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = comItem;

    
    self.title = @"我的问题";
    
    
    // Do any additional setup after loading the view from its nib.
    
    // 1. 新建一个类继承 MLShowViewController
    
    // 2. 设置collectionSuperView进行赋值
    UIView *picView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, WIDTH - 20, 200)];
    [self.view addSubview:picView];
//    picView.backgroundColor = [UIColor greenColor];
    
    self.collectionSuperView = picView;
    
    // 3. 设置可添加图片的最大数
    self.maxCount = 6;
    
    // 4. 初始化CollectionView
    [self initCollectionView];
    
    
    
    
    
    
    self.cropsView = [[PlaceholderTextView alloc]init];
    _cropsView.placeholderLabel.font = [UIFont systemFontOfSize:15];
    _cropsView.placeholder = @"请输入文字...";
    _cropsView.font = [UIFont systemFontOfSize:15];
    _cropsView.frame = (CGRect){10,240,CGRectGetWidth(self.view.frame)-20,50};
    _cropsView.maxLength = 5;
    _cropsView.layer.cornerRadius = 5.f;
    _cropsView.layer.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.3].CGColor;
    _cropsView.layer.borderWidth = 0.5f;
    [self.view addSubview:_cropsView];
    
    [_cropsView didChangeText:^(PlaceholderTextView *textView) {
        NSLog(@"%@",_cropsView.text);
    }];

    
    
    
    self.
    
    
    textView = [[PlaceholderTextView alloc]init];
    _textView.placeholderLabel.font = [UIFont systemFontOfSize:15];
    _textView.placeholder = @"请输入文字...";
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.frame = (CGRect){10,300,CGRectGetWidth(self.view.frame)-20,200};
    _textView.maxLength = 200;
    _textView.layer.cornerRadius = 5.f;
    _textView.layer.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.3].CGColor;
    _textView.layer.borderWidth = 0.5f;
    [self.view addSubview:_textView];
    
    [_textView didChangeText:^(PlaceholderTextView *textView) {
        NSLog(@"%@",textView.text);
    }];
    
    
    
    
    
}

- (void)buttonClick:(UIButton *)sender{
    
    // self.imageDataSource存储的是UIImage类型，上传直接遍历转换data类型即可
    NSLog(@"%@", self.imageDataSource);
    
    self.imageArr = [NSArray arrayWithArray:self.imageDataSource];
    self.cropsContent = self.textView.text;
    self.corpsName = self.cropsView.text;
    
    NSLog(@"%@    ---    %@",self.corpsName,self.cropsContent);
    
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
