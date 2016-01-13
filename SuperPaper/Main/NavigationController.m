//
//  ASNavigationController.m
//  Demo
//
//  Created by Ethan on 16/1/8.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "NavigationController.h"

#define kSelColor  [UIColor colorWithRed:232/255.0 green:79/255.0 blue:135./255.0 alpha:1.0f]

@interface NavigationController ()

@end
@interface  UIImage (colorful)
+ (UIImage *)imageWithColor:(UIColor *)color;
@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)initialize
{
    [super initialize];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    [navBar setBackgroundImage:[[UIImage imageWithColor:kSelColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarMetrics:UIBarMetricsDefault];
    
    navBar.backgroundColor = [UIColor clearColor];
    [navBar setTintColor:[UIColor whiteColor]];
    [navBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];

    
    UIBarButtonItem *btnItem = [UIBarButtonItem appearance];
    NSMutableDictionary * dictM = [NSMutableDictionary dictionary];
    dictM[NSForegroundColorAttributeName] = [UIColor clearColor];
    dictM[NSFontAttributeName] = [UIFont systemFontOfSize:0];

    NSShadow * shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeZero;
    dictM[NSShadowAttributeName] = shadow;
    [btnItem setTitleTextAttributes:dictM forState:UIControlStateNormal];

    NSMutableDictionary * highdictM = [NSMutableDictionary dictionaryWithDictionary:dictM];
    highdictM[NSForegroundColorAttributeName] = [UIColor clearColor];
    [btnItem setTitleTextAttributes:highdictM forState:UIControlStateHighlighted];
    
    NSMutableDictionary * disableDictM = [NSMutableDictionary dictionary];
    disableDictM[NSForegroundColorAttributeName] = [UIColor clearColor];
    [btnItem setTitleTextAttributes:disableDictM forState:UIControlStateDisabled];
    
}



- (void)back{
    [self popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@implementation UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end