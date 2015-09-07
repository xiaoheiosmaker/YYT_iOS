//
//  YYTUISwitch.m
//  YinYueTai_iPhone
//
//  Created by  on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YYTUISwitch.h"

@implementation YYTUISwitch
@synthesize row;

- (void)drawUnderlayersInRect:(CGRect)aRect withOffset:(float)offset inTrackWidth:(float)trackWidth
{
	if(useImage)
    {
		{
			CGPoint imagePoint = [self bounds].origin;
			imagePoint.x += 10 ;
			[onImage drawAtPoint:imagePoint];
		}
		{
			CGPoint imagePoint = [self bounds].origin;
           // NSLog(@"offset = %f imagePoint.x= %f",offset,imagePoint.x);
            
            if (offset>30)
            {
                imagePoint.x +=offset+4;
            }
            else
            {
                imagePoint.x +=34;
            }
			[offImage drawAtPoint:imagePoint];
		}
	}
    else
    {
		{
			CGRect textRect = [self bounds];
			textRect.origin.x += 14.0 + (offset - trackWidth);
			[onText drawTextInRect:textRect];
		}
		{
			CGRect textRect = [self bounds];
			textRect.origin.x += -14 + (offset + trackWidth);
			[offText drawTextInRect:textRect];
		}
	}
}

@end
