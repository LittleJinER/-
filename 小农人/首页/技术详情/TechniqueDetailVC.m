//
//  TechniqueDetailVC.m
//  小农人
//
//  Created by tomusng on 2017/9/23.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "TechniqueDetailVC.h"
#import "TechniqueDetailCell.h"
#import "TechniqueDetaModel.h"
#import "LLSearchView.pch"
#import "FirstHttpRequestManager.h"
#import "UIImageView+WebCache.h"
#import "WriteFormulaVC.h"


#define KScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height


#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]


#define MyDefaults [NSUserDefaults standardUserDefaults]

#define KHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYSearchhistories.plist"]

#define KColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]

#define BG_COLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]



@interface TechniqueDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat textOriginHeight;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation TechniqueDetailVC

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
    NSLog(@"fzff ****** :  %@",self.qsModel.fzff);
    self.view.backgroundColor = BG_COLOR;
    
    
    
    [self createTableUI];
    [self createSegmentUI];
    
    [self getTechniqueDetailData];
    
    
    
}


- (void)setQsModel:(QuestionModel *)qsModel{
    
    _qsModel = qsModel;
    
    
}


- (void)createSegmentUI{
    
    
    CGFloat space = 10*DISTANCE_WIDTH;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
//    图片
    UIImageView *headImg = [[UIImageView alloc] init];
    NSString *imgStr = self.qsModel.lbzp;
    [headImg sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@""]];
    headImg.frame = CGRectMake(0, 0, K_WIDTH, 150*DISTANCE_HEIGHT);
    headImg.backgroundColor = [UIColor greenColor];
    [bgView addSubview:headImg];
    
//    名字
    UILabel *nameLab = [[UILabel alloc] init];
    
    nameLab.frame = CGRectMake(space, CGRectGetMaxY(headImg.frame) + space, K_WIDTH- 2*space, 20*DISTANCE_HEIGHT);
    nameLab.font = [UIFont systemFontOfSize:17*DISTANCE_HEIGHT];
    nameLab.textColor = [UIColor grayColor];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.text = self.qsModel.titleName;
    
    [bgView addSubview:nameLab];
    
//    类型
    
    UILabel *typeLab = [[UILabel alloc] init];
    
    CGRect typeLRect = [self.qsModel.fbwh boundingRectWithSize:CGSizeMake(K_WIDTH - 2*space, K_WIDTH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*DISTANCE_HEIGHT]} context:nil];
    
    CGFloat typeLHeight = typeLRect.size.height;
    
    typeLab.frame = CGRectMake(space, CGRectGetMaxY(nameLab.frame) + space, K_WIDTH - 2*space, typeLHeight);
    typeLab.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
    typeLab.numberOfLines = 0;
    typeLab.textColor = [UIColor grayColor];
    typeLab.textAlignment = NSTextAlignmentLeft;
    typeLab.text = self.qsModel.fbwh;
    
    [bgView addSubview:typeLab];

    
    
//    segment
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"危害特征",@"发生规律",@"防止方法",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(space,CGRectGetMaxY(typeLab.frame)+space,K_WIDTH - 2*space,30*DISTANCE_HEIGHT);
    // 设置默认选择项索引
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = DE_RED_Color;
    
    [segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    
    [bgView addSubview:segmentedControl];

    
    _textOriginHeight = CGRectGetMaxY(segmentedControl.frame);
    
//    病虫害三个叙述label
    UILabel *textLab = [[UILabel alloc] init];
    
    CGRect textLabRect = [self.qsModel.whtz boundingRectWithSize:CGSizeMake(K_WIDTH - 2*space, K_WIDTH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*DISTANCE_HEIGHT]} context:nil];
    
    CGFloat textLabHeight = textLabRect.size.height;
    
    textLab.frame = CGRectMake(space, CGRectGetMaxY(segmentedControl.frame) + space, K_WIDTH - 2*space, textLabHeight);
    textLab.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
    textLab.numberOfLines = 0;
    textLab.textColor = [UIColor grayColor];
    textLab.textAlignment = NSTextAlignmentLeft;
    textLab.text = self.qsModel.whtz;
    [bgView addSubview:textLab];

    _textLab = textLab;
    
    bgView.frame = CGRectMake(0, 0, K_WIDTH, CGRectGetMaxY(textLab.frame) + 10*DISTANCE_HEIGHT);
    
    _bgView = bgView;
    
    _tableView.tableHeaderView = bgView;
}



