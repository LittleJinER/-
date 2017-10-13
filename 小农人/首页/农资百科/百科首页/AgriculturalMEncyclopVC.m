//
//  AgriculturalMEncyclopVC.m
//  小农人
//
//  Created by tomusng on 2017/9/26.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "AgriculturalMEncyclopVC.h"
#import "LLSearchView.pch"
#import "FirstHttpRequestManager.h"
#import "FaTextField.h"
#import "AgricultMaClassView.h"
#import "pesticideViewController.h"//农药页面
#import "SeedViewController.h"//种子页面
#import "FertilizerViewController.h"//肥料页面

#import "AgricultMEncySearchVC.h"//搜索界面

#import "FertilizerDetailViewController.h"//最小分类详情页面


#define ViewWidth [[UIScreen mainScreen] bounds].size.width
#define ViewHeight [[UIScreen mainScreen] bounds].size.height - 64 - MENU_HEIGHT - LINE_HEIGHT

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]
#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]
#define BG_COLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]
#define LIGHT_TITLE_COLOR [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1]

#define CUSTOM_COLOR(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]

#define LINE_HEIGHT 0.5*DISTANCE_WIDTH

#define MENU_BUTTON_WIDTH  [UIScreen mainScreen].bounds.size.width/7.0
#define MENU_HEIGHT 44*DISTANCE_WIDTH



@interface AgriculturalMEncyclopVC ()<UITextFieldDelegate>

@property (nonatomic, strong) NSDictionary *readDic;
@property (nonatomic, strong) NSDictionary *rootDic;
@property (nonatomic, strong) FaTextField *textField;
@property (nonatomic, assign) CGFloat navBarMaxH;
@property (nonatomic, assign) int teger;

@end

@implementation AgriculturalMEncyclopVC

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [_textField endEditing:YES];
    self.tabBarController.tabBar.hidden = NO;
}



- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"农资百科";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = BG_COLOR;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:@"home_navigation_back_btn"];
    leftBtn.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [leftBtn setImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navBarRect = self.navigationController.navigationBar.frame;
    
    _navBarMaxH = statusRect.size.height + navBarRect.size.height;
    
    
    [self getAgriculturaMEncyData];
   
  
    
    
}

- (void)createSearchBarUI{
    
    
    //    设置搜索框
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10*DISTANCE_WIDTH, _navBarMaxH+10*DISTANCE_HEIGHT, K_WIDTH - 20*DISTANCE_WIDTH, 30*DISTANCE_HEIGHT)];
    
    
    //设置圆角效果
    bgView.layer.cornerRadius = 14;
    bgView.layer.masksToBounds = YES;
    
    bgView.backgroundColor = [UIColor whiteColor];
    //    bgView.backgroundColor = BG_COLOR;
    
    [self.view addSubview:bgView];
    
    FaTextField *textField = [[FaTextField alloc] initWithFrame:CGRectMake(40*DISTANCE_WIDTH, 0, CGRectGetWidth(bgView.frame) - 120*DISTANCE_WIDTH, CGRectGetHeight(bgView.frame))];
    textField.font = [UIFont systemFontOfSize:13*DISTANCE_WIDTH];
    
    //清除按钮
    textField.clearButtonMode =UITextFieldViewModeWhileEditing;
    
    _textField = textField;
    
    textField.delegate = self;
    //键盘属性
    //    _textField.returnKeyType = UIReturnKeySearch;
    
    //为textField设置属性占位符
    //    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索问题" attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
    textField.placeholder = @"有效成分、作物";
    textField.textColor = [UIColor blackColor];
    textField.textAlignment = NSTextAlignmentCenter;
    
    [bgView addSubview:textField];
    
    UIImage *searchImage = [UIImage imageNamed:@"commen_search"];
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, searchImage.size.width, searchImage.size.height)];
    searchImageView.image = searchImage;
    searchImageView.contentMode = UIViewContentModeCenter;
    textField.leftView = searchImageView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    

}

