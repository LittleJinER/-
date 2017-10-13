//
//  pesticideViewController.m
//  小农人
//
//  Created by tomusng on 2017/9/27.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "pesticideViewController.h"
#import "FirstHttpRequestManager.h"
#import "LLSearchView.pch"
#import "SearchBarView.h"
#import "AllCateItemCell.h"
#import "BigClassModel.h"
#import "LittleClassModel.h"
#import "AllCateItemHeaderView.h"
#import "AllCateItemFooterView.h"
#import "MiniClassModel.h"



#define ViewWidth [[UIScreen mainScreen] bounds].size.width
#define ViewHeight [[UIScreen mainScreen] bounds].size.height - 64 - MENU_HEIGHT - LINE_HEIGHT

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

#define MENU_BUTTON_WIDTH  [UIScreen mainScreen].bounds.size.width/4.0
#define MENU_HEIGHT 44*DISTANCE_WIDTH
#define ITEM_HEIGHT 38*DISTANCE_WIDTH


static NSString *reuseID = @"itemCell";
static NSString *sectionHeaderID = @"setionHeader";
static NSString *sectionFooterID = @"sectionFooter";

@interface pesticideViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollBgView;

//@property (nonatomic, strong) NSMutableArray *nameArray;

@property (nonatomic, strong) NSMutableArray *menuArray;

@property (nonatomic, strong) NSMutableArray *collectionArray;

@property (nonatomic, strong) UIView *deLineV;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) NSMutableArray *cacheArr;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger teger;

@property (nonatomic, strong) BigClassModel *bigM;
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *miniArray;

@property (nonatomic, strong)UIActivityIndicatorView *indicator;

@property (nonatomic, strong) NSTimer *timer;// 定时器

@end

@implementation pesticideViewController

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"农药";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = BG_COLOR;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:@"home_navigation_back_btn"];
    leftBtn.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [leftBtn setImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
//    UILabel *titleLab = [[UILabel alloc] init];
//    titleLab.frame = CGRectMake(0, 0, 50*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
//    titleLab.text = @"农药";
//    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleLab];
    
    self.navigationItem.leftBarButtonItem = leftItem;
//    self.navigationItem.leftBarButtonItem = leftItem;

    SearchBarView *searchBV = [[SearchBarView alloc] initWithFrame:CGRectMake(10*DISTANCE_WIDTH, 64+10*DISTANCE_HEIGHT, K_WIDTH - 20*DISTANCE_WIDTH, 30*DISTANCE_HEIGHT)];
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
    
    [self getPesticideAllSpeciesData];
    
   
}



- (NSMutableArray *)menuArray{
    
    if (!_menuArray) {
        NSInteger teger = self.dataArray.count;
        _menuArray = [NSMutableArray arrayWithCapacity:teger];
    }
    return _menuArray;
}




