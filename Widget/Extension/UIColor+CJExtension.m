//
//  Created by 宋永强 on 11-5-30.
//
//  To change this template use File | Settings | File Templates.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "SLCorePreprocessorMacros.h"
#import "UIColor+CJExtension.h"
#import "NSString+CSPExtension.h"

TT_FIX_CATEGORY_BUG(UIColor_UFMobiAddtions)

@implementation UIColor(CJExtension)


+ (UIColor *)fromHexValue:(NSUInteger)hex
{
	NSUInteger a = ((hex >> 24) & 0x000000FF);
	float fa = ((0 == a) ? 1.0f : (a * 1.0f) / 255.0f);
    
	return [UIColor fromHexValue:hex alpha:fa];
}

+ (UIColor *)fromHexValue:(NSUInteger)hex alpha:(CGFloat)alpha
{
    if ( hex == 0xECE8E3 ) {
        
    }
	NSUInteger r = ((hex >> 16) & 0x000000FF);
	NSUInteger g = ((hex >> 8) & 0x000000FF);
	NSUInteger b = ((hex >> 0) & 0x000000FF);
	
	float fr = (r * 1.0f) / 255.0f;
	float fg = (g * 1.0f) / 255.0f;
	float fb = (b * 1.0f) / 255.0f;
	
	return [UIColor colorWithRed:fr green:fg blue:fb alpha:alpha];
}

+ (UIColor *)fromShortHexValue:(NSUInteger)hex
{
	return [UIColor fromShortHexValue:hex alpha:1.0f];
}

+ (UIColor *)fromShortHexValue:(NSUInteger)hex alpha:(CGFloat)alpha
{
	NSUInteger r = ((hex >> 8) & 0x0000000F);
	NSUInteger g = ((hex >> 4) & 0x0000000F);
	NSUInteger b = ((hex >> 0) & 0x0000000F);
	
	float fr = (r * 1.0f) / 15.0f;
	float fg = (g * 1.0f) / 15.0f;
	float fb = (b * 1.0f) / 15.0f;
	
	return [UIColor colorWithRed:fr green:fg blue:fb alpha:alpha];
}


+ (UIColor *)colorWithString:(NSString *)string
{
	if ( nil == string || 0 == string.length )
		return [UIColor clearColor];
	
	string = string.trim;
    
	NSArray *	array = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *	color = [array objectAtIndex:0];
    CGFloat		alpha = 1.0f;
    
	if ( array.count == 2 )
    {
        alpha = [[array objectAtIndex:1] floatValue];
    }
    
    if ( [color hasPrefix:@"#"] ) // #FFF
    {
		color = [color substringFromIndex:1];
        
		if ( color.length == 3 )
		{
			NSUInteger hexRGB = strtol(color.UTF8String , nil, 16);
			return [UIColor fromShortHexValue:hexRGB alpha:alpha];
		}
		else if ( color.length == 6 )
		{
			NSUInteger hexRGB = strtol(color.UTF8String , nil, 16);
			return [UIColor fromHexValue:hexRGB alpha:alpha];
		}
    }
    else if ( [color hasPrefix:@"0x"] || [color hasPrefix:@"0X"] ) // #FFF
    {
		color = [color substringFromIndex:2];
		
		if ( color.length == 8 )
		{
			NSUInteger hexRGB = strtol(color.UTF8String , nil, 16);
			return [UIColor fromHexValue:hexRGB alpha:alpha];
		}
		else if ( color.length == 6 )
		{
			NSUInteger hexRGB = strtol(color.UTF8String , nil, 16);
			return [UIColor fromHexValue:hexRGB alpha:1.0f];
		}
	}
    else
    {
        static NSMutableDictionary * __colors = nil;
        
        if ( nil == __colors )
        {
            __colors = [[NSMutableDictionary alloc] init];
            [__colors setObject:[UIColor clearColor] forKey:@"clear"];
            [__colors setObject:[UIColor clearColor] forKey:@"transparent"];
            [__colors setObject:[UIColor redColor] forKey:@"red"];
            [__colors setObject:[UIColor blackColor] forKey:@"black"];
            [__colors setObject:[UIColor darkGrayColor] forKey:@"darkGray"];
            [__colors setObject:[UIColor lightGrayColor] forKey:@"lightGray"];
            [__colors setObject:[UIColor whiteColor] forKey:@"white"];
            [__colors setObject:[UIColor grayColor] forKey:@"gray"];
            [__colors setObject:[UIColor redColor] forKey:@"red"];
            [__colors setObject:[UIColor greenColor] forKey:@"green"];
            [__colors setObject:[UIColor blueColor] forKey:@"blue"];
            [__colors setObject:[UIColor cyanColor] forKey:@"cyan"];
            [__colors setObject:[UIColor yellowColor] forKey:@"yellow"];
            [__colors setObject:[UIColor magentaColor] forKey:@"magenta"];
            [__colors setObject:[UIColor orangeColor] forKey:@"orange"];
            [__colors setObject:[UIColor purpleColor] forKey:@"purple"];
            [__colors setObject:[UIColor brownColor] forKey:@"brown"];
        }
        
        return [__colors objectForKey:color.lowercaseString];
    }
    
    return [UIColor clearColor];
}

@end


