//
//  MVDiscussCell.m
//  YYTHD
//
//  Created by ssj on 13-10-24.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MVDiscussCell.h"

@implementation MVDiscussCell

- (void)awakeFromNib{
    
    self.headImageView.layer.cornerRadius = 20;
    self.headImageView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.discussContentTextView.editable = NO;
    self.reply.hidden = YES;
    self.replyUserName.hidden = YES;
    self.userName.hidden = YES;
    self.replyUserName.textColor = [UIColor yytGreenColor];
    self.userName.textColor = [UIColor yytGreenColor];
    self.discussContentTextView.bounces = NO;
    self.reply.textColor = [UIColor yytDarkGrayColor];
    self.timeLabel.textColor = [UIColor yytDarkGrayColor];
    self.nameLabel.textColor = [UIColor yytGreenColor];
    self.discussContentTextView.textColor = [UIColor colorWithHEXColor:0xb2b2b2];
    self.discussContentTextView.scrollEnabled = NO;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}

- (void)setContentWithComment:(MVDiscussComment *)comment{
    self.mvDiscussComment = comment;
    BOOL isVip = NO;
    if ([comment.repliedId integerValue] > 0) {
        self.nameLabel.text = comment.userName;
        [self.nameLabel sizeToFit];
        if ([comment.vipLevel intValue] > 0) {
            self.nameLabel.textColor = [UIColor redColor];
            UIImageView *vipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 9)];
            vipImageView.left = self.nameLabel.right;
            [vipImageView setImageWithURL:[NSURL URLWithString:comment.vipImg]];
            [self.contentView addSubview:vipImageView];
            vipImageView.centerY = self.nameLabel.centerY;
            isVip = YES;
        }
        
        NSString *str = @"回复:";
        NIAttributedLabel *label = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 150, 16)];
        label.left = self.nameLabel.right;
        label.backgroundColor = [UIColor clearColor];
        label.centerY = self.nameLabel.centerY+2;
        label.text = [str stringByAppendingString:comment.repliedUserName];
        label.textColor = [UIColor yytGreenColor];
        label.font = [UIFont systemFontOfSize:11];
        [label sizeToFit];
        if (isVip) {
            label.centerX += 13;
        }
        [self.contentView addSubview:label];
        if ([comment.repliedUserVipLevel intValue] > 0) {
            label.textColor = [UIColor redColor];
            UIImageView *vipImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 9)];;
            vipImageView1.left = label.right;
            [vipImageView1 setImageWithURL:[NSURL URLWithString:comment.repliedUserVipImg]];
            [self.contentView addSubview:vipImageView1];
            vipImageView1.centerY = label.centerY;
        }
        NSRange range = {0,3};
        [label setTextColor:[UIColor colorWithHEXColor:0xb2b2b2] range:range];
    }else{
        self.nameLabel.text = comment.userName;
        if ([comment.vipLevel intValue] > 0) {
            [self.nameLabel sizeToFit];
            self.nameLabel.textColor = [UIColor redColor];
            UIImageView *vipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 9)];
            vipImageView.left = self.nameLabel.right;
            [vipImageView setImageWithURL:[NSURL URLWithString:comment.vipImg]];
            [self.contentView addSubview:vipImageView];
            vipImageView.centerY = self.nameLabel.centerY;
        }
    }

    self.timeLabel.text = comment.dateCreated;
    [self.headImageView setImageWithURL:[NSURL URLWithString:comment.userHeadImg] placeholderImage:IMAGE(@"default_headImage")];
    
    CGSize size = [comment.content sizeWithFont:[UIFont systemFontOfSize:12]
                      constrainedToSize:CGSizeMake(250, 1000)
                          lineBreakMode:NSLineBreakByCharWrapping];
    self.discussContentBackground.height = size.height+30;
    self.discussContentTextView.height = size.height+50;
    
    self.discussContentTextView.text = comment.content;

    self.replayBtn.frame = CGRectMake(self.replayBtn.frame.origin.x, self.discussContentTextView.frame.origin.y+ self.discussContentTextView.height - 30, self.replayBtn.frame.size.width, self.replayBtn.frame.size.height);
    self.lineBreadImage.frame = CGRectMake(self.lineBreadImage.frame.origin.x, self.replayBtn.frame.origin.y + self.replayBtn.height + 3, self.lineBreadImage.frame.size.width, self.lineBreadImage.frame.size.height);
    self.timeImageView.centerY = self.timeLabel.centerY = self.replayBtn.centerY;
    [self.contentView bringSubviewToFront:self.replayBtn];

    
}

- (CGFloat)getCellHeight{
    return self.replayBtn.frame.origin.y + self.replayBtn.height + 5;
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
