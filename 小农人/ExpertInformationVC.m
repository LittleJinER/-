//
//  ExpertInformationVC.m
//  小农人
//
//  Created by tomusng on 2017/9/9.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "ExpertInformationVC.h"
#import "XFStepView.h"
#import "IDCardViewController.h"
#import "ExpertTypeVC.h"
#import "SkilledCropsVC.h"
#import "ContactAddressVC.h"
#import "CropsDetailSpeciesModel.h"


#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1]
#define BGVIEW_COLOR     [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]
/* tabbar 高度*/
#define TABBAR_HEIGHT 49

@interface ExpertInformationVC ()<UITextFieldDelegate,ExpertTypeVCDelegate,SkilledCropsVCDelegate,ContactAddressDelegate>

@property (nonatomic, strong) XFStepView *stepView;

@property (nonatomic, assign) CGFloat setViewOriginHeight;
@property (nonatomic, assign) CGFloat setViewHeight;
@property (nonatomic, assign) CGFloat lineHeight;

@property (nonatomic, strong) UITextField *textF;
@property (nonatomic, strong) NSMutableArray *textFields;
@property (nonatomic, strong) NSArray *infoTextArr;
@property (nonatomic, strong) UILabel *expertTyLab;

@property (nonatomic, strong) UILabel *skilledCrLab;

@property (nonatomic, strong) UILabel *conAddreLab;

@property (nonatomic, strong) UITextField *realName;

@end

@implementation ExpertInformationVC
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"leftReturn"] style:UIBarButtonItemStylePlain target:self action:@selector(leftReturnClick:)];
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
    _stepView = [[XFStepView alloc] initWithFrame:CGRectMake(0, 10*DISTANCE_HEIGHT, K_WIDTH, 60*DISTANCE_HEIGHT) Titles:[NSArray arrayWithObjects:@"基本信息", @"身份证", @"个人照片", @"个人简介", nil] WithNum:0];
    _stepView.backgroundColor = BGVIEW_COLOR;
    bgView.backgroundColor = BGVIEW_COLOR;
    [bgView addSubview:_stepView];
    [self.view addSubview:bgView];
    
//    设置下面分类的初始高度
    _setViewOriginHeight = CGRectGetMaxY(bgView.frame);
//    设置每一行view的行高
    _setViewHeight = 50*DISTANCE_HEIGHT;
//    设置每条线view的高度
    _lineHeight = 0.5*DISTANCE_HEIGHT;
    
    [self createNextStepButton];
    [self createCategoryUI];
    
    
}

