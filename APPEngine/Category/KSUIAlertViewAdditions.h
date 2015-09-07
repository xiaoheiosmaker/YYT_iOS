//
//  PublicAlertView.h
//  NewsReader
//
//  Created by WuJianJun on 11/12/10.
//  Copyright 2010 Tieto. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIAlertView (KSUIAlertViewAdditions)

+ (void)alertViewWithTitle:(NSString*)title message:(NSString*)message;
+ (void)alertViewWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelTitle otherButtonTitles:(NSString*)otherTitle;
+ (void)alertViewWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelTitle otherButtonTitles:(NSString*)otherTitle tag:(int)tag;


@end
