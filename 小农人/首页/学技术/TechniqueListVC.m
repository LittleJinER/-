//
//  TechniqueListVC.m
//  小农人
//
//  Created by tomusng on 2017/9/25.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "TechniqueListVC.h"

#import "DetailedClassificationViewController.h"//选择关注农作物

#import "FaTextField.h"//搜索框父类
#import "UIColor+SWAddition.h"
#import "FirstHttpRequestManager.h"
#import "LLSearchView.pch"
#import "AttentionCropModel.h"
#import "TechniqueCell.h"//技术列表信息cell
#import "QuestionModel.h"//技术列表model

#import "TechniqueDiseaseVC.h"//病害页面

#import "TechniqueDetailVC.h"//技术详情





#define ViewWidth [[UIScreen mainScreen] bounds].size.width
#define ViewHeight [[UIScreen mainScreen] bounds].size.height - 64 - MENU_HEIGHT - LINE_HEIGHT

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height
#define DISTANCE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667.0
#define DISTANCE_WIDTH   [UIScreen mainScreen].bounds.size.width/375.0

#define LINEVIEW_COLOR   [UIColor colorWithRed:200.0/250 green:200.0/250 blue:200.0/250 alpha:1]
#define DE_RED_Color  [UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]
#define BG_COLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]


#define LINE_HEIGHT 0.5*DISTANCE_WIDTH

#define MENU_BUTTON_WIDTH  [UIScreen mainScreen].bounds.size.width/7.0
#define MENU_HEIGHT 44*DISTANCE_WIDTH



@interface TechniqueListVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollBgView;

@property (nonatomic, strong) NSMutableArray *nameArray;

@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong) NSMutableArray *tableArray;

@property (nonatomic, strong) NSMutableArray *headViewArr;

@property (nonatomic, strong) UIView *deLineV;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger tableID;

@property (nonatomic, strong) NSMutableArray *cropsDataArr;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) CGFloat navMaxH;

@end

@implementation TechniqueListVC

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"学技术";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = BG_COLOR;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:@"home_navigation_back_btn"];
    leftBtn.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [leftBtn setImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navBarRect = self.navigationController.navigationBar.frame;
    _navMaxH = statusRect.size.height + navBarRect.size.height;
    [self getAttentionCropsData];
    
}


- (NSMutableArray *)menuArray{
    
    if (!_menuArray) {
        NSInteger teger = self.nameArray.count;
        _menuArray = [NSMutableArray arrayWithCapacity:teger];
    }
    return _menuArray;
}
#pragma mark - 创建四个选择按钮 和lineView
- (void)createMenuView{
    
//    UIView *menuView = [[UIView alloc] init];
//    menuView.backgroundColor = [UIColor lightGrayColor];
    
    UIScrollView *menuScroll = [[UIScrollView alloc] init];
    
    menuScroll.backgroundColor = [UIColor whiteColor];
    
    menuScroll.frame = CGRectMake(0, _navMaxH,  6*MENU_BUTTON_WIDTH, MENU_HEIGHT);
                                  
    for (int i = 0 ; i < _nameArray.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = [UIFont systemFontOfSize:17*DISTANCE_WIDTH];
        [btn setFrame:CGRectMake(MENU_BUTTON_WIDTH*i , 0, MENU_BUTTON_WIDTH, MENU_HEIGHT)];
        [btn setTitle:_nameArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setTitleColor:DE_RED_Color forState:UIControlStateNormal];
        }
        [self.menuArray addObject:btn];
        [menuScroll addSubview:btn];
    }
    
    UIView *deLineV = [[UIView alloc] init];
    deLineV.frame = CGRectMake(0, MENU_HEIGHT - 2*DISTANCE_HEIGHT, MENU_BUTTON_WIDTH, 2*DISTANCE_HEIGHT);
    deLineV.backgroundColor = DE_RED_Color;
    _deLineV = deLineV;
    [menuScroll addSubview:deLineV];
    
    [self.view addSubview:menuScroll];
    
    UIImageView *addImgV = [[UIImageView alloc] init];
    addImgV.frame = CGRectMake(6*MENU_BUTTON_WIDTH, _navMaxH, MENU_BUTTON_WIDTH, MENU_HEIGHT);
    addImgV.image = [UIImage imageNamed:@"Study_addItem"];
    addImgV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addImgV];
    
    
    addImgV.userInteractionEnabled = YES;
    [addImgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImgViewClick:)]];
    
}

