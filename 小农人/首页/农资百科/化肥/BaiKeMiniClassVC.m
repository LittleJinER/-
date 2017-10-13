//
//  BaiKeMiniClassVC.m
//  小农人
//
//  Created by tomusng on 2017/9/29.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "BaiKeMiniClassVC.h"
#import "BaiKeMiniClassModel.h"
#import "FirstHttpRequestManager.h"
#import "LLSearchView.pch"
#import "BaiKeClassViewModel.h"
#import "BaiKeMiniClassCell.h"
#import "BaiKeMiniClassModel.h"

#define ViewWidth [[UIScreen mainScreen] bounds].size.width
#define ViewHeight [[UIScreen mainScreen] bounds].size.height - 64 - MENU_HEIGHT - LINE_HEIGHT

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]
#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]
#define BG_COLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]
#define LIGHT_TITLE_COLOR [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1]

#define CUSTOM_COLOR(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]

#define LINE_HEIGHT 0.5*DISTANCE_WIDTH

#define MENU_BUTTON_WIDTH  [UIScreen mainScreen].bounds.size.width/4.0
#define MENU_HEIGHT 44*DISTANCE_WIDTH
#define ITEM_HEIGHT 38*DISTANCE_WIDTH

@interface BaiKeMiniClassVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *basisArr;

@property (nonatomic, strong) NSMutableArray *extendedArr;

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) UILabel *textLab;

@property (nonatomic, copy) NSMutableArray *textArr;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) CGFloat footerHeight;

@end

@implementation BaiKeMiniClassVC

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = self.titleName;
    self.view.backgroundColor = CUSTOM_COLOR(248, 248, 248);
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:@"home_navigation_back_btn"];
    leftBtn.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [leftBtn setImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    
    [self createTableUI];
    [self getClassDetailData];
    
}

- (void)createTableUI{
    
    
    UITableView *table = [[UITableView alloc] init];
    table.frame = CGRectMake(0, 64+ 50*DISTANCE_HEIGHT, K_WIDTH, K_HETGHT - (64+ 50*DISTANCE_HEIGHT));
    table.backgroundColor = [UIColor whiteColor];
    table.delegate = self;
    table.dataSource = self;
    [table registerClass:[BaiKeMiniClassCell class] forCellReuseIdentifier:@"cellID"];
    _table = table;
    [self.view addSubview:table];

    _footerHeight = 200.0*DISTANCE_HEIGHT;
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
      return self.basisArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BaiKeMiniClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell) {
        
        cell = [[BaiKeMiniClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    if (self.basisArr.count == 0) {
        
    }else{
        BaiKeClassViewModel *baiKVM = self.basisArr[indexPath.row];
        
        cell.baiDVM = baiKVM;

    }
    
       return cell;
}

- (NSMutableArray *)textArr{
    
    if (!_textArr) {
        _textArr = [NSMutableArray array];
    }
    return _textArr;
    
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (self.basisArr.count != 0) {
            BaiKeClassViewModel *baiKVM = self.basisArr[indexPath.row];
            return baiKVM.cellHeight;
        }
    }
    
    

    return 0;
    
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    if (section == 0) {
        CGFloat space = 10*DISTANCE_WIDTH;
        
        UIView *bgView = [[UIView alloc] init];
        //    segment
        //    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"危害特征",@"发生规律",@"防止方法",nil];
        
        
        NSMutableArray *segmentedArray = [NSMutableArray array];
        
        
        for (BaiKeMiniClassModel *classModel in self.extendedArr) {
            [segmentedArray addObject:classModel.key];
            [self.textArr addObject:classModel.value];
        }
        
        //初始化UISegmentedControl
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
        segmentedControl.frame = CGRectMake(space,3*space,K_WIDTH - 2*space,3*space);
        // 设置默认选择项索引
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.tintColor = DE_RED_Color;
        
        [segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
        
        [bgView addSubview:segmentedControl];
        
        //    百科种类三个叙述label
        UILabel *textLab = [[UILabel alloc] init];
        
        for (BaiKeMiniClassModel *classModel in self.extendedArr) {
            [self.textArr addObject:classModel.value];
        }
        
        
        CGRect textLabRect = [_textArr[0] boundingRectWithSize:CGSizeMake(K_WIDTH - 2*space, K_WIDTH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*DISTANCE_HEIGHT]} context:nil];
        
        CGFloat textLabHeight = textLabRect.size.height;
        textLab.text = _textArr[0];
        textLab.frame = CGRectMake(space, 6*space + space, K_WIDTH - 2*space, textLabHeight);
        textLab.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
        textLab.numberOfLines = 0;
        textLab.textColor = [UIColor grayColor];
        textLab.textAlignment = NSTextAlignmentLeft;
        textLab.text = _textArr[0];
        [bgView addSubview:textLab];
        
        
        
        _textLab = textLab;
        
        bgView.frame = CGRectMake(0, 0, K_WIDTH, CGRectGetMaxY(textLab.frame) + 10*DISTANCE_HEIGHT);
        
        _bgView = bgView;
        
        NSLog(@"dddd UIView *bgView = [[UIView alloc] init];");
        
        _footerHeight = CGRectGetMaxY(bgView.frame) + space;
        
        return _bgView;

    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    
    
    
    
    return _footerHeight;
    
    
    
    
    
    
}

-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger index = Seg.selectedSegmentIndex;
    //    NSLog(@"Index %li", (long)index);
    
    CGFloat space = 10*DISTANCE_WIDTH;
    switch (index) {
        case 0:
        {
            _textLab.text = _textArr[0];
            
        }
            
            break;
        case 1:
            
        {
            _textLab.text = _textArr[1];
        }
            break;
        case 2:{
            
            _textLab.text = _textArr[2];
            
        }
            
            break;
            
        default:
            break;
    }
    
    CGRect textLabRect = [_textLab.text boundingRectWithSize:CGSizeMake(K_WIDTH - 2*space, K_WIDTH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*DISTANCE_HEIGHT]} context:nil];
    
    CGFloat textLabHeight = textLabRect.size.height;
    
    _textLab.frame = CGRectMake(space, 6*space + space, K_WIDTH - 2*space, textLabHeight);
    
    _bgView.frame = CGRectMake(0, 64, K_WIDTH, CGRectGetMaxY(_textLab.frame) + space);
    
    _footerHeight = CGRectGetMaxY(_bgView.frame) + space;
    
    [_table reloadData];
    
}









