//
//  NormalStudyViewController.m
//  SuperPaper
//
//  Created by wangli on 16/1/19.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "NormalStudyViewController.h"
#import "HomeNewsCell.h"
#import "NormalWebViewController.h"

#define KAppWidth [UIScreen mainScreen].bounds.size.width
#define KAppHeight [UIScreen mainScreen].bounds.size.height

@interface NormalStudyViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation NormalStudyViewController {
    UITableView *_studyTableView;
    NSMutableArray *_responseNewsInfoArr;
    int _type_id;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _studyTableView.delegate = self;
    _studyTableView.dataSource = self;
    
    if ([self.title isEqualToString:@"考研"]) {
        _type_id = 11;
    }
    else if ([self.title isEqualToString:@"留学"]) {
        _type_id = 12;
    }
    else if ([self.title isEqualToString:@"比赛"]) {
        _type_id = 13;
    }
    else if ([self.title isEqualToString:@"考证"]) {
        _type_id = 14;
    }
    else if ([self.title isEqualToString:@"计算机"]) {
        _type_id = 15;
    }
    else if ([self.title isEqualToString:@"大学46级"]) {
        _type_id = 16;
    }
    else if ([self.title isEqualToString:@"论文指导"]) {
        _type_id = 17;
    }
    else if ([self.title isEqualToString:@"作业指导"]) {
        _type_id = 18;
    }
    
    [self setUI];
    
    //获取学习情报
    [self getStudyNewsInfo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _studyTableView.frame = CGRectMake(0, 0, KAppWidth,self.view.bounds.size.height);
    
}

- (void)setUI {
    
    _studyTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _studyTableView.dataSource = self;
    _studyTableView.delegate = self;
    _studyTableView.sectionHeaderHeight = 10;
    _studyTableView.sectionFooterHeight = 10;
    [self.view addSubview:_studyTableView];
    
    //变量初始化
    _responseNewsInfoArr = [[NSMutableArray alloc]init];
    
    // 下拉刷新
    _studyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pullDownPageData];
    }];
    
    // 上拉加载
    _studyTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self pullUpPageData];
    }];
    
}

// 下拉刷新
- (void)pullDownPageData
{
    [_responseNewsInfoArr removeAllObjects];
    [self getStudyNewsInfo];
    
    [_studyTableView.mj_header endRefreshing];
}

// 上拉加载
- (void)pullUpPageData
{
    
    [self getStudyNewsInfo];
    
    [_studyTableView.mj_footer endRefreshing];
}

#pragma mark - AFnetworking 网络数据请求
//获取学习主页资讯
- (void)getStudyNewsInfo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    /**
     ** parameters 参数
     * ownertype  整型    固定值2:学习页
     * group_id   整型    10:刊物，11：考研，12：留学，13：比赛，14：考证，15：计算机，16：大学46级，17：论文指导，18：作业指导
     * start_pos  整型    表单中获取数据的开始位置。从0开始
     * list_num   整型    一次获取list数
     */
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:2], @"group_id":[NSNumber numberWithInt:_type_id], @"start_pos":[NSNumber numberWithInt:(int)_responseNewsInfoArr.count], @"list_num":[NSNumber numberWithInt:15]};
    NSString *urlString = [NSString stringWithFormat:@"%@study_newsinfo.php",BASE_URL];
    NSLog(@"%@",urlString);
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *myArr = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
        [_responseNewsInfoArr addObjectsFromArray:myArr];
        NSLog(@"%@",responseObject);
        [_studyTableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - TableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"classifiCell";
    HomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HomeNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (_responseNewsInfoArr.count == 0) {
        return cell;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",IMGURL,[[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"listitem_pic_name"]];
    NSString *timeString = [[[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"createdate"] substringToIndex:10];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          urlString,@"image",
                          [[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"title"],@"title",
                          timeString,@"time", nil];
    
    cell.infoDict = dict;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        
    NormalWebViewController *vc = [[NormalWebViewController alloc]init];
    vc.title = [[_responseNewsInfoArr objectAtIndex:indexPath.row]valueForKey:@"title"];
    vc.urlString = [[_responseNewsInfoArr objectAtIndex:indexPath.row]valueForKey:@"url"];
        
    /**
    * 跳转页面
    */
    [AppDelegate.app.nav pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _responseNewsInfoArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

@end