#pragma mark -- 增加作物的点击事件
- (void)addImgViewClick:(UITapGestureRecognizer *)recognizer{
    
    DetailedClassificationViewController *addCropVC = [[DetailedClassificationViewController alloc] init];
    [self.navigationController pushViewController:addCropVC animated:YES];
    
    
}


#pragma mark  --  segment里面button的点击事件
- (void)selectBtnClick:(UIButton *)sender{
    
    
    NSLog(@"%ld",sender.tag);
    NSInteger index = sender.tag - 1000;
    //    [_scrollBgView scrollRectToVisible:CGRectMake(index*K_WIDTH, K_HETGHT - ViewHeight, K_WIDTH, ViewHeight) animated:YES];
    [_scrollBgView setContentOffset:CGPointMake(index*K_WIDTH, 0) animated:YES];
    _tableID = index;
    
    [_dataArr removeAllObjects];
    
    [self refreshTableWithIndex:index];
    
    
}


- (NSMutableArray *)tableArray{
    
    if (!_tableArray) {
        NSInteger teger = self.nameArray.count;
        _tableArray = [NSMutableArray arrayWithCapacity:teger];
    }
    return _tableArray;
    
}

- (NSMutableArray *)headViewArr{
    
    if (!_headViewArr) {
        _headViewArr = [NSMutableArray array];
    }
    return _headViewArr;
    
    
}


#pragma mark -  创建下面的table表
- (void)createScrollTable{
    
    UIScrollView *scrollBgView = [[UIScrollView alloc] init];
    scrollBgView.backgroundColor = [UIColor lightGrayColor];
    scrollBgView.frame = CGRectMake(0, _navMaxH + MENU_HEIGHT + LINE_HEIGHT, K_WIDTH, ViewHeight);
    scrollBgView.contentSize = CGSizeMake(self.nameArray.count * K_WIDTH, 0);
    scrollBgView.delegate = self;
    _scrollBgView = scrollBgView;
    scrollBgView.pagingEnabled = YES;
    [self.view addSubview:scrollBgView];
    
    for (int i = 0 ; i < _nameArray.count; i ++) {
        UITableView *table = [[UITableView alloc]init];
        table.frame = CGRectMake(K_WIDTH*i, 0, K_WIDTH, ViewHeight);
        table.delegate = self;
        table.dataSource = self;
        [self.tableArray addObject:table];
        
        UIView *headView = [self createTableHeaderView];
        
        [self.headViewArr addObject:headView];
        
        [scrollBgView addSubview:table];
        
        if (i == 0) {
            _tableView = table;
        }
        
        [table registerClass:[TechniqueCell class] forCellReuseIdentifier:@"cellID"];
        
    }
    
    _tableID = 0;
    [self refreshTableWithIndex:_tableID];
    
}

#pragma mark ---   创建headerView  ----
- (UIView *)createTableHeaderView{
    
    
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = BG_COLOR;

    
    
    //    设置搜索框
   UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(20, 10, K_WIDTH - 40, 30)];
    
    
    //设置圆角效果
    bgView.layer.cornerRadius = 14;
    bgView.layer.masksToBounds = YES;
    
    bgView.backgroundColor = [UIColor sw_colorWithR:255 G:255 B:255];
