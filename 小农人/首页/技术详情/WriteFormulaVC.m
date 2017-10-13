//
//  WriteFormulaVC.m
//  小农人
//
//  Created by tomusng on 2017/9/25.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import "WriteFormulaVC.h"
#import "FormulaView.h"

#import "PlaceholderTextView.h"
//#import "MLShowViewController.h"


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




@interface WriteFormulaVC ()

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, assign) CGFloat viewOriginH;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, strong) NSMutableArray *formViewArr;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat btnheight;

@property (nonatomic, strong) UIView *considerationsBgView;

@property (nonatomic, strong) PlaceholderTextView *textView;

@property (nonatomic, assign) CGFloat considerHeight;
//@property (nonatomic, strong) MLShowViewController *mlController;

@end

@implementation WriteFormulaVC

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"写配方";
    self.view.backgroundColor = BG_COLOR;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self setUpUI];
    
    [self createSubmitBtn];
    
    
}

- (void)setUpUI{
    
    CGFloat viewHeight = 30*DISTANCE_HEIGHT;
    CGFloat labHeight = 20*DISTANCE_HEIGHT;
    CGFloat lineHeight = 0.5*DISTANCE_HEIGHT;
    CGFloat labWidth = 80*DISTANCE_WIDTH;
    CGFloat space = 10*DISTANCE_HEIGHT;
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.frame = CGRectMake(0, 64, K_WIDTH, K_HEIGHT - 64);
    
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    NSArray *nameArray = @[@"成分名称：",@"含        量：",@"稀释倍数："];
    NSArray *placehArr = @[@"例阿维菌素",@"例1.8%",@"例1800 - 2400倍"];
    
    for (int i = 0 ; i < 3; i ++) {
        
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 10*DISTANCE_HEIGHT + (viewHeight + lineHeight)*i, K_WIDTH, 30*DISTANCE_HEIGHT);
        bgView.backgroundColor = [UIColor whiteColor];
        
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.text = nameArray[i];
        nameLab.frame = CGRectMake(space, space/2, labWidth, labHeight);
        nameLab.textColor = [UIColor blackColor];
        nameLab.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
        nameLab.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:nameLab];
        
        UITextField *textF = [[UITextField alloc] init];
        textF.frame = CGRectMake(CGRectGetMaxX(nameLab.frame) + space, space/2, K_WIDTH - labWidth - 3*space, labHeight);
        textF.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
        //        textF.backgroundColor = [UIColor greenColor];
        textF.placeholder = placehArr[i];
        [bgView addSubview:textF];
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(space, 10*DISTANCE_HEIGHT + (viewHeight + lineHeight)*(i + 1), K_WIDTH - space, lineHeight);
        
        [_scrollView addSubview:lineView];
        
        [_scrollView addSubview:bgView];
        
        if (i == 2) {
            _viewOriginH = CGRectGetMaxY(lineView.frame);
        }
        
        
    }
    
    _btnheight = 50*DISTANCE_HEIGHT;
    
    //        解答按钮replyButton
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"add_sp"] forState:UIControlStateNormal];
    [addBtn setTitle:@"继续添加药剂" forState:UIControlStateNormal];
    _addBtn = addBtn;
    addBtn.frame = CGRectMake((K_WIDTH - 200*DISTANCE_WIDTH)/2, 101.5*DISTANCE_HEIGHT, 200*DISTANCE_WIDTH, _btnheight);
    [addBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [addBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [addBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f*DISTANCE_HEIGHT];
    
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:addBtn];
    
    
    
    
    //    注意事项背景view
    
    
    UIView *considerationsBgView = [[UIView alloc] init];
    
    
    
    _considerationsBgView = considerationsBgView;
    
    considerationsBgView.backgroundColor = [UIColor whiteColor];
    
    [scrollView addSubview:considerationsBgView];
    
    
    
    UILabel *considerLab = [[UILabel alloc] init];
    considerLab.frame = CGRectMake(space, space, 100*DISTANCE_WIDTH, 20*DISTANCE_HEIGHT);
    considerLab.font = [UIFont systemFontOfSize:15*DISTANCE_HEIGHT];
    considerLab.textColor = [UIColor blackColor];
    considerLab.text = @"注意事项";
    [considerationsBgView addSubview:considerLab];
    
    //    问题描述
    PlaceholderTextView *textView = [[PlaceholderTextView alloc]init];
    textView.placeholderLabel.font = [UIFont systemFontOfSize:14*DISTANCE_HEIGHT];
    textView.backgroundColor = BG_COLOR;
    textView.placeholder = @"请详细描述你的信息，最少5个字";
    textView.font = [UIFont systemFontOfSize:15];
    textView.frame = (CGRect){space,CGRectGetMaxY(considerLab.frame)+ space,K_WIDTH - 2*space,200*DISTANCE_HEIGHT};
    textView.maxLength = 200;
    textView.layer.cornerRadius = 5.f;
    textView.layer.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.3].CGColor;
    textView.layer.borderWidth = 0.5f;
    _textView = textView;
    [considerationsBgView addSubview:textView];
    
    [_textView didChangeText:^(PlaceholderTextView *textView) {
        NSLog(@"%@",_textView.text);
        
        if (_textView.text != nil) {
            //            [button setBackgroundColor:[UIColor colorWithRed:252/255.0 green:86/255.0 blue:56/255.0 alpha:1]];
        }
        
    }];
    
    
    //    MLShowViewController *mlControl = [[MLShowViewController alloc] init];
    //    mlControl.view.frame = CGRectMake(space/2, CGRectGetMaxY(textView.frame) + 2*space, K_WIDTH - space, 50*DISTANCE_HEIGHT);
    //    [considerationsBgView addSubview:mlControl.view];
    
    // 2. 设置collectionSuperView进行赋值
    UIView *picView = [[UIView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(textView.frame) + 2*space, K_WIDTH - space, 100*DISTANCE_HEIGHT)];
    