#pragma mark - 创建四个选择按钮 和lineView
- (void)createMenuView{
    
    UIView *menuView = [[UIView alloc] init];
    //    menuView.backgroundColor = [UIColor lightGrayColor];
    menuView.frame = CGRectMake((K_WIDTH - self.dataArray.count*MENU_BUTTON_WIDTH)/2, 64 + 50*DISTANCE_HEIGHT, _dataArray.count * MENU_BUTTON_WIDTH, MENU_HEIGHT);
    menuView.backgroundColor = [UIColor whiteColor];
    for (int i = 0 ; i < _dataArray.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = [UIFont systemFontOfSize:17*DISTANCE_HEIGHT];
        [btn setFrame:CGRectMake(MENU_BUTTON_WIDTH*i , 0, MENU_BUTTON_WIDTH, MENU_HEIGHT)];
        
        BigClassModel *model = _dataArray[i];
        
        [btn setTitle:model.cat_name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13*DISTANCE_HEIGHT];
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
    [self refreshCollectionWithIndex:index];
    
    
}


- (NSMutableArray *)collectionArray{
    
    if (!_collectionArray) {
        NSInteger teger = self.dataArray.count;
        _collectionArray = [NSMutableArray arrayWithCapacity:teger];
    }
    return _collectionArray;
    
}

#pragma mark -  创建下面的table表
- (void)createScrollCollection{
    
    UIScrollView *scrollBgView = [[UIScrollView alloc] init];
    scrollBgView.backgroundColor = [UIColor whiteColor];
    scrollBgView.frame = CGRectMake(0, 64 + 50*DISTANCE_HEIGHT + MENU_HEIGHT + LINE_HEIGHT, K_WIDTH, ViewHeight);
    scrollBgView.contentSize = CGSizeMake(self.dataArray.count * K_WIDTH, 0);
    scrollBgView.delegate = self;
    
    _scrollBgView = scrollBgView;
    scrollBgView.pagingEnabled = YES;
    [self.view addSubview:scrollBgView];
    
    for (int i = 0 ; i < _dataArray.count; i ++) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(K_WIDTH / 3.0, ITEM_HEIGHT);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.headerReferenceSize = CGSizeMake(K_WIDTH, 45*DISTANCE_HEIGHT);
        layout.footerReferenceSize = CGSizeMake(K_WIDTH, 0*DISTANCE_HEIGHT);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(K_WIDTH*i, 0, K_WIDTH, ViewHeight) collectionViewLayout:layout];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        collectionView.backgroundColor = [UIColor whiteColor];
        
        
        [collectionView registerClass:[AllCateItemCell class] forCellWithReuseIdentifier:reuseID];
        
        
        [collectionView registerClass:[AllCateItemHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID];
        [collectionView registerClass:[AllCateItemFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sectionFooterID];
        
        [self.collectionArray addObject:collectionView];
        
        [scrollBgView addSubview:collectionView];
        
        
        
        
        
    }
    [self refreshCollectionWithIndex:0];
    
}

#pragma mark   ---   <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    
    return self.miniArray.count;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.miniArray.count == 0) {
        return 10;
    }else{
        NSArray *litArr = [NSArray arrayWithArray:self.miniArray[0]];
        
        if (litArr.count == 2) {
            LittleClassModel *litM = litArr[2];
            return litM.child.count;
        }else
        {
            return 0;
        }
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AllCateItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    if (self.miniArray.count != 0) {
        
        NSLog(@"%ld",self.miniArray.count);
        NSArray *litArr = [NSArray arrayWithArray:self.miniArray[indexPath.section]];
            if (litArr.count == 2) {
            LittleClassModel *litM = litArr[2];
            MiniClassModel *model = litM.child[indexPath.row];
            cell.title = model.title;
            
            }
    }

    return cell;
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        AllCateItemHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionHeaderID forIndexPath:indexPath];
        
        if (headerView == nil) {
            headerView = [[AllCateItemHeaderView alloc] init];
        }
        headerView.backgroundColor = BG_COLOR;
        
        BigClassModel *bigM = self.dataArray[_teger];
        
        LittleClassModel *litModel = bigM.child[indexPath.section];
        
        headerView.title = litModel.cat_name;
        
        if (self.miniArray.count > 0) {
            
            NSArray *litArr = [NSArray arrayWithArray:self.miniArray[indexPath.section]];
            
            if (litArr.count == 2) {
                LittleClassModel *litM = litArr[2];
                headerView.title = litM.cat_name;
            }
        
        }
        
        
        
        return headerView;

    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        AllCateItemFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionFooterID forIndexPath:indexPath];
        
//        NSLog(@"   woshifooterview ******** ");
        
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了cell");
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        
    }else{
        CGFloat offsetX = scrollView.contentOffset.x;
        [self changeDeLineVRectWithOffsetX:offsetX];
        
    }
    
   
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        
    }else{
        NSInteger index = scrollView.contentOffset.x/K_WIDTH;
        
        [self refreshCollectionWithIndex:index];
        
        self.miniArray = nil;
        
        NSLog(@"self.miniArray = nil;");
        
    }
    
    
}