//    bgView.backgroundColor = BG_COLOR;
    
    [headView addSubview:bgView];
    
    FaTextField *textField = [[FaTextField alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(bgView.frame) - 10, CGRectGetHeight(bgView.frame))];
    textField.font = [UIFont systemFontOfSize:13];
    
    //清除按钮
    textField.clearButtonMode =UITextFieldViewModeWhileEditing;
    
    textField.delegate = self;
    //键盘属性
    //    _textField.returnKeyType = UIReturnKeySearch;
    
    //为textField设置属性占位符
    //    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索问题" attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
    textField.placeholder = @"搜索";
    textField.textColor = [UIColor blackColor];
    textField.textAlignment = NSTextAlignmentCenter;
    
    [bgView addSubview:textField];
    
    UIImage *searchImage = [UIImage imageNamed:@"commen_search"];
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, searchImage.size.width, searchImage.size.height)];
    searchImageView.image = searchImage;
    searchImageView.contentMode = UIViewContentModeCenter;
    textField.leftView = searchImageView;
    textField.leftViewMode = UITextFieldViewModeAlways;

    
//    设置下面的四个view
    
    //    图片与图片之间的间隔
    CGFloat spaceWidth = (K_WIDTH - 200*DISTANCE_WIDTH)/4;
    //    label与label之间的间隔
//    CGFloat labelSpaceW = (K_WIDTH - 280*DISTANCE_WIDTH)/4;
    
    NSArray *imgArr = @[@"Study_binghai",@"Study_chonghai",@"Study_caohai",@"Study_wenda"];
    NSArray *classifyStrArr = @[@"病害",@"虫害",@"草害",@"问答"];
    
    
    
    UIView *classBgView = [[UIView alloc] init];
    classBgView.frame = CGRectMake(0, CGRectGetMaxY(bgView.frame) + 10*DISTANCE_HEIGHT, K_WIDTH, 100*DISTANCE_HEIGHT);
    classBgView.backgroundColor = [UIColor whiteColor];
    
    [headView addSubview:classBgView];
    
    for (int i = 0; i < 4; i ++) {
        
        UIView *classView = [[UIView alloc] init];
        classView.frame = CGRectMake(spaceWidth/2 + (spaceWidth + 50*DISTANCE_WIDTH)*i, 0, 50*DISTANCE_WIDTH, 80*DISTANCE_WIDTH);
        
        UIImageView *classifyImageV = [[UIImageView alloc] init];
        
        classifyImageV.frame = CGRectMake(0,10*DISTANCE_HEIGHT, 50*DISTANCE_WIDTH, 50*DISTANCE_WIDTH);
        
        UIImage *claImage = [UIImage imageNamed:imgArr[i]];
        
        classifyImageV.image = claImage;
        
        //        创建资格label
        
        UILabel *classifyLabel = [[UILabel alloc] init];
        classifyLabel.frame = CGRectMake(0, CGRectGetMaxY(classifyImageV.frame) + 10*DISTANCE_HEIGHT, 50*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
        
        classifyLabel.text = classifyStrArr[i];
        classifyLabel.textColor = [UIColor blackColor];
        classifyLabel.backgroundColor = [UIColor whiteColor];
        classifyLabel.font = [UIFont systemFontOfSize:15.0f];
        classifyLabel.textAlignment = NSTextAlignmentCenter;
        [classView addSubview:classifyImageV];
        [classView addSubview:classifyLabel];
        [classBgView addSubview:classView];
        
        classView.userInteractionEnabled = YES;
        [classView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(classViewDidClick:)]];
        
        classView.tag = i + 1000;
        
    }
    
    headView.frame = CGRectMake(0, 0, K_WIDTH, CGRectGetMaxY(classBgView.frame));

    return headView;
    
    
}


