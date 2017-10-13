//
//  SearchQuestionVC.m
//  小农人
//
//  Created by tomusng on 2017/9/22.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "SearchQuestionVC.h"
#import "LLSearchView.pch"
#import "FirstHttpRequestManager.h"
#import "QuestionModel.h"
#import "myCollectTVCell.h"
#import "myCollectViewM.h"
#import "AppointedQuestionVC.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

@interface SearchQuestionVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *qtTable;
@property (nonatomic, strong) NSMutableArray *dataArr;


@end

@implementation SearchQuestionVC

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
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self createTableUI];
    [self getQuestionData];
    
}

- (void)createTableUI{
    
    UITableView *qtTable = [[UITableView alloc] init];
    qtTable.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    qtTable.delegate = self;
    qtTable.dataSource = self;
    [self.view addSubview:qtTable];
    
    _qtTable = qtTable;
    [qtTable registerClass:[myCollectTVCell class] forCellReuseIdentifier:@"cellID"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    myCollectViewM *myCollViewMod = _dataArr[indexPath.row];
    
    return myCollViewMod.cellHeight;
        
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    myCollectTVCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!myCell) {
        myCell = [[myCollectTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    myCollectViewM *myCollViewMod = _dataArr[indexPath.row];
    
    myCell.myCollViewMod = myCollViewMod;
    
    myCell.answerBtn.tag = 100000 + indexPath.row;
    
    [myCell.answerBtn addTarget:self action:@selector(answerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return myCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        NSInteger num = indexPath.row;
        
        AppointedQuestionVC *appointQVC = [[AppointedQuestionVC alloc] init];
        
        myCollectViewM *model = self.dataArr[num];
        
        appointQVC.post_id = model.myCollModel.post_id;
        appointQVC.headModel = model.myCollModel;
        [self.navigationController pushViewController:appointQVC animated:YES];
    
}
- (void)answerButtonClick:(UIButton *)sender{
    
    
    NSLog(@"%ld",sender.tag);
    
    NSInteger num = sender.tag - 100000;
    
    AppointedQuestionVC *appointQVC = [[AppointedQuestionVC alloc] init];
    
    myCollectViewM *model = self.dataArr[num];
    
    appointQVC.post_id = model.myCollModel.post_id;
    appointQVC.headModel = model.myCollModel;
    [self.navigationController pushViewController:appointQVC animated:YES];
    
    
    
}
- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
    
}

- (void)getQuestionData{
    
    NSString *str = [NSString stringWithFormat:TOM_HOST_SEARCH_TEC_QUE,@"api",@"Tom",@"search_post",oauth_token,oauth_token_secret,0,self.text];
    
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak SearchQuestionVC *weakSelf = self;
    [FirstHttpRequestManager searchQuestionsInfoWithUrl:encode WithBlock:^(NSArray * _Nullable array) {
    
        
//        [_dataArr addObjectsFromArray:array];
        for (int i = 0; i < array.count; i ++) {
            
            QuestionModel *myCollModel = array[i];
            
            NSArray *strArr = [myCollModel.content componentsSeparatedByString:@"img"];
            
            //有图片的进入下一次分割
            if (strArr.count > 1) {
                myCollModel.picArr = [NSMutableArray array];
                //                NSLog(@"%@",model.content);
                
                for (int j = 0; j < strArr.count; j ++) {
                    
                    //有图片的字符串
                    NSString *firstStr = strArr[j];
                    //                    NSLog(@"  11111  第一次分割后  %@",firstStr);
                    NSString *textStr = strArr[0];
                    NSArray *textA = [textStr componentsSeparatedByString:@"<"];
                    myCollModel.text = textA[0];
                    //                    从图片字符串开始分割
                    if (j > 0) {
                        
                        NSArray *secondArr = [firstStr componentsSeparatedByString:@"\""];
                        
                        //                        NSLog(@"%@",secondArr);
                        
                        NSString *secondStr = secondArr[1];
                        
                        NSString *picStr = [NSString stringWithFormat:@"http://192.168.1.86%@",secondStr];
                        //                        http://crazy.tomsung.cn
                        [myCollModel.picArr addObject:picStr];
                        //                        NSLog(@"     %@",myCollModel.imgArr);
                        
                    }
                    //                    NSLog(@"    *****     %@",myCollModel.imgArr);
                }
                
            }else{
                myCollModel.text = myCollModel.content;
                //                NSLog(@"%@",queModel.text);
            }
            
            myCollectViewM *myCollViewMod = [[myCollectViewM alloc] init];
            myCollViewMod.myCollModel = myCollModel;
            //            [myCollViewMod setqueModel:myCollModel];
            
            [weakSelf.dataArr addObject:myCollViewMod];
            
            //            NSLog(@"ccccccc  %lu",(unsigned long)_viewModelArr.count);
            
            //            [weakSelf.tableView.mj_header endRefreshing];
        }
        
        [weakSelf.qtTable reloadData];
        
        
        
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