#pragma mark ---- 返回按钮的方法
- (void)leftBtnClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)createScrollViewUI{
    CGFloat space = 10*DISTANCE_WIDTH;
    CGFloat width = K_WIDTH - 20*DISTANCE_WIDTH;
    CGFloat heightSpace = 12.5*DISTANCE_HEIGHT;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(space, _navBarMaxH + 50*DISTANCE_HEIGHT, K_WIDTH - 2*space, K_HETGHT - (64 + 50*DISTANCE_HEIGHT));
    //    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:scrollView];

    
    UIView *bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bgView];
    //      headImg
    UIImageView *headImg = [[UIImageView alloc] init];
    

    UIImage *timeImg = [UIImage imageNamed:@"BaikeHomeTimeBack"];
    
    CGFloat headImgHeight = 5*space * timeImg.size.height/timeImg.size.width;
    headImg.image = [UIImage imageNamed:@"BaikeHomeTimeBack"];
    headImg.frame = CGRectMake(1.5*space, 1.5*space, 5*space, headImgHeight);
    [bgView addSubview:headImg];
//    获取本地时间
    NSArray *timeArr = [self getCurrentTimes];
    
    UILabel *dayLab = [[UILabel alloc] init];
    dayLab.frame = CGRectMake(space, 0.8*space, CGRectGetWidth(headImg.frame) - 2*space, 1.5*space);
    dayLab.text = timeArr[1];
