//
// Created by wow on 13-12-29.
// Copyright (c) 2013 chanjet. All rights reserved.
//

#import "TWBorderedView.h"
#import "CSPUIStyle.h"
#import "UIView+UIStyle.h"
#import "UIColor+CJExtension.h"
#import "UIView+Metrics.h"

struct TWBorderedViewBorderStruct {
    int width;
    CGColorRef color;
};
typedef struct TWBorderedViewBorderStruct TWBorderedViewBorderStruct;

@implementation TWBorderedView



#pragma mark - Accessors

- (void)setTopBorderColor:(UIColor *)topBorderColor {
    _topBorderColor = topBorderColor;
    [self setNeedsDisplay];
}


- (void)setTopInsetColor:(UIColor *)topInsetColor {
    _topInsetColor = topInsetColor;
    [self setNeedsDisplay];
}


- (void)setRightBorderColor:(UIColor *)rightBorderColor {
    _rightBorderColor = rightBorderColor;
    [self setNeedsDisplay];
}


- (void)setRightInsetColor:(UIColor *)rightInsetColor {
    _rightInsetColor = rightInsetColor;
    [self setNeedsDisplay];
}


- (void)setBottomBorderColor:(UIColor *)bottomBorderColor {
    _bottomBorderColor = bottomBorderColor;
    [self setNeedsDisplay];
}


- (void)setBottomInsetColor:(UIColor *)bottomInsetColor {
    _bottomInsetColor = bottomInsetColor;
    [self setNeedsDisplay];
}


- (void)setLeftBorderColor:(UIColor *)leftBorderColor {
    _leftBorderColor = leftBorderColor;
    [self setNeedsDisplay];
}


- (void)setLeftInsetColor:(UIColor *)leftInsetColor {
    _leftInsetColor = leftInsetColor;
    [self setNeedsDisplay];
}


#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.contentMode = UIViewContentModeRedraw;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, rect);

    CGSize size = rect.size;

    // Top
    if (_topBorderColor) {
        // Top inset
        if (_topInsetColor) {
            CGContextSetFillColorWithColor(context, _topInsetColor.CGColor);
            CGContextFillRect(context, CGRectMake(0.0f, 1.0f, size.width, 1.0f));
        }

        // Top border
        CGContextSetFillColorWithColor(context, _topBorderColor.CGColor);
        CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, 1.0f));
    }

    CGFloat sideY = _topBorderColor ? 1.0f : 0.0f;
    CGFloat sideHeight = size.height;
    if (_topBorderColor) {
        sideHeight -= 1.0f;
    }

    if (_bottomBorderColor) {
        sideHeight -= 1.0f;
    }

    // Right
    if (_rightBorderColor) {
        // Right inset
        if (_rightInsetColor) {
            CGContextSetFillColorWithColor(context, _rightInsetColor.CGColor);
            CGContextFillRect(context, CGRectMake(size.width - 2.0f, sideY, 1.0f, sideHeight));
        }

        // Right border
        CGContextSetFillColorWithColor(context, _rightBorderColor.CGColor);
        CGContextFillRect(context, CGRectMake(size.width - 1.0f, sideY, 1.0f, sideHeight));
    }

    // Bottom
    if (_bottomBorderColor) {
        // Bottom inset
        if (_bottomInsetColor) {
            CGContextSetFillColorWithColor(context, _bottomInsetColor.CGColor);
            CGContextFillRect(context, CGRectMake(0.0f, rect.size.height - 2.0f, size.width, 1.0f));
        }

        // Bottom border
        CGContextSetFillColorWithColor(context, _bottomBorderColor.CGColor);
        CGContextFillRect(context, CGRectMake(0.0f, rect.size.height - 1.0f, size.width, 1.0f));
    }

    // Left
    if (_leftBorderColor) {
        // Left inset
        if (_leftInsetColor) {
            CGContextSetFillColorWithColor(context, _leftInsetColor.CGColor);
            CGContextFillRect(context, CGRectMake(1.0f, sideY, 1.0f, sideHeight));
        }

        // Left border
        CGContextSetFillColorWithColor(context, _leftBorderColor.CGColor);
        CGContextFillRect(context, CGRectMake(0.0f, sideY, 1.0f, sideHeight));
    }
}

- (void)applyUIStyleProperties:(NSDictionary *)properties {
    [super applyUIStyleProperties:properties];

    NSString *border = [properties objectForKey:@"border-top"];
    if (border) {
        TWBorderedViewBorderStruct borderStruct = [self parseBorder:border];
        if (borderStruct.color) {
            self.top = borderStruct.width;
            self.topBorderColor = [UIColor colorWithCGColor:borderStruct.color];
        }
    }
    border = [properties objectForKey:@"border-left"];
    if (border) {
        TWBorderedViewBorderStruct borderStruct = [self parseBorder:border];
        if (borderStruct.color) {
            self.left = borderStruct.width;
            self.leftBorderColor = [UIColor colorWithCGColor:borderStruct.color];
        }
    }
    border = [properties objectForKey:@"border-right"];
    if (border) {
        TWBorderedViewBorderStruct borderStruct = [self parseBorder:border];
        if (borderStruct.color) {
            self.right = borderStruct.width;
            self.rightBorderColor = [UIColor colorWithCGColor:borderStruct.color];
        }
    }
    border = [properties objectForKey:@"border-bottom"];
    if (border) {
        TWBorderedViewBorderStruct borderStruct = [self parseBorder:border];
        if (borderStruct.color) {
            self.bottom = borderStruct.width;
            self.bottomBorderColor = [UIColor colorWithCGColor:borderStruct.color];
        }
    }
}

- (TWBorderedViewBorderStruct) parseBorder:(NSString *)border {
    TWBorderedViewBorderStruct borderStruct;

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

            borderStruct.width = width.floatValue;
            borderStruct.color = [UIColor colorWithString:color].CGColor;
        }
        else if ( segments.count == 2 )
        {
            NSString * width = [segments objectAtIndex:0];
            NSString * color = [segments objectAtIndex:1];

            borderStruct.width = width.floatValue;
            borderStruct.color = [UIColor colorWithString:color].CGColor;
        }
    }

    return borderStruct;
}

@end