//
//  JobsViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "JobsViewController.h"
#import "SDCycleScrollView.h"
#import "NormalWebViewController.h"
#import "HomeNewsCell.h"
#import "ServiceButton.h"
#import "NormalJobViewController.h"

#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface JobsViewController ()<UITableViewDataSource, UITableViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView *jobTableView;

@end

@implementation JobsViewController
{
    // 返回就业主页资讯数据
    NSMutableArray *_responseNewsInfoArr;
    
    // 返回就业广告信息数据
    NSArray *_responseAdInfoArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _responseNewsInfoArr = [[NSMutableArray alloc] init];
    [self getJobPageAdInfo];
    [self getJobPageNewsInfo];
    [self setupUI];
}

#pragma mark - UI搭建
- (void)setupUI
{
    _jobTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight - 64 - 49) style:UITableViewStyleGrouped];
    _jobTableView.dataSource = self;
    _jobTableView.delegate = self;
    [self.view addSubview:_jobTableView];
    
    // 下拉刷新
    _jobTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pullDownPageData];
    }];
    
    // 上拉加载
    _jobTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self pullUpPageData];
    }];
}

// 下拉刷新
- (void)pullDownPageData
{
    [_responseNewsInfoArr removeAllObjects];
    [self getJobPageNewsInfo];
    [_jobTableView.mj_header endRefreshing];
}

// 上拉加载
- (void)pullUpPageData
{
    [self getJobPageNewsInfo];
    [_jobTableView.mj_footer endRefreshing];
}

- (NSString *)titleName {
    return @"就业";
}

#pragma mark - 网络请求
// 获取就业主页资讯
- (void)getJobPageNewsInfo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    /**
     ** parameters 参数
     * ownertype  整型    2：学生
     * start_pos  整型    表单中获取数据的开始位置。从0开始
     * list_num   整型    一次获取list数
     */
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:2], @"start_pos":[NSNumber numberWithInt:(int)_responseNewsInfoArr.count], @"list_num":[NSNumber numberWithInt:15]};
    NSString *urlString = [NSString stringWithFormat:@"%@jobpage_newsinfo.php",BASE_URL];
    NSLog(@"%@",urlString);
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *myArr = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
        [_responseNewsInfoArr addObjectsFromArray:myArr];
        NSLog(@"%@",responseObject);
        [_jobTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

// 获取学习广告信息
- (void)getJobPageAdInfo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    /**
     ** parameters 参数
     * ownertype  整型    5：就业主页
     */
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:5]};
    NSString *urlString = [NSString stringWithFormat:@"%@getadinfo.php",BASE_URL];
    NSLog(@"%@",urlString);
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _responseAdInfoArr = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
        NSLog(@"%@",responseObject);
        [_jobTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 活动图片点击事件
- (void)serviceBtnClick:(ServiceButton *)sender
{
    NormalJobViewController *normalJobVC = [[NormalJobViewController alloc] init];
    normalJobVC.title = sender.titleLabel.text;
    normalJobVC.group_id = (int)(sender.tag - 1000);
    [AppDelegate.app.nav pushViewController:normalJobVC animated:YES];
}

#pragma mark - UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return _responseNewsInfoArr.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"CarouselCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        // 采用网络图片实现
        NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic in _responseAdInfoArr) {
            NSString *iamgeURL = [NSString stringWithFormat:@"%@%@",IMGURL,[dic valueForKey:@"adpicname"]];
            [imagesURLStrings addObject:iamgeURL];
        }
        
        // 网络加载 --- 创建带标题的图片轮播器
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180) delegate:self placeholderImage:[UIImage imageWithASName:@"default_image" directory:@"common"]];
        
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        [cell.contentView addSubview:cycleScrollView];
        
        // --- 模拟加载延迟
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            cycleScrollView.imageURLStringsGroup = imagesURLStrings;
        });
        return cell;
    }else if (indexPath.section == 1){
        static NSString *cellIdentifier = @"ADCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSString *service   = [[NSBundle mainBundle] pathForResource:@"JobService" ofType:@"plist"];
        NSArray  *services = [NSArray arrayWithContentsOfFile:service];
        for (int i = 0; i < services.count; i ++) {
            NSDictionary *dic = services[i];
            ServiceButton *serviceBtn = [[ServiceButton alloc] initWithFrame:CGRectMake((i % 3) * kScreenWidth / 3, (i / 3) * kScreenWidth / 3, kScreenWidth / 3, kScreenWidth / 3)];
            serviceBtn.tag = i + 1019;
            serviceBtn.layer.borderColor = [UIColor colorWithRed:235.0/255.0f green:235.0/255.0f blue:241.0/255.0f alpha:1].CGColor;
            serviceBtn.layer.borderWidth = 1;
            [serviceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            serviceBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [serviceBtn addTarget:self action:@selector(serviceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [serviceBtn setTitle:dic[@"title"] forState:UIControlStateNormal];
            [serviceBtn setImage:[UIImage imageWithASName:dic[@"icon"] directory:@"Jobs"] forState:UIControlStateNormal];
            [cell.contentView addSubview:serviceBtn];
        }
        return cell;
    }else{
        
        static NSString *cellIdentifier = @"NewsCell";
        HomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[HomeNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (_responseNewsInfoArr.count == 0) {
            return cell;
        }
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",IMGURL,[[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"listitem_pic_name"]];
        NSString *timeString = [[[[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"createdate"] componentsSeparatedByString:@" "] objectAtIndex:0];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: urlString, @"image", [[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"title"], @"title", timeString, @"time", nil];
        cell.infoDict = dict;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 180;
    }else if (indexPath.section == 1) {
        return kScreenWidth / 3 * 2;
    }else{
        return 70;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }else{
        return 1.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        NormalWebViewController *normalWebVC = [[NormalWebViewController alloc]init];
        normalWebVC.title = [[_responseNewsInfoArr objectAtIndex:indexPath.row]valueForKey:@"title"];
        normalWebVC.urlString = [[_responseNewsInfoArr objectAtIndex:indexPath.row]valueForKey:@"url"];
        [AppDelegate.app.nav pushViewController:normalWebVC animated:YES];
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSString *urlStr = [NSString stringWithFormat:@"%@",[[_responseAdInfoArr objectAtIndex:index]valueForKey:@"url"]];
    if (urlStr) {
        NormalWebViewController *normalWebVC = [[NormalWebViewController alloc]init];
        normalWebVC.title = @"资讯";
        normalWebVC.urlString = urlStr;
        [AppDelegate.app.nav pushViewController:normalWebVC animated:YES];
    }
}

@end