//    considerationsBgView.backgroundColor = [UIColor whiteColor];
    
    [considerationsBgView addSubview:picView];
    //    picView.backgroundColor = [UIColor greenColor];
    
    self.collectionSuperView = picView;
    
    
    // 3. 设置可添加图片的最大数
    self.maxCount = 3;
    
    // 4. 初始化CollectionView
    [self initCollectionView];
  
    
    _considerHeight = CGRectGetMaxY(picView.frame) + 10*DISTANCE_HEIGHT;
    
    considerationsBgView.frame = CGRectMake(0, CGRectGetMaxY(addBtn.frame), K_WIDTH, _considerHeight);
    
}




- (NSMutableArray *)formViewArr{
    
    if (!_formViewArr) {
        _formViewArr = [NSMutableArray array];
    }
    return _formViewArr;
    
    
}



- (void)addBtnClick:(UIButton *)sender{
    
    _num ++;
    
    NSLog(@"addbtnClick:   %ld",_num);
    
    
    //    for (int i = 0 ; i < _num; i ++) {
    
    FormulaView *formView = [[FormulaView alloc] initWithFrame:CGRectMake(0, 101.5*DISTANCE_HEIGHT *(_num), K_WIDTH, 101.5*DISTANCE_HEIGHT )];
    
    //    formView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:formView];
    
    
    
    formView.subtractionBtn.tag = 1000 + _num;
    
    [_scrollView addSubview:formView];
    
    [formView.subtractionBtn addTarget:self action:@selector(subtractionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.formViewArr addObject:formView];
    
    
    _addBtn.frame = CGRectMake((K_WIDTH - 200*DISTANCE_WIDTH)/2, 101.5*DISTANCE_HEIGHT*(_num + 1), 200*DISTANCE_WIDTH, _btnheight);
    
     _considerationsBgView.frame = CGRectMake(0, CGRectGetMaxY(_addBtn.frame), K_WIDTH, _considerHeight);
    
    _scrollView.contentSize = CGSizeMake(0, 101.5*DISTANCE_HEIGHT*(_num + 1) + _btnheight + _considerHeight + 100*DISTANCE_HEIGHT);
    
    
}


- (void)subtractionBtnClick:(UIButton *)sender{
    
    _num --;
    
    NSLog(@"subtractionBtnClick:   %ld",_num);
    
    
    
    UIView *formView = _formViewArr[_num];
    
    [_formViewArr removeLastObject];
    [formView removeFromSuperview];
    
    _addBtn.frame = CGRectMake((K_WIDTH - 200*DISTANCE_WIDTH)/2, 101.5*DISTANCE_HEIGHT*(_num + 1), 200*DISTANCE_WIDTH, _btnheight);
    
    _considerationsBgView.frame = CGRectMake(0, CGRectGetMaxY(_addBtn.frame), K_WIDTH, _considerHeight);

    
    _scrollView.contentSize = CGSizeMake(0, 101.5*DISTANCE_HEIGHT*(_num + 1) + _btnheight + _considerHeight + 100*DISTANCE_HEIGHT);
    
}



- (void)createSubmitBtn{
    
    CGFloat space = 15*DISTANCE_WIDTH;
    CGFloat btnWidth = (K_WIDTH - 8*space)/4;
    CGFloat btnHeight = 25*DISTANCE_HEIGHT;

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    button.frame = CGRectMake(0, 0, btnWidth, btnHeight);
    
    [button setTitle:@"提交" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button setBackgroundColor:[UIColor whiteColor]];
    
    [button setBackgroundColor:BG_COLOR];
    
    //        [button.layer setBorderColor:(__bridge CGColorRef _Nullable)(LINEVIEW_COLOR)];
    
    [button.layer setBorderWidth:0.5*DISTANCE_HEIGHT];
    
    button.layer.cornerRadius = btnHeight/2;
    
    button.clipsToBounds = YES;
    
    [button.layer setMasksToBounds:YES];
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){200.0/255, 200.0/255, 200.0/255, 1});
    [button.layer setBorderColor:color];
    
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [button addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    
    
}


- (void)submitBtnClick:(UIButton *)sender{
    
    
    for (int i = 0; i < _num; i ++) {
        
        
        
        
        
        
    }
    
    
    
    
    
    
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
