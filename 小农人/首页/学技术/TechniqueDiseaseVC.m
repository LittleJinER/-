//
//  TechniqueDiseaseVC.m
//  小农人
//
//  Created by tomusng on 2017/9/25.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "TechniqueDiseaseVC.h"
#import "LLSearchView.pch"
#import "FirstHttpRequestManager.h"
#import "TechniqueCell.h"
#import "QuestionModel.h"
#import "TechniqueDetailVC.h"




#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

@interface TechniqueDiseaseVC ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;



@end

@implementation TechniqueDiseaseVC

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@%@",self.weiba_name,self.diseaseName];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 64, WIDTH, HEIGHT - 64);
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    [tableView registerClass:[TechniqueCell class] forCellReuseIdentifier:@"cellID"];
    
    [self getTechniqueData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TechniqueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[TechniqueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    QuestionModel *model = self.dataArr[indexPath.row];
    cell.myCollM = model;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*DISTANCE_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TechniqueDetailVC *techDVC = [[TechniqueDetailVC alloc] init];
    QuestionModel *qsModel = self.dataArr[indexPath.row];
    
    techDVC.qsModel = qsModel;
    //    NSLog(@"picArr ********LLLL    ******   :   %@",qsModel.picArr);
    //    NSLog(@"fsgl ********LLLL    ******   :   %@",qsModel.fsgl);
    [self.navigationController pushViewController:techDVC animated:YES];
    
    
}


- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
    
    
    
}



- (void)getTechniqueData{
    
    __weak TechniqueDiseaseVC *weakSelf = self;
    
    
    NSString *str = [NSString stringWithFormat:TOM_HOST_TECHNIQUE_CROPID_DISEASEID,@"api",@"Tom",@"get_pestandweed_posts",oauth_token,oauth_token_secret,self.disease_id,self.weiba_id];
    
    //            [];
    //            NSString *str = [NSString stringWithFormat:TOM_HOST,@"api",@"Weiba",@"get_all_user",oauth_token,oauth_token_secret];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [FirstHttpRequestManager searchTechniqueInfoWithUrl:encode WithBlock:^(NSArray * _Nullable array) {
        
        
        for (int i = 0; i < array.count; i ++) {
            
            QuestionModel *myCollModel = array[i];
            
            NSArray *strArr = [myCollModel.content componentsSeparatedByString:@"img"];
            
            //有图片的进入下一次分割
            if (strArr.count > 1) {
                
                myCollModel.picArr = [NSMutableArray array];
                //                NSLog(@"%@",model.content);
                
                for (int j = 0; j < strArr.count; j ++) {
                    
                    //有图片的字符串
//                    NSString *firstStr = strArr[j];
                    NSString *firstUnicode = strArr[j];
                    NSString *firstStr = [self replaceUnicode:firstUnicode];
                    //                    NSLog(@"  11111  第一次分割后  %@",firstStr);
                    NSString *textStr = strArr[0];
                    NSArray *textA = [textStr componentsSeparatedByString:@"<"];
                    myCollModel.text = textA[0];
                    //                    从图片字符串开始分割
                    if (j > 0) {
                        
                        NSArray *secondArr = [firstStr componentsSeparatedByString:@"\""];
                        
                        //                        NSLog(@"%@",secondArr);
                        
                        NSString *secondStr = secondArr[1];
                        
                        NSString *picStr = [NSString stringWithFormat:TOM_CRAZY,secondStr];
                        //
                        [myCollModel.picArr addObject:picStr];
                        //                        NSLog(@"     %@",myCollModel.picArr);
                        
//                        if (j > 1) {
                            //                            NSLog(@"longText *******:    %@",secondArr);
                            
                            for (int k = 0 ; k < secondArr.count; k ++) {
                                
                                NSString *text = secondArr[k];
                                
                                if ([text isEqualToString:@"title"]) {
                                    NSString *titleName = secondArr[k + 2];
                                    //                                    NSLog(@"title :   %@",titleName);
                                    myCollModel.titleName = titleName;
                                    
                                    NSLog(@"titleName:%@",myCollModel.titleName);
                                    
                                    
                                }
                                
                                if ([text isEqualToString:@"lbzp"]) {
                                    NSString *lbzp = [NSString stringWithFormat:TOM_CRAZY,secondArr[k+2]];
                                    //                                    NSLog(@"lazp 图片 ：  %@",lbzp);
                                    
                                    myCollModel.lbzp = lbzp;
                                }
                                
                                
                                if ([text isEqualToString:@"fbwh"]) {
                                    //                                    NSLog(@"fbwh   :  %@",secondArr[k+2]);
                                    NSString *fbwh = secondArr[k+2];
                                    myCollModel.fbwh = fbwh;
                                }
                                
                                if ([text isEqualToString:@"whtz"]) {
                                    //                                    NSLog(@"危害特征:   %@",secondArr[k+2]);
                                    NSString *whtz = secondArr[k+2];
                                    myCollModel.whtz = whtz;
                                }
                                
                                if ([text isEqualToString:@"fsgl"]) {
                                    //                                    NSLog(@"发生规律:   %@",secondArr[k+2]);
                                    NSString *fsgl = secondArr[k+2];
                                    myCollModel.fsgl = fsgl;
                                }
                                
                                if ([text isEqualToString:@"fzff"]) {
                                    //                                    NSLog(@"防止方法:   %@",secondArr[k+2]);
                                    NSString *fzff = secondArr[k+2];
                                    myCollModel.fzff = fzff;
                                }
                                
                                
//                            }
                            
                        }
                        
                    }
                    
                }
                
            }else{
                myCollModel.text = myCollModel.content;
                //                NSLog(@"%@",queModel.text);
            }
            
            //            myCollectViewM *myCollViewMod = [[myCollectViewM alloc] init];
            //            myCollViewMod.myCollModel = myCollModel;
            //            [myCollViewMod setqueModel:myCollModel];
            
            [weakSelf.dataArr addObject:myCollModel];
            
            //            NSLog(@"ccccccc  %lu",(unsigned long)_viewModelArr.count);
            //            [weakSelf.tableView.mj_header endRefreshing];
        }
        
        //        _tableView.frame = CGRectMake(K_WIDTH, 0, K_WIDTH, 80*DISTANCE_HEIGHT*_techniqueArr.count + 70*DISTANCE_HEIGHT);
        [weakSelf.tableView reloadData];
        
        
        
    }];
    
}


- (NSString*) replaceUnicode:(NSString*)TransformUnicodeString

{
    
    NSString*tepStr1 = [TransformUnicodeString stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    
    NSString*tepStr2 = [tepStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    
    NSString*tepStr3 = [[@"\"" stringByAppendingString:tepStr2]stringByAppendingString:@"\""];
    
    NSData*tepData = [tepStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString*axiba = [NSPropertyListSerialization propertyListWithData:tepData options:NSPropertyListMutableContainers format:NULL error:NULL];
    
    return [axiba stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    
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
