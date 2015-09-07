//
//  ArtistDetailViewController.h
//  YYTHD
//
//  Created by ssj on 13-10-29.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVAristDataController.h"
#import "Artist.h"
#import "ArtistDetailView.h"
#import "MVItemView.h"
#import "CombinationView.h"
#import "YYTActivityIndicatorView.h"
#import "ArtistComSearchView.h"

@interface ArtistDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ArtistDetailViewDelegate,MVItemViewDelegate,CombinationViewDelegate,YYTActivitySubViewDelegate,ArtistComSearchViewDelegate>{
    MVAristDataController *artistDataController;
    UIView *_searchView;
    ArtistComSearchView *videoTypeView;
    CGFloat topEdge;
}

@property (weak, nonatomic) IBOutlet UIButton *comSearch;
@property (weak, nonatomic) IBOutlet UIButton *searchByNewBtn;

@property (weak, nonatomic) IBOutlet UIButton *searchByHotBtn;
@property (strong, nonatomic) NSMutableDictionary *searchParams;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) Artist *artist;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (copy, nonatomic) NSString *artistID;
@property (strong, nonatomic) NSArray *videoList;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *videoTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil artistID:(NSString *)artistID;


@end
