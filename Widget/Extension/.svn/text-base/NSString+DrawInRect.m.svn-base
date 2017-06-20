//
//  NSString+DrawInRect.m
//  teamwork
//
//  Created by syq on 14/9/24.
//  Copyright (c) 2014年 chanjet. All rights reserved.
//

#import "NSString+DrawInRect.h"


@implementation NSString (DrawInRect)


// Single line, no wrapping. Truncation based on the NSLineBreakMode.
- (CGSize)sizeWithFontOfCompatible:(UIFont *)font //NS_DEPRECATED_IOS(2_0, 7_0, "Use -sizeWithAttributes:")
{
    return [self sizeWithFontOfCompatible:font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
}

- (CGSize)sizeWithFontOfCompatible:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode //NS_DEPRECATED_IOS(2_0, 7_0, "Use -boundingRectWithSize:options:attributes:context:")
{
    return [self sizeWithFontOfCompatible:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:lineBreakMode];
}

// Single line, no wrapping. Truncation based on the NSLineBreakMode.
- (CGSize)drawAtPointOfCompatible:(CGPoint)point withFont:(UIFont *)font //NS_DEPRECATED_IOS(2_0, 7_0, "Use -drawAtPoint:withAttributes:")
{
    return [self drawAtPointOfCompatible:point forWidth:MAXFLOAT withFont:font lineBreakMode:UILineBreakModeWordWrap];
}
- (CGSize)drawAtPointOfCompatible:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode  //NS_DEPRECATED_IOS(2_0, 7_0, "Use -drawInRect:withAttributes:")
{
    return [self drawAtPointOfCompatible:point forWidth:width withFont:font fontSize:font.pointSize lineBreakMode:lineBreakMode baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
}

// Wrapping to fit horizontal and vertical size. Text will be wrapped and truncated using the NSLineBreakMode. If the height is less than a line of text, it may return
// a vertical size that is bigger than the one passed in.
// If you size your text using the constrainedToSize: methods below, you should draw the text using the drawInRect: methods using the same line break mode for consistency
- (CGSize)sizeWithFontOfCompatible:(UIFont *)font constrainedToSize:(CGSize)size //NS_DEPRECATED_IOS(2_0, 7_0, "Use -boundingRectWithSize:options:attributes:context:") // Uses NSLineBreakModeWordWrap
{
    return [self sizeWithFontOfCompatible:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
}

- (CGSize)sizeWithFontOfCompatible:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode //NS_DEPRECATED_IOS(2_0, 7_0, "Use -boundingRectWithSize:options:attributes:context:") // NSTextAlignment is not needed to determine size
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
//        return [self sizeWithFontOfCompatible:font constrainedToSize:size lineBreakMode:lineBreakMode];
        return [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
    }
    else
    {
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = lineBreakMode;
        NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle};
        return [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    }
}

// Wrapping to fit horizontal and vertical size.
- (CGSize)drawInRectOfCompatible:(CGRect)rect withFont:(UIFont *)font //NS_DEPRECATED_IOS(2_0, 7_0, "Use -drawInRect:withAttributes:")
{
    return [self drawInRectOfCompatible:rect withFont:font lineBreakMode:UILineBreakModeWordWrap];
}

- (CGSize)drawInRectOfCompatible:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode //NS_DEPRECATED_IOS(2_0, 7_0, "Use -drawInRect:withAttributes:")
{
    return [self drawInRectOfCompatible:rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentLeft];
}

- (CGSize)drawInRectOfCompatible:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment //NS_DEPRECATED_IOS(2_0, 7_0, "Use -drawInRect:withAttributes:")
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        return [self drawInRect:rect withFont:font lineBreakMode:lineBreakMode alignment:alignment];
    }
    else
    {
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = lineBreakMode;
        textStyle.alignment = alignment;
        NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle};
        [self drawInRect:rect withAttributes:dic];
        
        return [self sizeWithAttributes:dic];
    }
}

// These methods will behave identically to the above single line methods if the string will fit in the specified width in the specified font.
// If not, the font size will be reduced until either the string fits or the minimum font size is reached.  If the minimum font
// size is reached and the string still won't fit, the string will be truncated and drawn at the minimum font size.
// The first two methods are used together, and the actualFontSize returned in the sizeWithFont method should be passed to the drawAtPoint method.
// The last method will do the sizing calculation and drawing in one operation.
//- (CGSize)sizeWithFont:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(CGFloat *)actualFontSize forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode NS_DEPRECATED_IOS(2_0, 7_0);

- (CGSize)drawAtPointOfCompatible:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font fontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment //NS_DEPRECATED_IOS(2_0, 7_0, "Use -drawInRect:withAttributes:")
{
    float actualFontSize;
    return [self drawAtPoint:point forWidth:width withFont:font minFontSize:fontSize actualFontSize:&actualFontSize lineBreakMode:lineBreakMode baselineAdjustment:baselineAdjustment];
}

- (CGSize)drawAtPointOfCompatible:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(CGFloat *)actualFontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment //NS_DEPRECATED_IOS(2_0, 7_0, "Use -drawInRect:withAttributes:");
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        return [self drawAtPoint:point forWidth:width withFont:font minFontSize:MAXFLOAT actualFontSize:actualFontSize lineBreakMode:lineBreakMode baselineAdjustment:baselineAdjustment];
    }
    else
    {
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = lineBreakMode;
        textStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle};
        
        [self drawInRect:CGRectMake(point.x, point.y, width, MAXFLOAT) withAttributes:dic];
        
        return [self sizeWithAttributes:dic];
    }
}

@end
