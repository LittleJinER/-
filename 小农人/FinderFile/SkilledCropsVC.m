//
//  SkilledCropsVC.m
//  小农人
//
//  Created by tomusng on 2017/9/11.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "SkilledCropsVC.h"
#import "CollectionViewHeaderView.h"
#import "CollectionViewCell.h"
#import "DetailedCategoryModel.h"
#import "Q_AHttpRequestManager.h"
#import "CropsClassificationModel.h"
#import "CropsDetailSpeciesModel.h"
#import "UIImageView+WebCache.h"

#define CellIdentifier @"CellIdentifier"

@interface SkilledCropsVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UITableView * leftTableView;
@property (nonatomic,strong) UICollectionView * rightCollectionView;

@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,assign) BOOL  isScrollDown;
@property (nonatomic,strong) UIView * lineView;
@property (nonatomic,strong) UICollectionViewFlowLayout * flowLayout;


@property (nonatomic,strong)UIButton *rightButton;

@property (nonatomic,assign)NSInteger num;
@property (nonatomic,strong)NSMutableArray *cropClassification;
@property (nonatomic,strong)NSMutableArray *detailSpecies;
@property (nonatomic,strong)NSMutableArray *follow_createArr;
//@property (nonatomic,strong)NSMutableArray *follow_destroyArr;

//
//@property (nonatomic,strong)NSMutableArray <DataSource *> * selectionArray;
@property (nonatomic,strong)UILabel *label;

@end

@implementation SkilledCropsVC

-(UITableView *)leftTableView{
    
    if (!_leftTableView) {
        
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width*0.3-2, self.view.bounds.size.height-64) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorColor = [UIColor clearColor];
        _leftTableView.scrollEnabled = NO;
    }
    return _leftTableView;
}



-(UICollectionView *)rightCollectionView{
    
    if (!_rightCollectionView) {
        
        self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _rightCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.3, 70, self.view.bounds.size.width*0.7, self.view.bounds.size.height-64) collectionViewLayout:self.flowLayout];
        self.flowLayout.minimumLineSpacing = 10;
        self.flowLayout.minimumInteritemSpacing = 10;
        
        
        self.flowLayout.itemSize = CGSizeMake((self.rightCollectionView.bounds.size.width-31)/3.5, (self.rightCollectionView.bounds.size.height-30)/5.5);
        self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        
        [_rightCollectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
        _rightCollectionView.backgroundColor = [UIColor whiteColor];
        
        [_rightCollectionView registerClass:[CollectionViewHeaderView class]
                 forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                        withReuseIdentifier:@"CollectionViewHeaderView"];
        
    }
    return _rightCollectionView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _rightButton.frame = CGRectMake(0, 0, 70, 30);
    _rightButton.backgroundColor = [UIColor clearColor];
    
    
    
    
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, 0, 70, 30);
    _label.font = [UIFont systemFontOfSize:12.0f];
    _label.backgroundColor = [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1];
    [_rightButton addSubview:_label];
    _label.text = @"确认（0）";
    _label.clipsToBounds = YES;
    _label.layer.cornerRadius = 15.0f;
    _label.textAlignment = NSTextAlignmentCenter;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self getAllCropsData];
    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.rightCollectionView];
    
    
}