-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger index = Seg.selectedSegmentIndex;
//    NSLog(@"Index %li", (long)index);
    
    CGFloat space = 10*DISTANCE_WIDTH;
    switch (index) {
        case 0:
        {
            _textLab.text = self.qsModel.whtz;
            
           }
           
            break;
        case 1:
            
        {
            _textLab.text = self.qsModel.fsgl;
        }
            break;
        case 2:{
            
            _textLab.text = self.qsModel.fzff;
            
        }
            
            break;
            
        default:
            break;
    }
    
    CGRect textLabRect = [_textLab.text boundingRectWithSize:CGSizeMake(K_WIDTH - 2*space, K_WIDTH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*DISTANCE_HEIGHT]} context:nil];
    
    CGFloat textLabHeight = textLabRect.size.height;
    
    _textLab.frame = CGRectMake(space, _textOriginHeight + space, K_WIDTH - 2*space, textLabHeight);
    
    
    
    _bgView.frame = CGRectMake(0, 64, K_WIDTH, CGRectGetMaxY(_textLab.frame) + space);
    
    _tableView.tableHeaderView = _bgView;
    
}

- (void)createTableUI{
    
    
    
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 64, K_WIDTH, K_HEIGHT - 64);
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    [tableView registerClass:[TechniqueDetailCell class] forCellReuseIdentifier:@"cellID"];
    
//    [self getTechniqueData];

    
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return self.dataArr.count;
    
    if (section == 0) {
        return 20;
    }else{
        return 0;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TechniqueDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[TechniqueDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    return cell;
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30*DISTANCE_HEIGHT;
}

//自定义表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        CGFloat space = 12*DISTANCE_HEIGHT;
        
        UIView *headerView = [[UIView alloc] init];
        headerView.frame = CGRectMake(0, 0, K_WIDTH, 30*DISTANCE_HEIGHT);
        headerView.backgroundColor = BG_COLOR;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = DE_RED_Color;
        lineView.frame = CGRectMake(space/2, space/2, 5*DISTANCE_WIDTH, 18*DISTANCE_HEIGHT);
        lineView.layer.cornerRadius = space/4;
        lineView.clipsToBounds = YES;
        [headerView addSubview:lineView];
        
        UILabel *wayLab = [[UILabel alloc] init];
        wayLab.frame = CGRectMake(CGRectGetMaxX(lineView.frame) + space/2, space/2, 100, 18*DISTANCE_HEIGHT);
        wayLab.font = [UIFont systemFontOfSize:16*DISTANCE_HEIGHT];
        wayLab.text = @"配方";
        wayLab.textColor = [UIColor grayColor];
        [headerView addSubview:wayLab];
        
        
        return headerView;

    }else{
        
        
        CGFloat btnWidth = 100*DISTANCE_WIDTH;
        CGFloat btnHeight = 30*DISTANCE_HEIGHT;
        
        UIView *footerView = [[UIView alloc] init];
        
        footerView.frame = CGRectMake(0, 0, K_WIDTH, 30*DISTANCE_HEIGHT);
        
        footerView.backgroundColor = [UIColor whiteColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        button.frame = CGRectMake( (K_WIDTH - btnWidth)/2 , 0, btnWidth, btnHeight);
        
        [button setTitle:@"我有配方" forState:UIControlStateNormal];
        
        [button setTitleColor:DE_RED_Color forState:UIControlStateNormal];
        
        [button setBackgroundColor:[UIColor whiteColor]];
        
        [button setBackgroundColor:[UIColor whiteColor]];
        
        [button.layer setBorderWidth:0.5*DISTANCE_HEIGHT];
        
        button.layer.cornerRadius = 5*DISTANCE_HEIGHT;
        
        button.clipsToBounds = YES;
        [button.layer setMasksToBounds:YES];
        
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){252.0/255, 86.0/255, 56.0/255, 1});
        [button.layer setBorderColor:color];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [footerView addSubview:button];
        
        return footerView;

    }
}

#pragma mark    --   uiscrollviewdelegate方法   ---  让表头随着表移动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 30*DISTANCE_HEIGHT;
    if (scrollView.contentOffset.y <= 30*DISTANCE_HEIGHT && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark --  去写配方
- (void)buttonClick:(UIButton *)sender{
    
    NSLog(@"我有配方");
    WriteFormulaVC *writeVC = [[WriteFormulaVC alloc] init];
    
    [self.navigationController pushViewController:writeVC animated:YES];
    
}



#pragma mark   -- 懒加载dataArr
- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
    
    
    
}
#pragma mark   --   网络数据请求  ---  配方 --
- (void)getTechniqueDetailData{
    
    NSString *str = [NSString stringWithFormat:TOM_HOST_CROP_ID,@"api",@"Tom",@"search_user_official",oauth_token,oauth_token_secret,(int)self.qsModel.post_id];
    
    //            [];
    //            NSString *str = [NSString stringWithFormat:TOM_HOST,@"api",@"Weiba",@"get_all_user",oauth_token,oauth_token_secret];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [FirstHttpRequestManager searchExpertInfoWithUrl:encode WithBlock:^(NSArray * _Nullable array) {
        
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
