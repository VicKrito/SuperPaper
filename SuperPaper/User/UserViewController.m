//
//  UserViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "UserViewController.h"
#import "MainViewController.h"
typedef enum{
    
    UserHeaderTypeLogin,
    UserHeaderTypeRegister,
    UserHeaderTypeCamera
    
}UserHeaderType;


@interface UserViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *backTableView;
@property (nonatomic ,strong) UIView *loginHeaderView;
@property (nonatomic ,strong) UIView *userHeaderView;
@property (weak, nonatomic)  UILabel *displayTypeLabel;
@property (weak, nonatomic)  UILabel *paperNumLabel;
@property (weak, nonatomic)  UILabel *telephoneNumLabel;
@property (weak, nonatomic) UIButton *loginButton;
@property (weak, nonatomic) UIButton *registerButton;
@property (weak, nonatomic) UIButton *userImageButton;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoginHeaderView];
    [self setupUserHeaderView];
    
}

- (void)userHeaderType:(UserHeaderType)type
{
    switch (type) {
        case UserHeaderTypeCamera:
            NSLog(@"UserHeaderTypeCamera");
            break;
        case UserHeaderTypeLogin:
            NSLog(@"UserHeaderTypeLogin");
            break;
        case UserHeaderTypeRegister:
            NSLog(@"UserHeaderTypeRegister");
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSString *)titleName {
    return @"我的";
}

//MARK: Helper
- (void) setupLoginHeaderView
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 130)];
    imageView.image = [UIImage imageNamed:@"bg_mine_head_login"];
    self.loginHeaderView = imageView;
    
    UIButton *loginBtn = [[UIButton alloc]init];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:24]];
    self.loginButton = loginBtn;
    loginBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *loginBtnWidthCon = [NSLayoutConstraint constraintWithItem:loginBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80];
    NSLayoutConstraint *loginBtnHeightCon = [NSLayoutConstraint constraintWithItem:loginBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60];
    NSLayoutConstraint *loginBtnTrailingCon = [NSLayoutConstraint constraintWithItem:loginBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-24];
    NSLayoutConstraint *loginBtnCenterYCon = [NSLayoutConstraint constraintWithItem:loginBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [imageView addSubview:loginBtn];
    [imageView addConstraints:@[loginBtnWidthCon,loginBtnHeightCon,loginBtnTrailingCon,loginBtnCenterYCon]];
    
    UIButton *registerBtn = [[UIButton alloc]init];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:24]];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.registerButton = registerBtn;
    registerBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *registerBtnWidthCon = [NSLayoutConstraint constraintWithItem:registerBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80];
    NSLayoutConstraint *registerBtnHeightCon = [NSLayoutConstraint constraintWithItem:registerBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60];
    NSLayoutConstraint *registerBtnTrailingCon = [NSLayoutConstraint constraintWithItem:registerBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:24];
    NSLayoutConstraint *registerBtnCenterYCon = [NSLayoutConstraint constraintWithItem:registerBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [imageView addSubview:registerBtn];
    [imageView addConstraints:@[registerBtnWidthCon,registerBtnHeightCon,registerBtnTrailingCon,registerBtnCenterYCon]];
    
    
    UIView *whiteLine = [[UIView alloc]init];
    whiteLine.backgroundColor = [UIColor whiteColor];
    whiteLine.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *whiteLineWidthCon = [NSLayoutConstraint constraintWithItem:whiteLine attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1];
    NSLayoutConstraint *whiteLineCenterXCon = [NSLayoutConstraint constraintWithItem:whiteLine attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *whiteLineCenterYCon = [NSLayoutConstraint constraintWithItem:whiteLine attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *whiteLineHeightCon = [NSLayoutConstraint constraintWithItem:whiteLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50];
    [imageView addSubview:whiteLine];
    [imageView addConstraints:@[whiteLineWidthCon,whiteLineHeightCon,whiteLineCenterXCon,whiteLineCenterYCon]];
    
    
    
}

- (void) setupUserHeaderView
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 130)];
    imageView.image = [UIImage imageNamed:@"bg_mine_head_login"];
    self.userHeaderView = imageView;
    UIImageView *headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_normalIcon"]];
    headImageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *headImageViewWidthCon = [NSLayoutConstraint constraintWithItem:headImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80];
    NSLayoutConstraint *headImageViewHeightCon = [NSLayoutConstraint constraintWithItem:headImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80];
    NSLayoutConstraint *headImageViewCenterXCon = [NSLayoutConstraint constraintWithItem:headImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *headImageViewCenterYCon = [NSLayoutConstraint constraintWithItem:headImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-17];
    [imageView addSubview:headImageView];
    [imageView addConstraints:@[headImageViewWidthCon,headImageViewHeightCon,headImageViewCenterYCon,headImageViewCenterXCon]];
    
    UIControl *control = [[UIControl alloc]init];
    control.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *controlWidthCon = [NSLayoutConstraint constraintWithItem:control attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
    NSLayoutConstraint *controlHeightCon = [NSLayoutConstraint constraintWithItem:control attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
    NSLayoutConstraint *controlTrailingCon = [NSLayoutConstraint constraintWithItem:control attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:headImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *controlBottomCon = [NSLayoutConstraint constraintWithItem:control attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:headImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [imageView addSubview:control];
    [imageView addConstraints:@[controlWidthCon,controlHeightCon,controlBottomCon,controlTrailingCon]];
    
    UIButton *cameraBtn = [[UIButton alloc]init];
    [cameraBtn setImage:[UIImage imageNamed:@"user_camera"] forState:UIControlStateNormal];
    cameraBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cameraBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *cameraBtnWidthCon = [NSLayoutConstraint constraintWithItem:cameraBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];
    NSLayoutConstraint *cameraBtnHeightCon = [NSLayoutConstraint constraintWithItem:cameraBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];
    NSLayoutConstraint *cameraBtnTrailingCon = [NSLayoutConstraint constraintWithItem:cameraBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:control attribute:NSLayoutAttributeTrailing multiplier:1 constant:-5];
    NSLayoutConstraint *cameraBtnBottomCon = [NSLayoutConstraint constraintWithItem:cameraBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:control attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [control addSubview:cameraBtn];
    [control addConstraints:@[cameraBtnBottomCon,cameraBtnHeightCon,cameraBtnTrailingCon,cameraBtnWidthCon]];
    
    UILabel *telLabel = [[UILabel alloc]init];
    telLabel.text = @"18525358682";
    telLabel.textAlignment = NSTextAlignmentCenter;
    telLabel.textColor = [UIColor whiteColor];
    telLabel.font = [UIFont systemFontOfSize:15];
    telLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *telLabelWidthCon = [NSLayoutConstraint constraintWithItem:telLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:194];
    NSLayoutConstraint *telLabelHeightCon = [NSLayoutConstraint constraintWithItem:telLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:21];
    NSLayoutConstraint *telLabelTopCon = [NSLayoutConstraint constraintWithItem:telLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:8];
    NSLayoutConstraint *telLabelCenterXCon = [NSLayoutConstraint constraintWithItem:telLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [imageView addSubview:telLabel];
    [imageView addConstraints:@[telLabelCenterXCon,telLabelHeightCon,telLabelTopCon,telLabelWidthCon]];
    
    
    
    
    
}

//MARK: TabelViewDataSource,Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (/* DISABLES CODE */ (1)) // 登陆状态
    {
        return section == 0 ? 6 : 3;
    }else
    {
        return section == 0 ? 3 : 3;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"userReuse%ld",indexPath.row ]];
        if (indexPath.row == 4)
        {
            self.displayTypeLabel = [cell viewWithTag:178802];
        }else if (indexPath.row == 5)
        {
            self.paperNumLabel = [cell viewWithTag:178803];
        }
    }else if (indexPath.section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"userCell%ld",indexPath.row ]];
        if (indexPath.row == 2)
        {
            self.telephoneNumLabel = [cell viewWithTag:178804];
        }
    }
    
    if (cell == nil)
    {
        NSLog(@"indexpathsection %ld  indexpath.row = %ld",indexPath.section , indexPath.row);
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 130;
    };
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return self.userHeaderView;
    }else
        return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *colorString = nil;
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                colorString = @"green"; // 我的消息
                break;
            case 1:
                colorString = @"yellow"; // 我的信息
                break;
            case 2:
                colorString = @"orange"; // 我的账户
                break;
            case 3:
                colorString = @"pink";  // 我的邀请
                break;
            case 5:
                colorString = @"gray";  // 我的论文
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                colorString = @"blue"; // 关于我们
                break;
            case 1:
                colorString = @"purple"; // 意见反馈
                break;

            
            default:
                break;
        }
    }
    
    if (colorString.length > 0)
    {
        [self performSegueWithIdentifier:colorString sender:nil];
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
