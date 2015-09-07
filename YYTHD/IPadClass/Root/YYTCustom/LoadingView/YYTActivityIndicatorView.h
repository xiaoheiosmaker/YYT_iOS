//
//  YYTActivityIndicatorView.h
//  YYTHD
//
//  Created by shuilin on 11/7/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTActivitySubView.h"

@interface YYTActivityIndicatorView : UIView
{
    
}
@property(assign,nonatomic) id <YYTActivitySubViewDelegate> delegate;

@property(assign,nonatomic) BOOL hidesWhenStopped;           // default is YES.
@property(assign,nonatomic) BOOL supportCancel;              // default is YES.
@property(assign,nonatomic) BOOL supportTip;                 // default is YES.

- (void)setTipText:(NSString*)tipText;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;
@end
