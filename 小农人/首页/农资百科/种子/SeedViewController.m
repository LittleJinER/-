//
//  SeedViewController.m
//  小农人
//
//  Created by tomusng on 2017/9/27.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "SeedViewController.h"
#import "FirstHttpRequestManager.h"
#import "LLSearchView.pch"
#import "SearchBarView.h"
#import "BigClassModel.h"
#import "LittleClassModel.h"
#import "SeedsClassCell.h"
#import "SeedsLCViewController.h"

//#define ViewWidth [[UIScreen mainScreen] bounds].size.width
//#define ViewHeight [[UIScreen mainScreen] bounds].size.height - 64 - MENU_HEIGHT - LINE_HEIGHT

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

#define VIEW_HEIGHT  55*DISTANCE_HEIGHT
#define VIEW_WIDTH 100*DISTANCE_WIDTH



@interface SeedViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UIActivityIndicatorView *indicator;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *nameLabArr;
@property (nonatomic, strong) NSMutableArray *redLineArr;
@property (nonatomic, strong) NSMutableArray *viewArr;
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, assign) CGFloat navMaxH;

@property (nonatomic, assign) NSInteger num;

@end

@implementation SeedViewController

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
    self.title = @"种子";
    self.view.backgroundColor = BG_COLOR;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:@"home_navigation_back_btn"];
    leftBtn.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [leftBtn setImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    //    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    
    
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navBarRect = self.navigationController.navigationBar.frame;
    _navMaxH = statusRect.size.height + navBarRect.size.height;
    
    SearchBarView *searchBV = [[SearchBarView alloc] initWithFrame:CGRectMake(10*DISTANCE_WIDTH, _navMaxH+10*DISTANCE_HEIGHT, K_WIDTH - 20*DISTANCE_WIDTH, 30*DISTANCE_HEIGHT)];
    searchBV.bgView.backgroundColor = [UIColor whiteColor];
    searchBV.textField.frame = CGRectMake(60*DISTANCE_WIDTH, 0, 195*DISTANCE_WIDTH, 30*DISTANCE_HEIGHT);
    searchBV.textField.placeholder = @"有效成分、作物、病害";
    [self.view addSubview:searchBV];
    //    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10*DISTANCE_WIDTH, 64+10*DISTANCE_HEIGHT, K_WIDTH - 20*DISTANCE_WIDTH, 30*DISTANCE_HEIGHT)];
    
    NSLog(@"cid:%d",self.cid);
    
    
    //    self.nameArray = [NSMutableArray arrayWithObjects:@"杀虫剂",@"杀菌剂",@"除草剂",@"植物生长调节剂", nil];
    
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //设置显示位置
    _indicator.center = self.view.center;
    //将这个控件加到父容器中。
    [self.view addSubview:_indicator];
    
    _num = 0;
    
    [self getseedsAllSpeciesData];
    
    
//    [self createTAbleUI];
    
    
}

- (NSMutableArray *)viewArr{
    
    if (!_viewArr) {
        _viewArr = [NSMutableArray array];
    }
    return _viewArr;
}


- (NSMutableArray *)nameLabArr{
    
    if (!_nameLabArr) {
        _nameLabArr = [NSMutableArray array];
    }
    return _nameLabArr;
    
}

- (NSMutableArray *)redLineArr{
    
    if (!_redLineArr) {
        _redLineArr = [NSMutableArray array];
    }
    return _redLineArr;
    
}

#pragma mark   -- 创建view
- (void)createViewUI{
    
    CGFloat space = 10*DISTANCE_WIDTH;
    
    for (int i = 0 ; i < self.dataArr.count; i ++) {
        
//        创建背景图
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, _navMaxH + 50*DISTANCE_HEIGHT + (VIEW_HEIGHT + LINE_HEIGHT)*i, VIEW_WIDTH, VIEW_HEIGHT);
        bgView.backgroundColor = BG_COLOR;
        [self.view addSubview:bgView];
        [self.viewArr addObject:bgView];
        
//        创建label
        
        UILabel *nameLab = [[UILabel alloc] init] ;
        BigClassModel *bigM = _dataArr[i];
        nameLab.frame = CGRectMake(space/2, 0, VIEW_WIDTH - space, VIEW_HEIGHT);
        nameLab.font = [UIFont systemFontOfSize:16*DISTANCE_HEIGHT];
        nameLab.backgroundColor = [UIColor clearColor];
        nameLab.text = bigM.cat_name;
        nameLab.textAlignment = NSTextAlignmentCenter;
        [self.nameLabArr addObject:nameLab];
        [bgView addSubview:nameLab];
//        创建红线
        UIView *redView = [[UIView alloc] init];
        redView.frame = CGRectMake(0, 0, space/2, VIEW_HEIGHT);
        redView.backgroundColor = [UIColor clearColor];
        [self.redLineArr addObject:redView];
        [bgView addSubview:redView];
//        创建横线
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, _navMaxH + 50*DISTANCE_HEIGHT + VIEW_HEIGHT + (VIEW_HEIGHT + LINE_HEIGHT)*i, VIEW_WIDTH, LINE_HEIGHT);
        lineView.backgroundColor = LINEVIEW_COLOR;
        [self.view addSubview:lineView];
        
        bgView.tag = 1000 + i;
        bgView.userInteractionEnabled = YES;
        [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewClick:)]];
        
        if (i == 0) {
            
            redView.backgroundColor = DE_RED_Color;
            nameLab.textColor = DE_RED_Color;
            bgView.backgroundColor = [UIColor whiteColor];
            
        }
        
        
    }
    
}