#pragma mark -    创建下一步 button      ----  nextStB  --
- (void)createNextStepButton{
    UIView *bgView = [[UIView alloc] init];
    
    bgView.frame = CGRectMake(0, K_HETGHT - TABBAR_HEIGHT, K_WIDTH, TABBAR_HEIGHT);
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = LINEVIEW_COLOR;
    lineView.frame = CGRectMake(0, 0, K_WIDTH, 0.5);
    [bgView addSubview:lineView];
    
    UIButton *nextStB = [UIButton buttonWithType:UIButtonTypeCustom];

    [nextStB setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStB.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [nextStB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [nextStB setBackgroundColor:TINTCOLOR];
    [nextStB setFrame:CGRectMake(10, 10, K_WIDTH - 20, TABBAR_HEIGHT - 20)];
    nextStB.clipsToBounds = YES;
    nextStB.layer.cornerRadius = 5.0f;
    
    [nextStB addTarget:self action:@selector(nextStepClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:nextStB];

}

#pragma mark - 创建分类UI --
- (void)createCategoryUI{
    
    UIView *bigView = [[UIView alloc] init];
    bigView.frame = CGRectMake(0, _setViewOriginHeight, K_WIDTH, K_HETGHT - _setViewOriginHeight - TABBAR_HEIGHT);
    [self.view addSubview:bigView];
    bigView.backgroundColor = BGVIEW_COLOR;
    
    NSArray *array = @[@"姓名",@"年龄",@"专家类型",@"擅长作物",@"工作单位",@"联系电话",@"联系地址",@"身份证"];
    for (int i = 0 ; i < 8; i ++) {
//        创建七个bgView
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, (_setViewHeight+_lineHeight)*i, K_WIDTH, _setViewHeight);
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        UILabel *label = [[UILabel alloc] init];
        label.text = array[i];
        label.frame = CGRectMake(10*DISTANCE_WIDTH, 15*DISTANCE_HEIGHT, 80*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
        label.backgroundColor = [UIColor greenColor];
        [bgView addSubview:label];
        label.font = [UIFont systemFontOfSize:16*DISTANCE_WIDTH];
        
//        创建七个lineView
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = LINEVIEW_COLOR;
        lineView.frame = CGRectMake(10*DISTANCE_WIDTH, _setViewHeight*(i+1) + _lineHeight*i, K_WIDTH - 10*DISTANCE_WIDTH, _lineHeight);
//        [self.view addSubview:lineView];
        
        [bigView addSubview:bgView];
        if (i == 2 || i == 3|| i == 6) {
           
            
            UIImageView *arrowView = [[UIImageView alloc] init];
            arrowView.frame = CGRectMake(K_WIDTH - 30*DISTANCE_WIDTH, 15*DISTANCE_HEIGHT, 20*DISTANCE_HEIGHT, 20*DISTANCE_HEIGHT);
            arrowView.image = [UIImage imageNamed:@"ReturnHistoryNW"];
            [bgView addSubview:arrowView];

            //                添加bgView的点击事件
            [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowViewDidClick:)]];
            arrowView.backgroundColor = [UIColor greenColor];
            bgView.tag = i + 1000;
            
            UILabel *textLab = [[UILabel alloc] init];
            textLab.frame = CGRectMake(CGRectGetMaxX(label.frame) + 10, 15*DISTANCE_HEIGHT, K_WIDTH-(30+CGRectGetWidth(label.frame)+30)*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
            [bgView addSubview:textLab];
            textLab.backgroundColor = [UIColor greenColor];
            textLab.textAlignment = NSTextAlignmentRight;
            textLab.tag = 2000 + i;
            
            switch (i) {
                case 2:
                {
                    NSNumber *textid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_official_category_id"];
                    id num = textid;
                    NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:@"expertType"];
                    if (![num isKindOfClass:[NSNull class]]&&![text isEqualToString:@""]) {
                        textLab.text = text;
                    }
                }
                    break;
                case 3:
                {
                    
                    NSString *textStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"tag"];
                    NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:@"cropsName"];
                    if (![textStr isEqualToString:@""]&&![text isEqualToString:@""]) {
                        textLab.text = text;
                    }

                }
                    break;
                case 6:
                {
                    NSString *textStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"location"];
                    if (![textStr isEqualToString:@""]) {
                        textLab.text = textStr;
                    }

                }
                    break;

                    
                default:
                    break;
            }
            
            
            
            
        }else{
            
            UITextField *textField = [[UITextField alloc] init];
            textField.frame = CGRectMake(CGRectGetMaxX(label.frame) + 10, 15*DISTANCE_HEIGHT, K_WIDTH-(30+CGRectGetWidth(label.frame)+30)*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
//            textField.keyboardType = UIKeyboardTypeNamePhonePad;
            [bgView addSubview:textField];
            textField.backgroundColor = [UIColor greenColor];
            textField.textAlignment = NSTextAlignmentRight;
//            textField.tag = 10000 + i;
            [self.textFields addObject:textField];
            
//            _textF = textField;
            
            switch (i) {
                case 0:{
                    
                    NSString *textStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"realname"];
                    if (![textStr isEqualToString:@""]) {
                        textField.text = textStr;
                    }
                    
                }
                    break;
                case 1:{
                    NSString *textStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"age"];
                    if (![textStr isEqualToString:@""]) {
                        textField.text = textStr;
                    }

                    
                }
                    break;

                case 4:{
                    NSString *textStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"company"];
                    if (![textStr isEqualToString:@""]) {
                        textField.text = textStr;
                    }

                    
                }
                    break;

                case 5:{
                    NSString *textStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
                    if (![textStr isEqualToString:@""]) {
                        textField.text = textStr;
                    }

                    
                }
                    break;

                case 7:{
                    NSString *textStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"idcard"];
                    if (![textStr isEqualToString:@""]) {
                        textField.text = textStr;
                    }

                    
                }
                    break;

                default:
                    break;
            }
            
            
            
            
        }
    }
    
}
#pragma mark - view的点击手势的方法
- (void)arrowViewDidClick:(UITapGestureRecognizer *)recognizer{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)recognizer;
    NSInteger tag = tap.view.tag;
    UILabel *label = (UILabel *)[tap.view viewWithTag:tag + 1000];
    switch (tag) {
        case 1002:
        {
            NSLog(@"2");
            self.expertTyLab = label;
            ExpertTypeVC *expVC = [[ExpertTypeVC alloc] init];
            expVC.delegate = self;
            [self.navigationController pushViewController:expVC animated:YES];
            
        }
            break;
        case 1003:
        {
            NSLog(@"3");
            SkilledCropsVC *skCrVC = [[SkilledCropsVC alloc] init];
            skCrVC.dataSourceDelegate = self;
            self.skilledCrLab = label;
            [self.navigationController pushViewController:skCrVC animated:YES];
            
        }
            break;
        case 1006:
        {
            NSLog(@"6");
            self.conAddreLab = label;
            ContactAddressVC *conAdVC = [[ContactAddressVC alloc] init];
            conAdVC.delegate = self;
            [self.navigationController pushViewController:conAdVC animated:YES];
            
            
        }
            break;
        default:
            break;
    }
}


