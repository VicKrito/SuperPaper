//
//  ASMainViewController.m
//  Demo
//
//  Created by Ethan on 16/1/8.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "PapersViewController.h"
#import "AssessmentTitleViewController.h"
#import "JobsViewController.h"
#import "StudyViewController.h"
#import "UserViewController.h"
#import "NavigationController.h"
#import "TabBar.h"
#import "IntroViewController.h"



@interface MainViewController ()<TabBarDelegate>

/**
 *  首页
 */
@property (strong, nonatomic) HomeViewController *homeController;
/**
 *  论文
 */
@property (strong, nonatomic) PapersViewController *paperController;
/**
 *  评职
 */
@property (strong, nonatomic) AssessmentTitleViewController *jobTitleController;
/**
 *  就业
 */
@property (strong, nonatomic) JobsViewController *jobsController;
/**
 *  学习
 */
@property (strong, nonatomic) StudyViewController *studyController;
/**
 *  我的
 */
@property (strong, nonatomic) UserViewController *userController;
/**
 *  当前视图
 */
@property (strong, nonatomic) BaseViewController *currentController;
/**
 *  广告
 */
@property (nonatomic,strong) IntroViewController *introPageView;

/**
 *  当前页面索引
 */
@property (assign, nonatomic) NSUInteger pageIndex;

/**
 *  User UIBarButtonItem
 */
@property (nonatomic,strong) UIBarButtonItem *normalBarButtonItem;
@property (nonatomic,strong) UIBarButtonItem *settingBarButtonItem;

@end

@implementation MainViewController


#pragma mark -   methods
- (void)changeTabBarDisplayType:(MainTabBarDisplayType)type
{
    if (type == MainTabBarDisplayTypeStudent) {
        self.tabbar.tabBarDisplayType = TabBarDisplayTypeTeacher;
    }else{
        self.tabbar.tabBarDisplayType = TabBarDisplayTypeStudent;
    }
}


#pragma mark -  like cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"主页面";
    self.tabbar = [[TabBar alloc] init];
    self.tabbar.delegate = self;
    [self.view addSubview:self.tabbar];
    self.tabbar.selectIndex = 0;
    
    [self addChildViewController:self.homeController];
    [self.view addSubview:self.homeController.view];
    [self.homeController didMoveToParentViewController:self];
    self.currentController = self.homeController;
    
    self.navigationItem.rightBarButtonItem = self.normalBarButtonItem;
    
    NSString *versionStr = @"CFBundleShortVersionString";
    NSString *currentVersionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:versionStr];
    NSString *oldVersionStr = [[NSUserDefaults standardUserDefaults] objectForKey:versionStr];
    if (![currentVersionStr isEqualToString:oldVersionStr])
    {
        self.tabbar.hidden = YES;
        IntroViewController *introPageView = [[IntroViewController alloc]init];

        [self addChildViewController:introPageView];
        [self.view addSubview:introPageView.view];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentVersionStr forKey:versionStr];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.introPageView = introPageView;
        [introPageView.studentButton addTarget:self action:@selector(removeScrollViewButton:) forControlEvents:UIControlEventTouchUpInside];
        [introPageView.teacherButton addTarget:self action:@selector(removeScrollViewButton:) forControlEvents:UIControlEventTouchUpInside];
        [self performSelector:@selector(removeIntroPageView:) withObject:introPageView afterDelay:5];
    }
}

