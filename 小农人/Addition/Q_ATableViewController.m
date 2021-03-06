//
//  Q_ATableViewController.m
//  小农人
//
//  Created by tomusng on 2017/8/26.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "Q_ATableViewController.h"//本页
#import "UIColor+SWAddition.h"
#import "LLSearchViewController.h"//搜索页面
#import "FaTextField.h"//搜索框父类
#import "UIImageView+WebCache.h"//网络加载图片第三方
#import "DetailedClassificationViewController.h"// 点选关注农作物页面
#import "DataSource.h"//
#import "Q_AHttpRequestManager.h"// 网络请求集合
#import "selectCropModel.h"// 关注农作物model
#import "ViewModel.h"// 问题列表model
#import "QuestionModel.h"//网络请求时问题列表接收model
//#import "MJRefresh.h"
#import "QTableViewCell.h"//自定义问题列表cell
#import "Q_AppointedCropViewControllerViewController.h" // 进入农作物专有页面
#import "AppointedQuestionVC.h"  //指定问题页面
#import "FirstViewController.h"  //专家列表页面
#import "PictureViewController.h" //快速提问页面
#import "MyReplyViewController.h" //我解答页面
#import "TBRefresh.h"//刷新控件
#import "SQPhotosManager.h" //放大图片的类
#import "LLSearchView.pch"


#define ItemHeight 90
#define IMG(name)           [UIImage imageNamed:name]

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height

#define BG_COLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]

@interface Q_ATableViewController ()<UITextFieldDelegate,YANScrollMenuProtocol,DetailCategoryDelegate,UITableViewDelegate,UITableViewDataSource>{
    FaTextField *_textField;
    
    NSInteger row;
    NSInteger item;
    
}

@property (nonatomic, strong) UISearchBar *myBar;
@property (nonatomic, strong) YANScrollMenu *menu;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray<DataSource *> *dataSource;/**
                                                                        *  dataSour
                                                                        */

@property (strong, nonatomic) NSArray *imageViews;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *urlImages;

/**
 *  视图模型
 */
@property (strong, nonatomic) ViewModel *vm;

/**
 *  模型数组
 */
@property (strong, nonatomic) NSMutableArray *viewModelArr;

@property (strong, nonatomic) UIImageView *expertView;
@property (strong, nonatomic) UIImageView *questionView;


@end

@implementation Q_ATableViewController


#pragma mark --   懒  加   载
- (NSMutableArray<DataSource *> *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    self.title = @"问答";
//    设置cell的分割线
    self.tableView.separatorColor = [UIColor clearColor];
    
    __weak Q_ATableViewController *weakself=self;
    self.tableView.frame = CGRectMake(0, 0, K_WIDTH, K_HETGHT - 64);
    
    [self.tableView addRefreshHeaderWithBlock:^{
        
        [weakself LoadUpdateDatas];
        
    }];
    
    [self.tableView addRefreshFootWithBlock:^{
        
        [weakself LoadMoreDatas];
    }];

    
    
    
//    设置关注作物每行放的cell个数
    item = 5;
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
    //GCD
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        
        [self createData];
        [self getData];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [self setUpUI];
            
        });
    });

}

- (void)setUpUI{
    
//    设置搜索框
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(20, 10, K_WIDTH - 40, 30)];
    
    
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
    
    [self prepareUI];
    
}



#pragma mark - Prepare UI----设置关注农作物  --  collectionview-
- (void)prepareUI{
    
    self.menu = [[YANScrollMenu alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgView.frame) + 10, self.view.frame.size.width, ItemHeight*row + kPageControlHeight)];
    self.menu.currentPageIndicatorTintColor = [UIColor colorWithRed:107/255.f green:191/255.f blue:255/255.f alpha:1.0];
    self.menu.delegate = self;
//    self.tableView.tableHeaderView = self.menu;
//    self.tableView.tableFooterView = [UIView new];
    
    [YANMenuItem appearance].textFont = [UIFont systemFontOfSize:12];
    [YANMenuItem appearance].textColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.0];
    
    [self creatExpertView];
    
    
}

