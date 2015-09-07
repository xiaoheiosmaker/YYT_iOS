//
//  VideoQualityCell.h
//  YYTHD
//
//  Created by shuilin on 10/24/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleButtonGroup.h"
#import "SettingsDataController.h"

@class VideoQualityCell;
@protocol VideoQualityCellDelegate <NSObject>
- (void)videoQualityCell:(VideoQualityCell*)cell clickedNormalButton:(id)sender;
- (void)videoQualityCell:(VideoQualityCell*)cell clicked540Button:(id)sender;
@end

@interface VideoQualityCell : UITableViewCell
{
    
}
@property(assign,nonatomic) id <VideoQualityCellDelegate> delegate;
@property(assign,nonatomic) VideoQualityType type;

@end
