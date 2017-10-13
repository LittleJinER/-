//
//  ExpertDetailsViewController.m
//  小农人
//
//  Created by tomusng on 2017/9/2.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "ExpertDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "QuestionModel.h"//网络请求时问题列表接收model
//#import "MJRefresh.h"
#import "ExpertDetailsTCell.h"//自定义问题列表cell
#import "Q_AHttpRequestManager.h"// 网络请求集合

#import "ExpertDViewModel.h"// 问题列表model

#import "AppointedQuestionVC.h"  //指定问题页面
#import "LLSearchView.pch"

#import "TBRefresh.h"



#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define Dist_Width   [UIScreen mainScreen].bounds.size.width/375.0
#define Dist_Height  [UIScreen mainScreen].bounds.size.height/667.0
#define LIGHT_TEXT_COLOR [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1]

@interface ExpertDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>


/**
 *  视图模型
 */
@property (strong, nonatomic) ExpertDViewModel *eVm;

/**
 *  模型数组
 */
@property (strong, nonatomic) NSMutableArray *viewModelArr;
@property (nonatomic, assign) BOOL follow;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *statusBarView;

@property (strong, nonatomic) UIButton *addFollowingBtn;


@end

@implementation ExpertDetailsViewController


- (void)viewWillDisappear:(BOOL)animated{
    
    //    self.navigationController.navigationBar.backgroundColor = [];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.shadowImage = nil;
     self.navigationController.navigationBar.barTintColor = nil;
    
    [self.statusBarView removeFromSuperview];
    
    self.navigationController.automaticallyAdjustsScrollViewInsets = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
   
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.tabBarController.tabBar.hidden = YES;
    
//    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:@"home_navigation_back_btn"];
    leftBtn.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [leftBtn setImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    
    
    
    self.navigationController.automaticallyAdjustsScrollViewInsets = YES;
    
    [self createTableViewUI];
    
   self.statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
    _statusBarView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:_statusBarView];
    
    [self getData];
}
- (void)leftBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createExpertInfoUI{
    
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, Width, 0);
    //    headView.backgroundColor = [UIColor colorWithRed:240.0/255/0 green:240.0/255/0 blue:240.0/255/0 alpha:1];
    //
    //    headView.backgroundColor = [UIColor lightGrayColor];
    
    //    背景   bgView
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0)];
    //    背景图   bgImageView
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"home_expert_detail_header_bg"];
    [bgView addSubview:bgImageView];
    //    头像     headImage
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake((Width - 80*Dist_Width)/2, 50 * Dist_Height, 80 *Dist_Width, 80*Dist_Width)];
    headImage.layer.cornerRadius = 40.0f*Dist_Width;
    headImage.backgroundColor = [UIColor greenColor];
    headImage.clipsToBounds = YES;
    [headImage sd_setImageWithURL:[NSURL URLWithString:self.model.avatar_middle] placeholderImage:[UIImage imageNamed:@""]];
    [bgView addSubview:headImage];
    
    //    姓名    nameLab
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.frame = CGRectMake(Width/4 - 40, CGRectGetMaxY(headImage.frame) + 15, 80, 30);
    nameLab.text = self.model.uname;
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.textColor = [UIColor whiteColor];
    [bgView addSubview:nameLab];
    
    //    类别   categoryLab
    UILabel *categoryLab = [[UILabel alloc] init];
    categoryLab.frame = CGRectMake(CGRectGetMaxX(nameLab.frame)+ 10, CGRectGetMaxY(headImage.frame) + 15, Width - CGRectGetMaxX(nameLab.frame) - 30, 30);
    categoryLab.text = self.model.official_category;
    //    categoryLab.textAlignment = NSTextAlignmentCenter;
    categoryLab.textColor = LIGHT_TEXT_COLOR;
    [bgView addSubview:categoryLab];
    
    //    被采纳数count   adopt_count_Lab
    UILabel *adopt_count_Lab = [[UILabel alloc] init];
    adopt_count_Lab.frame = CGRectMake(Width/4 - 40, CGRectGetMaxY(nameLab.frame) + 10, 80, 15);
    adopt_count_Lab.text = [NSString stringWithFormat:@"%ld",self.model.adopt_count];
    adopt_count_Lab.textAlignment = NSTextAlignmentCenter;
    adopt_count_Lab.textColor = [UIColor whiteColor];
    [bgView addSubview:adopt_count_Lab];
    
    //    被采纳label   adoptLab
    UILabel *adoptLab = [[UILabel alloc] init];
    adoptLab.frame = CGRectMake(Width/4 - 40, CGRectGetMaxY(adopt_count_Lab.frame) + 7, 80, 15);
    adoptLab.text = @"被采纳";
    adoptLab.textAlignment = NSTextAlignmentCenter;
    adoptLab.font = [UIFont systemFontOfSize:13.0f];
    adoptLab.textColor = LIGHT_TEXT_COLOR;
    [bgView addSubview:adoptLab];
    
    //    竖线 分割线    verticalLine
    UIView *verticalLine = [[UIView alloc] init];
    verticalLine.frame = CGRectMake(Width/2 - 0.5 , CGRectGetMaxY(nameLab.frame) + 10, 1, 35);
    verticalLine.backgroundColor = LIGHT_TEXT_COLOR;
    
    [bgView addSubview:verticalLine];
    
    //    粉丝数count   following_count_Lab
    UILabel *following_count_Lab = [[UILabel alloc] init];
    following_count_Lab.frame = CGRectMake(Width * 3/4.0 - 40, CGRectGetMaxY(nameLab.frame) + 10, 80, 15);
    following_count_Lab.text = [NSString stringWithFormat:@"%ld",self.model.following_count];
    following_count_Lab.textAlignment = NSTextAlignmentCenter;
    following_count_Lab.textColor = [UIColor whiteColor];
    [bgView addSubview:following_count_Lab];
    
    //    粉丝label   followingLab
    UILabel *followingLab = [[UILabel alloc] init];
    followingLab.frame = CGRectMake(Width * 3/4.0 - 40, CGRectGetMaxY(following_count_Lab.frame) + 7, 80, 15);
    followingLab.text = @"粉丝";
    followingLab.textAlignment = NSTextAlignmentCenter;
    followingLab.font = [UIFont systemFontOfSize:13.0f];
    followingLab.textColor = LIGHT_TEXT_COLOR;
    [bgView addSubview:followingLab];
    
    
    
    //    向专家提问按钮   consultBtn
    UIButton *consultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [consultBtn setFrame:CGRectMake(20, CGRectGetMaxY(adoptLab.frame) + 20, (Width - 20*2 - 30)/2.0, 35)];
    [consultBtn setTitle:@"向专家提问" forState:UIControlStateNormal];
    [consultBtn setBackgroundColor:[UIColor colorWithRed:244/255.0 green:164/255.0 blue:60/255.0 alpha:1]];
    consultBtn.layer.cornerRadius = 5.0f;
    consultBtn.clipsToBounds = YES;
    consultBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [consultBtn addTarget:self action:@selector(consultBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:consultBtn];
    
    //    加关注按钮   addFollowingBtn
    UIButton *addFollowingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addFollowingBtn setFrame:CGRectMake(Width/2.0 + 15, CGRectGetMaxY(followingLab.frame) + 20, (Width - 20*2 - 30)/2.0, 35)];
    if (self.model.Following == 0) {
        _follow = false;
        [addFollowingBtn setTitle:@"加关注" forState:UIControlStateNormal];
    }else{
        _follow = true;
        [addFollowingBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    
    
    [addFollowingBtn setBackgroundColor:[UIColor colorWithRed:140/255.0 green:184/255.0 blue:53/255.0 alpha:1]];
    addFollowingBtn.layer.cornerRadius = 5.0f;
    addFollowingBtn.clipsToBounds = YES;
    addFollowingBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    _addFollowingBtn = addFollowingBtn;
    [addFollowingBtn addTarget:self action:@selector(addFollowingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addFollowingBtn];
    
    //    上半部分背景的高度  bgHeight
    CGFloat bgHeight = CGRectGetMaxY(addFollowingBtn.frame) + 15;
    //    设置bgView 的frame
    bgView.frame = CGRectMake(0, 0, Width, bgHeight);
    //    设置bgImageView 的frame
    bgImageView.frame = CGRectMake(0, 0, Width, bgHeight);
    [bgView sendSubviewToBack:bgImageView];
    
    //    将上半部分的背景加载headview上
    [headView addSubview:bgView];
    

    //    专家    cardImage
    UIImageView *cardImage = [[UIImageView alloc] init];
    cardImage.frame = CGRectMake(10, CGRectGetMaxY(bgView.frame) + 15, 20, 20);
    cardImage.image = [UIImage imageNamed:@"B2cMine_photo"];
    [headView addSubview:cardImage];
    //    专家名片  cardLab
    UILabel *cardLab = [[UILabel alloc] init];
    cardLab.frame = CGRectMake(CGRectGetMaxX(cardImage.frame) + 10, CGRectGetMaxY(bgView.frame) + 15, 100, 20);
    cardLab.text = @"专家名片";
    cardLab.font = [UIFont systemFontOfSize:16.0f];
    [headView addSubview:cardLab];
    
    
    //    横向分割线label
    UIView *horizontalLine = [[UIView alloc] init];
    horizontalLine.frame = CGRectMake(10, CGRectGetMaxY(cardImage.frame)+ 10, Width - 10, 1);
    horizontalLine.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    [headView addSubview:horizontalLine];
    
    
    
    
    //    创建五个专家信息label
    NSArray *expertInfoArr = @[@"邀  请  码：",@"年        龄：",@"位        置：",@"擅长作物：",@"个人简介："];
    for (int i = 0 ; i < expertInfoArr.count; i ++) {
        UILabel *epLab = [[UILabel alloc] init];
        epLab.frame = CGRectMake(10, CGRectGetMaxY(horizontalLine.frame) + 30*i + 10, 80, 25);
        epLab.text = expertInfoArr[i];
        epLab.font = [UIFont systemFontOfSize:15.0f];
   
        [headView addSubview:epLab];
        
    }
    //    创建五个专家信息详情label
    for (int j = 0; j < expertInfoArr.count; j ++ ) {
        UILabel *infoLab = [[UILabel alloc] init];
        
        CGFloat infoWidth = Width - 120;
        
        infoLab.frame = CGRectMake(100, CGRectGetMaxY(horizontalLine.frame) + 30*j + 10, Width - 120, 25);
        infoLab.text = @"我是信息";
        infoLab.font = [UIFont systemFontOfSize:15.0f];
        [headView addSubview:infoLab];
        
        NSString *str = @"沃尔夫好多了烦死你了奶萨东方红我都搞活动破工会sad；干哈实力开发红烧冬瓜哈市好聊哈四大金刚怀柔问题和我安徽国际";
        switch (j) {
            case 0:
                
                break;
                
            case 1:{
                infoLab.text = [NSString stringWithFormat:@"%ld",self.model.age];
            }
            
                break;
                
            case 2:{
                infoLab.text = self.model.location;
            }
            
                break;
                
            case 3:{
                NSString *crops = [self.model.tag componentsJoinedByString:@","];
                infoLab.text = crops;
            }
                
                break;
                
            case 4:{
                
                
                CGSize textSize = [str boundingRectWithSize:CGSizeMake(infoWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f]} context:nil].size;
                
                infoLab.frame = CGRectMake(100, CGRectGetMaxY(horizontalLine.frame) + 30*j + 14, infoWidth, textSize.height);
                infoLab.text = str;
                infoLab.numberOfLines = 0;
               
                UIView *addView = [[UIView alloc] init];
                addView.frame = CGRectMake(0, CGRectGetMaxY(infoLab.frame) + 30, Width, 10);
                addView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
                [headView addSubview:addView];
                 headView.frame = CGRectMake(0, 0, Width, CGRectGetMaxY(addView.frame));
                
                break;
            }
            default:
                break;
        }
        
        
    }
 
    
    headView.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    
//    [self.view addSubview:headView];

    self.tableView.tableHeaderView = headView;
    
}







#pragma mark -------          tableView            -------------

- (void)createTableViewUI{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, Width, Height + 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ExpertDetailsTCell class] forCellReuseIdentifier:@"reuseId"];
    
    //    设置cell的分割线
