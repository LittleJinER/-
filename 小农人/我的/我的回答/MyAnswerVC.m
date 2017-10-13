//
//  MyAnswerVC.m
//  小农人
//
//  Created by tomusng on 2017/9/15.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "MyAnswerVC.h"
#import "MineHttpRequestManager.h"


#define ViewWidth [[UIScreen mainScreen] bounds].size.width
#define ViewHeight [[UIScreen mainScreen] bounds].size.height - 64 - MENU_HEIGHT - LINE_HEIGHT

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]
#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]

#define LINE_HEIGHT 0.5*DISTANCE_WIDTH

#define MENU_BUTTON_WIDTH  100*DISTANCE_WIDTH
#define MENU_HEIGHT 44*DISTANCE_WIDTH

@interface MyAnswerVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollBgView;

@property (nonatomic, strong) NSMutableArray *nameArray;

@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong) NSMutableArray *tableArray;

@property (nonatomic, strong) UIView *deLineV;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) NSMutableArray *questionArr;
@property (nonatomic, strong) NSMutableArray *commentsArr;



@end

@implementation MyAnswerVC


- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"学技术";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:@"home_navigation_back_btn"];
    leftBtn.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [leftBtn setImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.nameArray = [NSMutableArray arrayWithObjects:@"我的问题",@"我的回答", nil];
    [self createMenuView];
    [self createScrollTable];
    
    [self getQuestionDatas];
    
//    [self getCommentsDatas];
    
}

- (void)leftBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

- (NSMutableArray *)questionArr{
    
    if (_questionArr) {
        _questionArr = [NSMutableArray array];
    }
    return _questionArr;
    
}


- (void)getQuestionDatas{
    
    NSString *str = @"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=User&act=posteds&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e";
//    NSString *urlStr = @"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=User&act=user_following&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e";
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [MineHttpRequestManager MyQuestionInfoWithUrl:encode WithBlock:^(NSArray *array) {
        
    }];
    
    
}














- (NSMutableArray *)commentsArr{
    
    if (_commentsArr) {
        _commentsArr = [NSMutableArray array];
    }
    return _commentsArr;
    
}


- (void)getCommentsDatas{
    
    NSString *str = @"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=User&act=commenteds&oauth_token=af566a6210fd8465518f01016a17a69f&oauth_token_secret=9e4eb830ad6fecb691de7beda2bcfcef";
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [MineHttpRequestManager MyCommentsInfoWithUrl:encode WithBlock:^(NSArray *array) {
        
    }];
    
    
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
