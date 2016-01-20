//
//  ASMainViewController.h
//  Demo
//
//  Created by Ethan on 16/1/8.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "BaseViewController.h"
#import "TabBar.h"


typedef NS_ENUM(NSInteger , MainTabBarDisplayType) {
    
    MainTabBarDisplayTypeTeacher = 1,
    MainTabBarDisplayTypeStudent
};

/**
 *  @brief 主窗口类
 *
 */
@interface MainViewController : BaseViewController
/**
 *  TabBar
 */
@property (strong, nonatomic) TabBar *tabbar;

- (void)changeTabBarDisplayType:(MainTabBarDisplayType)type;

@end