//    self.tableView.separatorColor = [UIColor clearColor];
    
     [self createExpertInfoUI];
    __weak ExpertDetailsViewController *weakself = self;
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






#pragma mark - 懒加载

- (ExpertDViewModel *)eVm {
    if (!_eVm) {
        _eVm = [[ExpertDViewModel alloc] init];
    }
    return _eVm;
}

- (NSMutableArray *)viewModelArr{
    if (!_viewModelArr) {
        
        _viewModelArr = [NSMutableArray array];
        
    }
    return _viewModelArr;
}



- (void)getData{
    __weak __typeof(self) weakSelf = self;
    
    NSString *str = [NSString stringWithFormat:TOM_HOST,@"api",@"Weiba",@"commenteds",oauth_token,oauth_token_secret];
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
                        
                        NSString *picStr = [NSString stringWithFormat:@"http://192.168.1.86%@",secondStr];
                        [queModel.picArr addObject:picStr];
                        //                        NSLog(@"     %@",queModel.picArr);
                        
                    }
                    
                }
                
            }else{
                queModel.text = queModel.content;
                //                NSLog(@"%@",queModel.text);
            }
            
            ExpertDViewModel *eVModel = [[ExpertDViewModel alloc] init];
            eVModel.queModel = queModel;
            [eVModel setqueModel:queModel];
            
            [weakSelf.viewModelArr addObject:eVModel];
            
            //            NSLog(@"ccccccc  %lu",(unsigned long)_viewModelArr.count);
            [weakSelf.tableView reloadData];
            //            [weakSelf.tableView.mj_header endRefreshing];
        }
        
        NSLog(@"%ld",array.count);
        
    }];
}


