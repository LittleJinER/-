//
//  MyOrderVC.m
//  小农人
//
//  Created by tomusng on 2017/9/15.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "MyOrderVC.h"

#define ViewWidth [[UIScreen mainScreen] bounds].size.width
#define ViewHeight [[UIScreen mainScreen] bounds].size.height - 64 - MENU_HEIGHT - LINE_HEIGHT

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]
#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]

#define LINE_HEIGHT 0.5*DISTANCE_WIDTH

#define MENU_BUTTON_WIDTH  [UIScreen mainScreen].bounds.size.width/4.0
#define MENU_HEIGHT 44*DISTANCE_WIDTH



@interface MyOrderVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollBgView;

@property (nonatomic, strong) NSMutableArray *nameArray;

@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong) NSMutableArray *tableArray;

@property (nonatomic, strong) UIView *deLineV;

@property (nonatomic, copy) NSString *text;

@end

@implementation MyOrderVC


- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:@"home_navigation_back_btn"];
    leftBtn.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [leftBtn setImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.nameArray = [NSMutableArray arrayWithObjects:@"待付款",@"待发货",@"待收货",@"全部", nil];
    
    
    
    [self createMenuView];
    [self createScrollTable];

    
}

- (NSMutableArray *)menuArray{
    
    if (!_menuArray) {
        NSInteger teger = self.nameArray.count;
        _menuArray = [NSMutableArray arrayWithCapacity:teger];
    }
    return _menuArray;
}
#pragma mark - 创建四个选择按钮 和lineView
- (void)createMenuView{
    
    UIView *menuView = [[UIView alloc] init];
    //    menuView.backgroundColor = [UIColor lightGrayColor];
    menuView.frame = CGRectMake((K_WIDTH - self.nameArray.count*MENU_BUTTON_WIDTH)/2, 64, _nameArray.count * MENU_BUTTON_WIDTH, MENU_HEIGHT);
    for (int i = 0 ; i < _nameArray.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = [UIFont systemFontOfSize:17*DISTANCE_HEIGHT];
        [btn setFrame:CGRectMake(MENU_BUTTON_WIDTH*i , 0, MENU_BUTTON_WIDTH, MENU_HEIGHT)];
        [btn setTitle:_nameArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setTitleColor:DE_RED_Color forState:UIControlStateNormal];
        }
        [self.menuArray addObject:btn];
        [menuView addSubview:btn];
    }
    
    UIView *deLineV = [[UIView alloc] init];
    deLineV.frame = CGRectMake(0, MENU_HEIGHT - 2*DISTANCE_HEIGHT, MENU_BUTTON_WIDTH, 2*DISTANCE_HEIGHT);
    deLineV.backgroundColor = DE_RED_Color;
    _deLineV = deLineV;
    [menuView addSubview:deLineV];
    
    [self.view addSubview:menuView];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, CGRectGetMaxY(menuView.frame), K_WIDTH, LINE_HEIGHT);
    lineView.backgroundColor = LINEVIEW_COLOR;
    [self.view addSubview:lineView];
    
    
    
    
}


- (void)selectBtnClick:(UIButton *)sender{
    
    
    NSLog(@"%ld",sender.tag);
    NSInteger index = sender.tag - 1000;
    //    [_scrollBgView scrollRectToVisible:CGRectMake(index*K_WIDTH, K_HETGHT - ViewHeight, K_WIDTH, ViewHeight) animated:YES];
    [_scrollBgView setContentOffset:CGPointMake(index*K_WIDTH, 0) animated:YES];
    [self refreshTableWithIndex:index];
    
    
}


- (NSMutableArray *)tableArray{
    
    if (!_tableArray) {
        NSInteger teger = self.nameArray.count;
        _tableArray = [NSMutableArray arrayWithCapacity:teger];
    }
    return _tableArray;
    
}

#pragma mark -  创建下面的table表
- (void)createScrollTable{
    
    UIScrollView *scrollBgView = [[UIScrollView alloc] init];
    scrollBgView.backgroundColor = [UIColor lightGrayColor];
    scrollBgView.frame = CGRectMake(0, 64 + MENU_HEIGHT + LINE_HEIGHT, K_WIDTH, ViewHeight);
    scrollBgView.contentSize = CGSizeMake(self.nameArray.count * K_WIDTH, 0);
    scrollBgView.delegate = self;
    _scrollBgView = scrollBgView;
    scrollBgView.pagingEnabled = YES;
    [self.view addSubview:scrollBgView];
    
    for (int i = 0 ; i < _nameArray.count; i ++) {
        UITableView *table = [[UITableView alloc]init];
        table.frame = CGRectMake(K_WIDTH*i, 0, K_WIDTH, ViewHeight);
        table.delegate = self;
        table.dataSource = self;
        [self.tableArray addObject:table];
        [scrollBgView addSubview:table];
        
    }
    [self refreshTableWithIndex:0];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 9;
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@  %ld",_text,indexPath.row];
    
    return cell;
    
    
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    CGFloat offsetX = scrollView.contentOffset.x;
    [self changeDeLineVRectWithOffsetX:offsetX];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x/K_WIDTH;
    
    [self refreshTableWithIndex:index];
    
    
}

- (void)refreshTableWithIndex:(NSInteger)index{
    
    for (int i = 0; i < _menuArray.count; i ++) {
        UIButton *btn = _menuArray[i];
        if (i == index) {
            [btn setTitleColor:DE_RED_Color forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    
    
    UITableView *table = _tableArray[index];
    
    _text = self.nameArray[index];
    
    [table reloadData];
    
    
}


- (void)changeDeLineVRectWithOffsetX:(CGFloat)offsetX{
    
    CGFloat deLineWidth = offsetX/K_WIDTH * MENU_BUTTON_WIDTH;
    _deLineV.frame = CGRectMake(deLineWidth, MENU_HEIGHT - 2*DISTANCE_HEIGHT, MENU_BUTTON_WIDTH, 2*DISTANCE_HEIGHT);
    
    
    
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