- (NSMutableArray *)miniArray{
    
    if (!_miniArray) {
        _miniArray = [NSMutableArray array];
    }
    return _miniArray;
}
#pragma mark   --- 刷新表
- (void)refreshCollectionWithIndex:(NSInteger)index{
    
    [_indicator startAnimating];
    
    for (int i = 0; i < _menuArray.count; i ++) {
        UIButton *btn = _menuArray[i];
        if (i == index) {
            [btn setTitleColor:DE_RED_Color forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    UICollectionView *collection = _collectionArray[index];
    self.collection = collection;
//    _teger = index;
    
    
    
//    if (!_timer) {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getEveryData) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
//    }

    BigClassModel *bigM = self.dataArray[index];
    
    self.bigM = bigM;
    
    
    
    
//    dispatch_queue_t q = dispatch_queue_create("chuanxing", DISPATCH_QUEUE_CONCURRENT);

    
//    for (int i = 0 ; i < bigM.child.count; i ++) {
//    
////        dispatch_async(q, ^{
//    
//        
////        });
//    
//        
//        
//    }
    [self getMiniDataWithI:0];
    
}

- (void)getMiniDataWithI:(int)i{
    
    
    
    if (i >= _bigM.child.count) {
        return;
    }
    LittleClassModel *litM = self.bigM.child[i];
    //            NSString *bigCid = [NSString stringWithFormat:@"%ld",(long)bigM.cat_id];
    //            NSString *litCid = [NSString stringWithFormat:@"%ld",(long)littleModel.cat_id];
    NSString *str = [NSString stringWithFormat:C_HOST_API,@"/wiki/get_article_by_cid"];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    bool bool_true = true;
    NSDictionary *dic = @{@"cid_list":@[@(bool_true),@(_bigM.cat_id),@(litM.cat_id)]};
    __weak pesticideViewController *weakSelf = self;
    
    [FirstHttpRequestManager postChildEverySpeciesWithUrl:encode WithDic:dic WithBlock:^(NSArray * _Nullable array) {
        
        //                NSArray *litArray = [NSArray arrayWithArray:array];
        
        //                [weakSelf.miniArray addObjectsFromArray:array];
        [weakSelf.miniArray insertObject:array atIndex:i];
        
//        int a = i;
//        a++;
//        NSLog(@"ddddddddddd");
//        [weakSelf getMiniDataWithI:a];
//        
        
//        if (weakSelf.miniArray.count == _bigM.child.count) {
            //
            //                        dispatch_async(q, ^{
            //
            [_collection reloadData];
            //
            NSLog(@"collection reloadData");
            //
            //                            [_indicator stopAnimating];
            //                        });
//        }
    }];

    
    
}





- (void)getEveryData{
    
    static int i = 0;
    
     BigClassModel *bigM = self.dataArray[_teger];
    _collectionView = self.collectionArray[_teger];
    
    NSLog(@"dfdfdfdfdf  定时器");
    
    LittleClassModel *littleModel = bigM.child[i];
    NSString *bigCid = [NSString stringWithFormat:@"%ld",(long)bigM.cat_id];
    NSString *litCid = [NSString stringWithFormat:@"%ld",(long)littleModel.cat_id];
    NSString *str = [NSString stringWithFormat:C_HOST_API,@"/wiki/get_article_by_cid"];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    bool bool_true = true;
    
    NSDictionary *dic = @{@"cid_list":@[@(bool_true),bigCid,litCid]};
    __weak pesticideViewController *weakSelf = self;
    
    
    
    [FirstHttpRequestManager postChildEverySpeciesWithUrl:encode WithDic:dic WithBlock:^(NSArray * _Nullable array) {
        
//        NSArray *litArray = [NSArray arrayWithArray:array];
        
//        [weakSelf.miniArray addObject:array];
        
        [weakSelf.miniArray insertObject:array atIndex:i];
        
        NSLog(@" ************ %d",i);
        
        if (weakSelf.miniArray.count == bigM.child.count) {
            
            //                        dispatch_async(q, ^{
            
            [_collectionView reloadData];
            
            NSLog(@"collection reloadData");
            
            [_indicator stopAnimating];
            //                        });
        }
    }];
    
    i ++;
    
    if (i == bigM.child.count) {
        
        i = 0;
        [_timer invalidate];
        
        NSLog(@"_timer invalidate");
        
        _timer = nil;
    }
    
    
}



- (void)changeDeLineVRectWithOffsetX:(CGFloat)offsetX{
    
    CGFloat deLineWidth = offsetX/K_WIDTH * MENU_BUTTON_WIDTH;
    _deLineV.frame = CGRectMake(deLineWidth, MENU_HEIGHT - 2*DISTANCE_HEIGHT, MENU_BUTTON_WIDTH, 2*DISTANCE_HEIGHT);
    
    
    
}


- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
    
}


#pragma mark  -  获取详细分类
- (void)getPesticideAllSpeciesData{
    
    NSString *str = [NSString stringWithFormat:C_HOST_API,@"/wiki/get_children_by_cid?XDEBUG_SESSION_START=11650"];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    bool bool_true = true;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(bool_true) forKey:@"need_child"];
    [dic setValue:@(self.cid) forKey:@"cid"];
    
    
    __weak pesticideViewController *weakSelf = self;
    [FirstHttpRequestManager postChildAllSpeciesWithUrl:encode WithDic:dic WithBlock:^(NSArray * _Nullable array) {
      
        
        
        [weakSelf.dataArray addObjectsFromArray:array];
        
        
        [weakSelf createMenuView];
        [weakSelf createScrollCollection];
        [weakSelf.view bringSubviewToFront:_indicator];
        
    }];
    
}


- (void)leftBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
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