#pragma mark - tableView delegate -- 跳转至解答页面

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
    
    ExpertDViewModel *model = self.viewModelArr[num];
    
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
    ExpertDetailsTCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
   
    if (!cell) {
        cell = [[ExpertDetailsTCell alloc]initWithStyle:0 reuseIdentifier:reuseId];
    }
    //    NSLog(@"fkjalfjaslfjaslfjsalfj");
    cell.eVm = self.viewModelArr[indexPath.row];
    [cell setCellWithEvm:self.viewModelArr[indexPath.row]];
    
    //    设置cell的分割线（貌似没用）
    cell.separatorInset = UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
    
    //当点击cell时，cell状态不发生变化
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.delegate = self;
//    cell.replyButton.tag = indexPath.row + 10000;
//    
//    cell.answerButton.tag = indexPath.row + 100000;
//    
//    
//    [cell.replyButton addTarget:self action:@selector(replyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.answerButton addTarget:self action:@selector(answerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}






- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.5f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
        UIView *view = [[UIView alloc] init];
        
        UIImageView *expertImV = [[UIImageView alloc] init];
        expertImV.frame = CGRectMake(10, 15, 20, 20);
        expertImV.image = [UIImage imageNamed:@"home_expert_detail_answer"];
        expertImV.layer.cornerRadius = 10.0f;
        expertImV.clipsToBounds = YES;
        
        [view addSubview:expertImV];
        
        UILabel *questionLab = [[UILabel alloc] init];
        questionLab.text = @"专家回答过的问题";
        questionLab.frame = CGRectMake(CGRectGetMaxX(expertImV.frame)+20, 15, 200, 20);
        questionLab.font = [UIFont systemFontOfSize:16.0f];
        [view addSubview:questionLab];
    
    UIView *separLine = [[UIView alloc] init];
    separLine.frame = CGRectMake(0, 50, Width, 0.5);
    separLine.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:separLine];
    
        view.frame = CGRectMake(0, 0, Width, 50.5);
    
    return view;
    
}


