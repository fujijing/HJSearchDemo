//
// Created by wow on 13-12-14.
// Copyright (c) 2013 wow. All rights reserved.
//


#import "UIView+UIStyle.h"
#import "NSString+CSPExtension.h"
#import "UIColor+CJExtension.h"
#import "NSDictionary+CSPExtension.h"
#import "CSPUIMetrics.h"
#import "UIImage+Theme.h"
#import "UIFont+Theme.h"
#import <objc/message.h>

@implementation UIView (UIStyle)

+ (BOOL)supportForUIStyling
{
    return YES;
}

- (void)resetUIStyleProperties
{
    [super resetUIStyleProperties];
}

#pragma mark -

- (void)setBackgroundProperties:(NSDictionary *)properties
{
    NSString * background = [properties objectForKey:@"background"];
    NSString * backgroundColor = [properties objectForKey:@"background-color"];
    NSString * backgroundImage = [properties objectForKey:@"background-image"];
    NSString * backgroundMode = [properties objectForKey:@"background-mode"];
    NSString * backgroundInsets = [properties objectForKey:@"background-insets"];
    NSString * backgroundStyles = [properties stringOfAny:@[@"background-style", @"background-styles"]];

    BOOL hasStretchInsets = NO;
    UIEdgeInsets stretchInsets = UIEdgeInsetsZero;

    BOOL hasContentMode = NO;
    UIViewContentMode contentMode = UIViewContentModeCenter;

    NSString * imageName = nil;
    NSString * colorName = nil;

    BOOL pattern = NO;
    BOOL stretch = NO;
    BOOL round = NO;
    BOOL gray = NO;

    //background { #FFFFFF url(url)  }

    if ( background && background.length )
    {
        background = background.trim;
        if ( background.length )
        {
            NSArray * segments = [background componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            for (__strong NSString * segment in segments )
            {
                segment = segment.trim;

                if ( [segment hasPrefix:@"url("] && [segment hasSuffix:@")"] )
                {
                    NSRange range = NSMakeRange( 4, segment.length - 5 );
                    imageName = [segment substringWithRange:range].trim;
                }
                else if ( [segment hasPrefix:@"#"] )
                {
                    colorName = segment;
                }
                else
                {
                    // TODO:
                }
            }
        }
    }

// background-color: { #FFFFF | #FFFFFF, 0.6 }

    if ( backgroundColor )
    {
        backgroundColor = backgroundColor.trim;
        if ( backgroundColor.length )
        {
            colorName = backgroundColor;
        }
    }

// background-mode:

    if ( backgroundMode )
    {
        backgroundMode = backgroundMode.trim;
        if ( backgroundColor.length )
        {
            if ( [backgroundMode isEqualToString:@"stretch"] || [backgroundMode isEqualToString:@"stretched"] )
            {
                stretch = YES;

                hasContentMode = YES;
                contentMode = UIViewContentModeScaleToFill;
            }
            else if ( [backgroundMode isEqualToString:@"round"] || [backgroundMode isEqualToString:@"rounded"] )
            {
                round = YES;

                hasContentMode = YES;
                contentMode = UIViewContentModeScaleAspectFit;
            }
            else
            {
                hasContentMode = YES;
                contentMode = UIViewContentModeFromString( backgroundMode );
            }
        }
    }

// background-insets: { 0, 0, 0, 0 }

    if ( backgroundInsets )
    {
        backgroundInsets = backgroundInsets.trim;
        if ( backgroundInsets.length )
        {
            hasStretchInsets = YES;
            stretchInsets = UIEdgeInsetsFromStringEx( backgroundInsets );
            if ( NO == UIEdgeInsetsEqualToEdgeInsets(stretchInsets, UIEdgeInsetsZero) )
            {
                hasContentMode = YES;
                contentMode = UIViewContentModeScaleToFill;
            }
        }
    }

// background-image: { url(url) }

    if ( backgroundImage )
    {
        backgroundImage = backgroundImage.trim;
        if ( backgroundImage.length )
        {
            if ( [backgroundImage hasPrefix:@"url("] && [backgroundImage hasSuffix:@")"] )
            {
                NSRange range = NSMakeRange( 4, backgroundImage.length - 5 );
                imageName = [backgroundImage substringWithRange:range].trim;
            }
            else
            {
                imageName = backgroundImage;
            }
        }
    }

// background-style: { gray|pattern }

    if ( backgroundStyles )
    {
        backgroundStyles = backgroundStyles.trim;
        if ( backgroundStyles.length )
        {
            NSArray * segments = [backgroundStyles componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            for (__strong NSString * segment in segments )
            {
                segment = segment.trim;

                if ( [segment isEqualToString:@"gray"] || [segment isEqualToString:@"grayed"] )
                {
                    gray = YES;
                }
                else if ( [segment isEqualToString:@"pattern"] || [segment isEqualToString:@"repeat"] )
                {
                    pattern = YES;
                }
            }
        }
    }

// set color

    if ( colorName && colorName.length )
    {
        if ( pattern )
        {
            UIImage * image = [UIImage imageFromString:imageName];
            if ( image )
            {
                self.backgroundColor = [UIColor colorWithPatternImage:image];
                return;
            }
        }
        else
        {
            self.backgroundColor = [UIColor colorWithString:colorName];
        }
    }

//// content mode
//
//    if ( hasContentMode )
//    {
//        self.backgroundImageView.contentMode = contentMode;
//    }
//
//// set image
//
//    if ( imageName && imageName.length )
//    {
//        self.backgroundImageView.gray = gray;
//        self.backgroundImageView.round = round;
//        self.backgroundImageView.strech = stretch;
//
//        if ( hasStretchInsets )
//        {
//            self.backgroundImageView.strechInsets = stretchInsets;
//        }
//
//        if ( [imageName hasPrefix:@"http://"] || [imageName hasPrefix:@"https://"] )
//        {
//            self.backgroundImageView.url = imageName;
//        }
//        else
//        {
//            self.backgroundImageView.resource = imageName;
//        }
//    }
}

- (void)setBorderProperties:(NSDictionary *)properties
{
    NSString * border = [properties objectForKey:@"border"];
    NSString * borderColor  = [properties objectForKey:@"border-color"];
    NSString * borderWidth  = [properties objectForKey:@"border-width"];
    NSString * borderRadius = [properties objectForKey:@"border-radius"];

    // border:5px solid red;

    if ( border )
    {
        border = border.trim;
        if ( border.length )
        {
            NSArray * segments = [border componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ( segments.count == 3 )
            {
                NSString * width = [segments objectAtIndex:0];
//				NSString * type = [segments objectAtIndex:1];
                NSString * color = [segments objectAtIndex:2];

                // TODO: type

                self.layer.borderWidth = width.floatValue;
                self.layer.borderColor = [UIColor colorWithString:color].CGColor;
            }
            else if ( segments.count == 2 )
            {
                NSString * width = [segments objectAtIndex:0];
                NSString * color = [segments objectAtIndex:1];

                self.layer.borderWidth = width.floatValue;
                self.layer.borderColor = [UIColor colorWithString:color].CGColor;
            }
        }
    }

// border-color

    if ( borderColor )
    {
        self.layer.borderColor = [UIColor colorWithString:borderColor].CGColor;
    }

// border-width

    if ( borderWidth )
    {
        self.layer.borderWidth = borderWidth.floatValue;
    }

// border-radius

    if ( borderRadius )
    {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = borderRadius.floatValue;
    }
}

#pragma mark -

- (void)setContentProperties:(NSDictionary *)properties
{
// content-mode

    NSString * mode = [properties stringOfAny:@[@"content-mode"]];
    if ( mode )
    {
        mode = mode.trim;
        if ( mode.length )
        {
            UIViewContentMode contentMode = UIViewContentModeFromString( mode );
            self.contentMode = contentMode;
        }
    }

// font

    if ( [self respondsToSelector:@selector(setFont:)] )
    {
        NSString * font = [properties stringOfAny:@[@"font"]];
        if ( font )
        {
            font = font.trim;
            if ( font.length )
            {
                // 18,system,bold
                // 18,arial
                // 18
                // 18,bold
                // 18,italic

                UIFont * userFont = [UIFont fontFromString:font];

                if ( userFont )
                {
                    [self performSelector:@selector(setFont:) withObject:userFont];
                }
            }
        }
        else
        {
            NSString * fontFamily = [properties stringOfAny:@[@"font-name", @"font-family"]];
            NSString * fontStyle = [properties stringOfAny:@[@"font-style"]];
            NSString * fontWeight = [properties stringOfAny:@[@"font-weight"]];
            NSString * fontSize = [properties stringOfAny:@[@"font-size"]];

            if ( fontFamily || fontStyle || fontWeight || fontSize )
            {
                UIFont *		userFont = nil;
                CSPUIMetrics *	userSize = [CSPUIMetrics fromString:fontSize];

                if ( fontFamily && fontFamily.length )
                {
                    userFont = [UIFont fontWithName:fontFamily size:userSize.value];
                }
                else if ( [fontWeight matchAnyOf:@[@"bold"]] )
                {
                    userFont = [UIFont boldSystemFontOfSize:userSize.value];
                }
                else if ( [fontStyle matchAnyOf:@[@"italic"]] )
                {
                    userFont = [UIFont italicSystemFontOfSize:userSize.value];
                }
                else
                {
                    userFont = [UIFont systemFontOfSize:userSize.value];
                }

                if ( userFont )
                {
                    [self performSelector:@selector(setFont:) withObject:userFont];
                }
            }
        }
    }

// text

    NSString * text = [properties stringOfAny:@[@"text", @"content"]];
    if ( text )
    {
        if ( [self respondsToSelector:@selector(setText:)] )
        {
            [self performSelector:@selector(setText:) withObject:text];
        }
        else if ( [self respondsToSelector:@selector(setTitle:forState:)] )
        {
            UIControlState state = UIControlStateNormal;

            if ( [self respondsToSelector:@selector(state)] )
            {
                state = (UIControlState)objc_msgSend( self, @selector(state) );
            }

            objc_msgSend( self, @selector(setTitle:forState:), text,  state );
        }
    }

// text-color

    NSString * textColor = [properties stringOfAny:@[@"color", @"text-color"]];
    if ( textColor )
    {
        if ( [self respondsToSelector:@selector(setTextColor:)] )
        {
            UIColor * userColor = [UIColor colorWithString:textColor];
            if ( userColor )
            {
                [self performSelector:@selector(setTextColor:) withObject:userColor];
            }
        }
    }

// text-align

    NSString * textAlignment = [properties stringOfAny:@[@"text-align"]];
    if ( textAlignment )
    {
        textAlignment = textAlignment.trim;
        if ( textAlignment.length )
        {
            if ( [self respondsToSelector:@selector(setTextAlignment:)] )
            {
                NSTextAlignment userAlign = UITextAlignmentFromString( textAlignment );
                objc_msgSend( self, @selector(setTextAlignment:), userAlign );
            }
        }
    }

// text-v-align

    NSString * textVAlignment = [properties stringOfAny:@[@"text-valign", @"text-v-align", @"text-vertical-align"]];
    if ( textVAlignment )
    {
        textVAlignment = textVAlignment.trim;
        if ( textVAlignment.length )
        {
            if ( [self respondsToSelector:@selector(setBaselineAdjustment:)] )
            {
                UIBaselineAdjustment userAlign = UIBaselineAdjustmentFromString( textVAlignment );
                objc_msgSend( self, @selector(setBaselineAdjustment:), userAlign );
            }
        }
    }

// line-break

    NSString * lineBreakMode = [properties stringOfAny:@[@"line-break"]];
    if ( lineBreakMode )
    {
        lineBreakMode = lineBreakMode.trim;
        if ( lineBreakMode.length )
        {
            if ( [self respondsToSelector:@selector(setLineBreakMode:)] )
            {
                NSLineBreakMode userLineBreak = UILineBreakModeFromString( lineBreakMode );
                objc_msgSend( self, @selector(setLineBreakMode:), userLineBreak );
            }
        }
    }

// line-num

    NSString * numberOfLines = [properties stringOfAny:@[@"line-num"]];
    if ( numberOfLines )
    {
        numberOfLines = numberOfLines.trim;
        if ( numberOfLines.length )
        {
            if ( [self respondsToSelector:@selector(setNumberOfLines:)] )
            {
                objc_msgSend( self, @selector(setNumberOfLines:), numberOfLines.integerValue );
            }
        }
    }
}


#pragma mark -

- (void)setVisibilityProperties:(NSDictionary *)properties
{
// transparency

    NSString * alpha = [properties stringOfAny:@[@"alpha", @"opaque"]];
    if ( alpha )
    {
        alpha = alpha.trim;
        if ( alpha.length )
        {
            [self setAlpha:[alpha floatValue]];
        }
    }

// visibility

    NSString * display = [properties stringOfAny:@[@"display"]];
    if ( display )
    {
        display = display.trim;
        if ( display.length )
        {
            if ( [display isEqualToString:@"none"] )
            {
                [self setHidden:YES];
            }
            else if ( [display isEqualToString:@"inline"] )
            {
                [self setHidden:NO];
            }
            else
            {
                // TODO:
            }
        }
    }
}

#pragma mark -

- (void)setShadowProperties:(NSDictionary *)properties
{
// shadow-color

    NSString * color = [properties stringOfAny:@[@"shadow-color"]];
    if ( color && color.length )
    {
        self.layer.shadowColor = [UIColor colorWithString:color].CGColor;
    }

// shadow-offset

    NSString * offset = [properties stringOfAny:@[@"shadow-offset"]];
    if ( offset && offset.length )
    {
        NSArray * segments = [offset componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ( segments.count == 2 )
        {
            CGFloat w = [[segments objectAtIndex:0] floatValue];
            CGFloat h = [[segments objectAtIndex:1] floatValue];

            self.layer.shadowOffset = CGSizeMake( w, h );
        }
        else if ( segments.count == 1 )
        {
            CGFloat w = [[segments objectAtIndex:0] floatValue];
            CGFloat h = [[segments objectAtIndex:0] floatValue];

            self.layer.shadowOffset = CGSizeMake( w, h );
        }
    }

// shadow-opacity

    NSString * opacity = [properties stringOfAny:@[@"shadow-opacity"]];
    if ( opacity && opacity.length )
    {
        CGFloat value = [opacity floatValue];
        if ( value < 0.0f )
        {
            value = 0.0f;
        }
        else if ( value > 1.0f )
        {
            value = 1.0f;
        }

        self.layer.shadowOpacity = value;
    }

// shadow-radius

    NSString * radius = [properties stringOfAny:@[@"shadow-radius"]];
    if ( radius && radius.length )
    {
        CGFloat value = [radius floatValue];
        if ( value < 0.0f )
        {
            value = 0.0f;
        }

        self.layer.shadowRadius = value;
    }

////	self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (void)applyUIStyleProperties:(NSDictionary *)properties
{
    [super applyUIStyleProperties:properties];

    [self setBorderProperties:properties];
    [self setBackgroundProperties:properties];
    [self setContentProperties:properties];
    [self setShadowProperties:properties];
    [self setVisibilityProperties:properties];
}


@end