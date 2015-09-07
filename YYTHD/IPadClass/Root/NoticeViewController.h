//
//  NoticeViewController.h
//  YYTHD
//
//  Created by ssj on 14-3-7.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "NoticeDiscussCell.h"
#import "AlertWithComment.h"
@class MVDiscussComment;
@interface NoticeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,NoticeDiscussCellDelegate,AlertWithCommentDelegate>
@property (strong, nonatomic) IBOutlet UIView *announceHeadView;
@property (weak, nonatomic) IBOutlet UIImageView *systemLine;
@property (weak, nonatomic) IBOutlet UIImageView *discussLine;
@property (strong, nonatomic) IBOutlet UIView *sysytemHeadView;
@property (weak, nonatomic) IBOutlet UIImageView *anncouceLine;
@property (strong, nonatomic) IBOutlet UIView *discussHeadView;
@property (weak, nonatomic) IBOutlet UIImageView *nullAnnounce;
@property (weak, nonatomic) IBOutlet UIImageView *nullSystem;
@property (weak, nonatomic) IBOutlet UIImageView *nullDiscuss;
@property (weak, nonatomic) IBOutlet UIView *announceView;
@property (weak, nonatomic) IBOutlet UIView *systemView;
@property (weak, nonatomic) IBOutlet UILabel *noAnnounce;
@property (weak, nonatomic) IBOutlet UIView *discussView;
@property (weak, nonatomic) IBOutlet UILabel *noSystem;
@property (weak, nonatomic) IBOutlet UILabel *noDiscuss;
@property (weak, nonatomic) IBOutlet UIImageView *announcePopImage;
@property (weak, nonatomic) IBOutlet UIImageView *systemPopImage;
@property (weak, nonatomic) IBOutlet UILabel *discussLabel;
@property (weak, nonatomic) IBOutlet UIImageView *discussPopImage;
@property (weak, nonatomic) IBOutlet UILabel *announceLable;
@property (weak, nonatomic) IBOutlet UITableView *systemTableView;
@property (weak, nonatomic) IBOutlet UILabel *systemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *discussBackground;
@property (weak, nonatomic) IBOutlet UITableView *announceTableView;
@property (weak, nonatomic) IBOutlet UIImageView *systemBackground;
@property (weak, nonatomic) IBOutlet UITableView *discussTableView;
@property (weak, nonatomic) IBOutlet UIImageView *announceBackground;
@property (strong, nonatomic) MVDiscussComment *currDiscuss;
- (void)readData;
@end
