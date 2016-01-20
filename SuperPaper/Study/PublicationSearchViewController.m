//
//  PublicationSearchViewController.m
//  SuperPaper
//
//  Created by Emily on 16/1/13.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PublicationSearchViewController.h"
#import "PublicationSearchTableViewCell.h"

#define SEARCHPAGESIZE 30

@interface PublicationSearchViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation PublicationSearchViewController
{
    /// 资源图片文件路径
    NSString *_bundleStr;
    
    /// 搜索框
    UITextField *_searchBar;
    
    /// 返回数据
    NSMutableArray *_responseArr;
    
    /// 搜索table
    UITableView *_searchTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    _responseArr = [[NSMutableArray alloc] init];
    [self setupUI];
}

#pragma mark - 网络请求
- (void)getData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    /**
     ** parameters 参数
     * ownertype  整型    1：教师  其他不明确
     * keywords   字符串  搜索的关键字
     * start_pos  整型    表单中获取数据的开始位置。从0开始
     * list_num   整型    一次获取list数
     * group_id   整型    ownertype为1时  1：刊物  其他不明确
     */
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:1], @"keywords":_searchBar.text, @"start_pos":[NSNumber numberWithInt:(int)_responseArr.count], @"list_num":[NSNumber numberWithInt:SEARCHPAGESIZE], @"group_id":[NSNumber numberWithInt:1]};
    NSString *urlString = [NSString stringWithFormat:@"%@confer_searchnews.php",BASE_URL];
    NSLog(@"%@",urlString);
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *listArray = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
        [_responseArr addObjectsFromArray:listArray];
        NSLog(@"%@",responseObject);
        [_searchTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

// 加载前一页数据
- (void)loadPrePageData
{
    [_responseArr removeAllObjects];
    [self getData];
    [_searchTableView.mj_header endRefreshing];
}

// 加载后一页数据
- (void)loadNextPageData
{
    [self getData];
    [_searchTableView.mj_footer endRefreshing];
}

#pragma mark - UI搭建
// UI搭建
- (void)setupUI
{
    self.title = @"刊物搜索";
    [self setupSearchBar];
    [self setupTableView];
}

// 配置搜索框
- (void)setupSearchBar
{
    // searchBar的容器View
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [self.view addSubview:searchBgView];
    
    // 灰色背景图片
    UIImageView *searchBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    UIImage *image = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"searchBg" ofType:@"png" inDirectory:@"temp"]];
    searchBgImg.image = image;
    [searchBgView addSubview:searchBgImg];
    searchBgImg.userInteractionEnabled = YES;
    
    // 白色背景图片
    UIImageView *searchBarImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, self.view.frame.size.width - 30, 40)];
    UIImage *searchBarImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"searchBar" ofType:@"png" inDirectory:@"temp"]];
    searchBarImg.image = searchBarImage;
    [searchBgImg addSubview:searchBarImg];
    searchBarImg.userInteractionEnabled = YES;
    
    // 左侧图片搜索button
    UIButton *searchIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchIconBtn.frame = CGRectMake(10, 5, 30, 30);
    UIImage *searchIconBtnImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"searchIcon" ofType:@"png" inDirectory:@"temp"]];
    [searchIconBtn setBackgroundImage:searchIconBtnImage forState:UIControlStateNormal];
    [searchIconBtn addTarget:self action:@selector(clickToShowKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [searchBarImg addSubview:searchIconBtn];
    
    // 搜索textfield
    _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, searchBarImg.frame.size.width - 50, 40)];
    _searchBar.layer.cornerRadius = 5;
    _searchBar.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchBar.placeholder = @"输入您要搜索的关键词";
    _searchBar.font = [UIFont systemFontOfSize:16.0];
    _searchBar.textColor = [UIColor colorWithRed:232/255.0 green:79/255.0 blue:135./255.0 alpha:1.0f];
    _searchBar.clearButtonMode = UITextFieldViewModeAlways;
    
    // 右侧文字搜索button
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(_searchBar.frame.size.width - 80, 0, 80, _searchBar.frame.size.height);
    [searchBtn setTitle:@"搜一下" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(clickToSearch) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.backgroundColor = [UIColor colorWithRed:232/255.0 green:79/255.0 blue:135./255.0 alpha:1.0f];
    _searchBar.rightView = searchBtn;
    _searchBar.rightViewMode = UITextFieldViewModeAlways;
    [searchBarImg addSubview:_searchBar];
}

// 配置tableView
- (void)setupTableView
{
    _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50 - 64)];
    _searchTableView.showsVerticalScrollIndicator = NO;
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _searchTableView.backgroundColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242.0 / 255.0 alpha:1.0];
    [self.view addSubview:_searchTableView];
    
    // 下拉刷新
    _searchTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadPrePageData];
    }];
    
    // 上拉加载
    _searchTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadNextPageData];
    }];
    
    _searchTableView.mj_header.backgroundColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242.0 / 255.0 alpha:1.0];
    _searchTableView.mj_footer.backgroundColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242.0 / 255.0 alpha:1.0];
}

#pragma mark - Actions
- (void)clickToShowKeyboard
{
    [_searchBar becomeFirstResponder];
}

- (void)clickToSearch
{
    [_searchBar resignFirstResponder];
    if ([_searchBar.text isEqualToString:@""] || _searchBar.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入搜索关键字" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self getData];
    }
}

#pragma mark - UITableView DataSource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _responseArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    PublicationSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PublicationSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if (_responseArr.count == 0) {
        return cell;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",IMGURL,[[_responseArr objectAtIndex:indexPath.row] valueForKey:@"listitem_pic_name"]];
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:urlString]];
    cell.titleLabel.text = [[_responseArr objectAtIndex:indexPath.row] valueForKey:@"title"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

@end
