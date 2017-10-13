//
//  MyCollectionVC.m
//  小农人
//
//  Created by tomusng on 2017/9/15.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "MyCollectionVC.h"
#import "MineHttpRequestManager.h"
//#import "myCollectModel.h"
#import "myCollectViewM.h"
#import "myCollectTVCell.h"
#import "TechniqueCell.h"
#import "TBRefresh.h"//刷新控件

#import "AppointedQuestionVC.h"

#import "QuestionModel.h"


#define ViewWidth [[UIScreen mainScreen] bounds].size.width
#define ViewHeight [[UIScreen mainScreen] bounds].size.height - 64 - MENU_HEIGHT - LINE_HEIGHT

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]
#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]

#define LINE_HEIGHT 0.5*DISTANCE_WIDTH

#define MENU_BUTTON_WIDTH  100*DISTANCE_WIDTH
#define MENU_HEIGHT 44*DISTANCE_WIDTH


@interface MyCollectionVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) UIScrollView *menuScroll;
@property (nonatomic, strong) UIScrollView *scrollBgView;

@property (nonatomic, strong) NSMutableArray *nameArray;

@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) UIView *deLineV;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) NSMutableArray *questionArr;
@property (nonatomic, strong) NSMutableArray *techniqueArr;

@property (nonatomic, assign) NSInteger teger;



@end

@implementation MyCollectionVC

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:@"home_navigation_back_btn"];
    leftBtn.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [leftBtn setImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    self.nameArray = [NSMutableArray arrayWithObjects:@"问题",@"技术", nil];
    
    
    [self createMenuView];
    [self createScrollTable];
    [self getMyCollectQuestionData];
    [self getMyCollectTechniqueData];
}

- (void)leftBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



- (NSMutableArray *)menuArray{
    
    if (!_menuArray) {
        NSInteger teger = self.nameArray.count;
        _menuArray = [NSMutableArray arrayWithCapacity:teger];
    }
    return _menuArray;
}
#pragma mark - 创建两个选择按钮 和lineView
- (void)createMenuView{
    
    UIView *menuView = [[UIView alloc] init];
//    menuView.backgroundColor = [UIColor lightGrayColor];
    menuView.frame = CGRectMake((K_WIDTH - self.nameArray.count*MENU_BUTTON_WIDTH)/2, 64, _nameArray.count * MENU_BUTTON_WIDTH, MENU_HEIGHT);
    for (int i = 0 ; i < _nameArray.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = [UIFont systemFontOfSize:17*DISTANCE_HEIGHT];
        [btn setFrame:CGRectMake(MENU_BUTTON_WIDTH*i , 0, MENU_BUTTON_WIDTH, MENU_HEIGHT)];
        [btn setTitle:_nameArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setTitleColor:DE_RED_Color forState:UIControlStateNormal];
        }
        [self.menuArray addObject:btn];
        [menuView addSubview:btn];
    }
    
    UIView *deLineV = [[UIView alloc] init];
    deLineV.frame = CGRectMake(0, MENU_HEIGHT - 2*DISTANCE_HEIGHT, MENU_BUTTON_WIDTH, 2*DISTANCE_HEIGHT);
    deLineV.backgroundColor = DE_RED_Color;
    _deLineV = deLineV;
    [menuView addSubview:deLineV];
    
    [self.view addSubview:menuView];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, CGRectGetMaxY(menuView.frame), K_WIDTH, LINE_HEIGHT);
    lineView.backgroundColor = LINEVIEW_COLOR;
    [self.view addSubview:lineView];
    
    
    
    
}