- (void)userAction:(UIButton *)button
{
    self.tabbar.selectIndex = self.tabbar.tabBarDisplayType == TabBarDisplayTypeTeacher ? 3 : 4;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.currentController)
    {
        [self.currentController viewWillAppear:animated];
    }
 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.currentController)
    {
        [self.currentController viewWillDisappear:animated];
    }
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    float h = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) > self.topLayoutGuide.length? 20 : 0;
    
    h = self.navigationController.navigationBarHidden? h : h + 44;

    self.tabbar.frame = CGRectMake(0, kHeight - kSizeH - h, kWidth, kSizeH);
    
    [self.view bringSubviewToFront:self.tabbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TabBarDelegate
- (void)TabBarDisplayType:(SelectedButtonType)selectedButtonType didSelectAtIndex:(NSInteger)index {
    self.pageIndex = index;
    BaseViewController *destinationController = nil;
    switch (selectedButtonType)
    {
        case SelectedButtonTypeHome:
            destinationController = self.homeController;
            break;
        case SelectedButtonTypeStudy:
            destinationController = self.studyController;
            break;
        case SelectedButtonTypeJobs:
            destinationController = self.jobsController;
            break;
        case SelectedButtonTypeAssessmentTitle:
            destinationController = self.jobTitleController;
            break;
        case SelectedButtonTypePapers:
            destinationController = self.paperController;
            break;
        case SelectedButtonTypeUser:
            destinationController = self.userController;
            self.userController.mainControllerDelegate = self;
            break;
            
        default:
            break;
    }
    if (self.currentController == destinationController)
    {
        /***  刷新 ****/
        [self.currentController reloadViewController];

        return;
    }
    
    if (destinationController == self.userController)
    {
        self.navigationItem.rightBarButtonItem = self.settingBarButtonItem;
    }else{
        self.navigationItem.rightBarButtonItem = self.normalBarButtonItem;
    }

    self.title = destinationController.titleName;
    [self.currentController viewWillDisappear:YES];
    [self.currentController.view removeFromSuperview];
    [self.currentController removeFromParentViewController];
    [self addChildViewController:destinationController];
    [self.view addSubview:destinationController.view];
    
    [destinationController didMoveToParentViewController:self];

    self.currentController = destinationController;
    [self.view bringSubviewToFront:self.tabbar];
}


#pragma mark -  event response
- (void)settingButtonAction:(UIBarButtonItem *)button
{
    NSLog(@"%s 设置按钮",__FUNCTION__);
}

- (void)removeIntroPageView:(IntroViewController *)introPageView
{
    if (introPageView)
    {
        // 默认选择预留
        
    }
    if (!self.introPageView) return;
    [UIView animateWithDuration:0.3 animations:^{
        self.introPageView.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.tabbar.hidden = NO;
        self.navigationController.navigationBarHidden = NO;
        [self.introPageView.view removeFromSuperview];
        [self.introPageView removeFromParentViewController];
        self.introPageView = nil;
    }];
    
}

- (void)removeScrollViewButton:(UIButton *)button
{
    switch (button.tag) {
        case 1111:
            self.tabbar.tabBarDisplayType = TabBarDisplayTypeStudent;
            [self removeIntroPageView:nil];
            break;
        case 1112:
            self.tabbar.tabBarDisplayType = TabBarDisplayTypeTeacher;
            [self removeIntroPageView:nil];

            break;
            
        default:
            break;
    }
}



#pragma mark -  lazying - getter and setter

- (HomeViewController *)homeController
{
    if (!_homeController)
    {
        _homeController = [[HomeViewController alloc] init];
        CGRect rect = _homeController.view.frame;
        rect.size.height -= 83;
        _homeController.view.frame = rect;
    }
    
    return _homeController;
}

- (PapersViewController *)paperController
{
    if (!_paperController)
    {
        _paperController = [[PapersViewController alloc] init];
        CGRect rect = _paperController.view.frame;
        rect.size.height -= 83;
        _paperController.view.frame = rect;
    }
    
    return _paperController;
}

- (AssessmentTitleViewController *)jobTitleController
{
    if (!_jobTitleController)
    {
        _jobTitleController = [[AssessmentTitleViewController alloc] init];
        CGRect rect = _jobsController.view.frame;
        rect.size.height -= 83;
        _jobsController.view.frame = rect;
    }
    
    return _jobTitleController;
}

- (JobsViewController *)jobsController
{
    if (!_jobsController)
    {
        _jobsController = [[JobsViewController alloc] init];
        CGRect rect = _jobsController.view.frame;
        rect.size.height -= 83;
        _jobsController.view.frame = rect;
    }
    
    return _jobsController;
}

- (StudyViewController *)studyController
{
    if (!_studyController)
    {
        _studyController = [[StudyViewController alloc] init];
        CGRect rect = _studyController.view.frame;
        rect.size.height -= 83;
        _studyController.view.frame = rect;
    }
    
    return _studyController;
}

- (UserViewController *)userController
{
    if (!_userController)
    {
        _userController = [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateInitialViewController];
        CGRect rect = _userController.view.frame;
        rect.size.height -= 83;
        _userController.view.frame = rect;
    }
    
    return _userController;
}

- (UIBarButtonItem *)normalBarButtonItem
{
    if (!_normalBarButtonItem)
    {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        btn.clipsToBounds = YES;
        [btn setBackgroundImage:[UIImage imageWithASName:@"userImage" directory:@"navi"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(userAction:) forControlEvents:UIControlEventTouchUpInside];
        _normalBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    
    return _normalBarButtonItem;
}

- (UIBarButtonItem *)settingBarButtonItem
{
    if (!_settingBarButtonItem)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btn setTitle:@"设置" forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(settingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _settingBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    
    return _settingBarButtonItem;
}

#pragma mark - HttpRequest


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
