//
//  FirstViewController.m
//  segmentAndListDemo
//
//  Created by zwm on 15/5/26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "FirstViewController.h"
#import "WMTabControl.h"
#import "WMDropDownView.h"


#import "SABookModel.h"
#import "MJExtension.h"
#import "SABookModelTBCell.h"


#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define disten   [UIScreen mainScreen].bounds.size.height/667.0

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *_one;
    NSMutableArray *_two;
    NSMutableArray *_three;
    NSArray *_total;
    NSMutableArray *_totalIndex;

    NSInteger _segIndex;
}
//@property (weak, nonatomic) IBOutlet WMTabControl *tabControl;

@property (nonatomic,strong) WMTabControl *tabControl;

@property (nonatomic,strong) NSMutableArray *  dataArr;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 1.设置数据和初始索引
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tabControl = [[WMTabControl alloc]init];
    _tabControl.frame = CGRectMake(0, 64, WIDTH, 40);
    [self.view addSubview:_tabControl];
    
    [self createTableView];
    [self createSearchBar];
    
    _one = [NSMutableArray arrayWithObjects:@"全部", @"金", @"木", @"水", @"火", nil];
    _two = [NSMutableArray arrayWithObjects:@"区域", @"东", @"南", @"西", @"北", nil];
//    _three = [NSMutableArray arrayWithObjects:@"薪资", @"10000", @"20000", @"30000", @"40000", @"110000", @"120000", @"130000", @"140000", nil];
    _total = @[_one, _two];
    _totalIndex = [NSMutableArray arrayWithObjects:@0, @0, nil];
    __weak typeof(self) weakSelf = self;
    [_tabControl setItemsWithTitleArray:@[_one[0], _two[0]]
                          selectedBlock:^(NSInteger index) {
        [weakSelf openList:index];
                              
    }];
//    15*disten;
}

- (void)createSearchBar{
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    
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




- (void)openList:(NSInteger)column
{
    // 3.下拉菜单的处理
    WMDropDownView *listView = (WMDropDownView *)[self.view viewWithTag:9898];
    if (!listView) {
        // 3.1 显示下拉菜单
        _segIndex = column;
        
        NSArray *lists = (NSArray *)_total[column];

        CGFloat y = CGRectGetMaxY(_tabControl.frame);
        CGRect rect = CGRectMake(0, y, CGRectGetWidth(_tabControl.frame), CGRectGetHeight(self.view.frame) - y - 49);

        __weak typeof(self) weakSelf = self;
        WMDropDownView *listView =
            [[WMDropDownView alloc] initWithFrame:rect
                                           titles:lists
                                     defaultIndex:[_totalIndex[column] integerValue]
                                    selectedBlock:^(id title, NSInteger index) {
            [weakSelf changeIndex:index withColumn:column];
        }];
        listView.tag = 9898;
        [self.view addSubview:listView];
        [listView showView];
    } else if (_segIndex != column) {
        // 3.2 已存在下拉菜单，切换展示内容
        _segIndex = column;
        NSArray *lists = (NSArray *)_total[column];
        __weak typeof(self) weakSelf = self;
        [listView changeWithTitles:lists
                      defaultIndex:[_totalIndex[column] integerValue]
                     selectedBlock:^(id title, NSInteger index) {
                         NSLog(@"%@ -------- %ld",title,(long)index);
            [weakSelf changeIndex:index withColumn:column];
        }];
    } else {
        // 3.3 隐藏下拉菜单
        [listView hideView];
    }
}

- (void)changeIndex:(NSInteger)index withColumn:(NSInteger)column
{
    // 4. 用户点击了下拉菜单
    if (index == -1) {
        // 4.1 恢复分段条状态
        [self.tabControl selectIndex:-1];
        return;
    }
    // 4.2 改变对应的记录索引
    [_totalIndex replaceObjectAtIndex:column withObject:[NSNumber numberWithInteger:index]];

    NSLog(@"   ****   %ld *****  %ld",(long)column,(long)index);
    // 4.3 改变分段条的对应项标题，如果不想改变则不执行这条
    [_tabControl setTitle:_total[column][index] withIndex:column];

    NSLog(@"*****    %@   *******",_total[column][index]);
    
    // 4.4 按选择改变内容排序
    [self changeOrder];
}

- (void)changeOrder
{
}


#pragma mark - SABookCellDelegate


- (IBAction)didClickClearButton {
    
    for (SABookModel * bookModel in self.dataArr) {
        
        bookModel.count = 0;
        
    }
    
    [self.tableView reloadData];
    
}

- (IBAction)didClickBuyButton {
    for (SABookModel * bookModel in self.dataArr ) {
        if (bookModel.count) {
            NSLog(@"购买了%ld本{%@}",bookModel.count,bookModel.name);
        }
    }
    
    
}


- (void)createTableView{
    
    CGFloat tabHeight = CGRectGetMaxY(_tabControl.frame);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  tabHeight, WIDTH, HEIGHT - tabHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[SABookModelTBCell class] forCellReuseIdentifier:@"bookCell"];
   
    [self.view addSubview:_tableView];

}




#pragma mark - 数据源方法

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}


- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * kCellID = @"bookCell";
    
    SABookModelTBCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
//    if (!cell) {
//        cell = [[SABookModelTBCell alloc] initWithStyle:UITableViewCellFocusStyleCustom reuseIdentifier:kCellID];
//    }
    
    cell.bookModel = self.dataArr[indexPath.row];
    
    cell.questionBtn.tag = indexPath.row + 10000;
    
    [cell.questionBtn addTarget:self action:@selector(questionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}


- (void)questionClick:(UIButton *)sender{
    
    NSLog(@"%ld",sender.tag);
    
}



#pragma mark - 懒加载
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        
        _dataArr = [SABookModel mj_objectArrayWithFilename:@"books.plist"];
        
    }
    return _dataArr;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"ddddddddd");
    
    
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    // 2.下拉菜单的转屏适配，如不转屏则不用这部分
//    WMDropDownView *listView = (WMDropDownView *)[self.view viewWithTag:9898];
//    if (listView) {
//        CGFloat y = CGRectGetMaxY(_tabControl.frame);
//        listView.frame = CGRectMake(0, y, CGRectGetWidth(_tabControl.frame), CGRectGetHeight(self.view.frame) - y - 49);
//        NSLog(@"%f",listView.frame.size.height);
//
//    }
//
//}







@end
