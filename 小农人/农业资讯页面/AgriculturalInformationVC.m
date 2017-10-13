//
//  AgriculturalInformationVC.m
//  小农人
//
//  Created by tomusng on 2017/9/13.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "AgriculturalInformationVC.h"
#import "PictureRotate.h"
#import "DiscoveryHttpRequestManager.h"
#import "AgriInfoCell.h"
#import "AgriInfoModel.h"
#import "AttachModel.h"
#import "AgriViewModel.h"
#import "AgriDetailInfoVC.h"
#import "TBRefresh.h"//刷新控件



#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0
#define BGVIEW_COLOR     [UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1]


@interface AgriculturalInformationVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PictureRotate *pictureRotate;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *statusView;

@end

@implementation AgriculturalInformationVC

//添加一个定时器
- (void)viewWillAppear:(BOOL)animated{
//    
    if (_pictureRotate) {
        [_pictureRotate addTimerLoop];
    }
    self.tabBarController.tabBar.hidden = YES;
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];
   
    if (_statusView != nil) {
        [self.navigationController.navigationBar addSubview:_statusView];
    }
    
}

//销毁定时器
- (void)viewWillDisappear:(BOOL)animated{
    [self.statusView removeFromSuperview];
    [self.pictureRotate resumeTimer];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.backgroundColor = nil;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.statusView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, WIDTH, 20)];
    //    _statusView.alpha = 0.05;
    _statusView.backgroundColor = BGVIEW_COLOR;
    self.navigationController.navigationBar.backgroundColor = BGVIEW_COLOR;
    self.navigationController.navigationBar.alpha = 1;
//    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar addSubview:_statusView];
    
    
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.title = @"农业资讯";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    __weak __typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderWithBlock:^{
        
        [weakSelf LoadUpdateDatas];
        
    }];
    
    [self.tableView addRefreshFootWithBlock:^{
        
        [weakSelf LoadMoreDatas];
    }];

    
    //    自定义表头
        [self getData];
    
}
#pragma mark    -    自定义表头
- (void)createHeaderView{
    
//    UIView *bgView = [[UIView alloc] init];
//    bgView.backgroundColor = [UIColor whiteColor];
    
    
    
    
//    NSArray *images = @[@"001.jpg",@"002.jpg",@"003.jpg",@"004.jpg",@"005.jpg"];
    NSMutableArray *textArr = [NSMutableArray array];
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 0; i < self.dataArr.count; i ++) {
        AgriViewModel *agriVModel = _dataArr[i];
        NSString *text = agriVModel.agriModel.content;
        [textArr addObject:text];
        
        AttachModel *attachModel = agriVModel.agriModel.attach[1];
        NSString *imageStr = attachModel.attach_url;
    
        [imageArr addObject:imageStr];
    }
    
     NSArray *images = @[imageArr,textArr];
    
    self.pictureRotate = [[PictureRotate alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH*1/2.0)];
    _pictureRotate.images = images;
    _pictureRotate.timeInterval = 2.0;
//    [bgView addSubview:pictureRotate];
    self.tableView.tableHeaderView = self.pictureRotate;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AgriInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[AgriInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    AgriViewModel *model = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.agriViewModel = model;
    
    
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AgriViewModel *model = self.dataArr[indexPath.row];
    return model.cellHeight;
    
}


#pragma mark - dataArr懒加载
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


#pragma mark  - 获取农业资讯页面数据
- (void)getData{
    
    NSString *str = @"http://crazy.tomsung.cn/thinksns/index.php?app=api&mod=Channel&act=get_channel_feed&oauth_token=777c8beff43b4de7dbf95f87e7d48c5e&oauth_token_secret=0432511b5b75a5942f2a831e995e3adf&category_id=1";
    
    NSString *urlStr = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak __typeof(self) weakSelf = self;
    
    [DiscoveryHttpRequestManager getAgriInfomationWithUrl:urlStr WithBlock:^(NSArray *array) {
        
//        [weakSelf.dataArr addObjectsFromArray:array];
//
        
        for (AgriInfoModel *model in array) {
            AgriViewModel *agriViewModel = [[AgriViewModel alloc] init];
            agriViewModel.agriModel = model;
            [_dataArr addObject:agriViewModel];
        }
        
        
//        AgriInfoModel *model = _dataArr[0];
//        NSLog(@"uuuuuuuuu       %@",model.content);
//
//        for (int i = 0; i < model.attach.count; i ++) {
//            AttachModel *obj = model.attach[i];
//            NSLog(@"uuuuuuuuu       %@",obj.attach_url);
//        }
        
        [weakSelf.tableView reloadData];
        [weakSelf createHeaderView];

        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AgriViewModel *agriViewModel = self.dataArr[indexPath.row];
    AttachModel *attaModel = agriViewModel.agriModel.attach[0];
    NSString *html = attaModel.attach_url;
    AgriDetailInfoVC *agDIVC = [[AgriDetailInfoVC alloc] init];
    agDIVC.html = html;
    [self.navigationController pushViewController:agDIVC animated:YES];
    
}


#pragma mark-加载数据

-(void)LoadUpdateDatas
{
    
    //   [self.tableView.footer ResetNomoreData];
    
    // 模拟延时设置
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView.header endHeadRefresh];
        
    });
    
    
    
}

-(void)LoadMoreDatas
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView.footer NoMoreData];
        [self.tableView.footer ResetNomoreData];
        
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
