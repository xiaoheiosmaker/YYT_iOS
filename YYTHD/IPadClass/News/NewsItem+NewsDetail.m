//
//  NewsItem+NewsDetail.m
//  YYTHD
//
//  Created by IAN on 14-3-14.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "NewsItem+NewsDetail.h"

@implementation NewsItem (NewsDetail)


- (NSAttributedString *)detailAttributedString
{
    NSString *title = [NSString stringWithFormat:@"%@\n",self.title];
    NSString *create = [NSString stringWithFormat:@"音悦Tai  %@  作者：%@\n",self.createTime,self.userName];
    NSString *content = self.content;
    
    //title
    NSMutableParagraphStyle *tStyle = [[NSMutableParagraphStyle alloc] init];
    tStyle.alignment = NSTextAlignmentCenter;
    tStyle.lineSpacing = 5;
    tStyle.paragraphSpacing = 8;
    NSDictionary *titleAttr = @{NSParagraphStyleAttributeName: tStyle,
                                NSFontAttributeName: [UIFont systemFontOfSize:13],
                                NSForegroundColorAttributeName: [UIColor yytDarkGrayColor]};
    NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:title attributes:titleAttr];
    
    //create
    NSMutableParagraphStyle *cStyle = [[NSMutableParagraphStyle alloc] init];
    cStyle.alignment = NSTextAlignmentCenter;
    cStyle.paragraphSpacing = 13;
    NSDictionary *createAttr = @{NSParagraphStyleAttributeName: cStyle,
                                 NSFontAttributeName: [UIFont systemFontOfSize:11],
                                 NSForegroundColorAttributeName: [UIColor colorWithHEXColor:0xa9a6a6]};
    NSMutableAttributedString *attCreate = [[NSMutableAttributedString alloc] initWithString:create attributes:createAttr];
    [attCreate addAttribute:NSForegroundColorAttributeName value:[UIColor yytGreenColor] range:[create rangeOfString:self.userName]];
    
    //content
    NSMutableParagraphStyle *contentStyle = [[NSMutableParagraphStyle alloc] init];
    contentStyle.alignment = NSTextAlignmentJustified;
    contentStyle.lineSpacing = 6;
    contentStyle.paragraphSpacing = 8;
    //contentStyle.firstLineHeadIndent = 32;
    NSDictionary *contentAttr = @{NSParagraphStyleAttributeName: contentStyle,
                                  NSFontAttributeName: [UIFont systemFontOfSize:12],
                                  NSForegroundColorAttributeName: [UIColor colorWithHEXColor:0x6c6b6b]};
    NSAttributedString *attContent = [[NSAttributedString alloc] initWithString:content attributes:contentAttr];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:attTitle];
    [attString appendAttributedString:attCreate];
    [attString appendAttributedString:attContent];
    
    return attString;
}

@end
