//
//  PublicationSearchViewController.m
//  SuperPaper
//
//  Created by lihao on 16/1/13.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PublicationSearchViewController.h"
#import "PublicationSearchTableViewCell.h"

@interface PublicationSearchViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation PublicationSearchViewController
{
    NSArray *_iconArr;
    NSArray *_titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    _iconArr = @[@"searchList1", @"searchList2", @"searchList3", @"searchList1", @"searchList2", @"searchList3"];
    _titleArr = @[@"马克思主义与现实 Marxism & Reality", @"外国文学评论 Foreign Literature Review", @"外国文学评论 Foreign Literature Review", @"马克思主义与现实 Marxism & Reality", @"外国文学评论 Foreign Literature Review", @"外国文学评论 Foreign Literature Review"];
}

// UI搭建
- (void)setupUI
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"backnew"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.title = @"刊物搜索";
    self.view.backgroundColor = [UIColor colorWithRed:180.0 /255.0 green:180.0 /255.0 blue:180.0 /255.0 alpha:1.0];
    
    [self setupSearchBar];
    [self setupTableView];
}

// 配置搜索框
- (void)setupSearchBar
{
    UITextField *searchBar = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, self.view.frame.size.width - 30, 40)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 5;
    searchBar.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    leftView.image = [UIImage imageNamed:@"search"];
    leftView.contentMode = UIViewContentModeCenter;
    searchBar.leftView = leftView;
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
    rightView.frame = CGRectMake(searchBar.frame.size.width - 80, 0, 80, searchBar.frame.size.height);
    [rightView setTitle:@"搜一下" forState:UIControlStateNormal];
    [rightView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightView.backgroundColor = [UIColor colorWithRed:232/255.0 green:79/255.0 blue:135./255.0 alpha:1.0f];
    searchBar.rightView = rightView;
    searchBar.rightViewMode = UITextFieldViewModeAlways;
    
    searchBar.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:searchBar];
}

// 配置tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50 - 64)];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _iconArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    PublicationSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PublicationSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    [cell.iconImg setImage:[UIImage imageNamed:[_iconArr objectAtIndex:indexPath.row]]];
    cell.titleLabel.text = [_titleArr objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

@end
