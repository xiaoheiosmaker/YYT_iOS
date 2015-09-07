//
//  ArtistOrderViewController.h
//  YYTHD
//
//  Created by ssj on 13-10-26.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "BaseViewController.h"
#import "ArtistScrollerCell.h"
#import "MVItemView.h"
#import "YYTActivityIndicatorView.h"
@class MVAristDataController;
@interface ArtistOrderViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,ArtistScrollerCellDelegate,MVItemViewDelegate,YYTActivitySubViewDelegate>
{
    MVAristDataController *mvArtistDataController;
}
@property (weak, nonatomic) IBOutlet UITableView *artistTableView;
@property (strong, nonatomic) NSArray *artistList;
@property (strong, nonatomic) NSArray *videoList;
@end

