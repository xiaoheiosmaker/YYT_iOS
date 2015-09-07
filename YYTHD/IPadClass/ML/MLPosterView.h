//
//  MLPosterView.h
//  YYTHD
//
//  Created by 崔海成 on 12/18/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLItem;

@interface MLPosterView : UIView
@property (nonatomic, weak) MLItem *item;
@property (nonatomic, weak) UILabel *titleLabel;
@end
