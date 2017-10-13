//
//  SearchCropViewController.m
//  小农人
//
//  Created by tomusng on 2017/9/6.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "SearchCropViewController.h"
#import "QTableViewCell.h"
#import "ViewModel.h"
#import "QuestionModel.h"
#import "Q_AHttpRequestManager.h"
#import "UIColor+SWAddition.h"
#import "AppointedQuestionVC.h"
#import "TBRefresh.h"
#import "MyReplyViewController.h"


#define DEF_Screen_Width [UIScreen mainScreen].bounds.size.width
#define DEF_Screen_Height [UIScreen mainScreen].bounds.size.height

@interface SearchCropViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

/**
 *  视图模型
 */
@property (strong, nonatomic) ViewModel *vm;

/**
 *  模型数组
 */
@property (strong, nonatomic) NSMutableArray *viewModelArr;

/**
 *  新闻表格
 */
@property (strong, nonatomic) UITableView *tableView;




@end

@implementation SearchCropViewController
#pragma mark - 状态栏样式

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
    
}


#pragma mark - 懒加载

- (ViewModel *)vm {
    if (!_vm) {
        _vm = [[ViewModel alloc] init];
    }
    return _vm;
}

- (NSMutableArray *)viewModelArr{
    if (!_viewModelArr) {
        _viewModelArr = [NSMutableArray array];
    }
    return _viewModelArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createSearchBar];
    self.tabBarController.tabBar.hidden = YES;
    
    self.title = self.cropName;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    //刷新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
    //获取数据
    [self getData];
    //页面基本样式
    [self createBaseView];
    //kvo 只要数组发生变化就刷新表格
    //    [[RACObserve(self, viewModelArr) skip:1] subscribeNext:^(id x) {
    //        [_tableView reloadData];
    //        OVLog(@"x === %@",x);
    //    }];
    
    //    ;
    
    

    
}

- (void)createSearchBar{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(5, 7, self.view.frame.size.width-125, 30)];
    
    //    titleView.backgroundColor = [UIColor whiteColor];
    
    //设置圆角效果
    titleView.layer.cornerRadius = 15.0;
    titleView.layer.masksToBounds = YES;
    
    
    //    titleView.backgroundColor = [UIColor whiteColor];
    
    UIImage *searchImage = [UIImage imageNamed:@"sort_magnifier"];
    CGFloat imaHeight = searchImage.size.height;
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (30 - imaHeight)/2.0, searchImage.size.width, searchImage.size.height)];
    searchImageView.image = searchImage;
    searchImageView.contentMode = UIViewContentModeCenter;
    [titleView addSubview:searchImageView];
    
    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchImageView.frame) + 10, 0, CGRectGetWidth(titleView.frame) - 10, CGRectGetHeight(titleView.frame))];
    //    _textField = [[FaTextField alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.bgView.frame) - 10, CGRectGetHeight(_bgView.frame))];
    textField.font = [UIFont systemFontOfSize:13];
    textField.textColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1];
    //清除按钮
    textField.clearButtonMode =UITextFieldViewModeWhileEditing;
    
    textField.delegate = self;
    //键盘属性
    //    _textField.returnKeyType = UIReturnKeySearch;
    
    //为textField设置属性占位符
    //    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索问题" attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
    textField.placeholder = @"搜索";
    textField.textColor = [UIColor blackColor];
    textField.textAlignment = NSTextAlignmentLeft;
    
    [titleView addSubview:textField];
    
    
    
    titleView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_btn_message_nm"] style:UIBarButtonItemStylePlain target:self action:@selector(newsClick:)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1];
}

- (void)newsClick:(UIBarButtonItem *)sender{
    
    NSLog(@"进入消息页面");
    
    
}


#pragma mark - 获取页面基本数据

//- (void) getData {
//    //类型,,top(头条，默认),shehui(社会),guonei(国内),guoji(国际),yule(娱乐),tiyu(体育)junshi(军事),keji(科技),caijing(财经),shishang(时尚)
//    @weakify(self);
//    [[self.vm.command execute:@"keji"] subscribeNext:^(id x) {
//        if ([x isKindOfClass:[NSArray class]]) {
//            @strongify(self);
//            self.viewModelArr = x;
//            [_tableView.mj_header endRefreshing];
//        } else if ([x isKindOfClass:[NSString class]]) {
//            NSLog(@"加载失败");
//        }
//    }];
//}



