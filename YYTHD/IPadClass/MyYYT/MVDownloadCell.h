//
//  MVDownloadCell.h
//  YYTHD
//
//  Created by btxkenshin on 10/22/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "GMGridViewCell.h"
#import "MVDownloadItem.h"

@protocol MVDownloadCellDelegate;

@interface MVDownloadCell : GMGridViewCell

@property (nonatomic,weak) id<MVDownloadCellDelegate> delegate;


+ (CGSize)defaultSize;

- (void)reloadData:(MVDownloadItem *)item;


@end


@protocol MVDownloadCellDelegate <NSObject>

- (void)mvDownloadCellClicked:(MVDownloadCell *)cell;

@end