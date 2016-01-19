//
//  PersonalInfoViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/15.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "PersonalInfoHasSelectionTableViewCell.h"
#import "PersonalInfoTableViewCell.h"

@interface PersonalInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy) NSString *telNo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *carrior;
@property (nonatomic, copy) NSString *college;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *footerView;
@end

static NSString *const TelIdentifier = @"Tel";
static NSString *const HasNextIdentifier = @"HasNext";
@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.telNo = @"18525358682";
    self.name = @"于栋天";
    self.gender = @"男";
    self.age = 26;
    self.carrior = @"iOS Developer";
    self.college = @"大连理工大学";
    [self setupSubmitBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: Helper
- (void) setupSubmitBtn
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:238.0f/255 green:238.0f/255 blue:238.0f/255 alpha:1];
    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor colorWithRed:232.0f/255 green:79.0f/255 blue:135.0f/255 alpha:1]];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = 5;
    submitBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:submitBtn];
    
    NSLayoutConstraint *submitBtnLeadingCon = [NSLayoutConstraint constraintWithItem:submitBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:10];
    NSLayoutConstraint *submitBtnTrailingCon = [NSLayoutConstraint constraintWithItem:submitBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10];
    NSLayoutConstraint *submitBtnTopCon = [NSLayoutConstraint constraintWithItem:submitBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:20];
    NSLayoutConstraint *submitBtnHeightCon = [NSLayoutConstraint constraintWithItem:submitBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50];
    [view addConstraints:@[submitBtnTopCon,submitBtnHeightCon,submitBtnLeadingCon,submitBtnTrailingCon]];
    self.footerView = view;
}
//MARK:TableViewDataSource,Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        PersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TelIdentifier];
        cell.titleLabel.text = @"手机号码";
        cell.telNoLabel.text = self.telNo;
        return cell;
    }
    PersonalInfoHasSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HasNextIdentifier];
    switch (indexPath.row) {
        case 1:
        {
            cell.titleLabel.text = @"真实姓名";
            cell.detailsLabel.text = self.name;
            
        }
            break;
        case 2:{
            cell.titleLabel.text = @"性   别";
            cell.detailsLabel.text = self.gender;
        }
            break;
        case 3:{
            cell.titleLabel.text = @"年   龄";
            cell.detailsLabel.text = [NSString stringWithFormat:@"%lu",self.age];
        }
            break;
        case 4:{
            cell.titleLabel.text = @"职业选择";
            cell.detailsLabel.text = self.carrior;
        }
            break;
        case 5:{
            cell.titleLabel.text = @"学校名称";
            cell.detailsLabel.text = self.college;
        }
        default:
            break;
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 70;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        
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
