//
//  NoticeCell.m
//  YYTHD
//
//  Created by ssj on 14-3-12.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "NoticeCell.h"
#import "NoticeItem.h"
@implementation NoticeCell

- (void)awakeFromNib{
    self.announceLabel.numberOfLines = 0;
    self.timeLabel.textColor = [UIColor yytLightGrayColor];
    self.announceLabel.textColor = [UIColor yytLightGrayColor];
    self.subjectLabel.textColor = [UIColor yytDarkGrayColor];
    self.subjectLabel.font = [UIFont systemFontOfSize:12];
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

- (CGFloat)getCellHeight{
    return self.lineImage.bottom + 5;
}

- (void)setContentWithComment:(NoticeItem *)comment{
    self.subjectLabel.text = comment.subject;
    self.announceLabel.text = comment.content;
    self.timeLabel.text = comment.dateCreated;
    CGSize size = [self.announceLabel.text sizeWithFont:[UIFont systemFontOfSize:12]
                              constrainedToSize:CGSizeMake(224, 1000)
                                  lineBreakMode:NSLineBreakByCharWrapping];
    self.announceLabel.height = size.height + 30;
    [self.announceLabel sizeToFit];
    self.timeLabel.centerY = self.timeImage.centerY = self.announceLabel.centerY + self.announceLabel.height/2 +20;
    [self.timeLabel sizeToFit];
    self.timeImage.left = self.timeLabel.right + 5;
    self.timeLabel.centerY +=3;
    self.timeImage.centerY -= 1;
    self.lineImage.centerY = self.timeImage.bottom + 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