//    dayLab.backgroundColor = [UIColor lightGrayColor];
    dayLab.font = [UIFont systemFontOfSize:18*DISTANCE_WIDTH weight:0.5*DISTANCE_WIDTH];
    dayLab.textColor = [UIColor whiteColor];
    dayLab.textAlignment = NSTextAlignmentCenter;
    [headImg addSubview:dayLab];
    UILabel *monthLab = [[UILabel alloc] init];
    monthLab.frame = CGRectMake(space, CGRectGetMaxY(dayLab.frame) + space/2, CGRectGetWidth(dayLab.frame), 1.3*space);
    monthLab.text = [NSString stringWithFormat:@"%@月",timeArr[0]];
    monthLab.font = [UIFont systemFontOfSize:13*DISTANCE_HEIGHT];
    monthLab.textAlignment = NSTextAlignmentCenter;
    monthLab.textColor = [UIColor whiteColor];
    [headImg addSubview:monthLab];
    
    //      everyDLab
    UILabel *everyDLab = [[UILabel alloc] init];
    everyDLab.frame = CGRectMake(CGRectGetMaxX(headImg.frame) + 1.5*space, 1.9*space, 250*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
    everyDLab.font = [UIFont systemFontOfSize:16*DISTANCE_WIDTH];
    everyDLab.text = @"每日知识必读";
    [bgView addSubview:everyDLab];
    bgView.frame = CGRectMake(0, 0, width, CGRectGetMaxY(everyDLab.frame));
    //      dayRLab
    UILabel *dayRLab = [[UILabel alloc] init];
    dayRLab.frame = CGRectMake(CGRectGetMaxX(headImg.frame) + 1.5*space, CGRectGetMaxY(everyDLab.frame) + space/2, 250*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
    dayRLab.font = [UIFont systemFontOfSize:13*DISTANCE_WIDTH];
    dayRLab.textColor = LIGHT_TITLE_COLOR;
    dayRLab.text = @"学而无止境，每日一读";
    [bgView addSubview:dayRLab];
    
    bgView.frame = CGRectMake(0, 0, width, CGRectGetMaxY(dayRLab.frame) + 1.5*space);

    //        lineView
    UIView *lineView = [[UIView alloc] init];
    
    lineView.frame = CGRectMake(space, CGRectGetMaxY(bgView.frame), width - 2*space, 0.5*DISTANCE_HEIGHT);
    lineView.backgroundColor = LINEVIEW_COLOR;
    
    [scrollView addSubview:lineView];
    
//    下面部分的  detailBgView
    UIView *detailBgView = [[UIView alloc] init];
    detailBgView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:detailBgView];
    //      nameLab
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.frame = CGRectMake(space, 1.3*space, width - 2*space, 2*space);
    nameLab.font = [UIFont systemFontOfSize:16*DISTANCE_WIDTH];
    nameLab.text = self.readDic[@"title"];
    
    
    [detailBgView addSubview:nameLab];
    
    //        textLab
    UILabel *textLab = [[UILabel alloc] init];
    
    textLab.font = [UIFont systemFontOfSize:14*DISTANCE_WIDTH];

    textLab.numberOfLines = 0;
    NSString *readDescrip = self.readDic[@"description"];
    
    NSArray *textArr = [self separateString:readDescrip];
    
//    NSString *text = [self filterHTML:readModel.description];
    if (textArr.count >= 2) {
        textLab.text = [NSString stringWithFormat:@"%@\n%@",textArr[0],textArr[1]];
        
        CGRect textRect = [textLab.text boundingRectWithSize:CGSizeMake(width - 2*space, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*DISTANCE_WIDTH]} context:nil];
        
        textLab.frame = CGRectMake(space, CGRectGetMaxY(nameLab.frame) + space/2, width - 2*space, textRect.size.height);
        
    }
    

    textLab.textColor = [UIColor blackColor];
    [detailBgView addSubview:textLab];

    //      查看全部label
    
    UILabel *detailLab = [[UILabel alloc] init];
    detailLab.frame = CGRectMake(width - 100*DISTANCE_WIDTH, CGRectGetMaxY(textLab.frame) + heightSpace, 60*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
    detailLab.font = [UIFont systemFontOfSize:13*DISTANCE_WIDTH];
    detailLab.text = @"查看详情";
//    detailLab.textColor = LIGHT_TITLE_COLOR;
    detailLab.textAlignment = NSTextAlignmentRight;
    [detailBgView addSubview:detailLab];
    
    //        arrowImg
    UIImageView *arrowImg = [[UIImageView alloc] init];
    arrowImg.frame = CGRectMake( CGRectGetMaxX(detailLab.frame) + space, CGRectGetMaxY(textLab.frame) + 12*DISTANCE_HEIGHT, 2*space, 2*space);
    
    arrowImg.image = [UIImage imageNamed:@"ReturnHistoryNW"];
    
    [detailBgView addSubview:arrowImg];

    detailBgView.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame), width, CGRectGetMaxY(arrowImg.frame)+space);
    [scrollView addSubview:detailBgView];
    
    
    [detailBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readingDetailBgViewClick:)]];
    detailBgView.userInteractionEnabled = YES;
    
    
    
    
    
    
    
    
//    下面三个分类 农药    种子     肥料
    
    CGFloat classViewHeight = 140*DISTANCE_HEIGHT;
    
    CGFloat contentHeight = 0.0;
    
