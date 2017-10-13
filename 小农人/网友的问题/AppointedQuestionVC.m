//
//  AppointedQuestionVC.m
//  小农人
//
//  Created by tomusng on 2017/8/31.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "AppointedQuestionVC.h"

#import "HomeTableHeadView.h"
#import "HomeTableCell.h"
#import "NSString+Font.h"
#import "Header.h"
#import "HeadModel.h"
#import "ManyImageView.h"
#import "Q_AHttpRequestManager.h"
#import "UIImageView+WebCache.h"
#import "MyReplyViewController.h"

#import "LLSearchView.pch"
#import "TBRefresh.h"


#define NumberRow 3 //  设置每行显示的图片数量
#define CollClearance 3 //  图片据上下两边的宽度
#define ImageWidthMargin 3  //    图片据左右两边的宽度





@interface AppointedQuestionVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *homeTable;
@property (nonatomic, strong) NSArray *textArr;
@property (nonatomic, strong) UIView *popView;
@property (nonatomic, strong) UITableView *homeTextView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *appiontedDataArr;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, assign) int judgeSection;
@property (nonatomic) BOOL judgeBOOL;
@property (nonatomic) BOOL clickBOOL;

@property (nonatomic,strong) UIButton *opposeBtn;
@property (nonatomic,strong) UIButton *approveBtn;
@property (nonatomic,strong) NSMutableDictionary *approveDic;

@end

@implementation AppointedQuestionVC

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *collectionImage = [UIImage imageNamed:@"Study_sNav_colleNmal"];
    collectBtn.frame = CGRectMake(0, 0, collectionImage.size.width, collectionImage.size.height);
    [collectBtn setImage:collectionImage forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc] initWithCustomView:collectBtn];
    collectBtn.tag = 110;
    
    UIButton *transmitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *transmitImage = [UIImage imageNamed:@"Study_sNav_share"];
    transmitBtn.frame = CGRectMake(0, 0, transmitImage.size.width, transmitImage.size.height);
    [transmitBtn setImage:transmitImage forState:UIControlStateNormal];
    [transmitBtn addTarget:self action:@selector(transmitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *transmitItem = [[UIBarButtonItem alloc] initWithCustomView:transmitBtn];
    
    self.navigationItem.rightBarButtonItems = @[transmitItem,collectItem];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.judgeBOOL = NO;
    self.clickBOOL = YES;
    self.title = @"网友的问题";

    self.tabBarController.tabBar.hidden = YES;
    
    [self createMyAnswerButton];
    
    [self homeTableInterface];
}

- (void)createMyAnswerButton{
    
    UIView *bgView = [[UIView alloc] init];
    
    bgView.frame = CGRectMake(0, screenHight - TABBAR_HEIGHT, screenWidth, TABBAR_HEIGHT);
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    lineView.frame = CGRectMake(0, 0, screenWidth, 1);
    [bgView addSubview:lineView];
    
    UIButton *myAnsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [myAnsBtn setImage:[UIImage imageNamed:@"home_btn_myanswer_nm"] forState:UIControlStateNormal];
    [myAnsBtn setTitle:@"我解答" forState:UIControlStateNormal];
//    [myAnsBtn setBackgroundColor:[UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]];
    myAnsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    myAnsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
   
//    [myAnsBtn setTintColor:[UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]];
    [myAnsBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [myAnsBtn setTitleColor:[UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1] forState:UIControlStateNormal];
    
//    [myAnsBtn.titleLabel setTextColor:[UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]];
    
    [myAnsBtn setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
    [myAnsBtn setFrame:CGRectMake(30, 10, screenWidth - 60, TABBAR_HEIGHT - 20)];
    myAnsBtn.clipsToBounds = YES;
    myAnsBtn.layer.cornerRadius = 15.0f;
    
    [myAnsBtn addTarget:self action:@selector(myAnsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:myAnsBtn];
    
//    [self.view bringSubviewToFront:bgView];
}

- (void)myAnsBtnClick:(UIButton *)sender{
    
    MyReplyViewController *myReplyVC = [[MyReplyViewController alloc] init];
    myReplyVC.model = self.headModel;
    [self.navigationController pushViewController:myReplyVC animated:YES];
    
}


- (void)homeTableInterface{
    
    
    self.homeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVGATION_ADD_STATUS_HEIGHT, screenWidth, screenHight - NAVGATION_ADD_STATUS_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
    self.homeTable.dataSource = self;
    self.homeTable.delegate = self;
    
    self.homeTable.tableFooterView = [[UIView alloc] init];
    self.homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.homeTable];
    
    //    创建表头视图
    [self createHeadView];
    
    //创建手势对象
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    self.tap = tap;
    [self getCommentListData];
    
    
    //添加刷新方法
    __weak AppointedQuestionVC *weakself = self;
    [_homeTable addRefreshHeaderWithBlock:^{
        [weakself LoadUpdateDatas];
    }];
    
    [_homeTable addRefreshFootWithBlock:^{
        [weakself LoadMoreDatas];
    }];
    
    
    
}



#pragma mark-加载数据

-(void)LoadUpdateDatas
{
    
    //
    
    // 模拟延时设置
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.homeTable.header endHeadRefresh];
        
    });
    
    
    
}

