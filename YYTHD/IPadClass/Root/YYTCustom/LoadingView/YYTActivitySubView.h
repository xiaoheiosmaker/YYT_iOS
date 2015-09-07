//
//  YYTActivitySubView.h
//  YYTHD
//
//  Created by shuilin on 11/7/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYTActivitySubView;
@protocol YYTActivitySubViewDelegate <NSObject>
@optional
- (void)yytActivitySubView:(YYTActivitySubView*)subView clickedCancel:(id)sender;
@end

@interface YYTActivitySubView : UIView
{
    
}
@property(assign,nonatomic) id <YYTActivitySubViewDelegate> delegate;

@property(retain,nonatomic) IBOutlet UIActivityIndicatorView* activityIndicatorView;
@property(retain,nonatomic) IBOutlet UILabel* tipLabel;
@property(retain,nonatomic) IBOutlet UIButton* cancelButton;

@end
