//
//  YYTTextField.m
//  YinYueTai_iPhone
//
//  Created by sunsujun on 13-10-8.
//
//

#import "YYTTextField.h"

@implementation YYTTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//控制清除按钮的位置
//
//-(CGRect)clearButtonRectForBounds:(CGRect)bounds
//
//{
//    
//    return CGRectMake(bounds.origin.x + bounds.size.width - 50, bounds.origin.y + bounds.size.height -20, 16, 16);
//    
//}
//
//
//控制placeHolder的位置，左右缩20

-(CGRect)placeholderRectForBounds:(CGRect)bounds

{
    
    CGRect inset;
    
    //return CGRectInset(bounds, 20, 0);
    if ([SystemSupport versionPriorTo7]) {
        inset = CGRectMake(bounds.origin.x, bounds.origin.y+self.placeHolderY, bounds.size.width -10, bounds.size.height);//更好理解些
    }else{
        inset = CGRectMake(bounds.origin.x, bounds.origin.y+self.placeHolderY+7, bounds.size.width -10, bounds.size.height);//更好理解些
    }

    
    return inset;
    
}
//
////控制显示文本的位置
//
//-(CGRect)textRectForBounds:(CGRect)bounds
//
//{
//    
//    //return CGRectInset(bounds, 50, 0);
//    
//    CGRect inset = CGRectMake(bounds.origin.x+190, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
//    
//    
//    
//    return inset;
//    
//    
//}
//
////控制编辑文本的位置
//
//-(CGRect)editingRectForBounds:(CGRect)bounds
//
//{
//    
//    //return CGRectInset( bounds, 10 , 0 );
//    
//    
//    
//    CGRect inset = CGRectMake(bounds.origin.x +10, bounds.origin.y, bounds.size.width -10, bounds.size.height);
//    
//    return inset;
//    
//}
//
////控制左视图位置
//
//- (CGRect)leftViewRectForBounds:(CGRect)bounds
//
//{
//    
//    CGRect inset = CGRectMake(bounds.origin.x +10, bounds.origin.y, bounds.size.width-250, bounds.size.height);
//    
//    return inset;
//    
//    //return CGRectInset(bounds,50,0);
//    
//}
//
//-(void)drawTextInRect:(CGRect)rect{
//    [super drawTextInRect:rect];
//}

//控制placeHolder的颜色、字体

- (void)drawPlaceholderInRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, self.placeHolderColor.CGColor);
    CGContextSetFillColorWithColor(context, [UIColor colorWithHEXColor:0xb7b7b7].CGColor);
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:12.0]];
//    [[self placeholder] drawInRect:rect withFont:self.placeHolderFont];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
