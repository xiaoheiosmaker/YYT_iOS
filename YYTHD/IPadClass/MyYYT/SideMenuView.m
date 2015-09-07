//
//  SideMenuView.m
//  YYTHD
//
//  Created by shuilin on 10/23/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "SideMenuView.h"

@interface SideMenuView ()
{
    
}
@property(retain,nonatomic) NSMutableArray* items;
@end

@implementation SideMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.items = [[NSMutableArray alloc] init];
    
    SideMenuItem* item;
    
    //下载的MV
    item = [[SideMenuItem alloc] init];
    item.menuID = ID_DOWNLOAD_MV;
    [self.items addObject:item];
    
    //收藏的MV
    item = [[SideMenuItem alloc] init];
    item.menuID = ID_COLLECTION_MV;
    [self.items addObject:item];

    //收藏的悦单
    item = [[SideMenuItem alloc] init];
    item.menuID = ID_COLLECTION_ML;
    [self.items addObject:item];
    
    //创建的悦单
    item = [[SideMenuItem alloc] init];
    item.menuID = ID_MY_ML;
    [self.items addObject:item];
    
    //订阅的艺人
    item = [[SideMenuItem alloc] init];
    item.menuID = ID_ORDER_ARTIST;
    [self.items addObject:item];
    
    self.tbv.dataSource = self;
    self.tbv.delegate = self;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    
    static NSString *CellIdentifier = @"SideMenuCell";
    
    SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SideMenuCell" owner:self options:nil] lastObject];
        cell.delegate = self;
    }
    SideMenuItem* item = [self.items objectAtIndex:index];
    if(item.menuID == ID_DOWNLOAD_MV)
    {
        [cell.itemButton setImage:[UIImage imageNamed:@"DownloadMVPic"] forState:UIControlStateNormal];
        [cell.itemButton setImage:[UIImage imageNamed:@"DownloadMVPic2"] forState:UIControlStateHighlighted];
    }
    else if(item.menuID == ID_COLLECTION_MV)
    {
        [cell.itemButton setImage:[UIImage imageNamed:@"CollectMVPic"] forState:UIControlStateNormal];
        [cell.itemButton setImage:[UIImage imageNamed:@"CollectMVPic2"] forState:UIControlStateHighlighted];
    }
    else if(item.menuID == ID_COLLECTION_ML)
    {
        [cell.itemButton setImage:[UIImage imageNamed:@"CollectMLPic"] forState:UIControlStateNormal];
        [cell.itemButton setImage:[UIImage imageNamed:@"CollectMLPic2"] forState:UIControlStateHighlighted];
    }
    else if(item.menuID == ID_MY_ML)
    {
        [cell.itemButton setImage:[UIImage imageNamed:@"MyMLPic"] forState:UIControlStateNormal];
        [cell.itemButton setImage:[UIImage imageNamed:@"MyMLPic2"] forState:UIControlStateHighlighted];
    }
    else if(item.menuID == ID_ORDER_ARTIST)
    {
        [cell.itemButton setImage:[UIImage imageNamed:@"OrderArtistPic"] forState:UIControlStateNormal];
        [cell.itemButton setImage:[UIImage imageNamed:@"OrderArtistPic2"] forState:UIControlStateHighlighted];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.0;
}

- (void)sideMenuCell:(SideMenuCell *)cell clickedButton:(id)sender
{
    NSIndexPath* indexPath = [self.tbv indexPathForCell:cell];
    NSInteger index = indexPath.row;
    
    SideMenuItem* item = [self.items objectAtIndex:index];
    if(item.menuID == ID_DOWNLOAD_MV)
    {
        [self.delegate sideMenuView:self clickedDownloadMV:sender];
    }
    else if(item.menuID == ID_COLLECTION_MV)
    {
        [self.delegate sideMenuView:self clickedCollectMV:sender];
    }
    else if(item.menuID == ID_COLLECTION_ML)
    {
        [self.delegate sideMenuView:self clickedCollectML:sender];
    }
    else if(item.menuID == ID_MY_ML)
    {
        [self.delegate sideMenuView:self clickedMyML:sender];
    }
    else if(item.menuID == ID_ORDER_ARTIST)
    {
        [self.delegate sideMenuView:self clickedOrderArtist:sender];
    }
    
    self.hidden = YES;
}

@end
