//
//  TableViewController.m
//  YANScrollMenu
//
//  Created by Yan. on 2017/6/28.
//  Copyright © 2017年 Yan. All rights reserved.
//

#import "TableViewController.h"
#import "DataSource.h"
#import "ViewController.h"

#define ItemHeight 90
#define IMG(name)           [UIImage imageNamed:name]

#define K_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define K_HETGHT [[UIScreen mainScreen] bounds].size.height





@interface TableViewController ()<YANScrollMenuProtocol,DetailCategoryDelegate>{
    
    NSInteger row;
    NSInteger item;
}

@property (nonatomic, strong) YANScrollMenu *menu;
/**
 *  dataSource
 */
@property (nonatomic, strong) NSMutableArray<DataSource *> *dataSource;
@end

@implementation TableViewController



- (NSMutableArray<DataSource *> *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    row = 0;
//    item = 0;
    
    row = 2;
    item = 5;
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
    [self prepareUI];
    
    //GCD
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self createData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self reload:self.navigationItem.rightBarButtonItem];
            [self creatExpertView];
            
        });
    });
    
    


}
#pragma mark - Prepare UI-----
- (void)prepareUI{
    
    self.menu = [[YANScrollMenu alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ItemHeight*row + kPageControlHeight)];
    self.menu.currentPageIndicatorTintColor = [UIColor colorWithRed:107/255.f green:191/255.f blue:255/255.f alpha:1.0];
    self.menu.delegate = self;
    self.tableView.tableHeaderView = self.menu;
    self.tableView.tableFooterView = [UIView new];
    
    [YANMenuItem appearance].textFont = [UIFont systemFontOfSize:12];
    [YANMenuItem appearance].textColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.0];
    
}


#pragma mark -  Data--------
- (void)createData{
    
    
    NSArray *images = @[IMG(@"icon_cate"),
                        IMG(@"icon_drinks"),
                        IMG(@"icon_movie"),
                        IMG(@"icon_recreation"),
                        IMG(@"icon_cate"),
                        IMG(@"icon_drinks"),
                        IMG(@"icon_movie"),
                        IMG(@"icon_recreation"),
                        IMG(@"icon_stay"),
                        IMG(@"icon_ traffic"),
                        IMG(@"icon_ scenic"),
                        IMG(@"icon_fitness"),
                        IMG(@"icon_fitment"),
                        IMG(@"icon_hairdressing"),
                        IMG(@"icon_mom"),
                        IMG(@"icon_study"),
                        IMG(@"icon_travel"),
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1498711713465&di=d986d7003deaae41342dd9885c117e38&imgtype=0&src=http%3A%2F%2Fs9.rr.itc.cn%2Fr%2FwapChange%2F20168_3_0%2Fa86hlk59412347762310.GIF",
                        IMG(@"question_add_crop")
                        ];
    NSArray *titles = @[@"美食",
                        @"休闲娱乐",
                        @"电影/演出",
                        @"KTV",
                        @"美食",
                        @"休闲娱乐",
                        @"电影/演出",
                        @"KTV",
                        @"酒店住宿",
                        @"火车票/机票",
                        @"旅游景点",
                        @"运动健身",
                        @"家装建材",
                        @"美容美发",
                        @"母婴",
                        @"学习培训",
                        @"旅游出行",
                        @"动态图\n从网络获取",
                        @"添加作物"];
    
    for (NSUInteger idx = 0; idx< images.count; idx ++) {
        
        DataSource *object = [[DataSource alloc] init];
        object.text = titles[idx];
        object.image = images[idx];
        object.placeholderImage = IMG(@"placeholder");
        [self.dataSource addObject:object];
    }
    
    
}


#pragma mark ----------dataSourceDelegate方法----------
- (void)sendDataSource:(NSMutableArray<DataSource *> *)dataSource{
    
    NSLog(@"tttttttttt");
    NSLog(@"%ld",dataSource.count);
    NSLog(@"%@",dataSource);
    
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
    
    
    if (indexPath.section%2 == 1 && indexPath.row == 4) {
        
        ViewController *VC = [[ViewController alloc] init];
        VC.dataSourceDelegate = self;
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else if (self.dataSource.count/5 == indexPath.section - 1&& self.dataSource.count%5 == indexPath.row - 1){
        ViewController *VC = [[ViewController alloc] init];
        VC.dataSourceDelegate = self;
        [self.navigationController pushViewController:VC animated:YES];
    }
    else{
    
    
    NSUInteger idx = indexPath.section * item + indexPath.row;
    
    NSString *tips = [NSString stringWithFormat:@"IndexPath: [ %ld - %ld ]\nTitle:   %@",indexPath.section,indexPath.row,self.dataSource[idx].text];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:tips preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
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
    
    [self.menu reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    
}

#pragma mark -----创建专家view
- (void)creatExpertView{
    
    UIImageView *expertView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.menu.frame)+10, (K_WIDTH-1)/2.0, 70)];
    expertView.image = [UIImage imageNamed:@"go_expert"];
    
    UIImageView *questionView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(expertView.frame)+1, CGRectGetHeight(self.menu.frame)+10, CGRectGetWidth(expertView.frame), CGRectGetHeight(expertView.frame))];
    questionView.image = [UIImage imageNamed:@"go_answer"];
    
    [self.view addSubview:expertView];
    [self.view addSubview:questionView];
    
}














@end