//    NSArray *imgArr = @[@"BaikeHomeNY",@"BaikeHomeZZ",@"BaikeHomeFL"];
//    NSArray *classArr = @[@"农药",@"种子",@"肥料"];
    NSArray *dicName = @[@"pesticide",@"seed",@"fertilizer"];
    
    for (int i = 0 ; i < 3; i ++) {
        
        AgricultMaClassView *classView = [[AgricultMaClassView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(detailBgView.frame) + space + (classViewHeight + space)*i, scrollView.frame.size.width, classViewHeight)];
//        classView.headImg.image = [UIImage imageNamed:imgArr[i]];
//        classView.classLab.text = classArr[i];
//        classView.backgroundColor = [UIColor greenColor];
        [scrollView addSubview:classView];
        
        if (i == 2) {
            contentHeight = CGRectGetMaxY(classView.frame);
        }
        
//        switch (i) {
//            case 0:
//            {
//                classView.classLab.textColor = CUSTOM_COLOR(252, 86, 56);
//                
//                
//            }
//                break;
//                
//            case 1:
//            {
//                classView.classLab.textColor = CUSTOM_COLOR(91, 207, 85);
//            }
//                break;
//                
//            case 2:
//            {
//                classView.classLab.textColor = CUSTOM_COLOR(70, 161, 236);
//
//            }
//                break;
//                
//            default:
//                break;
//        }
//        classView.textLab.text = @"ddfdfdfdfdffff";
        
        
        NSDictionary *classDic = self.rootDic[dicName[i]];
        classView.dict = [NSDictionary dictionaryWithDictionary:classDic];
        
//        NSLog(@"NSDictionary dictionaryWithDictionary:classDic");
        
//        classView.dict = classDic;
        
        
        classView.detailBgView.tag = 1000 + i;
        [classView.detailBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailBgViewClick:)]];
        classView.detailBgView.userInteractionEnabled = YES;
        
        classView.bgView.tag = 2000 + i;
        [classView.bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allBgViewClick:)]];
        classView.bgView.userInteractionEnabled = YES;
        
        
        
    }
    
    scrollView.contentSize = CGSizeMake(0, contentHeight + 5*DISTANCE_HEIGHT);
    
}

- (void)readingDetailBgViewClick:(UITapGestureRecognizer *)recognizer{
    
    NSLog(@"查看详情");
    FertilizerDetailViewController *ferDeVC = [[FertilizerDetailViewController alloc] init];

//    NSDictionary *childDic = [NSDictionary dictionaryWithDictionary:self.readDic[@"reading"]];
    ferDeVC.aid = [self.readDic[@"article_id"] integerValue];
    ferDeVC.titleName = self.readDic[@"title"];

    [self.navigationController pushViewController:ferDeVC animated:YES];
    
    
    
}

#pragma detailBgViewClick点击方法  -- 查看详情
- (void)detailBgViewClick:(UITapGestureRecognizer *)recognizer{
    
    NSInteger teger = recognizer.view.tag;
     FertilizerDetailViewController *ferDeVC = [[FertilizerDetailViewController alloc] init];
    
    NSDictionary*littleDic;
    
    switch (teger) {
        case 1000:
        {
//            NSLog(@"1000");
            
//        ferDeVC
            littleDic = [NSDictionary dictionaryWithDictionary:self.rootDic[@"pesticide"]];
           
        }
            break;
            
        case 1001:
        {
//            NSLog(@"1001");
            littleDic = [NSDictionary dictionaryWithDictionary:self.rootDic[@"seed"]];
           
        }
            break;
            
        case 1002:
        {
//            NSLog(@"1002");
            littleDic = [NSDictionary dictionaryWithDictionary:self.rootDic[@"fertilizer"]];
           
        }
            break;
            
        default:
            break;
    }
    
    NSDictionary *childDic = [NSDictionary dictionaryWithDictionary:littleDic[@"child"]];
    ferDeVC.colorID = [littleDic[@"cat_id"] integerValue] + 99;
    ferDeVC.aid = [childDic[@"article_id"] integerValue];
    ferDeVC.titleName = childDic[@"title"];
    
    [self.navigationController pushViewController:ferDeVC animated:YES];
    
}

#pragma mark  -  allBgViewClick的点击方法  -- 分类的查看全部
- (void)allBgViewClick:(UITapGestureRecognizer *)recognizer{
    NSInteger teger = recognizer.view.tag;
   
    NSArray *dicName = @[@"pesticide",@"seed",@"fertilizer"];
    NSDictionary *classDic = self.rootDic[dicName[teger - 2000]];
    
    switch (teger) {
        case 2000:
        {
            NSLog(@"2000");
            pesticideViewController *pesticideVC = [[pesticideViewController alloc] init];
            pesticideVC.cid = [classDic[@"cat_id"] intValue];
            
            
            [self.navigationController pushViewController:pesticideVC animated:YES];

        }
            break;
            
        case 2001:
        {
            NSLog(@"2001");
            SeedViewController *seedVC = [[SeedViewController alloc] init];
            seedVC.cid = [classDic[@"cat_id"] intValue];
            [self.navigationController pushViewController:seedVC animated:YES];
            

        }
            break;
            
        case 2002:
        {
            NSLog(@"2002");
            FertilizerViewController *fertilizerVC =  [[FertilizerViewController alloc] init];
            fertilizerVC.cid = [classDic[@"cat_id"] intValue];
            [self.navigationController pushViewController:fertilizerVC animated:YES];

        }
            break;
            
        default:
            break;
    }

    
    
}




