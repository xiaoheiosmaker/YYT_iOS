//
//  AddMVToMLAssistantController.m
//  YYTHD
//
//  Created by 崔海成 on 11/1/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "AddMVToMLAssistantController.h"
#import "MLDataController.h"
#import "MLItem.h"
#import "MVItem.h"
#import "AddMVToMLViewController.h"
#import "UserDataController.h"
#import "EditableMLParticularViewController.h"
#import "MLParticularViewController.h"

@interface AddMVToMLAssistantController ()

- (void)addToML:(MLItem *)ml;
- (UIViewController *)rootViewController;
- (void)createMLWithTitle:(NSString *)title coverImageURLString:(NSString *)URLString description:(NSString *)description videoIDs:(NSString *)vids completion:(void (^)(MLItem *, NSError *))completion;

@end

@implementation AddMVToMLAssistantController
@synthesize mvToAdd = _mvToAdd;

+ (AddMVToMLAssistantController *)sharedInstance
{
    
    static AddMVToMLAssistantController *sharedInstance = nil;
    
    if (!sharedInstance)
    {
        sharedInstance = [super allocWithZone:nil];
    }
    
    return sharedInstance;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (void)setMvToAdd:(MVItem *)mvToAdd
{
    BOOL login = [[UserDataController sharedInstance] isLogin];
    if (!login && mvToAdd) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        loginViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        CGSize origSize = loginViewController.view.frame.size;
        [self.rootViewController presentViewController:loginViewController animated:NO completion:^{
            UIView *view = loginViewController.view;
            UIView *superView = view.superview;
            superView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            NSArray *subViews = superView.subviews;
            for (UIView *subView in subViews) {
                if (subView != view) {
                    subView.hidden = YES;
                }
            }
            CGPoint curCenter = superView.center;
            superView.frame = CGRectMake(0, 0, origSize.height, origSize.width);
            superView.center = curCenter;
        }];
        return;
    }
    if (mvToAdd != _mvToAdd) {
        _mvToAdd = mvToAdd;
        if (_mvToAdd != nil) {
            AddMVToMLViewController *addVC = [[AddMVToMLViewController alloc] init];
            addVC.delegate = self;
            [[self rootViewController] presentModalViewController:addVC animated:NO];
        }
    }
}

- (void)addToML:(MLItem *)ml
{
    void (^completionBlock)(BOOL, NSError *) = ^(BOOL success, NSError *error) {
        self.mvToAdd = nil;
        if (success) {
            [AlertWithTip flashSuccessMessage:@"成功添加到悦单"];
        }
        else {
            [AlertWithTip flashFailedMessage:[error yytErrorMessage]];
        }
    };
    if (ml.keyID) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:self.mvToAdd.keyID forKey:@"vid"];
        [parameters setObject:ml.keyID forKey:@"id"];
        [[MLDataController sharedObject] addMV:self.mvToAdd.keyID
                                          toML:ml.keyID
                                    completion:completionBlock];
    } else
    {
        SEL newSelector = @selector(beModified:property:);
        EditableMLParticularViewController *editPartViewController = [[EditableMLParticularViewController alloc] initWithMLItem:ml];
        editPartViewController.editing = YES;
        if ([editPartViewController respondsToSelector:newSelector])
        {
            
            NSMutableArray *videos = [NSMutableArray arrayWithObject:self.mvToAdd];
            NSDictionary *info = [NSDictionary dictionaryWithObject:videos forKey:@"videos"];
            [editPartViewController performSelector:newSelector withObject:nil withObject:info];
            [[self rootViewController] presentModalViewController:editPartViewController animated:YES];
            
        }
        
    }
}

- (UIViewController *)rootViewController
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

#pragma mark - AddMVToMLViewControllerDelegate
- (void)addMVToMLViewController:(AddMVToMLViewController *)addVC selectedML:(MLItem *)ml
{
    if (ml) {
        MVItem *item = self.mvToAdd;
        [addVC dismissViewControllerAnimated:YES completion:^{
            ml.videos = [NSMutableArray arrayWithObject:item];
            ml.videoCount = [NSNumber numberWithInt:[ml.videos count]];
            [self addToML:ml];
        }];
    }
    else {
        self.mvToAdd = nil;
    }
}

@end