-(void)LoadMoreDatas
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.homeTable.footer NoMoreData];
        [self.homeTable.footer ResetNomoreData];
    });
    
}





#pragma mark  - 获取问题评论列表数据

- (void)getCommentListData{
    
    self.dataArr = [NSMutableArray array];
    
    NSString *str = [NSString stringWithFormat:TOM_HOST_CROP_ID,@"api",@"Weiba",@"comment_list",oauth_token,oauth_token_secret,(int)self.post_id];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    

    
//    NSString *str = [NSString stringWithFormat:@"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=comment_list&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&id=%ld",self.post_id];
//    NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [Q_AHttpRequestManager getAppointedQuestionDetailedInfoWithUrl:encode WithBlock:^(NSArray * _Nullable array) {
        
        [_dataArr addObjectsFromArray:array];
        
        if (array.count == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"数据消失，请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismiss:) withObject:alert afterDelay:1.0];
            
        }else{
            for (int i = 0 ; i < _dataArr.count; i ++) {
                HeadModel *model = _dataArr[i];
                NSLog(@"%@",model.content);
                
                NSArray *contentArr = [model.content componentsSeparatedByString:@"="];
                
                if (contentArr.count > 1) {
                    model.image = [NSMutableArray array];
                    for (int j = 1; j < contentArr.count; j ++) {
                        
                        NSArray *imaArr = [contentArr[j] componentsSeparatedByString:@"}"];
                        
                        NSString *imaStr = [NSString stringWithFormat:@"http://192.168.1.86%@",imaArr[0]];
                        NSLog(@"ddddffffffffff%@",imaStr);
                        [model.image addObject:imaStr];
                        NSLog(@"fajlfkjasddlfd%@",model.image[0]);
                    }
                    
                    
                    NSArray *textA = [contentArr[0] componentsSeparatedByString:@"i"];
                    model.text = textA[0];
                    
                }else{
                    model.text = model.content;
                }
                
            }
            [_homeTable reloadData];

        }
        
        
        
    }];
}


