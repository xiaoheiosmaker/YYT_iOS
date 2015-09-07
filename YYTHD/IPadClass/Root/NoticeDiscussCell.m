//
//  NoticeDiscussCell.m
//  YYTHD
//
//  Created by ssj on 14-3-12.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "NoticeDiscussCell.h"
#import "MVDiscussComment.h"
@implementation NoticeDiscussCell

- (void)awakeFromNib{
    self.headView.layer.cornerRadius = 24;
    self.headView.layer.masksToBounds = YES;
    self.userName.textColor = [UIColor yytGreenColor];
    self.replyNameLabel.textColor = [UIColor yytGreenColor];
    self.replayLabel.textColor = [UIColor yytDarkGrayColor];
    self.replyComment.textColor = [UIColor yytDarkGrayColor];
    self.myComment.textColor = [UIColor colorWithHEXColor:0x858585];
    self.timeLabel.textColor = [UIColor yytLightGrayColor];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    UIImage *image = [UIImage imageNamed:@"notice_line_fu"];
    self.lineImage.image = [image resizableImageWithCapInsets:edgeInsets];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setContentWithComment:(MVDiscussComment *)comment{
    self.discussComment = comment;
    self.replayLabel.text = @"回复:";
    self.userName.text = comment.userName;
    self.replyNameLabel.text = @"我";
    [self.userName sizeToFit];
    [self.replayLabel sizeToFit];
    [self.replyNameLabel sizeToFit];
    BOOL userIsVip = NO;
    self.replyNameLabel.centerY = self.replayLabel.centerY = self.userName.centerY;
    
    if ([comment.vipLevel intValue] > 0) {
        self.userName.textColor = [UIColor redColor];
        UIImageView *vipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 9)];
        vipImageView.left = self.userName.right;
        [vipImageView setImageWithURL:[NSURL URLWithString:comment.vipImg]];
        [self.contentView addSubview:vipImageView];
        vipImageView.centerY = self.userName.centerY;
        userIsVip = YES;
    }
//    if ([comment.repliedUserVipLevel intValue] > 0) {
//        self.replyNameLabel.textColor = [UIColor redColor];
//        UIImageView *vipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 9)];
//        vipImageView.left = self.replyNameLabel.right;
//        [vipImageView setImageWithURL:[NSURL URLWithString:comment.vipImg]];
//        [self.contentView addSubview:vipImageView];
//        vipImageView.centerY = self.replyNameLabel.centerY;
//    }
    
    int imageWith = 0;
    if (userIsVip) {
        imageWith = 11;
    }

    self.replayLabel.left = self.userName.right + imageWith;
    self.replyNameLabel.left = self.replayLabel.right;
    self.replyComment.text = comment.content;
    [self.replyComment sizeToFit];
    [self.headView setImageWithURL:[NSURL URLWithString:comment.userHeadImg] placeholderImage:IMAGE(@"default_headImage")];
    NSString *str = [NSString stringWithFormat:@"回复我的评论“%@”",comment.quotedContent];
    self.myComment.text = str;
    self.myComment.lineBreakMode = NSLineBreakByCharWrapping;
    self.timeLabel.text = comment.dateCreated;
    [self.timeLabel sizeToFit];
    
    self.replyComment.centerY = self.userName.centerY + self.userName.height/2 + 10 + self.replyComment.height/2;
    self.myComment.centerY = self.replyComment.centerY + self.replyComment.height/2 + 30;
    [self.myComment sizeToFit];
    self.timeLabel.centerY = self.myComment.centerY + self.myComment.height/2 + 15;
    self.timeImage.centerY = self.replyBtn.centerY = self.timeLabel.centerY;
    self.lineImage.centerY = self.replyBtn.frame.origin.y + self.replyBtn.height + 5;
    self.timeImage.left = self.timeLabel.right + 5;
//    self.timeImage.centerY -=1;
}

- (CGFloat)getCellHeight{
    return self.lineImage.bottom + 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)replyBtnClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didReplyBtn:)]) {
        [_delegate didReplyBtn:self];
    }
}
@end
