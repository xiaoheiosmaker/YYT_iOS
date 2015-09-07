//
//  EditableViewController.h
//  YYTHD
//
//  Created by 崔海成 on 11/18/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "BaseViewController.h"

@interface EditableViewController : BaseViewController
@property (nonatomic) BOOL editable;
@property (nonatomic) BOOL editing;
@property (nonatomic) BOOL needCommit;
@property (nonatomic, readonly) UIButton *editBtn;
@property (nonatomic, readonly) UIButton *doneBtn;
@property (nonatomic, readonly) UIActivityIndicatorView *commitIndicator;

- (void)commit;
@end