#pragma mark 加载数据
- (void)getAllCropsData{
    
    self.cropClassification = [NSMutableArray array];
    self.detailSpecies = [NSMutableArray array];
    
    
    NSMutableArray *one = [NSMutableArray array];
    NSMutableArray *two = [NSMutableArray array];
    NSMutableArray *three = [NSMutableArray array];
    NSMutableArray *four = [NSMutableArray array];
    //    NSMutableArray *five = [NSMutableArray array];
    //    NSMutableArray *six = [NSMutableArray array];
    //    NSMutableArray *seven = [NSMutableArray array];
    //    NSMutableArray *eight = [NSMutableArray array];
    
    
    [Q_AHttpRequestManager getAllCropsWithUrl:@"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=get_all_weiba_cate&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e" withBlock:^(NSArray *array) {
        
        [_cropClassification addObjectsFromArray:array];
        
        for (NSInteger i = 0; i < _cropClassification.count; i ++) {
            CropsClassificationModel *obj = _cropClassification[i];
            obj.follow_count_by_crop = 0;
            obj.cid = i + 1;
        }
        
        //        for (NSInteger i = _cropClassification.count + 1; i < 9; i ++) {
        //            CropsClassificationModel *model = [[CropsClassificationModel alloc] init];
        //            [_cropClassification addObject:model];
        //        }
        //        NSLog(@"%lu",(unsigned long)_cropClassification.count);
        
        [Q_AHttpRequestManager getDesignatedCropsWithUrl:@"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=get_weiba_by_cate&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&cid=0" withBlock:^(NSArray *array) {
            
            for (CropsDetailSpeciesModel *obj in array) {
            
                
                
                switch (obj.cid) {
                    case 1:
                        [one addObject:obj];
                        break;
                    case 2:
                        [two addObject:obj];
                        break;
                    case 3:
                        [three addObject:obj];
                        break;
                    case 4:
                        [four addObject:obj];
                        break;
                        //                    case 5:
                        //                        [five addObject:obj];
                        //                        break;
                        //                    case 6:
                        //                        [six addObject:obj];
                        //                        break;
                        //                    case 7:
                        //                        [seven addObject:obj];
                        //                        break;
                        //                    case 8:
                        //                        [eight addObject:obj];
                        //                        break;
                        
                    default:
                        break;
                }
                
                
            }
            
            for (CropsDetailSpeciesModel *obj in one) {
                obj.following = 0;
            }
            for (CropsDetailSpeciesModel *obj in two) {
                obj.following = 0;
            }
            for (CropsDetailSpeciesModel *obj in three) {
                obj.following = 0;
            }
            for (CropsDetailSpeciesModel *obj in four) {
                obj.following = 0;
            }
            
            [_detailSpecies addObject:one];
            [_detailSpecies addObject:two];
            [_detailSpecies addObject:three];
            [_detailSpecies addObject:four];
            //                 [_detailSpecies addObject:five];
            //                 [_detailSpecies addObject:six];
            //                 [_detailSpecies addObject:seven];
            //                 [_detailSpecies addObject:eight];
            
            [_leftTableView reloadData];
            //            _leftTableView.frame.size.height = 44 * _cropClassification.count;
            //            _leftTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width*0.3-2, 44 * (_cropClassification.count+2));
            _leftTableView.separatorColor = [UIColor grayColor];
            
            [_rightCollectionView reloadData];
            
            _label.text = [NSString stringWithFormat:@"确认(%ld)",_num];
            
        }];
    }];
    
}

#pragma mark -------点击导航栏上的按钮将选中的作物传出--------
- (void)rightButtonClick:(UIButton *)sender{
    NSMutableArray *cropsArr = [NSMutableArray array];
    NSMutableArray *cropsNameArr = [NSMutableArray array];
    NSMutableArray *cropIdArr = [NSMutableArray array];
    
    for (CropsDetailSpeciesModel *obj in self.follow_createArr) {
        [cropsNameArr addObject:obj.weiba_name];
        NSNumber *cropID = [NSNumber numberWithInteger:obj.weiba_id];
        [cropIdArr addObject:cropID];
    }
    
    [cropsArr addObject:cropsNameArr];
    [cropsArr addObject:cropIdArr];
    
    if (self.follow_createArr.count != 0) {
        if ([self.dataSourceDelegate respondsToSelector:@selector(sendDataSource:)]) {
            [self.dataSourceDelegate sendDataSource:cropsArr];
        }

    }
    
    NSInteger num = self.navigationController.viewControllers.count;
    UIViewController *VC = self.navigationController.viewControllers[num - 2];
    
    [self.navigationController popToViewController:VC animated:YES];
}

#pragma mark UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cropClassification.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        UIView *view = [[UIView alloc]initWithFrame:cell.frame];
        view.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
        cell.selectedBackgroundView = view;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, 44)];
        line.backgroundColor = [UIColor redColor];
        [view addSubview:line];
    }
    
    //    NSLog(@"%f",cell.frame.size.height);
    CropsClassificationModel *ccModel = self.cropClassification[indexPath.row];
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%ld)",ccModel.name,(long)ccModel.follow_count_by_crop];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    
    return cell;
}


#pragma mark 点击cell进入collectionview指定的header
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectIndex = indexPath.row;
    [self scrollToTopOfSection:self.selectIndex animated:NO];
    [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)scrollToTopOfSection:(NSInteger)section animated:(BOOL)animated{
    
    CGRect headerRect = [self frameForHeaderForSection:section];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y-self.rightCollectionView.contentInset.top);
    [self.rightCollectionView setContentOffset:topOfHeader animated:animated];
}

-(CGRect)frameForHeaderForSection:(NSInteger)section{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.rightCollectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frameForFirstCell = attributes.frame;
    CGFloat headerHeight = [self collectionView:self.rightCollectionView layout:self.flowLayout referenceSizeForHeaderInSection:section].height;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.rightCollectionView.collectionViewLayout;
    CGFloat cellTopEdge = flowLayout.sectionInset.top;
    return CGRectOffset(frameForFirstCell, 0, -headerHeight-cellTopEdge);
    
    
}


