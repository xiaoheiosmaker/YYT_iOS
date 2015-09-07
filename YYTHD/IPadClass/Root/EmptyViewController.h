//
//  EmptyViewController.h
//  YYTHD
//
//  Created by shuilin on 11/22/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceView.h"
#import "ExtraUpView.h"

@class EmptyViewController;
@protocol EmptyViewControllerDelegate <NSObject>
@optional
//通知可以开始加载
- (void)triggerLoading:(EmptyViewController*)viewController;

@end

@interface EmptyViewController : UIViewController<ExtraUpViewDelegate,UIScrollViewDelegate>
{
    
}
@property(assign,nonatomic) id <EmptyViewControllerDelegate> delegate;
@property(retain,nonatomic) IBOutlet UIScrollView* scrv;
@property(assign,nonatomic) BOOL hidden;

//指定图片和文本提示信息
@property(retain,nonatomic) UIImage* holderImage;
@property(retain,nonatomic) NSString* holderText;

- (void)bringToFront;
-(void) doneLoading;    //加载完成后调用
@end