#pragma mark   --  两个按钮的点击事件  --
- (void)selectBtnClick:(UIButton *)sender{
    
    
//    NSLog(@"%ld",sender.tag);
    NSInteger index = sender.tag - 1000;
//    [_scrollBgView scrollRectToVisible:CGRectMake(index*K_WIDTH, K_HETGHT - ViewHeight, K_WIDTH, ViewHeight) animated:YES];
    [_scrollBgView setContentOffset:CGPointMake(index*K_WIDTH, 0) animated:YES];
    
    
    for (int i = 0; i < _menuArray.count; i ++) {
        UIButton *btn = _menuArray[i];
        if (i == index) {
            [btn setTitleColor:DE_RED_Color forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }

    _teger = index;
    [self refreshTableWithIndex:index];
    

}


- (NSMutableArray *)tableArray{
    
    if (!_tableArray) {
        NSInteger teger = self.nameArray.count;
        _tableArray = [NSMutableArray arrayWithCapacity:teger];
    }
    return _tableArray;
    
}

#pragma mark -  创建下面的table表
- (void)createScrollTable{
    
    UIScrollView *scrollBgView = [[UIScrollView alloc] init];
//    scrollBgView.backgroundColor = [UIColor lightGrayColor];
    scrollBgView.frame = CGRectMake(0, 64 + MENU_HEIGHT + LINE_HEIGHT, K_WIDTH, ViewHeight);
    scrollBgView.contentSize = CGSizeMake(self.nameArray.count * K_WIDTH, 0);
    scrollBgView.delegate = self;
    _scrollBgView = scrollBgView;
    scrollBgView.pagingEnabled = YES;
    [self.view addSubview:scrollBgView];
    
    __weak MyCollectionVC *weakself = self;
    
    
    

    
    for (int i = 0 ; i < _nameArray.count; i ++) {
        
//        if (i == 0) {
//            
//            UIView *view = [[UIView alloc] init];
//            view.frame = CGRectMake(0, 0, K_WIDTH, ViewHeight);
//            [scrollBgView addSubview:view];
//            [self.tableArray addObject:view];
//        }
//        else{
        
        
        UITableView *table = [[UITableView alloc]init];
        table.frame = CGRectMake(K_WIDTH*i, 0, K_WIDTH, ViewHeight);
        table.delegate = self;
        table.dataSource = self;
        [self.tableArray addObject:table];
        [scrollBgView addSubview:table];
        
        
//        _tableView = table;
        if (i == 0) {
            [_tableView registerClass:[myCollectTVCell class] forCellReuseIdentifier:@"cellID"];
            
        }
        [table addRefreshHeaderWithBlock:^{
            
            [weakself LoadUpdateDatas];
            
        }];
        
        [table addRefreshFootWithBlock:^{
            
            [weakself LoadMoreDatas];
        }];
        
//        }
    }
//    刷新表1
//    [self refreshTableWithIndex:1];
    _teger = 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     _tableView = _tableArray[0];
    if (tableView == _tableView) {
        return _questionArr.count;
    }else{
        return _techniqueArr.count;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _tableView = _tableArray[0];
    if (tableView == _tableView) {
        
//        NSLog(@"*****    %@",_text);
        myCollectViewM *myCollViewMod = _questionArr[indexPath.row];
        
        return myCollViewMod.cellHeight;
        
    }else{
        return 80*DISTANCE_HEIGHT;
    }
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
//    }
//    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@  %ld",_text,indexPath.row];
    
    _tableView = _tableArray[0];
    if (tableView == _tableView) {
        
        myCollectTVCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (!myCell) {
            myCell = [[myCollectTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        }
        myCollectViewM *myCollViewMod = _questionArr[indexPath.row];
        
        myCell.myCollViewMod = myCollViewMod;
        
        myCell.answerBtn.tag = 100000 + indexPath.row;
        
        [myCell.answerBtn addTarget:self action:@selector(answerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        return myCell;
    }
    else{
        TechniqueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
            if (!cell) {
                cell = [[TechniqueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
            }
        
        QuestionModel *myCollM = _techniqueArr[indexPath.row];
        cell.myCollM = myCollM;
        return cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _tableView = _tableArray[0];
    if (tableView == _tableView) {
    
    NSInteger num = indexPath.row;
    
    AppointedQuestionVC *appointQVC = [[AppointedQuestionVC alloc] init];
    
    myCollectViewM *model = self.questionArr[num];
    
    appointQVC.post_id = model.myCollModel.post_id;
    appointQVC.headModel = model.myCollModel;
    [self.navigationController pushViewController:appointQVC animated:YES];

    }
    
    
    
}


#pragma mark --  UIScrollViewDelegate的代理事件  --

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    }else{
        CGFloat offsetX = scrollView.contentOffset.x;
        [self changeDeLineVRectWithOffsetX:offsetX];
    }
    
    
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
        
        
    }else{
        
        NSInteger index = scrollView.contentOffset.x/K_WIDTH;
        
        for (int i = 0; i < _menuArray.count; i ++) {
            UIButton *btn = _menuArray[i];
            if (i == index) {
                [btn setTitleColor:DE_RED_Color forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
        _teger = index;
        [self refreshTableWithIndex:index];

    }
    

    
    
    
    
}


#pragma mark -  刷新表
- (void)refreshTableWithIndex:(NSInteger)index{
    
//    UITableView *table = _tableArray[index];

    _tableView = _tableArray[index];
    
    
    _text = self.nameArray[index];
    
//    [table reloadData];
    [_tableView reloadData];
    
}

#pragma mark - 改变红线的位置
- (void)changeDeLineVRectWithOffsetX:(CGFloat)offsetX{
    
    CGFloat deLineWidth = offsetX/K_WIDTH * MENU_BUTTON_WIDTH;
    _deLineV.frame = CGRectMake(deLineWidth, MENU_HEIGHT - 2*DISTANCE_HEIGHT, MENU_BUTTON_WIDTH, 2*DISTANCE_HEIGHT);
    
}


- (NSMutableArray *)questionArr{
    
    if (!_questionArr) {
        _questionArr = [NSMutableArray array];
    }
    return _questionArr;
    
    
}


#pragma mark ---   获取问题的数据
- (void)getMyCollectQuestionData{
    
    
    __weak __typeof(self) weakSelf = self;
    
//    UITableView *table = _tableArray[0];
    NSString *str = @"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=favorite_list&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&myPestandweed=0";
    
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [MineHttpRequestManager myFavoriteListCollectionWithUrl:encode WithBlock:^(NSArray *array) {
    
//        for (int i = 0 ; i < array.count; i ++) {
//            
//            myCollectViewM *myCollViewMod = [[myCollectViewM alloc]init];
//            myCollectModel *myCollModel = array[i];
//            myCollViewMod.myCollModel = myCollModel;
//            
//            NSLog(@"%@",myCollModel.content);
//            
//        }
    
        
        
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
            
            [weakSelf.questionArr addObject:myCollViewMod];
            
            //            NSLog(@"ccccccc  %lu",(unsigned long)_viewModelArr.count);
           
            //            [weakSelf.tableView.mj_header endRefreshing];
        }
        
        [weakSelf refreshTableWithIndex:0];
        
        
    }];
    
    
    
    
}



- (NSMutableArray *)techniqueArr{
    
    if (!_techniqueArr) {
        _techniqueArr = [NSMutableArray array];
    }
    return _techniqueArr;
    
    
}

#pragma mark   ---   获取技术的数据

- (void)getMyCollectTechniqueData{
    
    __weak __typeof(self) weakSelf = self;
    
//        _tableView = _tableArray[1];
    NSString *str = @"http://192.168.1.86/thinksns_v3.0/index.php?app=api&mod=Weiba&act=favorite_list&oauth_token=988b491a22040ef7634eb5b8f52e0986&oauth_token_secret=2a3d67f5f7bb03035e619518b364912e&myPestandweed=1";
    
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [MineHttpRequestManager myFavoriteListCollectTechniqueWithUrl:encode WithBlock:^(NSArray *array) {
        
        
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
                    
                }
                
            }else{
                myCollModel.text = myCollModel.content;
                //                NSLog(@"%@",queModel.text);
            }
            
//            myCollectViewM *myCollViewMod = [[myCollectViewM alloc] init];
//            myCollViewMod.myCollModel = myCollModel;
            //            [myCollViewMod setqueModel:myCollModel];
            
            [weakSelf.techniqueArr addObject:myCollModel];
            
            //            NSLog(@"ccccccc  %lu",(unsigned long)_viewModelArr.count);
            //            [weakSelf.tableView.mj_header endRefreshing];
        }

//        _tableView.frame = CGRectMake(K_WIDTH, 0, K_WIDTH, 80*DISTANCE_HEIGHT*_techniqueArr.count + 70*DISTANCE_HEIGHT);
          [weakSelf refreshTableWithIndex:1];
        
    }];
    
}


#pragma mark-加载数据

-(void)LoadUpdateDatas
{
    _tableView = _tableArray[_teger];
    //   [self.tableView.footer ResetNomoreData];
    
    // 模拟延时设置
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_tableView.header endHeadRefresh];

        
    });
    
    
    
}

-(void)LoadMoreDatas
{
    
   _tableView = _tableArray[_teger];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_tableView.footer NoMoreData];
        [_tableView.footer ResetNomoreData];
        
    });
    
}




- (void)answerButtonClick:(UIButton *)sender{
    
   
    NSLog(@"%ld",sender.tag);
    
    NSInteger num = sender.tag - 100000;
    
    AppointedQuestionVC *appointQVC = [[AppointedQuestionVC alloc] init];
    
    myCollectViewM *model = self.questionArr[num];
    
    appointQVC.post_id = model.myCollModel.post_id;
    appointQVC.headModel = model.myCollModel;
    [self.navigationController pushViewController:appointQVC animated:YES];

    
    
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
