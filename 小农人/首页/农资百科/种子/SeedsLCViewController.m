//
//  SeedsLCViewController.m
//  小农人
//
//  Created by tomusng on 2017/9/29.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "SeedsLCViewController.h"
#import "LLSearchView.pch"
#import "FirstHttpRequestManager.h"
#import "AllCateItemCell.h"
#import "FertilizerHeaderView.h"
#import "AllCateItemFooterView.h"
#import "FertilizerDetailViewController.h"//每一个种类的详细信息

#import "LittleClassModel.h"
#import "SearchBarView.h"

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



@interface SeedsLCViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *miniArr;

@end

@implementation SeedsLCViewController

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
    
//    NSLog(@"cid:%d",self.cid);
    
    
    
    if (self.search_cid == 2) {
        [self getSearchData];
    }else{
        [self getEveryData];
    }
}


#pragma mark -  创建下面的table表
- (void)createCollectionUI{
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(K_WIDTH / 3.0, ITEM_HEIGHT);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(K_WIDTH, 10*DISTANCE_HEIGHT);
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
    
//    NSLog(@"************   %ld",self.miniArr.count);
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.search_cid == 2) {
        
        return self.miniArr.count;
        
    }else{
        
        LittleClassModel *litM = self.miniArr[2];
        return litM.child.count;
   
    }

    
    
    
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AllCateItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    MiniClassModel *miniModel;
    
    if (self.search_cid == 2) {
        miniModel = self.miniArr[indexPath.row];
    }else{
        LittleClassModel *litM = self.miniArr[2];
        
        miniModel = litM.child[indexPath.row];

    }
    
    
    
    cell.title = miniModel.title;
    
    return cell;
    
    
    
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        FertilizerHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionHeaderID forIndexPath:indexPath];
        
        if (headerView == nil) {
            headerView = [[FertilizerHeaderView alloc] init];
        }
        headerView.backgroundColor = BG_COLOR;
        
        
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
    MiniClassModel *model;
    if (self.search_cid == 2) {
        model = self.miniArr[indexPath.row];
    }else{
        LittleClassModel *litM = self.miniArr[2];
        
        model = litM.child[indexPath.row];
        
    }
    

    
//    LittleClassModel *litmM = self.miniArr[2];
//    MiniClassModel *model = litmM.child[indexPath.row];
    
    //    BaiKeMiniClassVC *miniClVC = [[BaiKeMiniClassVC alloc] init];
    //
    //    miniClVC.titleName = model.title;
    //    miniClVC.aid = model.article_id;
    //
    //    [self.navigationController pushViewController:miniClVC animated:YES];
    
    FertilizerDetailViewController *ferDVC = [[FertilizerDetailViewController alloc] init];
    ferDVC.titleName = model.title;
    ferDVC.aid = model.article_id;
    ferDVC.colorID = 101;
    [self.navigationController pushViewController:ferDVC animated:YES];


}




- (NSMutableArray *)miniArr{
    
    if (!_miniArr) {
        _miniArr = [NSMutableArray array];
    }
    return _miniArr
    ;
}


- (void)getEveryData{
    
    bool bool_true = true;
    
    
    NSString *str = [NSString stringWithFormat:C_HOST_API,@"/wiki/get_article_by_cid"];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSDictionary *dic = @{@"cid_list":@[@(bool_true),@(self.bigCid),@(self.litCid)]};
    
    __weak SeedsLCViewController *weakSelf = self;
    
    [FirstHttpRequestManager postChildEverySpeciesWithUrl:encode WithDic:dic WithBlock:^(NSArray * _Nullable array) {
        
        [weakSelf.miniArr addObjectsFromArray:array];
        
        NSLog(@"weakSelf.miniArr: %@",weakSelf.miniArr);
        
        [weakSelf createCollectionUI];
        [weakSelf.collectionView reloadData];
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
    __weak SeedsLCViewController *weakSelf = self;
    
//    [FirstHttpRequestManager postChildEverySpeciesWithUrl:encode WithDic:dic WithBlock:^(NSArray * _Nullable array) {
//        
//        
//    }];

    [FirstHttpRequestManager searchPostChildEverySpeciesWithUrl:encode WithDic:dic WithBlock:^(NSArray * _Nullable array) {
       
        [weakSelf.miniArr addObjectsFromArray:array];
        
        NSLog(@"weakSelf.miniArr: %@",weakSelf.miniArr);
        
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