- (NSMutableArray *)basisArr{
    
    if (!_basisArr) {
        _basisArr = [NSMutableArray array];
    }
    return _basisArr;
}

- (NSMutableArray *)extendedArr{
    
    if (!_extendedArr) {
        _extendedArr = [NSMutableArray array];
    }
    return _extendedArr;
}


- (void)getClassDetailData{
    NSString *str = [NSString stringWithFormat:C_HOST_API,@"/wiki/get_detail"];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = @{@"aid":@(self.aid)};
    
    __weak BaiKeMiniClassVC *weakSelf = self;
    [FirstHttpRequestManager postChildEverySpeciesDetailedInfoWithUrl:encode WithDic:dic WithBlock:^(NSArray * _Nullable array) {
        
//        [weakSelf.basisArr addObjectsFromArray:array[0]];
        for (BaiKeMiniClassModel *baiKDModel in array[0]) {
            
            BaiKeClassViewModel *baiKVM = [[BaiKeClassViewModel alloc] init];
            
            baiKVM.baiKDModel = baiKDModel;
            
            [weakSelf.basisArr addObject:baiKVM];
            
        }
        
        [weakSelf.extendedArr addObjectsFromArray:array[1]];
        
        
        
//        weakSelf.table.frame = CGRectMake(0, 64+ 50*DISTANCE_HEIGHT, K_WIDTH, ));
        [weakSelf.table reloadData];
    }];
    
    
    
}


//- (void)createUI{

//    CGFloat space = 10*DISTANCE_WIDTH;
//    for (int i = 0; i < self.basisArr.count; i ++) {
//        
//        BaiKeMiniClassModel *basisM = _basisArr[i];
//        UILabel *basisLab = [[UILabel alloc] init];
//        
//        basisLab.text = [NSString stringWithFormat:@"%@%@",basisM.key,basisM.value];
//        
//        CGRect basisRect = [basisLab.text boundingRectWithSize:CGSizeMake(K_WIDTH - 2*space, 500*DISTANCE_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*DISTANCE_HEIGHT]} context:nil];
//        
//        basisLab.frame = CGRectMake(space, 64 + 50*DISTANCE_HEIGHT + , <#CGFloat width#>, <#CGFloat height#>)
//        
//        
//    }
//    
    
    
//}








- (void)leftBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
