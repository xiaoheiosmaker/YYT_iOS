//
//  NoticeDiscussCell.h
//  YYTHD
//
//  Created by ssj on 14-3-12.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Nimbus/NIAttributedLabel.h>
@protocol NoticeDiscussCellDelegate;
@class MVDiscussComment;
@interface NoticeDiscussCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *replyComment;
@property (weak, nonatomic) IBOutlet UILabel *myComment;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImage;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UILabel *replyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *replayLabel;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *lineImage;
@property (weak, nonatomic) id<NoticeDiscussCellDelegate>delegate;
@property (nonatomic, strong) MVDiscussComment *discussComment;
- (IBAction)replyBtnClicked:(id)sender;
- (CGFloat)getCellHeight;
- (void)setContentWithComment:(MVDiscussComment *)comment;
@end
@protocol NoticeDiscussCellDelegate <NSObject>

- (void)didReplyBtn:(NoticeDiscussCell *)cell;

@end