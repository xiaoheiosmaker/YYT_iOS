//
//  MVDetailViewController.h
//  YYTHD
//
//  Created by ssj on 13-10-22.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVItemView.h"
#import "AlertWithComment.h"
#import "MVDataController.h"
#import "AlertWithTip.h"
#import "YYTActivityIndicatorView.h"
#import "MVDiscussCell.h"
#import "YYTAlert.h"
#import "EmptyViewController.h"
#import "BaseViewController.h"

#define MOREOFFSET 10
#define SELECTITEM 200
@class MVItem;
@class MVDiscussItem;
@class MVDiscussComment;


@interface MVDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MVItemViewDelegate,AlertWithCommentDelegate,YYTActivitySubViewDelegate,MVDiscussCellDelegate,YYTAlertDelegate,EmptyViewControllerDelegate>{
    MVDataController *mvChannelData;
}
@property BOOL isMoviePlayStarted;
@property (copy, nonatomic) NSString *viewId;
@property(retain,nonatomic) EmptyViewController* emptyViewController;
@property (weak, nonatomic) IBOutlet UILabel *discussCommentNull;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *navBackGround;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) NSMutableArray *discussCommentArray;
@property (strong, nonatomic) IBOutlet UIView *discussView;
@property (weak, nonatomic) IBOutlet UIImageView *tableHeadView;
@property (strong, nonatomic) MVDiscussItem *mvDiscussItem;
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (weak, nonatomic) IBOutlet UIImageView *discussNullImage;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *discussViewBackground;
@property (strong, nonatomic) IBOutlet UITableView *discussTableView;
@property (weak, nonatomic) IBOutlet UIImageView *discussBackground;
@property (weak, nonatomic) IBOutlet UIButton *discussBtn;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *pullUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *pullDownBtn;
@property (strong, nonatomic) MVItem *mvItem;
@property (weak, nonatomic) IBOutlet UIView *artistView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailPicView;
@property (weak, nonatomic) IBOutlet UILabel *viewNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playCountIcon;
@property (weak, nonatomic) IBOutlet UIImageView *discussCountIcon;
@property (weak, nonatomic) IBOutlet UILabel *descriptionCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *discussCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *relateedTableView;
@property (strong, nonatomic) MVDiscussComment *currDisCuss;
@property (weak, nonatomic) IBOutlet UIImageView *descBackgroundView;
@property (strong, nonatomic) NSArray *playList;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *addToML;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

- (id)initWithId:(NSString *)viewId;
- (id)initWithId:(NSString *)viewId playList:(NSArray *)playList;

@end
