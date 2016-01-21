//
//  NormalAssessmentViewController.m
//  SuperPaper
//
//  Created by mapbarDaLian on 16/1/21.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "NormalAssessmentViewController.h"
#import "HomeNewsCell.h"
#import "NormalWebViewController.h"

@interface NormalAssessmentViewController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  加载进度
 */
@property(nonatomic, strong) UIActivityIndicatorView * indicatorView;
@end

@implementation NormalAssessmentViewController
{
    UITableView *_jobTableView;
    NSMutableArray *_responseNewsInfoArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _responseNewsInfoArr = [[NSMutableArray alloc] init];
    
    [self setupUI];
    [self getJobNewsInfo];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI搭建
- (void)setupUI
{
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.frame = CGRectMake(OWIDTH / 2 - 15, OHIGHT / 2 - 15, 30, 30);
    [_indicatorView startAnimating];
    [self.view addSubview:_indicatorView];
    
    _jobTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, OWIDTH, OHIGHT - 64)];
    _jobTableView.dataSource = self;
    _jobTableView.delegate = self;
    _jobTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    [self getJobNewsInfo];
    [_jobTableView.mj_header endRefreshing];
}

// 上拉加载
- (void)pullUpPageData
{
    
    [self getJobNewsInfo];
    [_jobTableView.mj_footer endRefreshing];
}

#pragma mark - AFnetworking 网络数据请求
//获取评职主页资讯
- (void)getJobNewsInfo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    /**
     ** parameters 参数
     * ownertype  整型    固定值 1:
     * group_id   整型    19:公务员，20：事业单位，21：国企单位，22：外企，23：民营，24：兼职
     * start_pos  整型    表单中获取数据的开始位置。从0开始
     * list_num   整型    一次获取list数
     */
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:1], @"group_id":[NSNumber numberWithInteger:self.group_id], @"start_pos":[NSNumber numberWithInt:(int)_responseNewsInfoArr.count], @"list_num":[NSNumber numberWithInt:15]};
    NSString *urlString = [NSString stringWithFormat:@"%@confer_newsinfo.php",BASE_URL];
    NSLog(@"%@",urlString);
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [_indicatorView stopAnimating];
        [_indicatorView setHidden:YES];
        
        NSArray *myArr = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
        [_responseNewsInfoArr addObjectsFromArray:myArr];
        NSLog(@"%@",responseObject);
        [_jobTableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _responseNewsInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Incell";
    HomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[HomeNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (_responseNewsInfoArr.count == 0) {
        return cell;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",IMGURL,[[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"listitem_pic_name"]];
    NSString *timeString = [[[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"createdate"] substringToIndex:10];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: urlString, @"image", [[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"title"], @"title", timeString, @"time", nil];
    cell.infoDict = dict;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalWebViewController *normalWebVC = [[NormalWebViewController alloc]init];
    normalWebVC.title = [[_responseNewsInfoArr objectAtIndex:indexPath.row]valueForKey:@"title"];
    normalWebVC.urlString = [[_responseNewsInfoArr objectAtIndex:indexPath.row]valueForKey:@"url"];
    [AppDelegate.app.nav pushViewController:normalWebVC animated:YES];
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