#pragma mark UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.detailSpecies.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //    NSLog(@"%ld",[self.dataSource[section][@"imgs"] count]);
    //    NSLog(@"%ld",[self.dataSource[section][@"list"] count]);
    //    NSLog(@"%@",self.dataSource[section][@"title"]);
    return [self.detailSpecies[section] count];
}

#pragma mark collectionView的重用
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    
    CropsDetailSpeciesModel *cdsModel = self.detailSpecies[indexPath.section][indexPath.row];
    
    
    NSString *text = cdsModel.weiba_name;
    NSString *imageStr = cdsModel.logo;
    cell.name.text = text;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"selected"]];
    
    if (cdsModel.following == 1) {
        cell.selectedView.alpha = 1;
    }else if (cdsModel.following == 0){
        cell.selectedView.alpha = 0;
    }
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier;
    // header
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        reuseIdentifier = @"CollectionViewHeaderView";
    }
    CollectionViewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:reuseIdentifier
                                                                               forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        //        view.label.text = self.dataSource[indexPath.section][@"title"];
        
        //        NSLog(@"%lu     %ld",(unsigned long)self.cropClassification.count,indexPath.section);
        
        CropsClassificationModel *model = self.cropClassification[indexPath.section];
        
        view.label.text = model.name;
        
        
    }
    return view;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(self.rightCollectionView.frame.size.width, 30);
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.isScrollDown && collectionView.dragging) {
        [self selectRowAtIndexPath:indexPath.section];
    }
}


-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isScrollDown && collectionView.dragging) {
        [self selectRowAtIndexPath:indexPath.section];
    }
}


-(void)selectRowAtIndexPath:(NSInteger)index{
    
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    static float lastOffSetY = 0;
    if (self.rightCollectionView == scrollView) {
        self.isScrollDown = lastOffSetY < scrollView.contentOffset.y;
        lastOffSetY = scrollView.contentOffset.y;
    }
}

#pragma mark    collectionViewCell 的点击事件

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSLog(@"别摸我");
        }
    }
    
    NSLog(@"%ld分组 %ld单元格",indexPath.section,indexPath.row);
    
    [self changeTitleInDataSourceWith:indexPath];
    
}


#pragma mark -------初始化待传的作物总数的数组---------
//- (NSMutableArray<DataSource *> *)selectionArray{
//    if (_selectionArray == nil) {
//        _selectionArray = [NSMutableArray array];
//    }
//    return _selectionArray;
//}


- (NSMutableArray *)follow_createArr{
    if (!_follow_createArr) {
        _follow_createArr = [NSMutableArray array];
    }
    return _follow_createArr;
}
//- (NSMutableArray *)follow_destroyArr{
//    if (!_follow_destroyArr) {
//        _follow_destroyArr = [NSMutableArray array];
//    }
//    return _follow_destroyArr;
//    
//}

- (void)changeTitleInDataSourceWith:(NSIndexPath *)indexPath{
    
    CropsDetailSpeciesModel *detailSPobj = self.detailSpecies[indexPath.section][indexPath.row];
    
//    NSString *urlStr;
    
    if (detailSPobj.following == 0) {
        detailSPobj.following = 1;
        
        _num ++;
        [self.follow_createArr addObject:detailSPobj];
        for (CropsClassificationModel *obj in self.cropClassification) {
            if (obj.cid == detailSPobj.cid) {
                obj.follow_count_by_crop ++;
            }
        }
//        urlStr = [NSString stringWithFormat:@"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=create&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&id=%d",(int)detailSPobj.weiba_id];
//        NSLog(@"__________dddddddddddddddddd");
        
    }else if (detailSPobj.following == 1){
        detailSPobj.following = 0;
        _num --;
        [self.follow_createArr removeObject:detailSPobj];
        
        for (CropsClassificationModel *obj in self.cropClassification) {
            if (obj.cid == detailSPobj.cid) {
                obj.follow_count_by_crop --;
            }
        }
//        urlStr = [NSString stringWithFormat:@"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=destroy&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&id=%d",(int)detailSPobj.weiba_id];
//        NSLog(@"___________ffffffffffffffff");
    }
    NSLog(@"          5555       %ld",detailSPobj.weiba_id);
    
//    [Q_AHttpRequestManager followCreateOrDestoryWithUrl:urlStr WithBlock:^(NSArray *array) {
    
//    }];
    
    [_leftTableView reloadData];
    [_rightCollectionView reloadData];
    _label.text = [NSString stringWithFormat:@"确认(%ld)",_num];

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
