//
//  NewsItemCell.m
//  YYTHD
//
//  Created by IAN on 14-3-11.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "NewsItemCell.h"
#import "NAImageView.h"


@implementation NewsItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImageWithURL:(NSURL *)imageURL
{
    [self.imageView setImageWithURL:imageURL];
}

- (void)setSummaryText:(NSString *)summaryText
{
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.alignment = NSTextAlignmentJustified;
    pStyle.lineSpacing = 7;
    pStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSDictionary *attr = @{NSParagraphStyleAttributeName: pStyle};
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:summaryText attributes:attr];
    
    self.summaryLabel.attributedText = str;
}

- (void)prepareForReuse
{
    self.imageView.image = nil;
}

@end
