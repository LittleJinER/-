//
//  FertilizerViewController.m
//  小农人
//
//  Created by tomusng on 2017/9/27.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "FertilizerViewController.h"
#import "LLSearchView.pch"
#import "FirstHttpRequestManager.h"
#import "AllCateItemCell.h"
#import "FertilizerHeaderView.h"
#import "AllCateItemFooterView.h"
#import "BigClassModel.h"
#import "LittleClassModel.h"
#import "SearchBarView.h"
#import "FertilizerLCViewController.h"


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

#define MENU_BUTTON_WIDTH  [UIScreen mainScreen].bounds.size.width/7.0
#define MENU_HEIGHT 44*DISTANCE_WIDTH
#define ITEM_HEIGHT 38*DISTANCE_WIDTH

static NSString *reuseID = @"itemCell";
static NSString *sectionHeaderID = @"setionHeader";
static NSString *sectionFooterID = @"sectionFooter";


@interface FertilizerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation FertilizerViewController

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
    self.title = @"肥料";
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

    NSLog(@"cid:%d",self.cid);
    
    [self getFertilizerAllSpeciesData];
    
    
}


#pragma mark -  创建下面的collection表
- (void)createCollectionUI{
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(K_WIDTH / 3.0, ITEM_HEIGHT);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(K_WIDTH, 45*DISTANCE_HEIGHT);
    layout.footerReferenceSize = CGSizeMake(K_WIDTH, 0*DISTANCE_HEIGHT);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + 50*DISTANCE_HEIGHT, K_WIDTH, ViewHeight) collectionViewLayout:layout];
        
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = [UIColor whiteColor];
        
    _collectionView = collectionView;
    [collectionView registerClass:[AllCateItemCell class] forCellWithReuseIdentifier:reuseID];
    
    [collectionView registerClass:[FertilizerHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID];
    [collectionView registerClass:[AllCateItemFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sectionFooterID];

    
}


#pragma mark   ---   <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSLog(@"************   %ld",self.dataArr.count);
    
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    BigClassModel *bigM = self.dataArr[section];
    
    return bigM.child.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AllCateItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    BigClassModel *bigM = self.dataArr[indexPath.section];
    
    LittleClassModel *litM = bigM.child[indexPath.row];
    
    cell.title = litM.cat_name;
    
    return cell;
    
    
    
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        FertilizerHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionHeaderID forIndexPath:indexPath];
        
        if (headerView == nil) {
            headerView = [[FertilizerHeaderView alloc] init];
        }
        headerView.backgroundColor = BG_COLOR;
        
        BigClassModel *bigM = self.dataArr[indexPath.section];
        
        headerView.title = bigM.cat_name;
        
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BigClassModel *bigM = self.dataArr[indexPath.section];
    
    LittleClassModel *litM = bigM.child[indexPath.row];
    
    FertilizerLCViewController *flcVC = [[FertilizerLCViewController alloc] init];
    
    flcVC.titleName = litM.cat_name;
    flcVC.litCid = litM.cat_id;
    flcVC.bigCid = bigM.cat_id;
    
    [self.navigationController pushViewController:flcVC animated:YES];
}




- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (void)getFertilizerAllSpeciesData{
    
    
    NSString *str = [NSString stringWithFormat:C_HOST_API,@"/wiki/get_children_by_cid?XDEBUG_SESSION_START=11650"];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    bool bool_true = true;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(bool_true) forKey:@"need_child"];
    [dic setValue:@(self.cid) forKey:@"cid"];
    
    __weak FertilizerViewController *weakSelf = self;
    
    [FirstHttpRequestManager postChildAllSpeciesWithUrl:encode WithDic:dic WithBlock:^(NSArray * _Nullable array) {
        
        
        [weakSelf.dataArr addObjectsFromArray:array];
        
        [weakSelf createCollectionUI];
        [weakSelf.collectionView reloadData];
        
        
        
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
