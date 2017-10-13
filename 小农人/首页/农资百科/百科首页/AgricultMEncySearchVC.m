//
//  AgricultMEncySearchVC.m
//  小农人
//
//  Created by tomusng on 2017/9/30.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "AgricultMEncySearchVC.h"
#import "FirstHttpRequestManager.h"
#import "LLSearchView.pch"

#import "AllCateItemCell.h"
#import "FertilizerHeaderView.h"
#import "AllCateItemFooterView.h"

#import "BigClassModel.h"
#import "LittleClassModel.h"

#import "SeedsLCViewController.h"//搜索种子
#import "FertilizerLCViewController.h"//搜索化肥


#define KScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height


#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]


#define MENU_BTN_WIDTH [UIScreen mainScreen].bounds.size.width/6.0

#define MyDefaults [NSUserDefaults standardUserDefaults]

#define KHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYSearchhistories.plist"]

#define KColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]

#define LIGHT_TITLE_COLOR [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1]

#define BG_COLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]
#define ITEM_HEIGHT 38*DISTANCE_WIDTH

static NSString *reuseID = @"itemCell";
static NSString *sectionHeaderID = @"setionHeader";
static NSString *sectionFooterID = @"sectionFooter";

@interface AgricultMEncySearchVC ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *btnArr;

@property (nonatomic, strong) UIButton *btn;

@property (strong, nonatomic) UIView *statusBarView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *collectionArr;

@property (nonatomic, strong) UIImageView *triangleImgV;

@property (nonatomic, assign) NSInteger teger;

@property (nonatomic, assign) CGFloat triangleOriginX;

@property (nonatomic, assign) CGFloat trImgVWidth;
@property (nonatomic, assign) CGFloat trImgVHeight;
@property (nonatomic, assign) CGFloat menuHeight;

@property (nonatomic, strong) UIScrollView *bgCollScroll;


@property (nonatomic, strong) NSMutableArray *selectedArr;


@property (nonatomic, assign) CGRect statusRect;
@property (nonatomic, assign) CGRect navBarRect;
@property (nonatomic, assign) CGFloat navMaxH;




@end

@implementation AgricultMEncySearchVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_searchBar.isFirstResponder) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    [self.navigationController.navigationBar addSubview:_statusBarView];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.barTintColor = nil;
    
    [self.statusBarView removeFromSuperview];

    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    
//    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:DE_RED_Color forState:UIControlStateNormal];
//    rightBtn.frame = CGRectMake(0, 0, 50*DISTANCE_WIDTH, 30*DISTANCE_HEIGHT);
//    [rightBtn addTarget:self action:@selector(searchIntoNextPage) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.view.backgroundColor = BG_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
    _statusBarView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:_statusBarView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clearImage"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelDidClick)];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    _statusRect = [[UIApplication sharedApplication] statusBarFrame];
    _navBarRect = self.navigationController.navigationBar.frame;
    _navMaxH = _navBarRect.size.height + _statusRect.size.height;
    
    [self createMenuBtnUI];
    
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self searchIntoNextPage];
    
}



- (void)searchIntoNextPage{
    
    
    if (_teger == 1) {
        SeedsLCViewController *seedVC = [[SeedsLCViewController alloc] init];
        
        seedVC.keyWords = _searchBar.text;
        seedVC.search_cid = _teger + 1;
        
//        NSLog(@"%ld",_teger + 1);
        
        [self.navigationController pushViewController:seedVC animated:YES];
    }
    else if (_teger == 2){
        
        FertilizerLCViewController *fertilizerVC = [[FertilizerLCViewController alloc] init];
        fertilizerVC.keyWords = _searchBar.text;
        fertilizerVC.search_cid = _teger + 1;
        [self.navigationController pushViewController:fertilizerVC animated:YES];
        
    }
     
}


- (NSMutableArray *)btnArr{
    
    if (!_btnArr) {
        _btnArr = [NSMutableArray arrayWithCapacity:3];
    }
    return _btnArr;
}