- (void)consultBtnClick:(UIButton *)sender{
   
    NSLog(@"向专家提问");
}

- (void)addFollowingBtnClick:(UIButton *)sender{
    NSString *urlStr;
    
    if (!_follow) {
        
        
        urlStr = [NSString stringWithFormat:TOM_HOST_USER_ID,@"api",@"User",@"follow_create",oauth_token,oauth_token_secret,self.model.uid];
       

//        urlStr = [NSString stringWithFormat:@"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=User&act=follow_create&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&user_id=%ld",self.model.uid];
        NSLog(@"1111   %ld",self.model.uid);
        
    }else{
        urlStr = [NSString stringWithFormat:TOM_HOST_USER_ID,@"api",@"User",@"follow_destroy",oauth_token,oauth_token_secret,self.model.uid];
//        urlStr = [NSString stringWithFormat:@"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=User&act=follow_destroy&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&user_id=%ld",self.model.uid];
        
        NSLog(@"00000");
        
    }
    
    
   
    
    
    
    NSString *encode = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [Q_AHttpRequestManager followFollowingOrCancleUserWithUrl:encode WithBlock:^(NSDictionary * _Nullable dictionary) {
        
        NSInteger teger = [dictionary[@"following"] integerValue];
        if (teger == 0) {
            
            [_addFollowingBtn setTitle:@"加关注" forState:UIControlStateNormal];
            
            _follow = false;
            

//
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"已取消关注" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            [alert show];
//            [alert performSelector:@selector(dismissClick:) withObject:alert afterDelay:1.0];
//            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"已取消关注" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismissClick:) withObject:alert afterDelay:1.0];
//
           
//
            
        }else{
            
            [_addFollowingBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            _follow = true;
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"已关注" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            [alert show];
//            [alert performSelector:@selector(dismissClick:) withObject:alert afterDelay:1.0];
//            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"已关注" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismissClick:) withObject:alert afterDelay:1.0];

            
           
            
        }
        
//        NSLog(@"   ****00000000------      %ld",(long)teger);
        
    }];
}


- (void)dismissClick:(UIAlertView *)alert{
    //    [alert dismissViewControllerAnimated:YES completion:nil];
    [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
}

//- (void)dismiss:(UIAlertView *)alertView{
//    
//    [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
//    
//    
//    
//}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > 20)
    {
        CGFloat alpha = offsetY  / 200;
//        [self wr_setNavBarBackgroundAlpha:alpha];
//        [self wr_setNavBarTintColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
//        [self wr_setNavBarTitleColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
//        [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
//        self.title = @"wangrui460";
        self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:alpha];
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
       
        self.statusBarView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:alpha];
        
//        [self setNeedsStatusBarAppearanceUpdate];
    }
    else
    {
//        [self wr_setNavBarBackgroundAlpha:0];
//        [self wr_setNavBarTintColor:[UIColor whiteColor]];
//        [self wr_setNavBarTitleColor:[UIColor whiteColor]];
//        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
//        self.title = @"";
        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
        self.statusBarView.backgroundColor = [UIColor clearColor];
//        [self setNeedsStatusBarAppearanceUpdate];
    }
}






//http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=commenteds&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e






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
