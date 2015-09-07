//
//  MLDetailViewController.h
//  YYTHD
//
//  Created by 崔海成 on 10/17/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MVItem.h"
#import "EditableViewController.h"
@class MLItem;

@protocol MLDetailViewControllerDelegate;

@interface MLDetailViewController : EditableViewController <
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (strong, nonatomic)MLItem *mlItem;
@property (weak, nonatomic)id <MLDetailViewControllerDelegate> delegate;

- (id)initWithMLItem:(MLItem *)item editing:(BOOL)editing;
- (id)initWithMLID:(NSNumber *)keyID editable:(BOOL)editable;
- (id)initWithMLID:(NSNumber *)keyID editing:(BOOL)editing;
- (id)initWithMLID:(NSNumber *)keyID;

@end

@protocol MLDetailViewControllerDelegate

- (void)detailViewController:(MLDetailViewController *)detailVC
           createMLWithTitle:(NSString *)title
                  coverImage:(UIImage *)image
                 description:(NSString *)description
                    videoIDs:(NSString *)vids // 123,456,789
                  completion:(void (^)(MLItem *, NSError *))completion;
- (void)cancelCreateMLInDetailViewController:(MLDetailViewController *)detailVC;

@end
