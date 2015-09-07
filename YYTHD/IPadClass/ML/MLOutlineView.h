//
//  MLOutlineView.h
//  YYTHD
//
//  Created by 崔海成 on 12/18/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLItem;

@interface MLOutlineView : UIView
@property (nonatomic, weak) MLItem *item;
@property (nonatomic) BOOL editing;
@property (nonatomic, weak) id controller;
@end

@protocol MLOutlineViewTargetAction

- (void)changeCover:(id)sender useSourceType:(NSNumber *)sourceType;
- (void)play:(id)sender;
- (void)addToFavorite:(id)sender;
- (void)share:(id)sender;
- (void)beModified:(id)sender property:(NSDictionary *)property;

@end