- (void)createMenuBtnUI{
    
    CGFloat space = 10;
    _menuHeight = _navBarRect.size.height;
//    CGFloat btnHeight = 25*DISTANCE_HEIGHT;
    
//    [self.view addSubview:bgView];
    
    UIScrollView *menuScroll = [[UIScrollView alloc] init];
    menuScroll.frame = CGRectMake(-20*DISTANCE_WIDTH, 0, 3*MENU_BTN_WIDTH, _menuHeight);
    menuScroll.contentSize = CGSizeMake(3*MENU_BTN_WIDTH, 4*space);
//    [bgView addSubview:menuScroll];
    
//    menuScroll.backgroundColor = [UIColor orangeColor];
    
    NSArray *nameArr = [NSArray arrayWithObjects:@"农药",@"种子",@"肥料", nil];
   
    for (int i = 0; i < 3; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        btn.frame = CGRectMake(MENU_BTN_WIDTH * i, 0.5*space, MENU_BTN_WIDTH, 2.5*space);
        [btn setTitle:nameArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.tag = 1000 + i;
        [self.btnArr addObject:btn];
        [menuScroll addSubview:btn];
        
        [btn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    UIImageView *triangleImgV = [[UIImageView alloc] init];
    UIImage *trImg = [UIImage imageNamed:@"sell_good_triangle"];
    triangleImgV.image = trImg;
    _trImgVWidth = 1.5*space;
    _trImgVHeight = trImg.size.height*_trImgVWidth/trImg.size.width;
    _triangleImgV = triangleImgV;
    triangleImgV.frame = CGRectMake((MENU_BTN_WIDTH - _trImgVWidth)/2, _menuHeight - _trImgVHeight, _trImgVWidth, _trImgVHeight);
//    triangleImgV.backgroundColor = [UIColor blackColor];
   
    _triangleOriginX = (MENU_BTN_WIDTH - _trImgVWidth)/2;
   
    [menuScroll addSubview:triangleImgV];
    
    [menuScroll bringSubviewToFront:triangleImgV];
    
    self.navigationItem.titleView = menuScroll;
    
    [self createSearchBarUI];
    
    
}
#pragma mark  ---   menubtn的点击事件
- (void)menuBtnClick:(UIButton *)sender{
    
    NSInteger index = sender.tag - 1000;
    
    NSLog(@"%ld",index);
    
//    NSLog(@"dfdfdfdfjsdlfjslfkjsdlfjdskfjsdfkdjs");
    [self refreshCollection:index];
    
    
    
    
    
}

#pragma mark  ---  切换表及改变button的字体颜色
- (void)refreshCollection:(NSInteger)index{
    
//    改变button的颜色
    for (int i = 0 ; i < 3; i ++) {
        
        UIButton *btn = _btnArr[i];
        
        if (i == index) {
            [btn setTitleColor:DE_RED_Color forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
//    刷新collectionview表
//    UICollectionView *collection = self.collectionArr[index];
    [_bgCollScroll setContentOffset:CGPointMake(K_WIDTH*index, 0) animated:YES];
   
    _teger = index;
    
    [self.dataArr removeAllObjects];
    self.dataArr = nil;
    
    
    
    if (index == 1) {
        return;
    }
    [self reRequestDataWithIndex:index];
    
}



- (void)createSearchBarUI{
    
    CGFloat space = 10*DISTANCE_HEIGHT;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];//WithFrame:CGRectMake(0, 0, K_WIDTH, 0)];
    _bgView = bgView;
    bgView.frame = CGRectMake(0, _navMaxH, K_WIDTH, 3*space);
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(space/2, 0, K_WIDTH - space, 3*space)];
    searchBar.placeholder = @"有效成分、作物、病虫害";
    
    searchBar.backgroundImage = [UIImage imageNamed:@"clearImage"];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    _searchBar = searchBar;
    UIView *searchTextField = searchTextField = [searchBar valueForKey:@"_searchField"];
    searchTextField.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:237/255.0 alpha:1];
    [searchBar setImage:[UIImage imageNamed:@"commen_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
//    [searchField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont boldSystemFontOfSize:16*DISTANCE_WIDTH] forKeyPath:@"_placeholderLabel.font"];
    
    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
//    修改标题和标题颜色
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [bgView addSubview:searchBar];
    self.searchBar = searchBar;
    [self.searchBar becomeFirstResponder];
//    self.navigationItem.titleView = titleView;
  
    [self.view addSubview:bgView];

    
    
    
    [self createCollectionUI];
}


- (void)cancelDidClick
{
//    [self.searchBar resignFirstResponder];
//    [self.navigationController popViewControllerAnimated:YES];
}

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


- (NSMutableArray *)collectionArr{
    
    if (!_collectionArr) {
        _collectionArr = [NSMutableArray array];
    }
    return _collectionArr;
    
}

- (void)createCollectionUI{
    
    UIScrollView *bgCollScroll = [[UIScrollView alloc] init];
    bgCollScroll.frame = CGRectMake(0, CGRectGetMaxY(_bgView.frame), K_WIDTH, K_HETGHT - CGRectGetMaxY(_bgView.frame));
    [self.view addSubview:bgCollScroll];
    bgCollScroll.contentSize = CGSizeMake(K_WIDTH * 3, 0);
    
    bgCollScroll.pagingEnabled = YES;
    bgCollScroll.delegate = self;
    _bgCollScroll = bgCollScroll;
    for (int i = 0 ; i < 3; i ++) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(K_WIDTH / 3.0, ITEM_HEIGHT);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.headerReferenceSize = CGSizeMake(K_WIDTH, 45*DISTANCE_HEIGHT);
        layout.footerReferenceSize = CGSizeMake(K_WIDTH, 0*DISTANCE_HEIGHT);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(K_WIDTH*i, 0, K_WIDTH, CGRectGetWidth(bgCollScroll.frame)) collectionViewLayout:layout];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        [self.view addSubview:collectionView];
        collectionView.backgroundColor = [UIColor whiteColor];
        
        if (i == 0) {
            _collectionView = collectionView;
        }
        
        [collectionView registerClass:[AllCateItemCell class] forCellWithReuseIdentifier:reuseID];
        
        [collectionView registerClass:[FertilizerHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID];
       
        [collectionView registerClass:[AllCateItemFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sectionFooterID];

        [self.collectionArr addObject:collectionView];
       
        [bgCollScroll addSubview:collectionView];
        
    }
    [self refreshCollection:0];

}


#pragma mark   ---   <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
//    NSLog(@"************   %ld",self.dataArr.count);
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
//    BigClassModel *bigM = self.dataArr[section];
    
    return self.dataArr.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AllCateItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    BigClassModel *bigM = self.dataArr[indexPath.row];
    
//    LittleClassModel *litM = bigM.child[indexPath.row];
    cell.titleLab.textColor = LIGHT_TITLE_COLOR;
    if (bigM.selected == YES) {
        
        NSLog(@"选中");
       cell.titleLab.textColor = DE_RED_Color;
    }
    NSLog(@"全部");
    cell.title = bigM.cat_name;
    
    return cell;
    
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        FertilizerHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionHeaderID forIndexPath:indexPath];
        
        if (headerView == nil) {
            headerView = [[FertilizerHeaderView alloc] init];
        }
        headerView.backgroundColor = [UIColor whiteColor];
        
//        BigClassModel *bigM = self.dataArr[indexPath.section];
        
        headerView.title = @"热门搜索";
        
        return headerView;
        
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        AllCateItemFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionFooterID forIndexPath:indexPath];
        
        if (footerView == nil) {
            footerView = [[AllCateItemFooterView alloc] init];
        }
        
        footerView.backgroundColor = [UIColor clearColor];
        return footerView;
    }
    
    return nil;
    
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSMutableArray *)selectedArr{
    
    if (!_selectedArr) {
        _selectedArr = [NSMutableArray array];
    }
    return _selectedArr;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    BigClassModel *bigM = self.dataArr[indexPath.section];
    
//    LittleClassModel *litM = bigM.child[indexPath.row];
    
    for (int i = 0 ; i < self.dataArr.count; i ++) {
        
        BigClassModel *bigM = self.dataArr[i];
        bigM.selected = NO;
        if (i == indexPath.row) {
            bigM.selected = YES;
            NSLog(@"点点滴滴");
        }
        
//        [_dataArr insertObject:bigM atIndex:i];
//        [_dataArr replaceObjectAtIndex:i withObject:bigM];
    }
    
     _collectionView = self.collectionArr[_teger];
    NSLog(@"选中了你：%ld",indexPath.row);
    
    [_collectionView reloadData];
    
    
    
    
    
    
  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        
    }else{
        
//        NSLog(@"scrollViewDidScroll:(UIScrollView *)scrollView");
        
        CGFloat contOffX = MENU_BTN_WIDTH*scrollView.contentOffset.x/K_WIDTH;
        _triangleImgV.frame = CGRectMake((MENU_BTN_WIDTH - _trImgVWidth)/2 + contOffX, _menuHeight - _trImgVHeight, _trImgVWidth, _trImgVHeight);

    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        
    }else{
        
        NSInteger x = scrollView.contentOffset.x / K_WIDTH;
        [self refreshCollection:x];
        
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.dataArr removeAllObjects];
}




- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (void)reRequestDataWithIndex:(NSInteger)index{
    
    _collectionView = self.collectionArr[index];
    
    NSString *str = [NSString stringWithFormat:C_HOST_API,@"/wiki/get_children_by_cid?XDEBUG_SESSION_START=11650"];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    bool bool_true = true;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(bool_true) forKey:@"need_child"];
    [dic setValue:@(index + 1) forKey:@"cid"];
    
    __weak AgricultMEncySearchVC *weakSelf = self;
    
    [FirstHttpRequestManager postChildAllSpeciesWithUrl:encode WithDic:dic WithBlock:^(NSArray * _Nullable array) {
        
        
        [weakSelf.dataArr addObjectsFromArray:array];
        
        [weakSelf.collectionView reloadData];
        
        
        
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
