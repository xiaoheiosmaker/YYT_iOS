//
//  AddMVToMLAssistantController.h
//  YYTHD
//
//  Created by 崔海成 on 11/1/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddMVToMLViewController.h"
#import "BaseAssistantController.h"

@class MLItem;
@class MVItem;

@interface AddMVToMLAssistantController : BaseAssistantController <AddMVToMLViewControllerDelegate>

+ (AddMVToMLAssistantController *)sharedInstance;
@property (nonatomic, strong) MVItem *mvToAdd;

@end
