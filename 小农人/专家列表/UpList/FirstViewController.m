//
//  FirstViewController.m
//  segmentAndListDemo
//
//  Created by zwm on 15/5/26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "FirstViewController.h"
#import "WMTabControl.h"
#import "WMDropDownView.h"
#import "Q_AHttpRequestManager.h"
#import "SABookModel.h"
#import "MJExtension.h"
#import "SABookModelTBCell.h"
#import "ExpertCategoryModel.h"
#import "ExpertDetailsViewController.h"
#import "TBRefresh.h"
#import "MakeData.h"
#import "LLSearchView.pch"



#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define disten   [UIScreen mainScreen].bounds.size.height/667.0

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *_one;
    NSMutableArray *_two;
    NSMutableArray *_three;
    NSArray *_total;
    NSMutableArray *_totalIndex;

    NSInteger _segIndex;
}
//@property (weak, nonatomic) IBOutlet WMTabControl *tabControl;

@property (nonatomic,strong) WMTabControl *tabControl;

@property (nonatomic,strong) NSMutableArray *  dataArr;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *categoryArr;

@end

@implementation FirstViewController



- (void)viewWillDisappear:(BOOL)animated{
    
//    self.navigationController.navigationBar.backgroundColor = [];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = nil;
//    self.tabControl = nil;
//    [self.tabControl removeFromSuperview];
//    _tabControl = nil;
     self.navigationController.navigationBar.barTintColor = nil;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];

    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabControl.frame = CGRectMake(0, 64, WIDTH, 40);
//    CGFloat height = self.tabControl.frame.size.height;
    [self.view addSubview:_tabControl];
//    NSLog(@"111111111   %f",height);
    
//     __weak typeof(self) weakSelf = self;
//    if (_one.count > 0) {
////        _tabControl;
////        [self.view addSubview:_tabControl];
//    }
    
   self.tabBarController.tabBar.hidden = YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 1.设置数据和初始索引
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    self.navigationItem.leftBarButtonItems = @[negativeSpacer];
    
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _tabControl = [[WMTabControl alloc]init];
    _tabControl.backgroundColor = [UIColor whiteColor];
    _tabControl.frame = CGRectMake(0, 64, WIDTH, 40);
    [self.view addSubview:_tabControl];

    
    [self createTableView];
    
    [self createSearchBar];
    
    [self getExpertCategoryData];
    
    [self getExpertListData];
    
}


- (NSMutableArray *)one{
    
    if (!_one) {
        _one = [NSMutableArray array];
    }
    return _one;
    
}


#pragma mark - 获取专家类别信息
- (void)getExpertCategoryData{
    
    CGFloat height = _tabControl.frame.size.height;
    NSLog(@"222222222%f",height);
//    _one = [NSMutableArray array];
//    _one = [NSMutableArray arrayWithObjects:@"全部", @"金", @"木", @"水", @"火", nil];
    _two = [NSMutableArray arrayWithObjects:@"区域", @"东", @"南", @"西", @"北", nil];
 
    _categoryArr = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    
    NSString *str = [NSString stringWithFormat:TOM_HOST,@"api",@"Weiba",@"get_all_user_cate",oauth_token,oauth_token_secret];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
//    NSString *urlStr = @"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=get_all_user_cate&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e";
    
    [Q_AHttpRequestManager getExpertCategoryInfoWithUrl:encode WithBlock:^(NSArray * _Nullable array) {
        
        [_categoryArr addObjectsFromArray:array];
       
        
//        [MakeData makeData:^(NSArray *array) {
        
        [weakSelf.one addObject:@"专家类型"];
       
        for (ExpertCategoryModel *obj  in _categoryArr) {
            [_one addObject:obj.title];
      
        }

        _total = @[_one, _two];
        _totalIndex = [NSMutableArray arrayWithObjects:@0, @0, nil];
        
        [_tabControl setItemsWithTitleArray:@[_one[0], _two[0]]
                                      selectedBlock:^(NSInteger index) {
                                          [weakSelf openList:index];
                                      }
         ];
    
//        }];
        
        
        
        
    }];
        
    
}


