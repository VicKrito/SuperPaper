//
//  HomeNewsCell.m
//  SuperPaper
//
//  Created by 瞿丹丹 on 16/1/16.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "HomeNewsCell.h"
#import "UIImageView+WebCache.h"

#define LEFT_MARGIN (5.0)

@implementation HomeNewsCell
{
    UIImageView *_headImageView;
    UILabel* _titleLabel;
    UILabel *_timeLabel;//详情
}
- (void)awakeFromNib {
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self creatUI];

    }
    return self;
}


- (void)creatUI{
    
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_MARGIN, LEFT_MARGIN, 60, 60)];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius  = 10;
    [self.contentView addSubview:_headImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + LEFT_MARGIN,LEFT_MARGIN, OWIDTH - CGRectGetMaxX(_headImageView.frame) - LEFT_MARGIN * 2, 40)];
    _titleLabel.font = [UIFont systemFontOfSize:15.0];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.numberOfLines = 2;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame),70- LEFT_MARGIN-20, OWIDTH - CGRectGetMaxX(_headImageView.frame) - LEFT_MARGIN , 20)];
    _timeLabel.font = [UIFont systemFontOfSize:14.0];
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
}

-(void)setInfoDict:(NSDictionary *)infoDict
{
    [_headImageView sd_setImageWithURL:infoDict[@"image"] placeholderImage:[UIImage imageWithASName:@"default_image" directory:@"common"]];
    _titleLabel.text = infoDict[@"title"];
    [_titleLabel sizeToFit];
    CGSize detailmaxSize = CGSizeMake(OWIDTH - CGRectGetMaxX(_headImageView.frame) - LEFT_MARGIN * 2, 40);
    CGSize detailSize = [_titleLabel sizeThatFits:detailmaxSize];
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + LEFT_MARGIN,LEFT_MARGIN , detailSize.width, detailSize.height);
    _timeLabel.text = infoDict[@"time"];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
