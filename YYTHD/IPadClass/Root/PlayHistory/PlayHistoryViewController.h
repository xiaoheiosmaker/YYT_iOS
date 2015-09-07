//
//  PlayHistoryViewController.h
//  YYTHD
//
//  Created by IAN on 13-11-6.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayHistoryEntity.h"
#import "PlayHistoryEntity+Addition.h"

@protocol PlayHistoryActionDelegate;

@interface PlayHistoryViewController : UIViewController

@property (nonatomic, weak) id<PlayHistoryActionDelegate> actionDelegate;
- (void)reloadData;

@end

@protocol PlayHistoryActionDelegate <NSObject>

- (void)playHistoryViewController:(PlayHistoryViewController *)controller didSelectedHistoryEntity:(PlayHistoryEntity *)playHistoryEntity;


@end