#pragma mark -----创建专家view   ---   专家与问答    -----
- (void)creatExpertView{
    
    
    UIImage *expertImage = [UIImage imageNamed:@"go_expert"];
    CGFloat imgWidth = expertImage.size.width;
    CGFloat imgHeight = expertImage.size.height;
    //等比例拉伸
    CGFloat expertHeight = (imgHeight * (K_WIDTH - 1)/2)/imgWidth;

    
    UIImageView *expertView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.menu.frame)+60, (K_WIDTH-1)/2.0, expertHeight)];
    expertView.image = [UIImage imageNamed:@"go_expert"];
    
    
    UIImageView *questionView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(expertView.frame)+1, CGRectGetMinY(expertView.frame), CGRectGetWidth(expertView.frame), CGRectGetHeight(expertView.frame))];
    questionView.image = [UIImage imageNamed:@"go_answer"];
    
//    [self.view addSubview:expertView];
//    [self.view addSubview:questionView];
    
   
    [expertView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidCLick:)]];
    
    [questionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidCLick:)]];
    [expertView setUserInteractionEnabled:YES];
    [questionView setUserInteractionEnabled:YES];
    _expertView = expertView;
    _questionView = questionView;
    
    
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_WIDTH, CGRectGetMaxY(questionView.frame))];
    [backGroundView addSubview:self.bgView];
    [backGroundView addSubview:self.menu];
    [backGroundView addSubview:expertView];
    [backGroundView addSubview:questionView];
    
    self.tableView.tableHeaderView = backGroundView;
    self.tableView.tableFooterView = [UIView new];
    
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


#pragma mark -  Data----请求数据  ---  请求关注农作物数据 -
- (void)createData{
    
    
    NSString *str = [NSString stringWithFormat:TOM_HOST,@"api",@"Tom",@"get_follow_weiba",oauth_token,oauth_token_secret];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    [Q_AHttpRequestManager getSelectedCrop:encode withBlock:^(NSMutableArray *array) {
        
        [self.dataSource addObjectsFromArray:array];
        
//        DataSource *model = _dataSource[1];
//        NSLog(@"%@",model.weiba_name);
        [self reload:self.navigationItem.rightBarButtonItem];
    
    }];
    
}

#pragma mark ----------dataSourceDelegate方法----------
- (void)sendDataSource:(NSMutableArray<DataSource *> *)dataSource{
    NSLog(@"dataSourceDelegate方法");
    self.dataSource = nil;
    [self createData];
    
}

#pragma mark - YANScrollMenuProtocol
- (NSUInteger)numberOfRowsForEachPageInScrollMenu:(YANScrollMenu *)scrollMenu{
    
    return row;
}
- (NSUInteger)numberOfItemsForEachRowInScrollMenu:(YANScrollMenu *)scrollMenu{
    
    return item;
}
- (NSUInteger)numberOfMenusInScrollMenu:(YANScrollMenu *)scrollMenu{
    
    return self.dataSource.count;
}
- (id<YANMenuObject>)scrollMenu:(YANScrollMenu *)scrollMenu objectAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger idx = indexPath.section * item + indexPath.row;
    
    return self.dataSource[idx];
}