- (NSMutableArray *)textFields{
    
    if (!_textFields) {
        _textFields = [NSMutableArray arrayWithCapacity:4];
    }
    
    return _textFields;
    
}

- (NSArray *)infoTextArr{
    
    if (!_infoTextArr) {
        _infoTextArr = @[@"姓名",@"年龄",@"工作单位",@"联系电话",@"身份证"];
    }
    
    return _infoTextArr;
}

#pragma mark - 点击  下一步button -----nextStepClick  --
- (void)nextStepClick:(UIButton *)sender{

    for (int i = 0; i < 5; i ++) {
        UITextField *textF = [self.textFields objectAtIndex:i];
//        if ([textF.text isEqualToString:@""]) {
//            
//            NSString *tips = [NSString stringWithFormat:@"%@不能为空",self.infoTextArr[i]];
//            
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:tips preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//                [alert dismissViewControllerAnimated:YES completion:nil];
//            }];
//            [alert addAction:action];
//            [self.navigationController presentViewController:alert animated:YES completion:nil];
//        }
        
        
        switch (i) {
            case 0:{
                [[NSUserDefaults standardUserDefaults] setObject:textF.text forKey:@"realname"];
                NSLog(@"      fff     %@",textF.text);
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
                break;
            case 1:{
                [[NSUserDefaults standardUserDefaults] setObject:textF.text forKey:@"age"];
                NSLog(@"      age     %@",textF.text);
                [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }
                break;
            case 2:{
                [[NSUserDefaults standardUserDefaults] setObject:textF.text forKey:@"company"];
                NSLog(@"      workCompany     %@",textF.text);
                [[NSUserDefaults standardUserDefaults] synchronize];
                }
                break;
            case 3:{
                [[NSUserDefaults standardUserDefaults] setObject:textF.text forKey:@"phone"];
                NSLog(@"      phone     %@",textF.text);
                [[NSUserDefaults standardUserDefaults] synchronize];
                }
                break;
            case 4:{
                [[NSUserDefaults standardUserDefaults] setObject:textF.text forKey:@"idcard"];
                NSLog(@"      idcard     %@",textF.text);
                [[NSUserDefaults standardUserDefaults] synchronize];
                }
                break;
                
            default:
                break;
        }
        
    }
    
    
    IDCardViewController *cardVC = [[IDCardViewController alloc] init];
    
    [self.navigationController pushViewController:cardVC animated:YES];
    
    
    
}


#pragma mark   -- 导航栏右侧 暂时略过按钮
- (void)rightBtnClick:(UIButton *)sender{
    
    for (int i = 0; i < 5; i ++) {
        UITextField *textF = [self.textFields objectAtIndex:i];
        
        switch (i) {
            case 0:{
                [[NSUserDefaults standardUserDefaults] setObject:textF.text forKey:@"realname"];
                NSLog(@"      fff     %@",textF.text);
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
                break;
            case 1:{
                [[NSUserDefaults standardUserDefaults] setObject:textF.text forKey:@"age"];
                NSLog(@"      age     %@",textF.text);
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
                break;
            case 2:{
                [[NSUserDefaults standardUserDefaults] setObject:textF.text forKey:@"company"];
                NSLog(@"      workCompany     %@",textF.text);
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
                break;
            case 3:{
                [[NSUserDefaults standardUserDefaults] setObject:textF.text forKey:@"phone"];
                NSLog(@"      phone     %@",textF.text);
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
                break;
            case 4:{
                [[NSUserDefaults standardUserDefaults] setObject:textF.text forKey:@"idcard"];
                NSLog(@"      idcard     %@",textF.text);
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
                break;
                
            default:
                break;
        }
    }
    
   
    
}

- (void)transferExpType:(NSArray *)expType{
    
    NSArray *array = [NSArray arrayWithArray:expType];
    self.expertTyLab.text = array[0];
    NSNumber *expert_num = array[1];
    [[NSUserDefaults standardUserDefaults] setValue:expert_num forKey:@"user_official_category_id"];
    [[NSUserDefaults standardUserDefaults] setObject:self.expertTyLab.text forKey:@"expertType"];
    NSLog(@"%@",expert_num);
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (![textField isExclusiveTouch]) {
        [textField resignFirstResponder];
    }
    return YES;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_textF endEditing:YES];
    
}

- (void)leftReturnClick:(UINavigationItem *)item{
    
    NSInteger num = self.navigationController.viewControllers.count;
//    NSLog(@"fffff   %ld",(long)num);
    UIViewController *viewC = self.navigationController.viewControllers[num - 2];
    [self.navigationController popToViewController:viewC animated:YES];
    
    
}

- (void)sendDataSource:(NSMutableArray *)dataSource{
    
//    NSLog(@"ffff     %@",dataSource);
    
    if (dataSource.count != 0) {
        NSMutableArray *cropsNameArr = [NSMutableArray array];
        [cropsNameArr addObjectsFromArray:dataSource[0]];
        NSString *text = [cropsNameArr componentsJoinedByString:@","];
        self.skilledCrLab.text = text;
        
        
        NSMutableArray *cropsIDArr = [NSMutableArray array];
        [cropsIDArr addObjectsFromArray:dataSource[1]];
        NSString *cropsID = [cropsIDArr componentsJoinedByString:@","];
        NSString *crops_ids = [cropsID stringByReplacingOccurrencesOfString:@"," withString:@"|"];
        [[NSUserDefaults standardUserDefaults]setObject:crops_ids forKey:@"tag"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:text forKey:@"cropsName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (void)sendContactAddress:(NSString *)address{
    
    self.conAddreLab.text = address;
    [[NSUserDefaults standardUserDefaults] setObject:address forKey:@"location"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
