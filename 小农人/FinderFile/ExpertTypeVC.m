//
//  ExpertTypeVC.m
//  小农人
//
//  Created by tomusng on 2017/9/11.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "ExpertTypeVC.h"
#import "Q_AHttpRequestManager.h"
#import "ExpertCategoryModel.h"


#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1]
#define BGVIEW_COLOR     [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]

@interface ExpertTypeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *table;


@end

@implementation ExpertTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"专家类型";
    self.table = [[UITableView alloc] init];
    _table.frame = CGRectMake(0, 0, K_WIDTH, K_HETGHT);
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    [self getData];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    if (self.dataArr.count != 0) {
        ExpertCategoryModel *model = self.dataArr[indexPath.row];
        
        cell.textLabel.text = model.title;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *expType;
    NSNumber *category_id;
    if (self.dataArr.count != 0) {
        ExpertCategoryModel *model = self.dataArr[indexPath.row];
        expType = model.title;
        category_id = [NSNumber numberWithInteger:model.user_official_category_id];
//        category_id = [NSString stringWithFormat:@"%ld",model.user_official_category_id];
    }
    NSArray *array = @[expType,category_id];
    
    if ([self.delegate respondsToSelector:@selector(transferExpType:)]) {
        [_delegate transferExpType:array];
        NSInteger num = self.navigationController.viewControllers.count;
        UIViewController *VC = self.navigationController.viewControllers[num - 2];
        [self.navigationController popToViewController:VC animated:YES];
    }
    
}

- (void)getData{
    
    self.dataArr = [NSMutableArray array];
    
     NSString *urlStr = @"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=get_all_user_cate&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e";
    
    [Q_AHttpRequestManager getExpertCategoryInfoWithUrl:urlStr WithBlock:^(NSArray * _Nullable array) {
        
        [_dataArr addObjectsFromArray:array];
        [_table reloadData];
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
