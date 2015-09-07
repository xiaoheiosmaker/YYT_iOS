//
//  ExtraUpView.h
//  TestLoad
//
//  Created by isgoinc on 13-2-25.
//  Copyright (c) 2013年 isgoinc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtraViewDefine.h"

@protocol ExtraUpViewDelegate <NSObject>

-(void) comeBeginUpLoading;

@end

@interface ExtraUpView : UIView
{
    RefreshState _state;
    CALayer *_arrowLayer;
}

@property(assign,nonatomic) id <ExtraUpViewDelegate> delegate;
@property(retain,nonatomic) IBOutlet UIImageView* arrowImageView;
@property(retain,nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property(retain,nonatomic) IBOutlet UILabel* tipLabel;

-(void) reset;
-(void) trackY:(CGFloat) y;
-(void) endTrackY:(CGFloat) y;
@end
