//
//  Q_AppointedCropViewControllerViewController.m
//  小农人
//
//  Created by tomusng on 2017/8/30.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "Q_AppointedCropViewControllerViewController.h"
#import "QTableViewCell.h"
#import "ViewModel.h"
//#import "MJRefresh.h"
//#import "Model.h"
#import "QuestionModel.h"
#import "Q_AHttpRequestManager.h"
#import "FaTextField.h"
#import "UIColor+SWAddition.h"
#import "LLSearchViewController.h"
#import "AppointedQuestionVC.h"
#import "TBRefresh.h"
#import "FirstViewController.h"//专家列表页
#import "PictureViewController.h"//上传问题页面
#import "MyReplyViewController.h"//我解答页面
#import "LLSearchView.pch"



#define DEF_Screen_Width [UIScreen mainScreen].bounds.size.width
#define DEF_Screen_Height [UIScreen mainScreen].bounds.size.height


@interface Q_AppointedCropViewControllerViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    FaTextField *_textField;
}

@property (nonatomic, strong) UIView *bgView;

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


@property (strong, nonatomic) UIImageView *expertView;
@property (strong, nonatomic) UIImageView *questionView;


@end


@implementation Q_AppointedCropViewControllerViewController


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



#pragma mark - 控制器生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    
     [self setUpUI];
    
    
    
}


- (void)setUpUI{
    
    //    设置搜索框
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(20, 10, DEF_Screen_Width - 40, 30)];
    
    
    //设置圆角效果
    _bgView.layer.cornerRadius = 14;
    _bgView.layer.masksToBounds = YES;
    
    _bgView.backgroundColor = [UIColor sw_colorWithR:255 G:255 B:255];
    _textField = [[FaTextField alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.bgView.frame) - 10, CGRectGetHeight(_bgView.frame))];
    _textField.font = [UIFont systemFontOfSize:13];
    
    //清除按钮
    _textField.clearButtonMode =UITextFieldViewModeWhileEditing;
    
    _textField.delegate = self;
    //键盘属性
    //    _textField.returnKeyType = UIReturnKeySearch;
    
    //为textField设置属性占位符
    //    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索问题" attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
    _textField.placeholder = @"搜索问题";
    _textField.textColor = [UIColor blackColor];
    _textField.textAlignment = NSTextAlignmentCenter;
    
    [_bgView addSubview:_textField];
    
    UIImage *searchImage = [UIImage imageNamed:@"commen_search"];
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, searchImage.size.width, searchImage.size.height)];
    searchImageView.image = searchImage;
    searchImageView.contentMode = UIViewContentModeCenter;
    _textField.leftView = searchImageView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    //    [self.view addSubview:bgView];
    
    [self creatExpertView];
    
}

#pragma mark -----创建专家view   ---   专家与问答    -----
- (void)creatExpertView{
    
    UIImage *expertImage = [UIImage imageNamed:@"go_expert"];
    CGFloat imgWidth = expertImage.size.width;
    CGFloat imgHeight = expertImage.size.height;
    //等比例拉伸
    CGFloat expertHeight = (imgHeight * (DEF_Screen_Width - 1)/2)/imgWidth;
    
    UIImageView *expertView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bgView.frame)+20, (DEF_Screen_Width-1)/2.0, expertHeight)];
    expertView.image = [UIImage imageNamed:@"go_expert"];
    
    UIImageView *questionView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(expertView.frame)+1, CGRectGetMinY(expertView.frame), CGRectGetWidth(expertView.frame), CGRectGetHeight(expertView.frame))];
    questionView.image = [UIImage imageNamed:@"go_answer"];
    
    //    [self.view addSubview:expertView];
    //    [self.view addSubview:questionView];
    
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_Screen_Width, CGRectGetMaxY(questionView.frame))];
    [backGroundView addSubview:self.bgView];
    backGroundView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
//    [backGroundView addSubview:self.menu];
    [backGroundView addSubview:expertView];
    [backGroundView addSubview:questionView];
    
    //    CGFloat meauHeight = CGRectGetMaxY(self.menu.frame);
    //    NSLog(@"作物视图高度%f",meauHeight);
    
    //    CGFloat backHeight = CGRectGetMaxY(backGroundView.frame);
    //    NSLog(@"背景视图高度%f",backHeight);
    
    self.tableView.tableHeaderView = backGroundView;
    self.tableView.tableFooterView = [UIView new];
    
    
    [expertView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidCLick:)]];
    
    [questionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidCLick:)]];
    [expertView setUserInteractionEnabled:YES];
    [questionView setUserInteractionEnabled:YES];
    _expertView = expertView;
    _questionView = questionView;
    
    
    
}

#pragma mark - 问专家imageview的手势方法   - 快速提问imageview的手势方法  (两个imageview不能用同一个UITapGestureRecognizer对象)
- (void)imageViewDidCLick:(UITapGestureRecognizer *)gestureRecognizer
{
    NSLog(@"click");
    
    NSLog(@"%d",[gestureRecognizer isMemberOfClass:[UIGestureRecognizer class]]);
    
    UIView *viewClicked = [gestureRecognizer view];
    if (viewClicked == _expertView) {
        
        FirstViewController *expertVC = [[FirstViewController alloc] init];
        
        [self.navigationController pushViewController:expertVC animated:YES];
        
    }else{
        
        PictureViewController *picVC = [[PictureViewController alloc] init];
        [self.navigationController pushViewController:picVC animated:NO];
        
        
    }
    
    
    
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
    
    NSString *str = [NSString stringWithFormat:TOM_HOST_CROP_NAME,@"api",@"Tom",@"get_posts",oauth_token,oauth_token_secret,self.cropName];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    
//    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=get_posts&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&keyword=%@",self.cropName];
    NSLog(@"vvvvvvvv   %@",self.cropName);
//    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [Q_AHttpRequestManager getQuestionInfoWithUrl:encode WithBlock:^(NSArray * _Nullable array) {
        
        
        
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
                        
                        NSString *picStr = [NSString stringWithFormat:TOM_CRAZY,secondStr];
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
        
        NSLog(@"%ld",array.count);
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
    __weak Q_AppointedCropViewControllerViewController *weakself = self;
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
    
    cell.replyButton.tag = indexPath.row + 10000;
    [cell.answerButton addTarget:self action:@selector(answerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
    
    [_textField resignFirstResponder];
    LLSearchViewController *seachVC = [[LLSearchViewController alloc] init];
    [self.navigationController pushViewController:seachVC animated:YES];
    
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
