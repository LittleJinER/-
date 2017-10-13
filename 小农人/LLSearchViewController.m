//
//  LLSearchViewController.m
//  LLSearchView
//
//  Created by 王龙龙 on 2017/7/25.
//  Copyright © 2017年 王龙龙. All rights reserved.
//

#import "LLSearchViewController.h"

//#import "Q_AppointedCropViewControllerViewController.h"
//#import "LLSearchResultViewController.h"
//#import "LLSearchSuggestionVC.h"
#import "LLSearchView.h"
#import "SearchCropViewController.h"

#define KScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

#define MyDefaults [NSUserDefaults standardUserDefaults]

#define KHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYSearchhistories.plist"]

#define KColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
@interface LLSearchViewController ()<UISearchBarDelegate,LLSearchViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) LLSearchView *searchView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;


@end

@implementation LLSearchViewController

- (NSMutableArray *)hotArray
{
    if (!_hotArray) {
//        self.hotArray = [NSMutableArray arrayWithObjects:@"悦诗风吟", @"洗面奶", @"兰芝", @"面膜", @"篮球鞋", @"阿迪达斯", @"耐克", @"运动鞋", nil];
        
        _hotArray = [NSMutableArray arrayWithObjects:@"苹果",@"香蕉",@"菠萝",@"番茄",@"白菜",@"萝卜",@"辣椒", nil];
    }
    return _hotArray;
}

#pragma mark - 搜索历史 - 

- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
//        _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KHistorySearchPath];
        
        _historyArray = [NSMutableArray array];
        [_historyArray addObjectsFromArray:[MyDefaults objectForKey:@"cropsArr"]];
//        if (!_historyArray) {
//            self.historyArray = [NSMutableArray array];
//        }
    }
    return _historyArray;
}


- (LLSearchView *)searchView
{
    if (!_searchView) {
        
        
        
        
        
        _searchView = [[LLSearchView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64) hotArray:self.hotArray historyArray:self.historyArray];
//        __weak LLSearchViewController *weakSelf = self;
//        _searchView.tapAction = ^(NSString *str) {
//            [weakSelf pushToSearchResultWithSearchStr:str];
//        };
        _searchView.delegate = self;
    }
    return _searchView;
}


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
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    
    [self setBarButtonItem];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    NSArray *array = [NSArray arrayWithObjects:@"大豆",@"西瓜", nil];
    [MyDefaults setObject:array forKey:@"cropsArr"];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchView];
}


- (void)setBarButtonItem
{
    [self.navigationItem setHidesBackButton:YES];
    // 创建搜索框
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(5, 7, self.view.frame.size.width-50, 30)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleView.frame) - 15, 30)];
    searchBar.placeholder = @"搜索内容";
    searchBar.backgroundImage = [UIImage imageNamed:@"clearImage"];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    UIView *searchTextField = searchTextField = [searchBar valueForKey:@"_searchField"];
    searchTextField.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:237/255.0 alpha:1];
    [searchBar setImage:[UIImage imageNamed:@"sort_magnifier"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
    //修改标题和标题颜色
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
    [self.searchBar becomeFirstResponder];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"leftReturn"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelDidClick)];
}


//- (void)presentVCFirstBackClick:(UIButton *)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}


/** 点击取消 */
- (void)cancelDidClick
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}



//- (void)setHistoryArrWithStr:(NSString *)str
//{
//    for (int i = 0; i < _historyArray.count; i++) {
//        if ([_historyArray[i] isEqualToString:str]) {
//            [_historyArray removeObjectAtIndex:i];
//            break;
//        }
//    }
//    [_historyArray insertObject:str atIndex:0];
//    [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
//}


#pragma mark - UISearchBarDelegate -


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

#pragma mark -- 点击进入要搜索的农作物页面
- (void)selectedCropClassificationWithCrop:(NSString *)cropStr{
    
    SearchCropViewController *searchCropVC = [[SearchCropViewController alloc] init];
    searchCropVC.cropName = cropStr;
    [self.navigationController pushViewController:searchCropVC animated:YES];
    
    
}





- (void)didReceiveMemoryWarning
{
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
