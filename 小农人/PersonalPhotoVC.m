//
//  PersonalPhotoVC.m
//  小农人
//
//  Created by tomusng on 2017/9/9.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "PersonalPhotoVC.h"
#import "XFStepView.h"
#import "IndividualResumeVC.h"

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1]
#define BGVIEW_COLOR     [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]
/* tabbar 高度*/
#define TABBAR_HEIGHT 49


@interface PersonalPhotoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) XFStepView *stepView;
@property (nonatomic, assign) CGFloat setViewOriginHeight;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong)UIImagePickerController *picker;

@end

@implementation PersonalPhotoVC

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
//   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(leftReturnClick:)];
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
    _stepView = [[XFStepView alloc] initWithFrame:CGRectMake(0, 10*DISTANCE_HEIGHT, K_WIDTH, 60*DISTANCE_HEIGHT) Titles:[NSArray arrayWithObjects:@"基本信息", @"身份证", @"个人照片", @"个人简介", nil] WithNum:2];
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
    
    
    UIButton *nextStB = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [nextStB setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStB.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [nextStB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [nextStB setBackgroundColor:TINTCOLOR];
    [nextStB setFrame:CGRectMake(K_WIDTH/2 + 10, 10, K_WIDTH/2 - 20, TABBAR_HEIGHT - 20)];
    nextStB.clipsToBounds = YES;
    nextStB.layer.cornerRadius = 5.0f;
    
    [nextStB addTarget:self action:@selector(nextStepClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:nextStB];
    
}

#pragma mark - 创建证件照UI
- (void)createCardViewUI{
    
    UIView *bigView = [[UIView alloc] init];
    bigView.frame = CGRectMake(0, _setViewOriginHeight, K_WIDTH, K_HETGHT - _setViewOriginHeight - TABBAR_HEIGHT);
    [self.view addSubview:bigView];
    bigView.backgroundColor = BGVIEW_COLOR;
    
    UIImage *image = [UIImage imageNamed:@"home_question_addImage_btn"];
    //    图片的高度和宽度
    CGFloat imageWidth = 100*DISTANCE_WIDTH;
    CGFloat imageHeight = (imageWidth/image.size.width)*image.size.height;
    //    label的高度和宽度
    CGFloat labWidth = 200*DISTANCE_WIDTH;
    CGFloat labHeight = 15*DISTANCE_HEIGHT;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];

    
    UIImageView *imageV = [[UIImageView alloc] init];
    
    imageV.frame = CGRectMake((K_WIDTH - imageWidth)/2, 25*DISTANCE_HEIGHT, imageWidth, imageHeight);
    
    imageV.image = [UIImage imageNamed:@"home_question_addImage_btn"];
    
    NSData *imageData = [[NSUserDefaults standardUserDefaults]objectForKey:@"用户头像"];
    
    if (imageData != nil) {
        imageV.image = [UIImage imageWithData:imageData];
    }
    
    
    imageV.userInteractionEnabled = YES;
    [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageVClick:)]];
    _imageV = imageV;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake((K_WIDTH - labWidth)/2, 25*DISTANCE_HEIGHT + imageHeight + 10*DISTANCE_HEIGHT, labWidth, labHeight);
    label.text = @"个人照片";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15*DISTANCE_WIDTH];
    [bgView addSubview:imageV];
    [bgView addSubview:label];
        
        

    //    设置bgView的高度

    CGFloat bgViewHeight = CGRectGetMaxY(label.frame) + 25*DISTANCE_HEIGHT;

    bgView.frame = CGRectMake(0, 0, K_WIDTH, bgViewHeight);
    
    [bigView addSubview:bgView];
    
    UILabel *annotationLab = [[UILabel alloc] init];
    annotationLab.text = @"*头像审核通过后不可修复";
    annotationLab.frame = CGRectMake(10*DISTANCE_WIDTH, CGRectGetMaxY(bgView.frame) + 10, K_WIDTH - 100*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
    annotationLab.font = [UIFont systemFontOfSize:13*DISTANCE_WIDTH];
    
    [bigView addSubview:annotationLab];
    
    
}

- (void)imageVClick:(UITapGestureRecognizer *)recognizer{
    
    NSLog(@"imageV被点击了");
    [self getImagePicker];
    
    
    
}


#pragma mark  - 点击上一步button lastStepClick   --
- (void)lastStepClick:(UIButton *)sender{

   
    
    NSInteger num = self.navigationController.viewControllers.count;
    //    NSLog(@"fffff   %ld",(long)num);
    UIViewController *viewC = self.navigationController.viewControllers[num - 2];
    [self.navigationController popToViewController:viewC animated:YES];

     NSLog(@"上一步");
    
}

#pragma mark - 点击  下一步button -----nextStepClick  --
- (void)nextStepClick:(UIButton *)sender{
    NSLog(@"next step ");
    
//    if ([UIImagePNGRepresentation(_imageV.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"home_question_addImage_btn"])]) {
//        
//        NSString *tips = [NSString stringWithFormat:@"请输入您的个人照片"];
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:tips preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [alert dismissViewControllerAnimated:YES completion:nil];
//                            }];
//        [alert addAction:action];
//        [self.navigationController presentViewController:alert animated:YES completion:nil];
//        
//    }
//    
    
    IndividualResumeVC *indivVC = [[IndividualResumeVC alloc] init];
    
    [self.navigationController pushViewController:indivVC animated:YES];
    
}

- (void)rightBtnClick:(UIButton *)sender{
   
    IndividualResumeVC *indivVC = [[IndividualResumeVC alloc] init];
    
    [self.navigationController pushViewController:indivVC animated:YES];

    
}


//- (void)leftReturnClick:(UIBarButtonItem *)item{
//    
//}

- (void)getImagePicker{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"个人照片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // 判断是否支持相机.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        NSLog(@"支持相机");
    } else {
        
        NSLog(@"不支持相机");
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"从相册上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 获取相册对象.
        self.picker = [[UIImagePickerController alloc] init];
        
        // 选择完成图片或点击取消按钮都是通过代理来操作所需的逻辑过程.
        self.picker.delegate = self;
        
        // 相册对象是否可编辑.
        self.picker.allowsEditing = YES;
        
        // 设置相册呈现的样式(枚举值).
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;// 相册获取.
        
        // 使用模态推出相册.
        [self presentViewController:self.picker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action];
    [alert addAction:actionCancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // 点击取消执行的代码.
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 获取照片.
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    NSLog(@"%@",image);
    
    self.imageV.image = image;
    
    // 设置显示照片.
    //    [self.buttonForUser setImage:image forState:UIControlStateNormal];
    
    //    CGSize size = CGSizeMake(WIDTH / 5, WIDTH / 5);
    
    // 调整image 的大小.
    //    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    //    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    //    [image drawInRect:rect];
    
    //    self.buttonForUser.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //    UIGraphicsEndImageContext();
    
    // 保存图片到本地, 注意:上传照片到服务器使用(未实现).
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"用户头像"];
    
        [[NSUserDefaults standardUserDefaults] synchronize];
    
}





//- (void)leftReturnClick:(UINavigationItem *)item{
//    
//    
//    
//}
//





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
