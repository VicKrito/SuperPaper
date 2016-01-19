//
//  ASTabBar.m
//  Demo
//
//  Created by Ethan on 16/1/8.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "TabBar.h"
#import "TabBarItem.h"

#define TABBARITEMTAG 22222
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kSizeH 49
#define kLineColor  [UIColor colorWithRed:232/255.0 green:79/255.0 blue:135./255.0 alpha:1.0f]

#define kLine  1.0f/([UIScreen mainScreen].scale) * 2


@interface TabBar() {
    NSArray *_teacherArr;
    NSArray *_studentArr;
    SelectedButtonType _selType;
    UIView *_lineView;
}


@end

@implementation TabBar

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.frame = CGRectMake(0, kHeight - kSizeH , kWidth, kSizeH);
        _lineView = [[UIView alloc] init];
//        _lineView.backgroundColor =  kLineColor;
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_lineView];
        // 老师 4个
        {
            TabBarItem *item1 = [[TabBarItem alloc] initTabbarItemTitle:@"首页"
                                                                  image:@"tabbar_universal_gray_home"
                                                               selImage:@"tabbar_universal_pink_home"];
            item1.tag = TABBARITEMTAG + 0;
            TabBarItem *item2 = [[TabBarItem alloc] initTabbarItemTitle:@"评职"
                                                                  image:@"tabbar_tercher_gray_jobTitle"
                                                               selImage:@"tabbar_teacher_pink_jobTitle"];
            item2.tag = TABBARITEMTAG + 1;
            TabBarItem *item3 = [[TabBarItem alloc] initTabbarItemTitle:@"论文"
                                                                  image:@"tabbar_universal_gray_paper"
                                                               selImage:@"tabbar_universal_pink_paper"];
            item3.tag = TABBARITEMTAG + 2;
            TabBarItem *item4 = [[TabBarItem alloc] initTabbarItemTitle:@"我的"
                                                                  image:@"tabbar_universal_gray_profile"
                                                               selImage:@"tabbar_universal_pink_profile"];
            item4.tag = TABBARITEMTAG + 3;
            _teacherArr = [NSArray arrayWithObjects:item1,item2,item3,item4, nil];
            
            for (TabBarItem *item in _teacherArr)
            {
                [item addTarget:self
                         action:NSSelectorFromString(@"delegateAction:")
               forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        // 学生 5个
        {
            TabBarItem *item1 = [[TabBarItem alloc] initTabbarItemTitle:@"首页"
                                                                  image:@"tabbar_universal_gray_home"
                                                               selImage:@"tabbar_universal_pink_home"];
            item1.tag = TABBARITEMTAG + 0;
            TabBarItem *item2 = [[TabBarItem alloc] initTabbarItemTitle:@"学习"
                                                                  image:@"tabbar_student_gray_learn"
                                                               selImage:@"tabbar_student_pink_learn"];
            item2.tag = TABBARITEMTAG + 1;
            TabBarItem *item3 = [[TabBarItem alloc] initTabbarItemTitle:@"就业"
                                                                  image:@"tabbar_student_gray_obtainEmployment"
                                                               selImage:@"tabbar_student_pink_obtainEmployment"];
            item3.tag = TABBARITEMTAG + 2;
            TabBarItem *item4 = [[TabBarItem alloc] initTabbarItemTitle:@"论文"
                                                                  image:@"tabbar_universal_gray_paper"
                                                               selImage:@"tabbar_universal_pink_paper"];
            item4.tag = TABBARITEMTAG + 3;
            TabBarItem *item5 = [[TabBarItem alloc] initTabbarItemTitle:@"我的"
                                                                  image:@"tabbar_universal_gray_profile"
                                                               selImage:@"tabbar_universal_pink_profile"];
            item5.tag = TABBARITEMTAG + 4;
            _studentArr = [NSArray arrayWithObjects:item1,item2,item3,item4,item5, nil];
            for (TabBarItem *item in _studentArr)
            {
                [item addTarget:self
                         action:NSSelectorFromString(@"delegateAction:")
               forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        self.tabBarDisplayType = TabBarDisplayTypeTeacher;
        self.selectIndex = 0;
        _selType = SelectedButtonTypeHome;
        
    }
    return self;
}

- (void)setSelectIndex:(NSUInteger)selectIndex {
    if (self.tabBarDisplayType == TabBarDisplayTypeTeacher && selectIndex > _teacherArr.count) return;
    if (self.tabBarDisplayType == TabBarDisplayTypeStudent && selectIndex > _studentArr.count) return;
    
    _selectIndex = selectIndex;
    
    if (self.tabBarDisplayType == TabBarDisplayTypeTeacher) {
        switch (selectIndex) {
            case 0:
                _selType = SelectedButtonTypeHome;
                break;
            case 1:
                _selType = SelectedButtonTypeAssessmentTitle;
                break;
            case 2:
                _selType = SelectedButtonTypePapers;
                break;
            case 3:
                _selType = SelectedButtonTypeUser;
                break;
                
            default:
                _selType = SelectedButtonTypeNormal;
                break;
        }
    } else if (self.tabBarDisplayType == TabBarDisplayTypeStudent) {
        switch (selectIndex) {
            case 0:
                _selType = SelectedButtonTypeHome;
                break;
            case 1:
                _selType = SelectedButtonTypeStudy;
                break;
            case 2:
                _selType = SelectedButtonTypeJobs;
                break;
            case 3:
                _selType = SelectedButtonTypePapers;
                break;
            case 4:
                _selType = SelectedButtonTypeUser;
                break;
                
            default:
                _selType = SelectedButtonTypeNormal;
                break;
        }
    }
    
    [self setSelectedButtonType:self.tabBarDisplayType];
    
    [self resetSelectedButton:_selectIndex];
    
    
    if (![self.delegate conformsToProtocol:@protocol(TabBarDelegate)]) return;
    
    if (![self.delegate respondsToSelector:@selector(TabBarDisplayType:didSelectAtIndex:)]) return;
    
    [self.delegate TabBarDisplayType:_selType
                    didSelectAtIndex:(selectIndex)];
}

- (void)resetSelectedButton:(NSUInteger)selectIndex {
    NSArray *tempArr = self.tabBarDisplayType == TabBarDisplayTypeTeacher ? _teacherArr : _studentArr;
    
    [tempArr enumerateObjectsUsingBlock:^(TabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((item.tag - TABBARITEMTAG) != selectIndex) {
            [item setSelected:NO];
        } else {
            [item setSelected:YES];
        }
    }];
    
    [self setNeedsLayout];
}


- (void)setTabBarDisplayType:(TabBarDisplayType)tabBarDisplayType {
    if (_tabBarDisplayType == tabBarDisplayType) return;

    for (UIView *aView in self.subviews) {
        if ([aView isKindOfClass:[TabBarItem class]]) {
            TabBarItem *item = (TabBarItem *)aView;
            if (item.selected) {
                [item setSelected:NO];
            }
            [item removeFromSuperview];
        }
    }
    // 1.显示tabbar显示正确
    
    
    // 2.传出的时候 类型正确

    _tabBarDisplayType = tabBarDisplayType;
    
    [self setSelectedButtonType:_tabBarDisplayType];
    
    NSArray *tempArr = self.tabBarDisplayType == TabBarDisplayTypeTeacher? _teacherArr : _studentArr;

    for (TabBarItem *item in tempArr) {
        if ((item.tag - TABBARITEMTAG) == _selectIndex)
        {
            [item setSelected:YES];
        }
        [self addSubview:item];
    }
    
    [self setNeedsLayout];
    
    
    // 通知代理 刷新视图
    if (![self.delegate conformsToProtocol:@protocol(TabBarDelegate)]) return;
    
    if (![self.delegate respondsToSelector:@selector(TabBarDisplayType:didSelectAtIndex:)]) return;
    
    [self.delegate TabBarDisplayType:_selType didSelectAtIndex:(self.selectIndex)];
}

- (void)setSelectedButtonType:(TabBarDisplayType)tabBarDisplayType {
    if (tabBarDisplayType == TabBarDisplayTypeTeacher) {
        switch (_selType) {
            case SelectedButtonTypeHome:
            case SelectedButtonTypePapers:
            case SelectedButtonTypeUser:
                break;
            case SelectedButtonTypeStudy:
            case SelectedButtonTypeJobs:
                _selType = SelectedButtonTypeAssessmentTitle;
                break;
            default:
                break;
        }
    } else if(tabBarDisplayType == TabBarDisplayTypeStudent) {
        switch (_selType) {
            case SelectedButtonTypeHome:
            case SelectedButtonTypePapers:
            case SelectedButtonTypeUser:
                break;
            case SelectedButtonTypeAssessmentTitle:
                _selType = SelectedButtonTypeJobs;
                break;
            default:
                break;
        }
    }
    
    if (tabBarDisplayType == TabBarDisplayTypeTeacher) {
        switch (_selType) {
            case SelectedButtonTypeHome:
                _selectIndex = 0;
                break;
            case SelectedButtonTypeAssessmentTitle:
                _selectIndex = 1;
                break;
            case SelectedButtonTypePapers:
                _selectIndex = 2;
                break;
            case SelectedButtonTypeUser:
                _selectIndex = 3;
                break;
                
            default:
                break;
        }
    } else if(tabBarDisplayType == TabBarDisplayTypeStudent) {
        switch (_selType) {
            case SelectedButtonTypeHome:
                _selectIndex = 0;
                break;
            case SelectedButtonTypeStudy:
                _selectIndex = 1;
                break;
            case SelectedButtonTypeJobs:
                _selectIndex = 2;
                break;
            case SelectedButtonTypePapers:
                _selectIndex = 3;
                break;
            case SelectedButtonTypeUser:
                _selectIndex = 4;
                break;
                
            default:
                break;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _lineView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kLine);

    NSArray *tempArr = self.tabBarDisplayType == TabBarDisplayTypeTeacher ? _teacherArr : _studentArr;
    
    NSInteger w = tempArr.count; 
    
    CGFloat width = self.bounds.size.width / w;
    for (int i = 0 ; i < tempArr.count; i ++) {
        TabBarItem *item = [tempArr objectAtIndex:i];
        item.frame = CGRectMake( i * width, kLine , width, kSizeH - kLine);
    }
}


#pragma mark - TabBarDelegate
- (void)delegateAction:(TabBarItem *)item {
    if (item.selected) return;
    self.selectIndex = item.tag - TABBARITEMTAG;
    
    if (![self.delegate conformsToProtocol:@protocol(TabBarDelegate)]) return;
    
    if (![self.delegate respondsToSelector:@selector(TabBarDisplayType:didSelectAtIndex:)]) return;
    
    [self.delegate TabBarDisplayType:_selType
                    didSelectAtIndex:(item.tag - TABBARITEMTAG)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
