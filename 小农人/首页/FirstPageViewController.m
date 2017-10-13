//
//  FirstPageViewController.m
//  小农人
//
//  Created by tomusng on 2017/8/14.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "FirstPageViewController.h"
#import "FirstHttpRequestManager.h"
#import "PictureRotate.h"
#import "FirstSearchViewController.h"
#import "TechniqueListVC.h"//学技术
#import "AgriculturalMEncyclopVC.h"//农资百科
#import "TestViewController.h"
#import "MyInfomationViewController.h"//我的消息页面

#import "LoginViewController.h"


#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0




@interface FirstPageViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) PictureRotate *pictureRotate;
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation FirstPageViewController

//添加一个定时器
- (void)viewWillAppear:(BOOL)animated{
    //
    if (_pictureRotate) {
        [_pictureRotate addTimerLoop];
    }
    self.tabBarController.tabBar.hidden = NO;
    //    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];
    
    
}

//销毁定时器
- (void)viewWillDisappear:(BOOL)animated{
    
    [self.pictureRotate resumeTimer];
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"首页";
    self.view.backgroundColor = [UIColor greenColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    NSLog(@"ddfffffffffff");
    
    //创建导航栏上的搜索框
    [self createSearchBar];
    
    //    自定义表头
    [self createHeaderView];
    


}
#pragma mark  -  创建导航栏上的搜索框
- (void)createSearchBar{
    
    
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(5, 7, self.view.frame.size.width-100*DISTANCE_WIDTH, 30)];
    _titleView.backgroundColor = [UIColor blackColor];
    
    //设置圆角效果
    _titleView.layer.cornerRadius = 15.0*DISTANCE_HEIGHT;
    _titleView.layer.masksToBounds = YES;
    
    
    //    titleView.backgroundColor = [UIColor whiteColor];
    
    UIImage *searchImage = [UIImage imageNamed:@"commen_search"];
    CGFloat imaHeight = searchImage.size.height;
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (30 - imaHeight)/2.0, searchImage.size.width, searchImage.size.height)];
    searchImageView.image = searchImage;
    searchImageView.contentMode = UIViewContentModeCenter;
    [_titleView addSubview:searchImageView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchImageView.frame) + 10, 0, CGRectGetWidth(_titleView.frame) - 10, CGRectGetHeight(_titleView.frame))];
    //    _textField = [[FaTextField alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.bgView.frame) - 10, CGRectGetHeight(_bgView.frame))];
    _textField.font = [UIFont systemFontOfSize:13*DISTANCE_WIDTH];
    _textField.textColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1];
    //清除按钮
    _textField.clearButtonMode =UITextFieldViewModeWhileEditing;
    
    _textField.delegate = self;
    //键盘属性
    //    _textField.returnKeyType = UIReturnKeySearch;
    
    //为textField设置属性占位符
    //    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索问题" attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
    _textField.placeholder = @"搜索";
    _textField.textColor = [UIColor blackColor];
    _textField.textAlignment = NSTextAlignmentLeft;
    
    [_titleView addSubview:_textField];
    
    _titleView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.navigationItem.titleView = _titleView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_btn_message_nm"] style:UIBarButtonItemStylePlain target:self action:@selector(newsClick:)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1];
    
}

- (void)newsClick:(UIBarButtonItem *)sender{
    
    MyInfomationViewController *myInfoVC = [[MyInfomationViewController alloc] init];
    
    [self.navigationController pushViewController:myInfoVC animated:YES];
}

