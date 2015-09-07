//
//  PublicAlertView.m
//  NewsReader
//
//  Created by WuJianJun on 11/12/10.
//  Copyright 2010 Tieto. All rights reserved.
//

#import "KSUIAlertViewAdditions.h"

@implementation UIAlertView (KSUIAlertViewAdditions)

+ (void)alertViewWithTitle:(NSString*)title message:(NSString*)message
{
	[UIAlertView alertViewWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
}

+ (void)alertViewWithTitle:(NSString*)title 
				   message:(NSString*)message 
				  delegate:(id)delegate 
		 cancelButtonTitle:(NSString*)cancelTitle
		 otherButtonTitles:(NSString*)otherTitle 
{
	UIAlertView	*_alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
	[_alert show];
}

+ (void)alertViewWithTitle:(NSString*)title 
				   message:(NSString*)message 
				  delegate:(id)delegate
		 cancelButtonTitle:(NSString*)cancelTitle 
		 otherButtonTitles:(NSString*)otherTitle 
					   tag:(int)tag
{
	UIAlertView	*_alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
	_alert.tag = tag;
	[_alert show];
}

@end
