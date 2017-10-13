//
//  SearchExpertsVC.m
//  小农人
//
//  Created by tomusng on 2017/10/11.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "SearchExpertsVC.h"
#import "LLSearchView.pch"
#import "FirstHttpRequestManager.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

@interface SearchExpertsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *epTable;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation SearchExpertsVC

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getExpertsData];
    
}


- (void)createTableUI{
    
    UITableView *epTable = [[UITableView alloc] init];
    epTable.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    epTable.delegate = self;
    epTable.dataSource = self;
    [self.view addSubview:epTable];
    
    _epTable = epTable;
//    [epTable registerClass:[myCollectTVCell class] forCellReuseIdentifier:@"cellID"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    myCollectViewM *myCollViewMod = _dataArr[indexPath.row];
//    
//    return myCollViewMod.cellHeight;
    return 1;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    myCollectTVCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
//    if (!myCell) {
//        myCell = [[myCollectTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
//    }
//    
//    myCollectViewM *myCollViewMod = _dataArr[indexPath.row];
//    
//    myCell.myCollViewMod = myCollViewMod;
//    
//    myCell.answerBtn.tag = 100000 + indexPath.row;
//    
//    [myCell.answerBtn addTarget:self action:@selector(answerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    return myCell;
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSInteger num = indexPath.row;
//    
//    AppointedQuestionVC *appointQVC = [[AppointedQuestionVC alloc] init];
//    
//    myCollectViewM *model = self.dataArr[num];
//    
//    appointQVC.post_id = model.myCollModel.post_id;
//    appointQVC.headModel = model.myCollModel;
//    [self.navigationController pushViewController:appointQVC animated:YES];
    
}


- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
    
}


- (void)getExpertsData{
    
    NSString *str = [NSString stringWithFormat:TOM_HOST_SEARCH_EXPERT,@"api",@"Tom",@"search_user_official",oauth_token,oauth_token_secret,self.text];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak SearchExpertsVC *weakSelf = self;
    [FirstHttpRequestManager searchExpertInfoWithUrl:encode WithBlock:^(NSArray * _Nullable array) {
    
        [_dataArr addObjectsFromArray:array];
        [weakSelf.epTable reloadData];
    
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
