//
//  MLParticularViewController.h
//  YYTHD
//
//  Created by 崔海成 on 12/18/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLItem.h"
#import "BaseViewController.h"

@interface MLParticularViewController : BaseViewController
{
    BOOL modified;
}
@property (nonatomic, strong) MLItem *item;
@property (nonatomic) BOOL editing;
- (void)hideKeyboard;

- (id)initWithMLItem:(MLItem *)item;
- (void)updateData;
@end