#pragma mark ------item的点击事件------
- (void)scrollMenu:(YANScrollMenu *)scrollMenu didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
   NSUInteger idx = indexPath.section * item + indexPath.row;
    
    NSString *cropsStr = self.dataSource[idx].weiba_name;
    
    if ([cropsStr isEqualToString:@"添加作物"]) {
//       跳入关注农作物页面
        DetailedClassificationViewController *VC = [[DetailedClassificationViewController alloc] init];
       
        VC.dataSourceDelegate = self;
       
        [self.navigationController pushViewController:VC animated:YES];
    }
    else{
    
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:tips preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            [alert dismissViewControllerAnimated:YES completion:nil];
//            
//        }];
//        [alert addAction:action];
//        [self.navigationController presentViewController:alert animated:YES completion:nil];

//    NSLog(@"lsjaflajsflasjflsajflsajflasjfslfjasdlj");
    //        跳入至指定农作物问题页面
        
        
    Q_AppointedCropViewControllerViewController *qAppointedCropVC = [[Q_AppointedCropViewControllerViewController alloc] init];
    
        qAppointedCropVC.cropName = cropsStr;
        
    [self.navigationController pushViewController:qAppointedCropVC animated:YES];
    
    }
}
- (YANEdgeInsets)edgeInsetsOfItemInScrollMenu:(YANScrollMenu *)scrollMenu{
    
    return YANEdgeInsetsMake(kScale(10), 0, kScale(5), 0, kScale(5));
}
- (IBAction)reload:(id)sender {
    
    self.tableView.tableHeaderView = nil;
    
    CGRect frame = self.menu.frame;
    frame.size.height = row * ItemHeight + kPageControlHeight;
    self.menu.frame = frame;
    
    self.tableView.tableHeaderView = self.menu;

    
    DataSource *object = [[DataSource alloc] init];
    object.weiba_name = @"添加作物";
    object.image = IMG(@"question_add_crop");
    [self.dataSource addObject:object];
    
    if (self.dataSource.count > 10) {
        
        for (NSUInteger i = 9; i < _dataSource.count ; i = i + 10) {
            DataSource *object = [[DataSource alloc] init];
            object.text = @"添加作物";
            object.image = IMG(@"question_add_crop");
            [self.dataSource insertObject:object atIndex:i];
        }
        
        if (_dataSource.count%10 == 1) {
            
            
            [self.dataSource removeLastObject];
            
        }
        
    }
    if (self.dataSource.count == 0) {
        [self.dataSource addObject:object];
    }
    
    if (_dataSource.count < 6) {
        row = 1;
    }else{
        row = 2;
    }
   
    [self setUpUI];
    
}

#pragma mark 搜索框的点击事件  textField
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [_textField resignFirstResponder];
    LLSearchViewController *seachVC = [[LLSearchViewController alloc] init];
    [self.navigationController pushViewController:seachVC animated:YES];
    
}



#pragma mark -------          tableView            -------------

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


#pragma mark   --  问题列表
- (void)getData{
    __weak __typeof(self) weakSelf = self;
    
    NSString *str = [NSString stringWithFormat:TOM_HOST,@"api",@"Tom",@"get_posts",oauth_token,oauth_token_secret];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
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
            
//            [weakSelf.tableView.mj_header endRefreshing];
        }
        [weakSelf.tableView reloadData];
//        NSLog(@"%ld",array.count);
        
    }];
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
    
    
    
    NSInteger num = indexPath.row;
    
    AppointedQuestionVC *appointedQueVC = [[AppointedQuestionVC alloc] init];
    
    ViewModel *model = self.viewModelArr[num];
    
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
    
//    设置cell的分割线（貌似没用）
    cell.separatorInset = UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);

    //当点击cell时，cell状态不发生变化
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.delegate = self;
    cell.replyButton.tag = indexPath.row + 10000;
    
    cell.answerButton.tag = indexPath.row + 100000;
    
    [cell.replyButton addTarget:self action:@selector(replyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.answerButton addTarget:self action:@selector(answerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
       return cell;
}



#pragma mark  跳转至解答页面
- (void)replyButtonClick:(UIButton *)sender{
    
    MyReplyViewController *myReplyVC = [[MyReplyViewController alloc] init];
    
    ViewModel *vModel = self.viewModelArr[sender.tag - 10000];
    
    myReplyVC.model = vModel.queModel;
    
    NSLog(@"labawodexiaobaobei    %ld",sender.tag);
    
    [self.navigationController pushViewController:myReplyVC animated:YES];
    
}

- (void)answerButtonClick:(UIButton *)sender{
    
    NSLog(@"%ld",sender.tag);
    
    NSInteger num = sender.tag - 100000;
    
    AppointedQuestionVC *appointedQueVC = [[AppointedQuestionVC alloc] init];
    
    ViewModel *model = self.viewModelArr[num];
    
    appointedQueVC.post_id = model.queModel.post_id;
    appointedQueVC.headModel = model.queModel;
    [self.navigationController pushViewController:appointedQueVC animated:YES];
    
}

//- (void)choseQItem:(UIButton *)button{
//    
//    NSLog(@"%ld",button.tag);
//    
//}
//



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
