//
//  IntroViewController.m
//  SuperPaper
//
//  Created by YaoQiang on 16/1/14.
//  Copyright © 2016年 Share technology. All rights reserved.
//
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

#import "IntroViewController.h"
#import "UserSession.h"

@interface IntroViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic)   UIScrollView    *scrollView;
@property (strong, nonatomic)   NSMutableArray  *arrayOfImageSource;
@property (strong, nonatomic)   UIPageControl   *pageControl;
@end

@implementation IntroViewController
- (NSMutableArray *)arrayOfImageSource{
    if (!_arrayOfImageSource) {
        _arrayOfImageSource = [[NSMutableArray alloc]init];
        
        UIImage *image1 =[UIImage imageWithASName:@"g1" directory:@"introducepage" type:@"jpg"];
        UIImage *image2 =[UIImage imageWithASName:@"g2" directory:@"introducepage" type:@"jpg"];
        UIImage *image3 =[UIImage imageWithASName:@"g3" directory:@"introducepage" type:@"jpg"];
//        UIImage *image4 =[UIImage imageNamed:@"guide_4.jpg"];
        if (image1) {
            [_arrayOfImageSource addObject:image1];
        }
        if (image2) {
            [_arrayOfImageSource addObject:image2];
        }
        if (image3) {
            [_arrayOfImageSource addObject:image3];
        }
//        if (image4) {
//            [_arrayOfImageSource addObject:image4];
//        }

    }
    return _arrayOfImageSource;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 30)];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.numberOfPages = [self.arrayOfImageSource count];
    }
    return _pageControl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBarHidden = YES;
    self.view.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self setupScrollView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

//    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [self testUserSession];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}
- (void)setupScrollView{
    CGSize size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    for (int index = 0; index < [self.arrayOfImageSource count]; index ++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[self.arrayOfImageSource objectAtIndex:index]];
        imageView.frame = CGRectMake(index * size.width, 0, size.width, size.height);
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        [self.scrollView addSubview:imageView];
        self.scrollView.contentSize = CGSizeMake((index + 1) * size.width, 0);
        if (index == [self.arrayOfImageSource count] - 1) {
            self.teacherButton = [[UIButton alloc]initWithFrame:CGRectMake(size.width*(index + 1) - 320, SCREEN_HEIGHT - 200, 320, 60)];
            [self.teacherButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.teacherButton setTitle:@"我是老师" forState:UIControlStateNormal];
            self.teacherButton.tag = 1111;
            
            self.studentButton = [[UIButton alloc]initWithFrame:CGRectMake(size.width*(index + 1) - 320, SCREEN_HEIGHT - 150, 320, 60)];
            self.teacherButton.tag = 1112;
            [self.studentButton setTitle:@"我是学生" forState:UIControlStateNormal];
            [self.studentButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

            [self.scrollView addSubview:self.studentButton];
            [self.scrollView addSubview:self.teacherButton];
        }
    }
}
#pragma -mark scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int pageCount = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    _pageControl.currentPage = pageCount;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.navigationController.navigationBarHidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)testUserSession {
//    UserRole role = [[UserSession sharedInstance] currentRole];
//    NSLog(@"----> CurrentUserRole:%ld",role);
//    if (role == kUserRoleStudent) {
//        [[UserSession sharedInstance] setCurrentRole:kUserRoleTeacher];
//    } else if (role == kUserRoleTeacher) {
//        [[UserSession sharedInstance] setCurrentRole:kUserRoleStudent];
//    }
//}

@end
