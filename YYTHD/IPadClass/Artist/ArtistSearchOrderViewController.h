//
//  ArtistSearchOrderViewController.h
//  YYTHD
//
//  Created by ssj on 13-10-31.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtistOrderView.h"
#import "MVAristDataController.h"
#import "ArtistOrderCell.h"
#import "ArtistDetailView.h"
#import "ArtistComSearchView.h"
#import "YYTActivityIndicatorView.h"

@interface ArtistSearchOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ArtistOrderCellDelegate,ArtistDetailViewDelegate,ArtistComSearchViewDelegate,YYTActivitySubViewDelegate>{
    MVAristDataController * artistDataController;
    int currentOffset;
    int addComSearch;
    ArtistComSearchView *areaView;
    ArtistComSearchView *singerTypeView;
    UIView *_searchView;
    CGFloat topEdge;
    YYTActivityIndicatorView *indicatorView;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *artistTableView;
@property (strong, nonatomic) NSArray *suggestArtistList;
@property (strong, nonatomic) NSArray *artistList;
@property (weak, nonatomic) IBOutlet UIButton *searchComBtn;
@property (strong, nonatomic) NSMutableDictionary *searchParams;
@property (strong, nonatomic) NSMutableDictionary *changeParams;
@end
