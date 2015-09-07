//
//  NoticeCell.h
//  YYTHD
//
//  Created by ssj on 14-3-12.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoticeItem;
@interface NoticeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *announceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImage;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineImage;


- (CGFloat)getCellHeight;
- (void)setContentWithComment:(NoticeItem *)comment;
@end
