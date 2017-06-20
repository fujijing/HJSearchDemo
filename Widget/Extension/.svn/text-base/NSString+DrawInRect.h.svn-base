//
//  NSString+DrawInRect.h
//  teamwork
//
//  Created by syq on 14/9/24.
//  Copyright (c) 2014年 chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DrawInRect)

// Single line, no wrapping. Truncation based on the NSLineBreakMode.
- (CGSize)sizeWithFontOfCompatible:(UIFont *)font NS_DEPRECATED_IOS(2_0, 7_0, "Use -sizeWithAttributes:");
- (CGSize)sizeWithFontOfCompatible:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode NS_DEPRECATED_IOS(2_0, 7_0, "Use -boundingRectWithSize:options:attributes:context:");

// Single line, no wrapping. Truncation based on the NSLineBreakMode.
- (CGSize)drawAtPointOfCompatible:(CGPoint)point withFont:(UIFont *)font NS_DEPRECATED_IOS(2_0, 7_0, "Use -drawAtPoint:withAttributes:");
- (CGSize)drawAtPointOfCompatible:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode  NS_DEPRECATED_IOS(2_0, 7_0, "Use -drawInRect:withAttributes:");

// Wrapping to fit horizontal and vertical size. Text will be wrapped and truncated using the NSLineBreakMode. If the height is less than a line of text, it may return
// a vertical size that is bigger than the one passed in.
// If you size your text using the constrainedToSize: methods below, you should draw the text using the drawInRect: methods using the same line break mode for consistency
- (CGSize)sizeWithFontOfCompatible:(UIFont *)font constrainedToSize:(CGSize)size NS_DEPRECATED_IOS(2_0, 7_0, "Use -boundingRectWithSize:options:attributes:context:"); // Uses NSLineBreakModeWordWrap
- (CGSize)sizeWithFontOfCompatible:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode NS_DEPRECATED_IOS(2_0, 7_0, "Use -boundingRectWithSize:options:attributes:context:"); // NSTextAlignment is not needed to determine size

// Wrapping to fit horizontal and vertical size.
- (CGSize)drawInRectOfCompatible:(CGRect)rect withFont:(UIFont *)font NS_DEPRECATED_IOS(2_0, 7_0, "Use -drawInRect:withAttributes:");
- (CGSize)drawInRectOfCompatible:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode NS_DEPRECATED_IOS(2_0, 7_0, "Use -drawInRect:withAttributes:");
- (CGSize)drawInRectOfCompatible:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment NS_DEPRECATED_IOS(2_0, 7_0, "Use -drawInRect:withAttributes:");

// These methods will behave identically to the above single line methods if the string will fit in the specified width in the specified font.
// If not, the font size will be reduced until either the string fits or the minimum font size is reached.  If the minimum font
// size is reached and the string still won't fit, the string will be truncated and drawn at the minimum font size.
// The first two methods are used together, and the actualFontSize returned in the sizeWithFont method should be passed to the drawAtPoint method.
// The last method will do the sizing calculation and drawing in one operation.
//- (CGSize)sizeWithFontOfCompatible:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(CGFloat *)actualFontSize forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode NS_DEPRECATED_IOS(2_0, 7_0);

- (CGSize)drawAtPointOfCompatible:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font fontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment NS_DEPRECATED_IOS(2_0, 7_0, "Use -drawInRect:withAttributes:");

- (CGSize)drawAtPointOfCompatible:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(CGFloat *)actualFontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment NS_DEPRECATED_IOS(2_0, 7_0, "Use -drawInRect:withAttributes:");

@end
