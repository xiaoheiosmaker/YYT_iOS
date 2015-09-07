//
//  AddMVToMLViewController.h
//  YYTHD
//
//  Created by 崔海成 on 10/30/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLItem;

@protocol AddMVToMLViewControllerDelegate;

@interface AddMVToMLViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSMutableArray *mlList;
@property (nonatomic, weak) id <AddMVToMLViewControllerDelegate> delegate;
@end

@protocol AddMVToMLViewControllerDelegate

- (void)addMVToMLViewController:(AddMVToMLViewController *)addMC selectedML:(MLItem *)ml;

@end
