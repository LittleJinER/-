//
//  MyConcernVC.m
//  小农人
//
//  Created by tomusng on 2017/9/15.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "MyConcernVC.h"
#import "MineHttpRequestManager.h"
#import "SABookModel.h"
#import "ConcernTVCell.h"
#import "TBRefresh.h"//刷新控件
#import "ExpertDetailsViewController.h"

#define ViewWidth [[UIScreen mainScreen] bounds].size.width
#define ViewHeight [[UIScreen mainScreen] bounds].size.height - 64 - MENU_HEIGHT - LINE_HEIGHT

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]
#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]

#define LINE_HEIGHT 0.5*DISTANCE_WIDTH

#define MENU_BUTTON_WIDTH  60*DISTANCE_WIDTH
#define MENU_HEIGHT 44*DISTANCE_WIDTH



@interface MyConcernVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UITableView *tableView;



@end

@implementation MyConcernVC

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的关注";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:@"home_navigation_back_btn"];
    leftBtn.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [leftBtn setImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self setTableViewUI];
    
    [self getMyConcernData];
    
    
    
}

- (void)leftBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTableViewUI{
    
    UITableView *tableView = [[UITableView alloc] init];
    
//    tableView.frame = CGRectMake(0, 64, K_WIDTH, K_HETGHT - 64);
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    _tableView = tableView;
    
//    tableView.backgroundColor = [UIColor greenColor];
    [tableView registerClass:[ConcernTVCell class] forCellReuseIdentifier:@"cellID"];
    
    
    __weak MyConcernVC *weakself = self;
    
    [tableView addRefreshHeaderWithBlock:^{
        
        [weakself LoadUpdateDatas];
        
    }];
    
    [tableView addRefreshFootWithBlock:^{
        
        [weakself LoadMoreDatas];
    }];

    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 100*DISTANCE_HEIGHT;
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ConcernTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[ConcernTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    SABookModel *bookModel = self.dataArr[indexPath.row];

    cell.bookModel = bookModel;
    cell.questionBtn.tag = indexPath.row + 10000;
    
    [cell.questionBtn addTarget:self action:@selector(questionClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
    
    
    
}

#pragma mark - uitableview  -  delegate方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SABookModel *model = self.dataArr[indexPath.row];
    ExpertDetailsViewController *expertDVC = [[ExpertDetailsViewController alloc] init];
    expertDVC.model = model;
    [self.navigationController pushViewController:expertDVC animated:YES];
    
}


- (void)questionClick:(UIButton *)button{
    
    
    
    
    
}





- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
    
}

- (void)getMyConcernData{
    
    __weak __typeof(self) weakSelf = self;
    
    NSString *str = @"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=User&act=user_following&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e";
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [MineHttpRequestManager myFavoriteListConcernWithUrl:encode WithBlock:^(NSArray *array) {
        
        [weakSelf.dataArr addObjectsFromArray:array];
        
        _tableView.frame = CGRectMake(0, 64, K_WIDTH, 100*DISTANCE_HEIGHT * _dataArr.count + 90*DISTANCE_HEIGHT);
        
        [weakSelf.tableView reloadData];
        
        
    }];
    
}


#pragma mark-加载数据

-(void)LoadUpdateDatas
{
    
    //       [self.tableView.footer ResetNomoreData];
    
    // 模拟延时设置
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView.header endHeadRefresh];
        //        NSLog(@"dddddffff");
        
    });
    
    
    
}

-(void)LoadMoreDatas
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView.footer NoMoreData];
        [self.tableView.footer ResetNomoreData];
        //        NSLog(@"fdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfd3333333333");
    });
    
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