- (void)getExpertListData{
    CGFloat height = _tabControl.frame.size.height;
    NSLog(@"3333333333333%f",height);
    _dataArr = [NSMutableArray array];
    
    
    NSString *str = [NSString stringWithFormat:TOM_HOST,@"api",@"Weiba",@"get_all_user",oauth_token,oauth_token_secret];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
//    NSString *urlStr = @"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=get_all_user&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e";
    [Q_AHttpRequestManager getExpertListInfoWithUrl:encode WithBlock:^(NSArray * _Nullable array) {
        
        if (array.count == 0) {
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"数据中断，请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismiss:) withObject:alert afterDelay:1.0];
            
            
            
        }else{
            
            [_dataArr addObjectsFromArray:array];
            [_tableView reloadData];
            
        }
        
        
       
        
    }];
    
    
}

- (void)dismiss:(UIAlertView *)alert{
    //    [alert dismissViewControllerAnimated:YES completion:nil];
    [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
}



- (void)createSearchBar{
    
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(5, 7, self.view.frame.size.width-125, 30)];
    
//    titleView.backgroundColor = [UIColor whiteColor];
    
    //设置圆角效果
    titleView.layer.cornerRadius = 15.0;
    titleView.layer.masksToBounds = YES;
    
    
//    titleView.backgroundColor = [UIColor whiteColor];
    
    UIImage *searchImage = [UIImage imageNamed:@"sort_magnifier"];
    CGFloat imaHeight = searchImage.size.height;
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (30 - imaHeight)/2.0, searchImage.size.width, searchImage.size.height)];
    searchImageView.image = searchImage;
    searchImageView.contentMode = UIViewContentModeCenter;
    [titleView addSubview:searchImageView];
    
    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchImageView.frame) + 10, 0, CGRectGetWidth(titleView.frame) - 10, CGRectGetHeight(titleView.frame))];
//    _textField = [[FaTextField alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.bgView.frame) - 10, CGRectGetHeight(_bgView.frame))];
    textField.font = [UIFont systemFontOfSize:13];
    textField.textColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1];
    //清除按钮
    textField.clearButtonMode =UITextFieldViewModeWhileEditing;
    
    textField.delegate = self;
    //键盘属性
    //    _textField.returnKeyType = UIReturnKeySearch;
    
    //为textField设置属性占位符
    //    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索问题" attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
    textField.placeholder = @"搜索";
    textField.textColor = [UIColor blackColor];
    textField.textAlignment = NSTextAlignmentLeft;
    
    [titleView addSubview:textField];
    
    
    
    titleView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_btn_message_nm"] style:UIBarButtonItemStylePlain target:self action:@selector(newsClick:)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1];
    
}

- (void)newsClick:(UIBarButtonItem *)sender{
    
    NSLog(@"进入消息页面");
    
    
}


- (void)openList:(NSInteger)column
{
    // 3.下拉菜单的处理
    WMDropDownView *listView = (WMDropDownView *)[self.view viewWithTag:9898];
    
    if (!listView) {
        // 3.1 显示下拉菜单
        _segIndex = column;
        
        NSArray *lists = (NSArray *)_total[column];

        CGFloat y = CGRectGetMaxY(_tabControl.frame);
        CGRect rect = CGRectMake(0, y, CGRectGetWidth(_tabControl.frame), CGRectGetHeight(self.view.frame) - y - 49);

        __weak typeof(self) weakSelf = self;
        WMDropDownView *listView =
            [[WMDropDownView alloc] initWithFrame:rect
                                           titles:lists
                                     defaultIndex:[_totalIndex[column] integerValue]
                                    selectedBlock:^(id title, NSInteger index) {
                                         NSLog(@"%@ -----+++++++++--- %ld",title,(long)index);
            [weakSelf changeIndex:index withColumn:column];
        }];
        listView.tag = 9898;
        [self.view addSubview:listView];
        [listView showView];
    } else if (_segIndex != column) {
        // 3.2 已存在下拉菜单，切换展示内容
        _segIndex = column;
        NSArray *lists = (NSArray *)_total[column];
        __weak typeof(self) weakSelf = self;
        [listView changeWithTitles:lists
                      defaultIndex:[_totalIndex[column] integerValue]
                     selectedBlock:^(id title, NSInteger index) {
                         NSLog(@"%@ -------- %ld",title,(long)index);
            [weakSelf changeIndex:index withColumn:column];
        }];
    } else {
        // 3.3 隐藏下拉菜单
        [listView hideView];
    }
}

