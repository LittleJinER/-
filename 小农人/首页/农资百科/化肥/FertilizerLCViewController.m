//
//  FertilizerLCViewController.m
//  小农人
//
//  Created by tomusng on 2017/9/29.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "FertilizerLCViewController.h"
#import "FirstHttpRequestManager.h"
#import "LLSearchView.pch"
#import "SearchBarView.h"
#import "FertilizerLClassCell.h"
#import "LittleClassModel.h"
#import "MiniClassModel.h"
#import "BaiKeMiniClassVC.h"
#import "FertilizerDetailViewController.h"

#define ViewWidth [[UIScreen mainScreen] bounds].size.width
#define ViewHeight [[UIScreen mainScreen] bounds].size.height - 64 - MENU_HEIGHT - LINE_HEIGHT

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0
#define CUSTOM_COLOR(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]

@interface FertilizerLCViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSMutableArray *miniArr;

@property (nonatomic, strong) UITableView *table;

@end

@implementation FertilizerLCViewController

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = self.titleName;
    self.view.backgroundColor = CUSTOM_COLOR(248, 248, 248);
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:@"home_navigation_back_btn"];
    leftBtn.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [leftBtn setImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    SearchBarView *searchBV = [[SearchBarView alloc] initWithFrame:CGRectMake(10*DISTANCE_WIDTH, 64+10*DISTANCE_HEIGHT, K_WIDTH - 20*DISTANCE_WIDTH, 30*DISTANCE_HEIGHT)];
    searchBV.bgView.backgroundColor = [UIColor whiteColor];
    searchBV.textField.frame = CGRectMake(60*DISTANCE_WIDTH, 0, 195*DISTANCE_WIDTH, 30*DISTANCE_HEIGHT);
    searchBV.textField.placeholder = @"有效成分、作物、病害";
    [self.view addSubview:searchBV];

    
    
    
    if (self.search_cid == 3) {
        [self getSearchData];
    }else{
        [self getEveryData];
    }
}

- (void)createTableUI{
    
    UITableView *table = [[UITableView alloc] init];
    table.frame = CGRectMake(0, 64+ 50*DISTANCE_HEIGHT, K_WIDTH, K_HETGHT - (64+ 50*DISTANCE_HEIGHT));
    table.backgroundColor = [UIColor whiteColor];
    table.delegate = self;
    table.dataSource = self;
    [table registerClass:[FertilizerLClassCell class] forCellReuseIdentifier:@"cellID"];
    _table = table;
    [self.view addSubview:table];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    
    
    if (self.search_cid == 3) {
        
        return self.miniArr.count;
        
    }else{
        
        LittleClassModel *litM = self.miniArr[2];
        return litM.child.count;
        
    }
    
    

//    LittleClassModel *litmM = self.miniArr[2];
//    NSLog(@"litmM.child.count:       %ld",litmM.child.count);
//    return litmM.child.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FertilizerLClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell) {
       
        cell = [[FertilizerLClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
//    LittleClassModel *litmM = self.miniArr[2];
//    
//    MiniClassModel *model = litmM.child[indexPath.row];
    
    MiniClassModel *miniModel;
    
    if (self.search_cid == 3) {
        miniModel = self.miniArr[indexPath.row];
    }else{
        LittleClassModel *litM = self.miniArr[2];
        
        miniModel = litM.child[indexPath.row];
        
    }
    
    cell.title = miniModel.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
//    NSLog(@"tableviewcell 被点击了");
    
//    LittleClassModel *litmM = self.miniArr[2];
//    MiniClassModel *model = litmM.child[indexPath.row];
    
//    BaiKeMiniClassVC *miniClVC = [[BaiKeMiniClassVC alloc] init];
//    
//    miniClVC.titleName = model.title;
//    miniClVC.aid = model.article_id;
//    
//    [self.navigationController pushViewController:miniClVC animated:YES];
    
    
    MiniClassModel *miniModel;
    
    if (self.search_cid == 3) {
        miniModel = self.miniArr[indexPath.row];
    }else{
        LittleClassModel *litM = self.miniArr[2];
        
        miniModel = litM.child[indexPath.row];
        
    }
    
    
    FertilizerDetailViewController *ferDVC = [[FertilizerDetailViewController alloc] init];
    ferDVC.titleName = miniModel.title;
    ferDVC.aid = miniModel.article_id;
    ferDVC.colorID = 102;
    [self.navigationController pushViewController:ferDVC animated:YES];
    
}



- (NSMutableArray *)miniArr{
    
    if (!_miniArr) {
        _miniArr = [NSMutableArray array];
    }
    return _miniArr;
    
}

- (void)getEveryData{
    
    bool bool_true = true;
    
    
    NSString *str = [NSString stringWithFormat:C_HOST_API,@"/wiki/get_article_by_cid"];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    NSDictionary *dic = @{@"cid_list":@[@(bool_true),@(self.bigCid),@(self.litCid)]};
   
    __weak FertilizerLCViewController *weakSelf = self;
    
    [FirstHttpRequestManager postChildEverySpeciesWithUrl:encode WithDic:dic WithBlock:^(NSArray * _Nullable array) {
        
        [weakSelf.miniArr addObjectsFromArray:array];
        
        NSLog(@"weakSelf.miniArr: %@",weakSelf.miniArr);
        
        [weakSelf createTableUI];
        [weakSelf.table reloadData];
    }];
    
    
    
}


- (void)getSearchData{
    
    NSString *str = [NSString stringWithFormat:C_HOST_API,@"/wiki/get_search_result"];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //
    //    NSNumber *limit = @(20);
    //    NSNumber *offset = @(0);
    //
    NSString *cid = [NSString stringWithFormat:@"%ld",(long)self.search_cid];
    
    NSDictionary *dic = @{@"cid":cid,@"keywords":self.keyWords,@"limit":@(20),@"offset":@(0)};
    
    NSLog(@"%@",dic);
    __weak FertilizerLCViewController *weakSelf = self;
    
    
    [FirstHttpRequestManager searchPostChildEverySpeciesWithUrl:encode WithDic:dic WithBlock:^(NSArray * _Nullable array) {
        
        [weakSelf.miniArr addObjectsFromArray:array];
        
        NSLog(@"weakSelf.miniArr: %@",weakSelf.miniArr);
        
        [weakSelf createTableUI];
        [weakSelf.table reloadData];
        
    }];
    
}







- (void)leftBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
