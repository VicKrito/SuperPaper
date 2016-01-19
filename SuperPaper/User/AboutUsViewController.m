//
//  AboutUsViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/10.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AboutUsHasNextTableViewCell.h"
#import "VersionTableViewCell.h"

@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_titles;
}
@end

static NSString *const HasNextIdentifier = @"HasNext";
static NSString *const VersionIdentifier = @"Version";
@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titles = @[@"服务条款",
                @"关于我们"
                ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: TableViewDataSource,Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 2) {
        AboutUsHasNextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HasNextIdentifier];
        cell.titleLabel.text = _titles[indexPath.row];
        return cell;
    }else{
        VersionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VersionIdentifier];
        return cell;
    }
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