- (void)changeIndex:(NSInteger)index withColumn:(NSInteger)column
{
    // 4. 用户点击了下拉菜单
    if (index == -1) {
        // 4.1 恢复分段条状态
        [self.tabControl selectIndex:-1];
        return;
    }
    // 4.2 改变对应的记录索引
    [_totalIndex replaceObjectAtIndex:column withObject:[NSNumber numberWithInteger:index]];

//    NSLog(@"   ****   %ld *****  %ld",(long)column,(long)index);
    // 4.3 改变分段条的对应项标题，如果不想改变则不执行这条
    [_tabControl setTitle:_total[column][index] withIndex:column];

//    NSLog(@"*****    %@   *******",_total[column][index]);
    
    // 4.4 按选择改变内容排序
    [self changeOrder];
    
    
    NSString *urlStr;
    
//   if (column != -1) {
    
        _dataArr = nil;
        _dataArr = [NSMutableArray array];
        if (column == 0) {
            urlStr = @"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=get_all_user&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e";
        }else{
            urlStr = [NSString stringWithFormat:@"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=get_all_user&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&id=%ld",(long)column];
        }
        
        [Q_AHttpRequestManager getExpertListInfoWithUrl:urlStr WithBlock:^(NSArray * _Nullable array) {
            
            [_dataArr addObjectsFromArray:array];
            [_tableView reloadData];
            
        }];
        
//    }
    
    
}

- (void)changeOrder
{
}



- (void)createTableView{
    
    CGFloat tabHeight = CGRectGetMaxY(_tabControl.frame);
    NSLog(@"table的初始高度  %f",tabHeight);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  40, WIDTH, HEIGHT - tabHeight) style:UITableViewStylePlain];
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  104, WIDTH, HEIGHT - 104) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[SABookModelTBCell class] forCellReuseIdentifier:@"bookCell"];
   
    [self.view addSubview:_tableView];
    
    
    

    __weak FirstViewController *weakself = self;
    [_tableView addRefreshHeaderWithBlock:^{
        [weakself LoadUpdateDatas];
    }];
    
    [_tableView addRefreshFootWithBlock:^{
        [weakself LoadMoreDatas];
    }];
    
    
    
}



#pragma mark-加载数据    刷新方法

-(void)LoadUpdateDatas
{
    
    //
    
    // 模拟延时设置
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView.header endHeadRefresh];
        
    });
    
    
    
}

-(void)LoadMoreDatas
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView.footer NoMoreData];
        [self.tableView.footer ResetNomoreData];
    });
    
}





#pragma mark - 数据源方法

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    NSLog(@"ffff     %ld",self.dataArr.count);
    return self.dataArr.count;
}


- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * kCellID = @"bookCell";
    
    SABookModelTBCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
//    if (!cell) {
//        cell = [[SABookModelTBCell alloc] initWithStyle:UITableViewCellFocusStyleCustom reuseIdentifier:kCellID];
//    }
    
    cell.bookModel = self.dataArr[indexPath.row];
    
    cell.questionBtn.tag = indexPath.row + 10000;
    
    [cell.questionBtn addTarget:self action:@selector(questionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}


- (void)questionClick:(UIButton *)sender{
    
    NSLog(@"%ld",sender.tag);
    
}

#pragma mark - uitableview  -  delegate方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SABookModel *model = self.dataArr[indexPath.row];
    ExpertDetailsViewController *expertDVC = [[ExpertDetailsViewController alloc] init];
    expertDVC.model = model;
    [self.navigationController pushViewController:expertDVC animated:YES];
    
}



#pragma mark - 懒加载
//- (NSMutableArray *)dataArr{
//    if (!_dataArr) {
//        
//        _dataArr = [SABookModel mj_objectArrayWithFilename:@"books.plist"];
//        
//    }
//    return _dataArr;
//}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"ddddddddd");
    
    
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    // 2.下拉菜单的转屏适配，如不转屏则不用这部分
//    WMDropDownView *listView = (WMDropDownView *)[self.view viewWithTag:9898];
//    if (listView) {
//        CGFloat y = CGRectGetMaxY(_tabControl.frame);
//        listView.frame = CGRectMake(0, y, CGRectGetWidth(_tabControl.frame), CGRectGetHeight(self.view.frame) - y - 49);
//        NSLog(@"%f",listView.frame.size.height);
//
//    }
//
//}







@end