#pragma mark - bgView 的点击事件
- (void)classViewDidClick:(UITapGestureRecognizer *)recognizer{
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)recognizer;
    
    NSInteger tag = tap.view.tag;
    
    int disease_id = 0;
    NSString *diseaseName;
    
    switch (tag) {
        case 1000:
        {
           
            disease_id = 1;
            diseaseName = @"病害";
        }
            break;
        case 1001:
        {
           
             disease_id = 2;
             diseaseName = @"虫害";
            
        }
            break;
        case 1002:
        {
            NSLog(@"3");
           
             disease_id = 3;
             diseaseName = @"草害";
            
        }
            break;
        case 1003:
        {
            NSLog(@"3");
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    TechniqueDiseaseVC *diseaseVC = [[TechniqueDiseaseVC alloc] init] ;
    
    AttentionCropModel *cropModel = _cropsDataArr[_tableID];
    
    diseaseVC.weiba_id = cropModel.weiba_id;
    diseaseVC.weiba_name = cropModel.weiba_name;
    diseaseVC.disease_id = disease_id;
    diseaseVC.diseaseName = diseaseName;
    
    [self.navigationController pushViewController:diseaseVC animated:YES];

}









- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TechniqueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[TechniqueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@  %ld",_text,indexPath.row];
    QuestionModel *model = self.dataArr[indexPath.row];
    
    cell.myCollM = model;
    
    return cell;
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   return 80*DISTANCE_HEIGHT;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [self.dataArr removeAllObjects];
    
    if (self.dataArr.count == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"数据中断，请稍后重试" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        
        [alert show];
        
        [self performSelector:@selector(dismiss:) withObject:alert afterDelay:1.0];
        
    }else{
        
        TechniqueDetailVC *techDVC = [[TechniqueDetailVC alloc] init];
        QuestionModel *qsModel = self.dataArr[indexPath.row];
        
        techDVC.qsModel = qsModel;
        //    NSLog(@"picArr ********LLLL    ******   :   %@",qsModel.picArr);
        //    NSLog(@"fsgl ********LLLL    ******   :   %@",qsModel.fsgl);
        [self.navigationController pushViewController:techDVC animated:YES];
        

    }
    
    
}


- (void)dismiss:(UIAlertView *)alert{
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    
}





#pragma mark  -- uiscrollviewdelegate事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    }else{
        CGFloat offsetX = scrollView.contentOffset.x;
        [self changeDeLineVRectWithOffsetX:offsetX];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
    NSLog(@"dfdfdfdfdfdfd");
    
    if (_tableID == _tableArray.count - 1) {
        
    }else{
        
        _tableView = _tableArray[_tableID + 1];
        
        UIView *headView = _headViewArr[_tableID + 1];
        
        _tableView.tableHeaderView = headView;
    }
   

}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    }else{
        NSInteger index = scrollView.contentOffset.x/K_WIDTH;
        
        _tableID = index;
        
        [_dataArr removeAllObjects];
        
        [self refreshTableWithIndex:index];
    }
    
    
    
    
}