- (void)dismiss:(UIAlertView *)alert{
    
    [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    
}





#pragma mark    设置cell的header的高度    **H E I G H T
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    //    CGFloat viewHeight = 48.0f;
    
    HeadModel *dataModel = _dataArr[section];
    NSString *text = [NSString stringWithFormat:@"%@",dataModel.text];
    CGFloat height = [text heightWithText:text font:[UIFont systemFontOfSize:15 * DISTENCEW] width:screenWidth - 45 * DISTENCEW];
    
    NSString *commentText = [NSString stringWithFormat:@"%@",dataModel.text];
    CGFloat commentHeight = [commentText heightWithText:commentText font:[UIFont systemFontOfSize:15 * DISTENCEW] width:screenWidth - 45 * DISTENCEW];
    
    int integer = (int)dataModel.image.count / NumberRow;  //整数
    int remainder = dataModel.image.count % NumberRow;//   余数
    if (remainder > 0) {
        remainder = 1;
    }
    int imageHeight = (((screenWidth - 40 * DISTENCEW - (3 * (NumberRow + 1))) / NumberRow) * (integer + remainder) + (integer + remainder) * 3);
    if (imageHeight > screenHight - NAVGATION_ADD_STATUS_HEIGHT) {
        imageHeight = screenHight - NAVGATION_ADD_STATUS_HEIGHT - 2 * CollClearance;
    }
    
    if ((height > 0 && commentHeight == 0) || (commentHeight > 0 && height == 0)) {
        
        return 123 * DISTENCEW + height + imageHeight + commentHeight;
        
        
    }else if (height > 0 && commentHeight > 0){
        
        return 133 * DISTENCEH + imageHeight + commentHeight + height;
        
    }else{
        
        return 113* DISTENCEH + imageHeight + commentHeight + height;
    }
    
    
}
#pragma mark 创建表头视图   **H E A D V I E W
- (void)createHeadView{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 200 * DISTENCEH)];
    headView.backgroundColor = [UIColor whiteColor];
    self.homeTable.tableHeaderView = headView;
    
    //    数据model
//    HeadModel *dataModel = _dataArr[38];
    
    
    
    
    //    textlabel
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*DISTENCEW, 10 * DISTENCEH, screenWidth - 15 * DISTENCEW - 20, 0)];
    textLabel.text = [NSString stringWithFormat:@"%@",self.headModel.text];
    textLabel.font = [UIFont systemFontOfSize:15 * DISTENCEW];
    textLabel.textColor = RGB_COLOR(50, 50, 50);
    textLabel.numberOfLines = 0;
    NSString *text = [NSString stringWithFormat:@"%@",self.headModel.text];
    CGFloat height = [text heightWithText:text font:[UIFont systemFontOfSize:15 * DISTENCEW] width:screenWidth - 15 * DISTENCEW - 20*DISTENCEW];
    textLabel.height = height;
    [headView addSubview:textLabel];
    
    //    种类
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(textLabel.left, textLabel.bottom + 10*DISTENCEH, 50 * DISTENCEW, 17 * DISTENCEH)];
    nameLabel.text = [NSString stringWithFormat:@"%@",self.headModel.author_info.uname];
    nameLabel.textColor = RGB_COLOR(58, 87, 136);
    nameLabel.font = [UIFont boldSystemFontOfSize:14 * DISTENCEW];
    [headView addSubview:nameLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.right, nameLabel.top, 100 * DISTENCEW, 16 * DISTENCEH)];
    timeLabel.text = [NSString stringWithFormat:@"%@",self.headModel.author_info.location];
    timeLabel.font = [UIFont systemFontOfSize:14 * DISTENCEW];
    timeLabel.textColor = [UIColor grayColor];
    if (timeLabel.text.length == 0) {
        timeLabel.frame = CGRectMake(nameLabel.left, nameLabel.bottom , 100 * DISTENCEW, 16 * DISTENCEH);
    }
    [headView addSubview:timeLabel];
    
    
    //    图片
    int integer = (int)_headModel.picArr.count / NumberRow;  //整数
    int remainder = _headModel.picArr.count % NumberRow;//   余数
    if (remainder > 0) {
        remainder = 1;
    }
    int imageHeight = (((screenWidth - 30 * DISTENCEW - (3 * (NumberRow + 1))) / NumberRow) * (integer + remainder) + (integer + remainder) * 3);
    if (imageHeight > screenHight - NAVGATION_ADD_STATUS_HEIGHT) {
        imageHeight = screenHight - NAVGATION_ADD_STATUS_HEIGHT - 2 * CollClearance;
    }
    ManyImageView *imageView = [ManyImageView initWithFrame:CGRectMake(textLabel.left, nameLabel.bottom + 10, screenWidth - 30 * DISTENCEW , imageHeight) imageArr:self.headModel.picArr numberRow:NumberRow widthClearance:ImageWidthMargin];
    imageView.backgroundColor = [UIColor whiteColor];
    headView.height = CGRectGetMaxY(imageView.frame) + 20*DISTENCEH;
    [headView addSubview:imageView];
    //    最下面的bottomView视图
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake( 0, CGRectGetMaxY(imageView.frame) + 5, screenWidth, 20*DISTENCEH);
    bottomView.backgroundColor = RGB_COLOR(247, 247, 247);
    [headView addSubview:bottomView];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20*DISTENCEH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0*DISTENCEH;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"%ld",_dataArr.count);
    return _dataArr.count;
}

