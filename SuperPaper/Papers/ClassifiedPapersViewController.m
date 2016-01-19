//
//  ClassifiedPapersViewController.m
//  SuperPaper
//
//  Created by Emily on 16/1/15.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ClassifiedPapersViewController.h"
#import "PapersSearchViewController.h"
#import "ExportableWebViewController.h"
#import "PapersSortsViewController.h"
#import "GetPapersViewController.h"

#define SEARCHPAGESIZE 30
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

@interface ClassifiedPapersCell : UITableViewCell

@property (nonatomic, strong) UILabel *titltLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation ClassifiedPapersCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titltLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth - 30, 20)];
        self.titltLabel.font = [UIFont systemFontOfSize:17.0];
        self.titltLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titltLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titltLabel.frame.origin.x, CGRectGetMaxY(self.titltLabel.frame) + 5, self.titltLabel.frame.size.width, 40)];
        self.detailLabel.font = [UIFont systemFontOfSize:15.0];
        self.detailLabel.textColor = [UIColor grayColor];
        self.detailLabel.numberOfLines = 3;
        [self.contentView addSubview:self.detailLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 110, CGRectGetMaxY(self.detailLabel.frame) + 5, 100, 20)];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.font = [UIFont systemFontOfSize:14.0];
        self.dateLabel.textColor = [UIColor grayColor];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.dateLabel];
    }
    return self;
}

@end

@interface ClassifiedPapersViewController ()<UITableViewDataSource, UITableViewDelegate,ClassifiedPapersViewControllerDelegate>

@end

@implementation ClassifiedPapersViewController
{
    UITableView *_tableView;
    NSMutableArray *_paperArray;
    
    /// 资源图片文件路径
    NSString *_bundleStr;

    NSString *tagId;

    /// 下拉加载header
    MJRefreshNormalHeader *header;
    
    /// 上拉刷新footer
    MJRefreshAutoNormalFooter *footer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    _paperArray = [[NSMutableArray alloc] init];
    tagId = @"";
    [self getData];
    [self setupUI];
}

#pragma mark - 网络请求获取数据
- (void)getData
{
    NSDictionary *parameters = @{@"type_id":[NSNumber numberWithInt:[self.type_id intValue]], @"start_pos":[NSNumber numberWithInt:0], @"list_num":[NSNumber numberWithInt:15], @"paper_tagid":tagId};
    NSString *urlString =  [NSString stringWithFormat:@"%@paper_list.php",BASE_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setTimeoutInterval:15.0f];
    [manager POST:urlString
       parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
           
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
           NSDictionary * dataDic = [NSDictionary dictionary];
           dataDic = responseObject;
           NSLog(@"%@",dataDic);
           if (dataDic) {
               NSArray * listData = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
               [_paperArray addObjectsFromArray:listData];
               [_tableView reloadData];
           }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSLog(@"%@",error);
       }];
}

- (void)getDifferentTagData
{
    NSDictionary *parameters = @{@"type_id":[NSNumber numberWithInt:[self.type_id intValue]], @"start_pos":[NSNumber numberWithInt:0], @"list_num":[NSNumber numberWithInt:15], @"paper_tagid":tagId};
    NSString *urlString =  [NSString stringWithFormat:@"%@paper_list.php",BASE_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setTimeoutInterval:15.0f];
    [manager POST:urlString
       parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
           
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
           NSDictionary * dataDic = [NSDictionary dictionary];
           dataDic = responseObject;
           NSLog(@"%@",dataDic);
           if (dataDic) {
               NSArray * listData = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
               [_paperArray removeAllObjects];
               [_paperArray addObjectsFromArray:listData];
               [_tableView reloadData];
           }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSLog(@"%@",error);
       }];
}

// 加载前一页数据
- (void)loadPrePageData
{
    [_paperArray removeAllObjects];
    [self getData];
    [_tableView.mj_header endRefreshing];
}

// 加载后一页数据
- (void)loadNextPageData
{
    [self getData];
    [_tableView.mj_footer endRefreshing];
}

#pragma mark - UI搭建
- (void)setupUI
{
    [self setupTitleView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadPrePageData];
    }];
    
    // 上拉加载
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadNextPageData];
    }];
    
    _tableView.mj_header.backgroundColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242.0 / 255.0 alpha:1.0];
    _tableView.mj_footer.backgroundColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242.0 / 255.0 alpha:1.0];
}

- (void)setupTitleView
{
    UIImage *image = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"searchBtn" ofType:@"png" inDirectory:@"Paper"]];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(10, 0, 25, 25);
    [searchBtn setImage:image forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchpPapers) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    UIButton *sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sortBtn.frame = CGRectMake(10, 0, 25, 25);
    [sortBtn setImage:image forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(sortPapers) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortBtn];
    
    self.navigationItem.rightBarButtonItems = @[searchItem, sortItem];
}

#pragma mark - Actions
- (void)searchpPapers
{
    PapersSearchViewController *papersSearchVC = [[PapersSearchViewController alloc] init];
    papersSearchVC.title = [NSString stringWithFormat:@"%@搜索",self.title];
    [AppDelegate.app.nav pushViewController:papersSearchVC animated:YES];
}

- (void)sortPapers
{
    PapersSortsViewController *sortsView = [[PapersSortsViewController alloc]init];
    sortsView.typeId = self.type_id;
    sortsView.delegate =self;
    [self.navigationController pushViewController:sortsView animated:YES];
}

#pragma mark - ClassifiedPapersViewControllerDelegate
- (void)passTypeId:(NSString *)typeId
{
    tagId = typeId;
    [self getDifferentTagData];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _paperArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    ClassifiedPapersCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ClassifiedPapersCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if (_paperArray.count == 0) {
        return cell;
    }
    cell.titltLabel.text = [[_paperArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.detailLabel.text = [[_paperArray objectAtIndex:indexPath.row] valueForKey:@"description"];
    cell.dateLabel.text = [[[[_paperArray objectAtIndex:indexPath.row] valueForKey:@"createdate"] componentsSeparatedByString:@" "] objectAtIndex:0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetPapersViewController *getPapersVC = [[GetPapersViewController alloc] init];
    getPapersVC.title = [[_paperArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    getPapersVC.paperTitleStr = [[_paperArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    getPapersVC.dateStr = [[[[_paperArray objectAtIndex:indexPath.row] valueForKey:@"createdate"] componentsSeparatedByString:@" "] objectAtIndex:0];
    getPapersVC.paperID = [[_paperArray objectAtIndex:indexPath.row] valueForKey:@"id"];
    [AppDelegate.app.nav pushViewController:getPapersVC animated:YES];
}

@end
