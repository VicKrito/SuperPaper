//
//  GetPapersViewController.h
//  SuperPaper
//
//  Created by Emily on 16/1/19.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "BaseViewController.h"

@interface GetPapersViewController : BaseViewController
/**
 *  论文标题
 */
@property(nonatomic, strong) NSString  * paperTitleStr;
/**
 *  日期显示
 */
@property(nonatomic, strong) NSString  * dateStr;
/**
 *  论文ID
 */
@property(nonatomic, strong) NSString  * paperID;

@end