#pragma mark     设置cell的header视图       **V I E W
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    HeadModel *dataModel = _dataArr[section];
    
    UIView *layerView = [[UIView alloc] init];
    layerView.frame = CGRectMake(0, 0, screenWidth, 80 * DISTENCEW);
    layerView.backgroundColor = RGB_COLOR(247, 247, 247);
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(5*DISTENCEW, 0*DISTENCEW, screenWidth - 10*DISTENCEW, 80 * DISTENCEW)];
    mainView.backgroundColor = [UIColor whiteColor];
    [layerView addSubview:mainView];
    
    mainView.layer.cornerRadius = 5.0f;
    mainView.clipsToBounds = YES;
    
    //头像
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(15 * DISTENCEW, 15 * DISTENCEH, 30 * DISTENCEH, 30 * DISTENCEW)];
//    headImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dataModel.author_info.avatar_tiny]];
   
    [headImage sd_setImageWithURL:[NSURL URLWithString:dataModel.author_info.avatar_tiny] placeholderImage:[UIImage imageNamed:@""]];
    
    [mainView addSubview:headImage];
    
    headImage.layer.cornerRadius = 15.0f*DISTENCEW;
    headImage.clipsToBounds = YES;
    
    //    姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImage.right + 10 * DISTENCEW, headImage.top, 40 * DISTENCEW, 17 * DISTENCEH)];
    nameLabel.text = [NSString stringWithFormat:@"%@",dataModel.author_info.uname];
    nameLabel.textColor = RGB_COLOR(58, 87, 136);
    nameLabel.font = [UIFont boldSystemFontOfSize:15 * DISTENCEW];
    [mainView addSubview:nameLabel];
    //    认证专家
    UIImageView *authenticationImage = [[UIImageView alloc] init];
    UIImage *image_authen = [UIImage imageNamed:dataModel.authentication];
    authenticationImage.image = [UIImage imageNamed:dataModel.authentication];
    authenticationImage.frame = CGRectMake(nameLabel.right, nameLabel.top, 70*DISTENCEW, 17*DISTENCEH);
    authenticationImage.frame = CGRectMake(nameLabel.right, nameLabel.top, image_authen.size.width, image_authen.size.height);
    [mainView addSubview:authenticationImage];
    
    //    时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom + 5 * DISTENCEH, 100 * DISTENCEW, 16 * DISTENCEH)];
    timeLabel.text = [NSString stringWithFormat:@"%@",dataModel.time];
    timeLabel.font = [UIFont systemFontOfSize:14 * DISTENCEW];
    timeLabel.textColor = [UIColor grayColor];
    if (timeLabel.text.length == 0) {
        timeLabel.frame = CGRectMake(nameLabel.left, nameLabel.bottom , 100 * DISTENCEW, 16 * DISTENCEH);
    }
    [mainView addSubview:timeLabel];
    
    //    textlabel
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImage.left, timeLabel.bottom + 10 * DISTENCEH, mainView.width - 15 * DISTENCEW - 20, 0)];
    textLabel.text = [NSString stringWithFormat:@"%@",dataModel.text];
    textLabel.font = [UIFont systemFontOfSize:15 * DISTENCEW];
    textLabel.textColor = RGB_COLOR(50, 50, 50);
    textLabel.numberOfLines = 0;
    NSString *text = [NSString stringWithFormat:@"%@",dataModel.text];
    CGFloat height = [text heightWithText:text font:[UIFont systemFontOfSize:15 * DISTENCEW] width:mainView.width - 15 * DISTENCEW - 20*DISTENCEW];
    textLabel.height = height;
    [mainView addSubview:textLabel];
    
    //    图片
    int integer = (int)dataModel.image.count / NumberRow;  //整数
    
    NSLog(@"woshitupian     %@",dataModel.image);
    
    int remainder = dataModel.image.count % NumberRow;//   余数
    if (remainder > 0) {
        remainder = 1;
    }
    int imageHeight = (((mainView.width - 30 * DISTENCEW - (3 * (NumberRow + 1))) / NumberRow) * (integer + remainder) + (integer + remainder) * 3);
    if (imageHeight > screenHight - NAVGATION_ADD_STATUS_HEIGHT) {
        imageHeight = screenHight - NAVGATION_ADD_STATUS_HEIGHT - 2 * CollClearance;
    }
    
    //    设置imageView的初始高度
    float imageOriginHeight;
    if (textLabel.height == 0) {
        imageOriginHeight = timeLabel.bottom + 10*DISTENCEH;
    }else{
        imageOriginHeight = textLabel.bottom + 10*DISTENCEH;
    }
    
    ManyImageView *imageView = [ManyImageView initWithFrame:CGRectMake(headImage.left, imageOriginHeight, mainView.width - 30 * DISTENCEW , imageHeight) imageArr:dataModel.image numberRow:NumberRow widthClearance:ImageWidthMargin];
    imageView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:imageView];
    
    //    评论 commentLab
    UILabel *commentLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.left, imageView.bottom + 10 * DISTENCEH, mainView.width - 15 * DISTENCEW - 20*DISTENCEW, 0)];
    commentLab.text = [NSString stringWithFormat:@"%@",dataModel.comment];
    commentLab.font = [UIFont systemFontOfSize:15 * DISTENCEW];
    commentLab.textColor = RGB_COLOR(50, 50, 50);
    commentLab.numberOfLines = 0;
    NSString *commentText = [NSString stringWithFormat:@"%@",dataModel.comment];
    CGFloat commentHeight = [commentText heightWithText:commentText font:[UIFont systemFontOfSize:15 * DISTENCEW] width:mainView.width - 15 * DISTENCEW - 20*DISTENCEW];
    commentLab.height = commentHeight;
    [mainView addSubview:commentLab];
    commentLab.backgroundColor = RGB_COLOR(247, 247, 247);
    
    
    //    设置supportView的初始高度
    float supportOriginHeight;
    if (commentHeight == 0) {
        supportOriginHeight = imageView.bottom + 10*DISTENCEH;
    }else{
        supportOriginHeight = commentLab.bottom + 10*DISTENCEH;
    }
    
    UIView *supportView = [[UIView alloc] init];
    
    supportView.frame = CGRectMake(0, supportOriginHeight, mainView.width, 40);
    [mainView addSubview:supportView];
    
    
    CGFloat btnWidth = 100.0f;
    //    反对按钮
    UIButton *opposeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    opposeBtn.frame = CGRectMake(((mainView.width - 1)/2 - btnWidth)/2, 10, btnWidth, 20);
    
    opposeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    [supportView addSubview:opposeBtn];
    
    
    //    支持按钮
    UIButton *approveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    approveBtn.frame = CGRectMake((mainView.width - 1)/2.0 + ((mainView.width - 1)/2 - btnWidth)/2, 10, btnWidth, 20);
    
    approveBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [opposeBtn addTarget:self action:@selector(opposeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [approveBtn addTarget:self action:@selector(approveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.opposeBtn = opposeBtn;
    opposeBtn.tag = section + 1000;
    
    self.approveBtn = approveBtn;
    approveBtn.tag = section + 10000;
    
    [supportView addSubview:approveBtn];
    
    UIView *uprightView = [[UIView alloc] init];
    
    uprightView.frame = CGRectMake((mainView.width - 1)/2 - 0.5, 10, 1, 20);
    uprightView.backgroundColor = RGB_COLOR(240, 240, 240);
    [supportView addSubview:uprightView];
    [supportView bringSubviewToFront:uprightView];
    
    //    设置水平线
    UIView *horizontalView = [[UIView alloc] init];
    
    horizontalView.frame = CGRectMake(15*DISTENCEW, supportView.top, mainView.width - 30 * DISTENCEW, 1);
    horizontalView.backgroundColor = RGB_COLOR(240, 240, 240);
    [mainView addSubview:horizontalView];
    [mainView bringSubviewToFront:horizontalView];
    
    //    添加赞成和反对的数字label
    
    UILabel *opposeLab = [[UILabel alloc] init];
    opposeLab.backgroundColor = [UIColor whiteColor];
    opposeLab.font = [UIFont systemFontOfSize:10.0f];
    opposeLab.frame = CGRectMake(opposeBtn.right - 30, opposeBtn.top - 5, 10, 10);
    opposeLab.tag = section + 2000;
    [supportView addSubview:opposeLab];
    opposeLab.textColor = [UIColor blackColor];
    opposeLab.textAlignment = NSTextAlignmentCenter;
    UILabel *approveLab = [[UILabel alloc] init];
    approveLab.font = [UIFont systemFontOfSize:10.0f];
    approveLab.frame = CGRectMake(approveBtn.right - 30, approveBtn.top - 5, 10, 10);
    [supportView addSubview:approveLab];
    approveLab.tag = section + 20000;
    approveLab.textColor = RGB_COLOR(252, 86, 56);
    approveLab.textAlignment = NSTextAlignmentCenter;
    
    
    NSLog(@"%ld",(long)section);
    
    
    
    if (dataModel.oppose == 0) {
        [opposeBtn setImage:[UIImage imageNamed:@"question_disagree"] forState:UIControlStateNormal];
    }else{
        [opposeBtn setImage:[UIImage imageNamed:@"question_disagree_selected"] forState:UIControlStateNormal];
        opposeLab.text = @"1";
    }
    
    if (dataModel.approve == 0) {
        [approveBtn setImage:[UIImage imageNamed:@"question_agree"] forState:UIControlStateNormal];
    }else{
        [approveBtn setImage:[UIImage imageNamed:@"question_agree_selected"] forState:UIControlStateNormal];
        approveLab.text = @"1";
    }
    
    mainView.height = CGRectGetMaxY(supportView.frame);
    
    return layerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableCell *cell = [HomeTableCell creatCellWithTableView:tableView];
    cell.contentView.backgroundColor = [UIColor blackColor];
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.judgeBOOL == YES) {
        //        int heght = scrollView.contentOffset.y;
        //        if (heght <= 3 || heght >= -3) {
        [_homeTable removeGestureRecognizer:_tap];
        _judgeBOOL = NO;
        _clickBOOL = YES;
        [self.homeTable reloadData];
        //        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:2];
        //        [self.homeTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        //        }else{
        //
        //        }
    }
}


//  赞
- (void)praiseClick:(UIButton *)sender{
    NSLog(@"这是第几个 %ld",(long)sender.tag - 1000);
    self.judgeBOOL = NO;
    [self.homeTable reloadData];
    
}


//  评论
- (void)commentClick:(UIButton *)sender{
    NSLog(@"评论 %ld",sender.tag - 1000);
    self.judgeBOOL = NO;
    [self.homeTable reloadData];
    
    
}


#pragma mark 点击赞成和反对按钮的方法
- (void)opposeBtnClick:(UIButton *)sender{
    //    UIButton *btn = ;
    HeadModel *model = self.dataArr[sender.tag - 1000];
    
    if (model.approve == 1) {
        return;
    }
    model.oppose = 1;
    UIButton *btn = (UIButton *)[sender.superview viewWithTag:sender.tag];
    [btn setImage:[UIImage imageNamed:@"question_disagree_selected"] forState:UIControlStateNormal];
    
    UILabel *lab = (UILabel *)[sender.superview viewWithTag:sender.tag + 1000];
    
    lab.text = @"1";
    
    
    
}

- (void)approveBtnClick:(UIButton *)sender{
    
    HeadModel *model = self.dataArr[sender.tag - 10000];
    if (model.oppose == 1) {
        return;
    }
    model.approve = 1;
    
    UIButton *btn = [sender.superview viewWithTag:sender.tag];
    [btn setImage:[UIImage imageNamed:@"question_agree_selected"] forState:UIControlStateNormal];
    
    NSLog(@"%ld",(long)sender.tag);
    
    UILabel *lab = (UILabel *)[sender.superview viewWithTag:sender.tag + 10000];
    lab.text = @"1";
    
}


//  手势方法
- (void)tapAction:(UITapGestureRecognizer *)tap{
    NSLog(@"点击了手势");
    [_homeTable removeGestureRecognizer:_tap];
    //    [_tap removeTarget:self action:@selector(tapAction:)];
    if (self.judgeBOOL == YES) {
        _clickBOOL = YES;
        self.judgeBOOL = NO;
        [self.homeTable reloadData];
    }
}


#pragma mark   点击收藏的方法   -
- (void)collectBtnClick:(UIButton *)sender{
    
    static BOOL _click;
//    UIImage *collectionImage;
//    UIButton *btn = (UIButton *)[sender.superview viewWithTag:sender.tag];
    
//    NSString *collectionStr;
    
    if (!_click) {
//        collectionImage = [UIImage imageNamed:@"Study_SNav_colleHight"];
//        collectionStr = @"已收藏";
        NSString *str = [NSString stringWithFormat:@"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=post_favorite&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&id=%ld",self.post_id];
        NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [Q_AHttpRequestManager colletFavoriteWithUrl:urlStr WithBlock:^(NSString * _Nullable string) {
            
            if ([string isEqualToString:@"1"]) {
                
                UIImage *collectionImage;
                UIButton *btn = (UIButton *)[sender.superview viewWithTag:sender.tag];
                collectionImage = [UIImage imageNamed:@"Study_SNav_colleHight"];
                btn.size = CGSizeMake(collectionImage.size.width, collectionImage.size.height);
                [btn setImage:collectionImage forState:UIControlStateNormal];
                _click = !_click;
                NSLog(@"取消收藏");
            }
                       
        }];
        
        
    }else{
        
        NSString *str = [NSString stringWithFormat:@"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=post_unfavorite&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&id=%ld",self.post_id];
        NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [Q_AHttpRequestManager colletFavoriteWithUrl:urlStr WithBlock:^(NSString * _Nullable string) {
            
            if ([string isEqualToString:@"1"]) {
            UIImage *collectionImage;
            UIButton *btn = (UIButton *)[sender.superview viewWithTag:sender.tag];
            collectionImage = [UIImage imageNamed:@"Study_sNav_colleNmal"];
            //        collectionStr = @"取消收藏";
            btn.size = CGSizeMake(collectionImage.size.width, collectionImage.size.height);
            [btn setImage:collectionImage forState:UIControlStateNormal];
            
                 _click = !_click;
            NSLog(@"取消收藏");
             }
        }];
       
    }

}

- (void)transmitBtnClick:(UIButton *)sender{
    NSLog(@"请转发");
    
}

- (void)newsBtnClick:(UIButton *)sender{
    
    if (_clickBOOL) {
        self.judgeBOOL = YES;
        self.judgeSection = (int)sender.tag;
        [self.homeTable reloadData];
        if (self.judgeBOOL == YES) {
            [self.homeTable reloadData];
        }
        [_homeTable addGestureRecognizer:_tap];
    }else{
        if (self.judgeBOOL == YES) {
            [_tap removeTarget:self action:@selector(tapAction:)];
            self.judgeBOOL = NO;
            [self.homeTable reloadData];
        }
    }
    _clickBOOL = !_clickBOOL;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@",,,,,,,,");
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
