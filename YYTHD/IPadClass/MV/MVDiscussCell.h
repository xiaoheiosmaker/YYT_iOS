//
//  MVDiscussCell.h
//  YYTHD
//
//  Created by ssj on 13-10-24.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVDiscussComment.h"
#import <Nimbus/NIAttributedLabel.h>
@protocol MVDiscussCellDelegate;
@interface MVDiscussCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet NIAttributedLabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lineBreadImage;
@property (weak, nonatomic) IBOutlet UITextView *discussContentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *discussContentBackground;
@property (weak, nonatomic) IBOutlet UIButton *replayBtn;
@property (weak, nonatomic) IBOutlet UILabel *replyUserName;
@property (weak, nonatomic) IBOutlet UILabel *reply;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) MVDiscussComment *mvDiscussComment;
@property (weak, nonatomic) id<MVDiscussCellDelegate>delegate;

- (CGFloat)getCellHeight;
- (void)setContentWithComment:(MVDiscussComment *)comment;
@end

@protocol MVDiscussCellDelegate <NSObject>

- (void)didReplyBtn:(MVDiscussCell *)cell;

@end

