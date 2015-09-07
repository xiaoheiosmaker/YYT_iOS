//
//  PlayHistoryViewController.m
//  YYTHD
//
//  Created by IAN on 13-11-6.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "PlayHistoryViewController.h"
#import "PlayHistoryDataController.h"
#import <QuartzCore/QuartzCore.h>
#import "PlayHistroyCell.h"

#define CELL_IMAGEVIEW_TAG 101
#define CELL_TITLELABLE_TAG 102
#define CELL_SUBTITLELABLE_TAG 103


@interface PlayHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIButton *_mvBtn;
    __weak IBOutlet UIButton *_mlBtn;
}

@property (assign, nonatomic) PlayHistoryType selectedHistoryType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PlayHistoryDataController *dataController;

@end

@implementation PlayHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.selectedHistoryType = PlayHistoryMVType;
        self.dataController = [PlayHistoryDataController sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contentSizeForViewInPopover = self.view.size;
    //self.tableView.layer.borderColor = [[UIColor yytLightGrayColor] CGColor];
    //self.tableView.layer.borderWidth = 1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadData];
}

- (void)reloadData
{
    [self.dataController reloadData];
    [self.tableView reloadData];
}


- (IBAction)mvBtnClicked:(id)sender
{
    self.selectedHistoryType = PlayHistoryMVType;
    [self.tableView reloadData];
    [_mvBtn setSelected:YES];
    [_mlBtn setSelected:NO];
}


- (IBAction)mlBtnClicked:(id)sender
{
    self.selectedHistoryType = PlayHistoryMLType;
    [self.tableView reloadData];
    [_mvBtn setSelected:NO];
    [_mlBtn setSelected:YES];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataController numberOfObjectsWithPlayHistoryType:self.selectedHistoryType];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"MVPlayHistoryCell";
    if (self.selectedHistoryType == PlayHistoryMLType) {
        cellIndentifier = @"MLPlayHistoryCell";
    }
    
    PlayHistroyCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        PlayHistroyCellStyle style = PlayHistroyCellStyleDefault;
        if (self.selectedHistoryType == PlayHistoryMLType) {
            style = PlayHistroyCellStyleSquareImage;
        }
        cell = [[PlayHistroyCell alloc] initWithStyle:style reuseIdentifier:cellIndentifier];
    }
    
    PlayHistoryEntity *historyEntity = [self.dataController playHistoryEntityAtIndex:indexPath.row withType:self.selectedHistoryType];
    NSString *imageAddr = historyEntity.coverAddr;
    NSString *artist = historyEntity.artist;
    NSString *title = historyEntity.title;
    
    if ([imageAddr length]>0) {
        [cell.coverImageView setImageWithURL:[NSURL URLWithString:imageAddr]];
    }
    cell.titleLabel.text = title;
    cell.artistLabel.text = artist;
    
    return cell;
}

#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayHistoryEntity *historyEntity = [self.dataController playHistoryEntityAtIndex:indexPath.row withType:self.selectedHistoryType];
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(playHistoryViewController:didSelectedHistoryEntity:)]) {
        [self.actionDelegate playHistoryViewController:self didSelectedHistoryEntity:historyEntity];
    }
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