- (void)refreshTableWithIndex:(NSInteger)index{
    
    for (int i = 0; i < _menuArray.count; i ++) {
        UIButton *btn = _menuArray[i];
        if (i == index) {
            [btn setTitleColor:DE_RED_Color forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    
    
    _tableView = _tableArray[index];
    
    _text = self.nameArray[index];
    
    _tableID = index;
    
    UIView *headView = [self createTableHeaderView];
    
    _tableView.tableHeaderView = headView;
    
//    [_tableView reloadData];
    
    AttentionCropModel *cropModel = _cropsDataArr[index];
    
    [self getTechniqueListDataWithWeibaID:cropModel.weiba_id];
    
    
}


- (void)changeDeLineVRectWithOffsetX:(CGFloat)offsetX{
    
    CGFloat deLineWidth = offsetX/K_WIDTH * MENU_BUTTON_WIDTH;
    _deLineV.frame = CGRectMake(deLineWidth, MENU_HEIGHT - 2*DISTANCE_HEIGHT, MENU_BUTTON_WIDTH, 2*DISTANCE_HEIGHT);
    
    
    
}


#pragma mark   ---   返回上一个界面的按钮
- (void)leftBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark  -  懒加载cropsDataArr
- (NSMutableArray *)cropsDataArr{
    
    if (!_cropsDataArr) {
        _cropsDataArr = [NSMutableArray array];
    }
    return _cropsDataArr;
    
}

#pragma mark -- 懒加载nameArray
- (NSMutableArray *)nameArray{
    if (!_nameArray) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}
#pragma mark   ---  你关注的农作物的数据请求
- (void)getAttentionCropsData{
    
    
    __weak TechniqueListVC *weakSelf = self;
    NSString *str = [NSString stringWithFormat:TOM_HOST,@"api",@"Tom",@"get_follow_weiba",oauth_token,oauth_token_secret];
    NSString *encode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [FirstHttpRequestManager getAttentionCropsInfoWithUrl:encode WithBlock:^(NSArray * _Nullable array) {
        
        
        [weakSelf.cropsDataArr addObjectsFromArray:array];
        for (int i = 0 ; i < array.count; i ++) {
            AttentionCropModel *cropModel = _cropsDataArr[i];
            [weakSelf.nameArray addObject:cropModel.weiba_name];
            
        }
        
        [weakSelf createMenuView];
        [weakSelf createScrollTable];
        
        AttentionCropModel *cropModel = _cropsDataArr[0];
        
        [weakSelf getTechniqueListDataWithWeibaID:cropModel.weiba_id];
        
    }];
    
    
    
    
}
#pragma mark  --  懒加载技术列表数组dataArr
- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark   --   请求技术列表数据
- (void)getTechniqueListDataWithWeibaID:(NSInteger)weiba_id{

        __weak TechniqueListVC *weakSelf = self;
//        NSLog(@"uuuuuuuuuuuuuuuu");
    
        NSString *str = [NSString stringWithFormat:TOM_HOST_TECHNIQUE_CROPID,@"api",@"Tom",@"get_pestandweed_posts",oauth_token,oauth_token_secret,weiba_id];
    NSLog(@"%@",str);
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
                        
//                        NSLog(@"strArr:  %@",strArr);
                        
                        //有图片的字符串
                        
                        NSString *firstUnicode = strArr[j];
                        NSString *firstStr = [self replaceUnicode:firstUnicode];
                        
//                      NSString *firstStr = strArr[j];
                        
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
//                             NSLog(@"     %@",myCollModel.picArr);
                            
//                            NSLog(@"%@",secondArr);
                            
//                            if (j > 1) {
                                NSLog(@"longText *******:    %@",secondArr);
                                
                                for (int k = 0 ; k < secondArr.count; k ++) {
                                    
                                    NSString *text = secondArr[k];
                                    
                                    if ([text isEqualToString:@"title"]) {
                                        NSString *titleName = secondArr[k + 2];
//                                        NSLog(@"title :   %@",titleName);
                                        myCollModel.titleName = titleName;
                                        
                                        NSLog(@"titleName:%@",myCollModel.titleName);
                                        
                                        
                                    }
                                    
                                    if ([text isEqualToString:@"lbzp"]) {
                                        NSString *lbzp = [NSString stringWithFormat:TOM_CRAZY,secondArr[k+2]];
                                        NSLog(@"lazp 图片 ：  %@",lbzp);
                                        
                                        myCollModel.lbzp = lbzp;
                                    }
                                    
                                    
                                    if ([text isEqualToString:@"fbwh"]) {
//                                    NSLog(@"fbwh   :  %@",secondArr[k+2]);
                                        NSString *fbwh = secondArr[k+2];
                                        myCollModel.fbwh = fbwh;
                                    }
                                    
                                    if ([text isEqualToString:@"whtz"]) {
//                                       NSLog(@"危害特征:   %@",secondArr[k+2]);
                                        NSString *whtz = secondArr[k+2];
                                        myCollModel.whtz = whtz;
                                    }
                                    
                                    if ([text isEqualToString:@"fsgl"]) {
//                                    NSLog(@"发生规律:   %@",secondArr[k+2]);
                                        NSString *fsgl = secondArr[k+2];
                                        myCollModel.fsgl = fsgl;
                                    }
                                    
                                    if ([text isEqualToString:@"fzff"]) {
//                                        NSLog(@"防止方法:   %@",secondArr[k+2]);
                                        NSString *fzff = secondArr[k+2];
                                        myCollModel.fzff = fzff;
                                    }
//                                }
                            }
                            
                        }
                        
                    }
                    
                }else{
                    
                    myCollModel.text = myCollModel.content;

                }

                
                [weakSelf.dataArr addObject:myCollModel];

            }
            
            _tableView = _tableArray[_tableID];
            
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