#pragma mark    -    自定义表头
- (void)createHeaderView{
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    
    NSArray *images = @[@"001.jpg",@"002.jpg",@"003.jpg",@"004.jpg",@"005.jpg"];
    
    PictureRotate *pictureRotate = [[PictureRotate alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    pictureRotate.images = images;
    pictureRotate.timeInterval = 2.0;
    _pictureRotate = pictureRotate;
    [bgView addSubview:pictureRotate];
    
    //    self.tableView.tableHeaderView = pictureRotate;
    
    //    图片与图片之间的间隔
    CGFloat spaceWidth = (WIDTH - 200*DISTANCE_WIDTH)/4;
    //    label与label之间的间隔
    CGFloat labelSpaceW = (WIDTH - 280*DISTANCE_WIDTH)/4;
    
    NSArray *imgArr = @[@"home_new_xuejishu",@"home_new_mainongzi",@"home_new_nybaike",@"home_new_wzhuanjia"];
     NSArray *classifyStrArr = @[@"学技术",@"买农资",@"农资百科",@"问专家"];
    
    for (int i = 0; i < 4; i ++) {
        UIImageView *classifyImageV = [[UIImageView alloc] init];
        
        classifyImageV.frame = CGRectMake(spaceWidth/2 + (spaceWidth + 50*DISTANCE_WIDTH)*i, CGRectGetMaxY(pictureRotate.frame)+ 10*DISTANCE_HEIGHT, 50*DISTANCE_WIDTH, 50*DISTANCE_WIDTH);
        
        UIImage *claImage = [UIImage imageNamed:imgArr[i]];
        
        classifyImageV.image = claImage;
        
        //        创建资格label
       
        UILabel *classifyLabel = [[UILabel alloc] init];
        classifyLabel.frame = CGRectMake(labelSpaceW/2 + (labelSpaceW + 70*DISTANCE_WIDTH)*i, CGRectGetMaxY(pictureRotate.frame)+ 20*DISTANCE_HEIGHT + 50*DISTANCE_WIDTH, 70*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
        
        classifyLabel.text = classifyStrArr[i];
        classifyLabel.textColor = [UIColor blackColor];
        classifyLabel.backgroundColor = [UIColor whiteColor];
        classifyLabel.font = [UIFont systemFontOfSize:15.0f*DISTANCE_WIDTH];
        classifyLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:classifyImageV];
        [bgView addSubview:classifyLabel];
        
        
        classifyImageV.userInteractionEnabled = YES;
        [classifyImageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewDidClick:)]];
        
        classifyImageV.tag = i + 1000;

        
        
        
        
    }
    
    bgView.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(pictureRotate.frame)+ 50*DISTANCE_HEIGHT + 50*DISTANCE_WIDTH);
    self.tableView.tableHeaderView = bgView;
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    return cell;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    
    NSLog(@"textFieldDidBeginEditing");
    
    FirstSearchViewController *searchVC = [[FirstSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
    
    
    
}


#pragma mark - bgView 的点击事件
- (void)bgViewDidClick:(UITapGestureRecognizer *)recognizer{
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)recognizer;
    
    NSInteger tag = tap.view.tag;
    
    switch (tag) {
        case 1000:
        {
//            学技术
            NSLog(@"0   -  学技术");
            TechniqueListVC *techVC = [[TechniqueListVC alloc] init];
            [self.navigationController pushViewController:techVC animated:YES];
//            ExpertInformationVC *exInfoVC = [[ExpertInformationVC alloc]init];
//            [self.navigationController pushViewController:exInfoVC animated:YES];
            
        }
            break;
        case 1001:
        {
            NSLog(@"1 -- 买农资");

            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
            
//
//            TestViewController *testVC = [[TestViewController alloc] init];
//            [self.navigationController pushViewController:testVC animated:YES];
            
            
        }
            break;
        case 1002:
        {
            NSLog(@"2  -  农资百科");
            AgriculturalMEncyclopVC *agriMEncyVC = [[AgriculturalMEncyclopVC alloc] init];
            
            [self.navigationController pushViewController:agriMEncyVC animated:YES];
            
        }
            break;
        case 1003:
        {
            NSLog(@"3  --  问专家");
            //            FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
            //            [self.navigationController pushViewController:feedbackVC animated:YES];
            
            
        }
            break;
   
        default:
            break;
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
