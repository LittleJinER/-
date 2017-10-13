//
//  FirstSearchViewController.m
//  小农人
//
//  Created by tomusng on 2017/9/22.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "FirstSearchViewController.h"
//#import "LLSearchView.h"
//#import "SearchCropViewController.h"
#import "FirstHttpRequestManager.h"
#import "SearchTechniqueVC.h"//搜索技术页面
#import "SearchQuestionVC.h"//搜索问题页面
#import "SearchExpertsVC.h"//搜索专家页面

#import "LLSearchView.pch"



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

@interface FirstSearchViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *btnArr;

@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, assign) NSInteger teger;
@end

@implementation FirstSearchViewController


#pragma mark - 搜索历史 -


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_searchBar.isFirstResponder) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    if (_searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }

}




- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setBarButtonItem];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    NSArray *array = [NSArray arrayWithObjects:@"大豆",@"西瓜", nil];
    [MyDefaults setObject:array forKey:@"cropsArr"];
    
    [self createFourButton];
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    rightButton.frame = CGRectMake(0, 0, 70, 30);
//    rightButton.backgroundColor = DE_RED_Color;
//    
//    
//    [rightButton setTitle:@"搜索" forState:UIControlStateNormal];
//    
//    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    
}


- (void)rightButtonClick:(UIButton *)sender{
    
    
    NSLog(@"rightButtonClick");
    
    
}


- (void)setBarButtonItem
{
    [self.navigationItem setHidesBackButton:YES];
    // 创建搜索框
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 7*DISTANCE_HEIGHT, self.view.frame.size.width-35*DISTANCE_HEIGHT, 30*DISTANCE_HEIGHT)];
//    titleView.backgroundColor = [UIColor greenColor];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleView.frame) - 5*DISTANCE_WIDTH, 30*DISTANCE_HEIGHT)];
//    searchBar.backgroundColor = [UIColor orangeColor];
    searchBar.placeholder = @"搜索内容";
    searchBar.backgroundImage = [UIImage imageNamed:@"clearImage"];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    UITextField * searchField = [searchBar valueForKey:@"_searchField"];
//    [searchField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont boldSystemFontOfSize:16*DISTANCE_WIDTH] forKeyPath:@"_placeholderLabel.font"];
    _searchBar = searchBar;
    UIView *searchTextField = searchTextField = [searchBar valueForKey:@"_searchField"];
    searchTextField.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:237/255.0 alpha:1];
    [searchBar setImage:[UIImage imageNamed:@"sort_magnifier"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
//    修改标题和标题颜色
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
//    [cancleBtn addTarget:searchBar action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
    [self.searchBar becomeFirstResponder];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(cancleDidClick)];
}


//- (void)searchBtnClick:(UIButton *)sender{
//    
//    
//    NSLog(@"dddddddddddddddddddd");
//    
//}

/** 点击取消 */
- (void)cancleDidClick
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UISearchBarDelegate -


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
   
    switch (_teger) {
        
        case 0:
            
            NSLog(@"00000    ---");
            
            break;
            
        case 1:{
            
//            NSLog(@"11111    ---");
            SearchTechniqueVC *techniqueVC = [[SearchTechniqueVC alloc] init];
            techniqueVC.text = _searchBar.text;
            [self.navigationController pushViewController:techniqueVC animated:YES];
            
        }
            break;
            
        case 2:{
        
//            NSLog(@"222222    ---");
            SearchQuestionVC *questionVC = [[SearchQuestionVC alloc] init];
            questionVC.text = _searchBar.text;
            [self.navigationController pushViewController:questionVC animated:YES];
        }
            break;
            
        case 3:{
            
            NSLog(@"333333    ---");
            SearchExpertsVC *expertsVC = [[SearchExpertsVC alloc] init];
            expertsVC.text = _searchBar.text;
            [self.navigationController pushViewController:expertsVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

#pragma mark -- 点击进入要搜索的农作物页面
//- (void)selectedCropClassificationWithCrop:(NSString *)cropStr{
//    
//    
//}

- (NSMutableArray *)btnArr{
    
    if (_btnArr) {
        _btnArr = [NSMutableArray arrayWithCapacity:4];
    }
    return _btnArr;
    
    
}

#pragma mark   -   创建四个按钮
- (void)createFourButton{
    
    NSArray *array = [NSArray arrayWithObjects:@"商品",@"技术",@"问题",@"专家", nil];
    CGFloat space = 15*DISTANCE_WIDTH;
    CGFloat btnWidth = (K_WIDTH - 8*space)/4;
    CGFloat btnHeight = 30*DISTANCE_HEIGHT;
    for ( int i = 0 ; i < 4; i ++ ) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        button.frame = CGRectMake(space + (btnWidth + 2*space)*i, 64 + 40*DISTANCE_HEIGHT, btnWidth, btnHeight);
        
        [button setTitle:array[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button setBackgroundColor:[UIColor whiteColor]];
        
        [button setBackgroundColor:BG_COLOR];
        
        [button.layer setBorderWidth:0.5*DISTANCE_HEIGHT];
        
        button.layer.cornerRadius = btnHeight/2;
        
        button.clipsToBounds = YES;
        
        [self.btnArr addObject:button];
        
        [button.layer setMasksToBounds:YES];
        
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){200.0/255, 200.0/255, 200.0/255, 1});
        [button.layer setBorderColor:color];
        
        if (i == 0) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
            CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){231.0/255, 86.0/255, 71.0/255, 1});
            [button.layer setBorderColor:color];
            
            _selectedBtn = button;
            _teger = 0;
        }
        
        
        
        button.tag = 10000 + i;
        
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        
        
    }
    
    
}

#pragma mark  -- 下面四个button的点击事件
- (void)buttonClick:(UIButton *)sender{

    if (_selectedBtn) {
//        _selectedBtn.backgroundColor = [UIColor whiteColor];
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){200.0/255, 200.0/255, 200.0/255, 1});
        [_selectedBtn.layer setBorderColor:color];
        [_selectedBtn setBackgroundColor:BG_COLOR];
        [_selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    
    _selectedBtn = sender;
//    _selectedBtn.backgroundColor = [UIColor redColor];
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){231.0/255, 86.0/255, 71.0/255, 1});
    [_selectedBtn.layer setBorderColor:color];
    
    [_selectedBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [_selectedBtn setBackgroundColor:[UIColor redColor]];

    _teger = sender.tag - 10000;
    
    
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
