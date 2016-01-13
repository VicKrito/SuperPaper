//
//  PublicationSearchTableViewCell.m
//  SuperPaper
//
//  Created by lihao on 16/1/13.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PublicationSearchTableViewCell.h"

@implementation PublicationSearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 60, 80)];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImg.frame.origin.x + self.iconImg.frame.size.width + 15, self.iconImg.frame.origin.y, self.frame.size.width - 15, 50)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

@end