- (void)bgViewClick:(UITapGestureRecognizer *)recognizer{
    
    NSInteger teger = recognizer.view.tag;
    
    _num = teger - 1000;
    //    UIView *bgView = recognizer.view;
    //    NSArray *array = bgView.subviews;
    
    //    UILabel *nameLab = (UILabel *)array[0];
    //    nameLab.textColor = DE_RED_Color;
    //    redV.backgroundColor = DE_RED_Color;
    
//    NSLog(@"ddddd  %ld",self.nameLabArr.count);
    
    for (int i = 0 ; i < self.dataArr.count; i ++) {
        
        UILabel *lab = self.nameLabArr[i];
        UIView *redView = self.redLineArr[i];
        UIView *bgView = self.viewArr[i];
        if (i == teger - 1000) {
            
//            NSLog(@"dddd");
            bgView.backgroundColor = [UIColor whiteColor];
            lab.textColor = DE_RED_Color;
            redView.backgroundColor = DE_RED_Color;
            
        }else{
            lab.textColor = [UIColor blackColor];
            redView.backgroundColor = [UIColor clearColor];
            bgView.backgroundColor = BG_COLOR;
        }
    }
    
    [_table reloadData];
    
}


#pragma mark   ---   创建表
- (void)createTAbleUI{
    
    UITableView *table = [[UITableView alloc] init];
    table.frame = CGRectMake(VIEW_WIDTH, _navMaxH + 50*DISTANCE_HEIGHT, K_WIDTH - VIEW_WIDTH, K_HETGHT - (64+50*DISTANCE_HEIGHT));
    table.backgroundColor = [UIColor whiteColor];
    
    table.delegate = self;
    table.dataSource = self;
    
    _table = table;
    [table registerClass:[SeedsClassCell class] forCellReuseIdentifier:@"cellID"];
    
    [self.view addSubview:table];
    
    
}

#pragma mark -    UITableViewDelegate,UITableViewDataSource    方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    BigClassModel *bigModel = self.dataArr[_num];
    
    return bigModel.child.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SeedsClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell) {
        cell = [[SeedsClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    BigClassModel *bigM = self.dataArr[_num];
    LittleClassModel *litM = bigM.child[indexPath.row];
    
    cell.litModel = litM;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return VIEW_HEIGHT + LINE_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BigClassModel *bigM = self.dataArr[indexPath.section];
    
    LittleClassModel *litM = bigM.child[indexPath.row];
    
    SeedsLCViewController *slcVC = [[SeedsLCViewController alloc] init];
    
    slcVC.titleName = litM.cat_name;
    slcVC.bigCid = bigM.cat_id;
    slcVC.litCid = litM.cat_id;
    [self.navigationController pushViewController:slcVC animated:YES];
    
}



- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
    
}



#pragma mark  -  获取详细分类
- (void)getseedsAllSpeciesData{
    
    NSString *str = [NSString stringWithFormat:C_HOST_API,@"/wiki/get_children_by_cid?XDEBUG_SESSION_START=11650"];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    bool bool_true = true;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(bool_true) forKey:@"need_child"];
    [dic setValue:@(self.cid) forKey:@"cid"];
    
    __weak SeedViewController *weakSelf = self;
    [FirstHttpRequestManager postChildAllSpeciesWithUrl:encode WithDic:dic WithBlock:^(NSArray * _Nullable array) {
        
        
        [weakSelf.dataArr addObjectsFromArray:array];
        [weakSelf createViewUI];
        [weakSelf createTAbleUI];
        
        
        
        
    }];

    
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
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
