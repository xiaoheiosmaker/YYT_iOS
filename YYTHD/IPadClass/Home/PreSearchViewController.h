//
//  PreSearchViewController.h
//  YYTHD
//
//  Created by ssj on 13-11-2.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PreSearchViewControllerDelegate;
@interface PreSearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSIndexPath *idxPath;
    BOOL isFirst;
}
@property (weak, nonatomic)id <PreSearchViewControllerDelegate>delegate;
@property (strong, nonatomic) UITableView *searchTableView;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic)UIImageView *backImageView;
@end

@protocol PreSearchViewControllerDelegate <NSObject>

- (void)searchText:(NSString *)searchText;

@end