//
//  PlatformSelectViewController.h
//  YYTHD
//
//  Created by 崔海成 on 12/2/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareAssistantController.h"

@protocol PlatformSelectViewControllerDelegate;

@interface PlatformSelectViewController : UIViewController

@property (nonatomic, weak) id <PlatformSelectViewControllerDelegate> delegate;

@end

@protocol PlatformSelectViewControllerDelegate

- (void)selectOpenPlatform:(int)opType;

@end
