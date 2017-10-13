//
//  MyReplyViewController.m
//  小农人
//
//  Created by tomusng on 2017/9/6.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "MyReplyViewController.h"
#import "PlaceholderTextView.h"
#import "Q_AHttpRequestManager.h"
#import "LLSearchView.pch"


#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface MyReplyViewController ()
@property (nonatomic, copy) NSString *cropsContent;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) PlaceholderTextView *textView;
@end

@implementation MyReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tabBarController.tabBar.hidden = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:CGRectMake(0, 0, 50, 20)];
    
    [button setTitle:@"提交" forState:UIControlStateNormal];
    
    [button setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *comItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = comItem;
    
    
    self.title = @"我解答";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    // Do any additional setup after loading the view from its nib.
    
    // 1. 新建一个类继承 MLShowViewController
    
    // 2. 设置collectionSuperView进行赋值
    UIView *picView = [[UIView alloc] initWithFrame:CGRectMake(10,320,CGRectGetWidth(self.view.frame)-20,200)];
    [self.view addSubview:picView];
    //    picView.backgroundColor = [UIColor greenColor];
    
    self.collectionSuperView = picView;
    
    // 3. 设置可添加图片的最大数
    self.maxCount = 6;
    
    // 4. 初始化CollectionView
    [self initCollectionView];
    
    
    self.textView = [[PlaceholderTextView alloc]init];
    _textView.placeholderLabel.font = [UIFont systemFontOfSize:15];
    _textView.placeholder = @"请尽量详细的解答是什么病虫草害，如何防治与使用什么药剂（不少于10个字）";
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.frame = (CGRect){10, 100, WIDTH - 20, 200};
    _textView.maxLength = 200;
    _textView.layer.cornerRadius = 5.f;
    _textView.layer.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.3].CGColor;
    _textView.layer.borderWidth = 0.5f;
    [self.view addSubview:_textView];
    
    [_textView didChangeText:^(PlaceholderTextView *textView) {
        NSLog(@"%@",_textView.text);
        
        if (_textView.text != nil) {
            [button setBackgroundColor:[UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]];
        }
        
    }];

    
    
}


- (void)buttonClick:(UIButton *)sender{
    
    // self.imageDataSource存储的是UIImage类型，上传直接遍历转换data类型即可
    NSLog(@"%@", self.imageDataSource);
    
    self.imageArr = [NSArray arrayWithArray:self.imageDataSource];
    
    NSMutableArray *imaArr = [NSMutableArray array];
    
    
    for (int i = 0; i < self.imageArr.count; i ++) {
        
        UIImage *image = self.imageArr[i];
        
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
        
         NSString *imgDataString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [imaArr addObject:imgDataString];
        
    }
    
    
    
    
    self.cropsContent = self.textView.text;
//    self.corpsName = self.cropsView.text;
    
//    NSLog(@"%@    ---    %@",self.corpsName,self.cropsContent);
    
//    NSString *cropContentString = [self.cropsContent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *corpsNameString = [self.corpsName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    NSString *str = [NSString stringWithFormat:@"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=create_post&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&weiba_name=%@&content=%@&title=%@&file=%@",self.model.author_info.uname,cropContentString,self.model.author_info.uname,imaArr];
    
//    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=create_post&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&weiba_name=%@&content=%@&title=%@",self.corpsName,self.cropsContent,self.corpsName];
    
//    NSLog(@"%@",str);
    //    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    ////
    //    [Q_AHttpRequestManager ExpressOnesProblemsWithUrl:str  WithBlock:^(NSArray * _Nullable array) {
    //
    //
    //
    //    }];
    
    NSString *str = [NSString stringWithFormat:TOM_HOST,@"api",@"Weiba",@"create_post",oauth_token,oauth_token_secret];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    
//    NSString *str = @"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=create_post&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e";
//
//    NSString *encoded = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"weiba_name":self.model.author_info.uname,@"content":self.cropsContent,@"title":self.model.author_info.uname,@"file":imaArr};
    
    [Q_AHttpRequestManager ProblemsWithUrl:encode WithDic:dic WithBlock:^(NSString * _Nullable string) {
        
        NSString *text;
        if ([string isEqualToString:@"1"]) {
            
            text = @"您的回答已提交，谢谢您的参与";
            
        }else if ([string isEqualToString:@"0"]){
            
            text = @"您的回答提交失败，请稍后再试，如果您之前提交过，请勿重复提交";
        
        }else{
            
            text = [self replaceUnicode:string];
            
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];

    }];
    
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