- (void)getData{
    __weak __typeof(self) weakSelf = self;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=get_posts&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&keyword=%@",self.cropName];
    NSLog(@"vvvvvvvv   %@",self.cropName);
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [Q_AHttpRequestManager getQuestionInfoWithUrl:encodedString WithBlock:^(NSArray * _Nullable array) {
        
        
        
        for (int i = 0; i < array.count; i ++) {
            
            QuestionModel *queModel = array[i];
            
            NSArray *strArr = [queModel.content componentsSeparatedByString:@"img"];
            
            //有图片的进入下一次分割
            if (strArr.count > 1) {
                queModel.picArr = [NSMutableArray array];
                //                NSLog(@"%@",model.content);
                
                for (int j = 0; j < strArr.count; j ++) {
                    
                    //有图片的字符串
                    NSString *firstStr = strArr[j];
                    //                    NSLog(@"  11111  第一次分割后  %@",firstStr);
                    NSString *textStr = strArr[0];
                    NSArray *textA = [textStr componentsSeparatedByString:@"<"];
                    queModel.text = textA[0];
                    //                    从图片字符串开始分割
                    if (j > 0) {
                        
                        NSArray *secondArr = [firstStr componentsSeparatedByString:@"\""];
                        
                        //                        NSLog(@"%@",secondArr);
                        
                        NSString *secondStr = secondArr[1];
                        
                        NSString *picStr = [NSString stringWithFormat:@"http://192.168.1.86%@",secondStr];
                        [queModel.picArr addObject:picStr];
                        //                        NSLog(@"     %@",queModel.picArr);
                        
                    }
                    
                }
                
            }else{
                queModel.text = queModel.content;
                //                NSLog(@"%@",queModel.text);
            }
            
            ViewModel *vModel = [[ViewModel alloc] init];
            vModel.queModel = queModel;
            [vModel setqueModel:queModel];
            
            [weakSelf.viewModelArr addObject:vModel];
            
            //            NSLog(@"ccccccc  %lu",(unsigned long)_viewModelArr.count);
            [_tableView reloadData];
            //            [_tableView.mj_header endRefreshing];
        }
        
//        NSLog(@"%ld",array.count);
        //        NSLog(@"%f",_tableView.frame.size.height);
        
    }];
}


#pragma mark - 页面基本样式



- (void) createBaseView {
    //    self.tableView = [[UITableView alloc] init];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEF_Screen_Width, DEF_Screen_Height - 64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    //    @weakify(self);
    //    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        @strongify(self);
    //        [self getData];
    //    }];
    //    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    [tableView.mj_header beginRefreshing];
    //    _tableView = tableView;
    //    [self.view addSubview:_tableView];
    __weak SearchCropViewController *weakself = self;
    [_tableView addRefreshHeaderWithBlock:^{
        [weakself LoadUpdateDatas];
    }];
    
    [_tableView addRefreshFootWithBlock:^{
        [weakself LoadMoreDatas];
    }];
    
    
    
}



#pragma mark-加载数据

-(void)LoadUpdateDatas
{
    
    //
    
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


#pragma mark - tableView delegate

/**
 *  点选的row
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView selectRowAtIndexPath:nil animated:NO scrollPosition:0];
    //    ViewModel *vm = self.viewModelArr[indexPath.row];
    //    Model *model = vm.queModel;
    //    OVLog(@"%@",model.url);
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AppointedQuestionVC *appointedQueVC = [[AppointedQuestionVC alloc] init];
    
    ViewModel *model = self.viewModelArr[indexPath.row];
    
    appointedQueVC.post_id = model.queModel.post_id;
    appointedQueVC.headModel = model.queModel;
    [self.navigationController pushViewController:appointedQueVC animated:YES];

    
   
}

/**
 *  row高度
 */
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"我是一个高%f",[self.viewModelArr[indexPath.row] rowHeight]);
    return [self.viewModelArr[indexPath.row] rowHeight];
}


#pragma mark - tableView dataSouce

/**
 *  行数
 */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModelArr.count;
}

/**
 *  UITableViewCell
 */
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseId = @"reuseId";
    QTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[QTableViewCell alloc]initWithStyle:0 reuseIdentifier:reuseId];
    }
    //    NSLog(@"fkjalfjaslfjaslfjsalfj");
    cell.vm = self.viewModelArr[indexPath.row];
    [cell setCellWithVm:self.viewModelArr[indexPath.row]];
    
    cell.answerButton.tag = indexPath.row + 100000;
    [cell.answerButton addTarget:self action:@selector(answerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.replyButton.tag = indexPath.row + 10000;
   
    [cell.replyButton addTarget:self action:@selector(replyButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    
  
    
    return cell;
}






- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, DEF_Screen_Width, 10.0f);
    view.backgroundColor = [UIColor grayColor];
    return view;
    
    
}


#pragma mark 搜索框的点击事件
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
//    [_textField resignFirstResponder];
//    LLSearchViewController *seachVC = [[LLSearchViewController alloc] init];
//    [self.navigationController pushViewController:seachVC animated:YES];
    
}



- (void)answerButtonClick:(UIButton *)sender{
    
    NSLog(@"sldfjdslfjd%ld",sender.tag);
    NSInteger num = sender.tag - 100000;
    
    AppointedQuestionVC *appointedQueVC = [[AppointedQuestionVC alloc] init];
    
    ViewModel *model = self.viewModelArr[num];
    
    appointedQueVC.post_id = model.queModel.post_id;
    appointedQueVC.headModel = model.queModel;
    [self.navigationController pushViewController:appointedQueVC animated:YES];
    
}


#pragma mark  跳转至解答页面
- (void)replyButtonClick:(UIButton *)sender{
    
    MyReplyViewController *myReplyVC = [[MyReplyViewController alloc] init];
    
    ViewModel *vModel = self.viewModelArr[sender.tag - 10000];
    
    myReplyVC.model = vModel.queModel;
    
    NSLog(@"labawodexiaobaobei    %ld",sender.tag);
    
    [self.navigationController pushViewController:myReplyVC animated:YES];
    
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