#pragma mark -- 懒加载数组 readArr  rootArr
//- (NSMutableArray *)readArr{
//    
//    if (!_readArr) {
//        _readArr = [NSMutableArray array];
//    }
//    return _readArr;
//    
//    
//}

//- (NSMutableArray *)rootArr{
//    
//    if (!_rootArr) {
//        _rootArr = [NSMutableArray array];
//    }
//    return _rootArr;
//    
//    
//}

#pragma mark --  网络请求农资百科的顶级页面的数据

- (void)getAgriculturaMEncyData{
    
    NSString *str = [NSString stringWithFormat:C_HOST_API,@"/wiki/get_top_rated"];
    
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak AgriculturalMEncyclopVC *weakSelf = self;
    
    
    [FirstHttpRequestManager getAgriculturaMEncyInfoWithUrl:encode WithBlock:^(NSArray * _Nullable array) {
        
//        [weakSelf.readArr addObjectsFromArray:array[0]];
        
        weakSelf.readDic = [NSDictionary dictionaryWithDictionary:array[0]];
//        [weakSelf.rootArr addObjectsFromArray:array[1]];
        weakSelf.rootDic = [NSDictionary dictionaryWithDictionary:array[1]];
        
        
        
        
        [self createSearchBarUI];
        [self createScrollViewUI];
    }];
    
    
}

#pragma mark -- 获取当前时间
- (NSArray *)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
//    NSLog(@"%@",currentTimeString);
    NSArray *strArr = [currentTimeString componentsSeparatedByString:@"-"];
//    NSLog(@"%@",strArr);
    
    NSString *month;
    NSString *monthStr = [strArr[1] substringToIndex:1];
    if ([monthStr isEqualToString:@"0"]) {
//        NSLog(@"%@",monthStr);
        month = [strArr[1] substringFromIndex:1];
//        NSLog(@"month: %@",month);
    }else{
        month = strArr[1];
    }
    
//    NSString *day;
    NSString *day = [strArr[2] substringToIndex:2];
//    NSLog(@"day:  %@",day);
    
    NSArray *timeArr = @[month,day];
    
//    NSLog(@"%@",timeArr);
    
    return timeArr;
//    return currentTimeString;
    
}

#pragma mark -- 去掉HTML里面的标签并且分组
- (NSArray *)separateString:(NSString *)string{
    
//    NSLog(@"");
    
    
    NSArray *firstArr = [string componentsSeparatedByString:@"<br/>"];
    
//    NSLog(@"%@",firstArr);
    
    NSMutableArray *strArr = [NSMutableArray array];
    
    for (int i = 0 ; i < firstArr.count; i ++) {
        
        NSString *textStr = [self filterHTML:firstArr[i]];
        
//        NSLog(@"%@",textStr);
        
        [strArr addObject:textStr];
    }
    
    NSArray *array = [NSArray arrayWithArray:strArr];
    
    return array;
    
}
#pragma mark -- 去掉HTML里面的标签
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
//    NSLog(@"html:   %@",html);
    
    return html;
}




- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"ddd");
    AgricultMEncySearchVC *searchVC = [[AgricultMEncySearchVC alloc] init];
    
    [self.navigationController pushViewController:searchVC animated:YES];
    
    
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
