//
// Created by wow on 13-12-17.
// Copyright (c) 2013 chanjet. All rights reserved.
//


#import "CSPUIStyle.h"
#import "CSPUIMetrics.h"
#import "JSONKit.h"
#import "NSDictionary+CSPExtension.h"
#import "NSString+CSPExtension.h"
#import "NSObject+UIStyle.h"

#pragma mark -

@interface CSPUIStyle()
{
    NSString *				_name;
    NSMutableDictionary *	_properties;
}

+ (NSString *)generateName;

@end

#pragma mark -


@implementation CSPUIStyle {

}
DEF_STRING( ALIGN_CENTER,			@"center" )
DEF_STRING( ALIGN_LEFT,				@"left" )
DEF_STRING( ALIGN_TOP,				@"top" )
DEF_STRING( ALIGN_BOTTOM,			@"bottom" )
DEF_STRING( ALIGN_RIGHT,			@"right" )

DEF_STRING( ORIENTATION_HORIZONAL,	@"horizonal" )
DEF_STRING( ORIENTATION_VERTICAL,	@"vertical" )

//DEF_STRING( POSITION_ABSOLUTE,		@"absolute" )
//DEF_STRING( POSITION_RELATIVE,		@"relative" )
//DEF_STRING( POSITION_LINEAR,		@"linear" )

DEF_STRING( COMPOSITION_ABSOLUTE,	@"absolute" )
DEF_STRING( COMPOSITION_RELATIVE,	@"relative" )
DEF_STRING( COMPOSITION_LINEAR,		@"linear" )
DEF_STRING( COMPOSITION_GRID,		@"grid" )
DEF_STRING( COMPOSITION_DOCK,		@"dock" )
DEF_STRING( COMPOSITION_FRAME,		@"frame" )

+ (NSString *)generateName
{
    static NSUInteger __seed = 0;
    return [NSString stringWithFormat:@"style_%@", @(__seed++).stringValue];
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.name = [CSPUIStyle generateName];
        self.properties = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    self.name = nil;
    self.properties = nil;
}

#pragma mark -

- (CSPUIStyleBlockN)PROPERTY
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        NSMutableDictionary * dict = nil;

        if ( [first isKindOfClass:[NSString class]] )
        {
            NSString * json = [(NSString *)first stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
            if ( json && json.length )
            {
                dict = [json objectFromJSONString];
                if ( nil == dict || ![dict isKindOfClass:[NSDictionary class]])
                {
                    va_list args;
                    va_start( args, first );

                    NSString * key = (NSString *)first;
                    NSString * val = va_arg( args, NSString * );

                    va_end( args );

                    dict = [NSMutableDictionary dictionaryWithObject:val forKey:key];
                }
            }
        }
        else if ( [first isKindOfClass:[NSDictionary class]] )
        {
            dict = (NSMutableDictionary *)first;
        }

        self.CSS( dict );

        return self;
    };

    return [block copy];
}


- (NSString *)css
{
    NSMutableString * cssText = [NSMutableString string];

    for ( NSString * key in self.properties.allKeys )
    {
        NSString * value = [self.properties objectForKey:key];
        [cssText appendFormat:@"%@ : %@;", key, value];
    }

    return cssText;
}
- (CSPUIStyleBlockN)CSS
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        NSMutableDictionary * dict = nil;

        if ( first )
        {
            if ( [first isKindOfClass:[NSString class]] )
            {
                dict = [NSMutableDictionary dictionary];

                NSString *	text = (NSString *)first;
                NSArray *	segments = [text componentsSeparatedByString:@";"];

                for ( NSString * seg in segments )
                {
                    NSArray * keyValue = [seg componentsSeparatedByString:@":"];
                    if ( keyValue.count == 2 )
                    {
                        NSString * key = [keyValue objectAtIndex:0];
                        NSString * val = [keyValue objectAtIndex:1];

                        key = key.trim.unwrap;
                        val = val.trim.unwrap;

                        [dict setObject:val forKey:key];
                    }
                }

                [self.properties addEntriesFromDictionary:dict];
            }
            else if ( [first isKindOfClass:[NSDictionary class]] )
            {
                dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)first];
            }
        }

        if ( dict && dict.count )
        {
            for ( NSString * key in dict.allKeys )
            {
                NSObject * value = [dict objectForKey:key];

                if ( value && [value isKindOfClass:[NSString class]] )
                {
                    if ( [(NSString *)value rangeOfString:@"!important"].length )
                    {
                        NSString * newValue;
                        newValue = [(NSString *)value stringByReplacingOccurrencesOfString:@"!important" withString:@""];
                        newValue = newValue.trim;

                        [dict setObject:newValue forKey:key];
                    }
                }
            }

            NSString * x = [dict stringOfAny:@[@"x"]];
            if ( x )
            {
                [dict removeObjectForKey:@"x"];
//                [dict removeObjectForKey:@"left"];

                self.X( x );
            }

            NSString * y = [dict stringOfAny:@[@"y"]];
            if ( y )
            {
                [dict removeObjectForKey:@"y"];
//                [dict removeObjectForKey:@"top"];

                self.Y( y );
            }

            NSString * w = [dict stringOfAny:@[@"w", @"width"]];
            if ( w )
            {
                [dict removeObjectForKey:@"w"];
                [dict removeObjectForKey:@"width"];

                self.W( w );
            }

            NSString * h = [dict stringOfAny:@[@"h", @"height"]];
            if ( h )
            {
                [dict removeObjectForKey:@"h"];
                [dict removeObjectForKey:@"height"];

                self.H( h );
            }

            NSString * max_w = [dict stringOfAny:@[@"max-w", @"max-width"]];
            if ( max_w )
            {
                [dict removeObjectForKey:@"max-w"];
                [dict removeObjectForKey:@"max-width"];

                self.MAX_WIDTH( max_w );
            }

            NSString * max_h = [dict stringOfAny:@[@"max-h", @"max-height"]];
            if ( max_h )
            {
                [dict removeObjectForKey:@"max-h"];
                [dict removeObjectForKey:@"max-height"];

                self.MAX_HEIGHT( max_h );
            }

            NSString * min_w = [dict stringOfAny:@[@"min-w", @"min-width"]];
            if ( min_w )
            {
                [dict removeObjectForKey:@"min-w"];
                [dict removeObjectForKey:@"min-width"];

                self.MIN_WIDTH( min_w );
            }

            NSString * min_h = [dict stringOfAny:@[@"min-h", @"min-height"]];
            if ( min_h )
            {
                [dict removeObjectForKey:@"min-h"];
                [dict removeObjectForKey:@"min-height"];

                self.MIN_HEIGHT( max_h );
            }

            NSString * gravity = [dict stringOfAny:@[@"gravity"]];
            if ( gravity )
            {
                [dict removeObjectForKey:@"gravity"];

                self.GRAVITY( gravity );
            }

//            NSString * pos = [dict stringOfAny:@[@"position"]];
//            if ( pos )
//            {
//                [dict removeObjectForKey:@"position"];
//
//                self.POSITION( pos );
//            }

//            NSString * align = [dict stringOfAny:@[@"align"]];
//            if ( align )
//            {
//                [dict removeObjectForKey:@"align"];
//
//                self.ALIGN( align );
//            }
//
//            NSString * v_align = [dict stringOfAny:@[@"valign", @"v-align", @"vertical-align"]];
//            if ( v_align )
//            {
//                [dict removeObjectForKey:@"valign"];
//                [dict removeObjectForKey:@"v-align"];
//                [dict removeObjectForKey:@"vertical-align"];
//
//                self.V_ALIGN( v_align );
//            }

//            NSString * floating = [dict stringOfAny:@[@"float"]];
//            if ( floating )
//            {
//                [dict removeObjectForKey:@"float"];
//
//                self.FLOATING( floating );
//            }
//
//            NSString * v_floating = [dict stringOfAny:@[@"v-float", @"vertical-float"]];
//            if ( v_floating )
//            {
//                [dict removeObjectForKey:@"v-float"];
//                [dict removeObjectForKey:@"vertical-float"];
//
//                self.V_FLOATING( v_floating );
//            }

            NSString * orientation = [dict stringOfAny:@[@"orient", @"orientation"]];
            if ( orientation )
            {
                [dict removeObjectForKey:@"orient"];
                [dict removeObjectForKey:@"orientation"];

                if ( [orientation matchAnyOf:@[@"h", @"horizonal"]] )
                {
                    self.ORIENTATION( CSPUIStyle.ORIENTATION_HORIZONAL );
                }
                else if ( [orientation matchAnyOf:@[@"v", @"vertical"]] )
                {
                    self.ORIENTATION( CSPUIStyle.ORIENTATION_VERTICAL );
                }
                else
                {
                    self.ORIENTATION( CSPUIStyle.ORIENTATION_VERTICAL );
                }
            }

            NSString * margin = [dict stringOfAny:@[@"margin"]];
            if ( margin )
            {
                [dict removeObjectForKey:@"margin"];

                NSArray * components = [margin.trim componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ( components.count == 1 )
                {
                    self.MARGIN( ((NSString *)[components objectAtIndex:0]).trim );
                }
                else if ( components.count == 2 )
                {
                    self.MARGIN_TOP( ((NSString *)[components objectAtIndex:0]).trim );
                    self.MARGIN_RIGHT( ((NSString *)[components objectAtIndex:1]).trim );
                    self.MARGIN_BOTTOM( ((NSString *)[components objectAtIndex:0]).trim );
                    self.MARGIN_LEFT( ((NSString *)[components objectAtIndex:1]).trim );
                }
                else if ( components.count == 4 )
                {
                    self.MARGIN_TOP( ((NSString *)[components objectAtIndex:0]).trim );
                    self.MARGIN_RIGHT( ((NSString *)[components objectAtIndex:1]).trim );
                    self.MARGIN_BOTTOM( ((NSString *)[components objectAtIndex:2]).trim );
                    self.MARGIN_LEFT( ((NSString *)[components objectAtIndex:3]).trim );
                }
            }

            NSString * margin_left = [dict stringOfAny:@[@"margin-left"]];
            if ( margin_left )
            {
                [dict removeObjectForKey:@"margin-left"];

                self.MARGIN_LEFT( margin_left.trim );
            }

            NSString * margin_right = [dict stringOfAny:@[@"margin-right"]];
            if ( margin_right )
            {
                [dict removeObjectForKey:@"margin-right"];

                self.MARGIN_RIGHT( margin_right.trim );
            }

            NSString * margin_top = [dict stringOfAny:@[@"margin-top"]];
            if ( margin_top )
            {
                [dict removeObjectForKey:@"margin-top"];

                self.MARGIN_TOP( margin_top.trim );
            }

            NSString * margin_bottom = [dict stringOfAny:@[@"margin-bottom"]];
            if ( margin_bottom )
            {
                [dict removeObjectForKey:@"margin-bottom"];

                self.MARGIN_BOTTOM( margin_bottom.trim );
            }

            NSString * padding = [dict stringOfAny:@[@"padding"]];
            if ( padding )
            {
                [dict removeObjectForKey:@"padding"];

                NSArray * components = [padding.trim componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ( components.count == 1 )
                {
                    self.PADDING( ((NSString *)[components objectAtIndex:0]).trim );
                }
                else if ( components.count == 2 )
                {
                    self.PADDING_TOP( ((NSString *)[components objectAtIndex:0]).trim );
                    self.PADDING_RIGHT( ((NSString *)[components objectAtIndex:1]).trim );
                    self.PADDING_BOTTOM( ((NSString *)[components objectAtIndex:0]).trim );
                    self.PADDING_LEFT( ((NSString *)[components objectAtIndex:1]).trim );
                }
                else if ( components.count == 4 )
                {
                    self.PADDING_TOP( ((NSString *)[components objectAtIndex:0]).trim );
                    self.PADDING_RIGHT( ((NSString *)[components objectAtIndex:1]).trim );
                    self.PADDING_BOTTOM( ((NSString *)[components objectAtIndex:2]).trim );
                    self.PADDING_LEFT( ((NSString *)[components objectAtIndex:3]).trim );
                }
            }

            NSString * padding_left = [dict stringOfAny:@[@"padding-left"]];
            if ( padding_left )
            {
                [dict removeObjectForKey:@"padding-left"];

                self.PADDING_LEFT( padding_left.trim );
            }

            NSString * padding_right = [dict stringOfAny:@[@"padding-right"]];
            if ( padding_right )
            {
                [dict removeObjectForKey:@"padding-right"];

                self.PADDING_RIGHT( padding_right.trim );
            }

            NSString * padding_top = [dict stringOfAny:@[@"padding-top"]];
            if ( padding_top )
            {
                [dict removeObjectForKey:@"padding-top"];

                self.PADDING_TOP( padding_top.trim );
            }

            NSString * padding_bottom = [dict stringOfAny:@[@"padding-bottom"]];
            if ( padding_bottom )
            {
                [dict removeObjectForKey:@"padding-bottom"];

                self.PADDING_BOTTOM( padding_bottom.trim );
            }

            // relative layout params
            NSString * above = [dict stringOfAny:@[@"above"]];
            if (above)
                [dict setObject:above forKey:@"above"];
            NSString * below = [dict stringOfAny:@[@"below"]];
            if (below)
                [dict setObject:below forKey:@"below"];
            NSString * left = [dict stringOfAny:@[@"left"]];
            if (left)
                [dict setObject:left forKey:@"left"];
            NSString * right = [dict stringOfAny:@[@"right"]];
            if (right)
                [dict setObject:right forKey:@"right"];
            NSString * aliginTop = [dict stringOfAny:@[@"align-top"]];
            if (aliginTop)
                [dict setObject:aliginTop forKey:@"align-top"];
            NSString * aliginLeft = [dict stringOfAny:@[@"align-left"]];
            if (aliginLeft)
                [dict setObject:aliginLeft forKey:@"align-left"];
            NSString * aliginRight = [dict stringOfAny:@[@"align-right"]];
            if (aliginRight)
                [dict setObject:aliginRight forKey:@"align-right"];
            NSString * aliginBottom = [dict stringOfAny:@[@"align-bottom"]];
            if (aliginBottom)
                [dict setObject:aliginBottom forKey:@"align-bottom"];

            [self.properties addEntriesFromDictionary:dict];
        }

        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)APPLY_FOR
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        [self applyFor:first];

        return self;
    };

    return [block copy];
}

- (void)applyFor:(id)object
{
    if ( nil == object || 0 == self.properties.count )
        return;

    if ( [[object class] supportForUIStyling] )
    {
        if ( [object isKindOfClass:[UIView class]] )
        {
            [object applyUIStyleProperties:self.properties];
        }
        else if ( [object isKindOfClass:[UIViewController class]] )
        {
            [object applyUIStyleProperties:self.properties];
        }
        else if ( [object isKindOfClass:[NSArray class]] )
        {
            for ( NSObject * obj in (NSArray *)object )
            {
                if ( [obj isKindOfClass:[UIView class]] )
                {
                    [obj applyUIStyleProperties:self.properties];
                }
                else if ( [obj isKindOfClass:[UIViewController class]] )
                {
                    [obj applyUIStyleProperties:self.properties];
                }
            }
        }
//        else if ( [object isKindOfClass:[CSPUICollection class]] )
//        {
//            for ( NSObject * obj in ((CSPUICollection *)object).views )
//            {
//                [obj applyUIStyleProperties:self.properties];
//            }
//        }
    }
}

#pragma mark -

- (CSPUIMetrics *)x
{
    return [self.properties objectForKey:@"x"];
}

- (CSPUIMetrics *)y
{
    return [self.properties objectForKey:@"y"];
}

- (CSPUIMetrics *)w
{
    CSPUIMetrics * value = [self.properties objectForKey:@"w"];
//    if ( nil == value )
//    {
////		return [CSPUIMetrics wrapContent];
//        return [CSPUIMetrics percent:100];
//    }

    return value;
}

- (CSPUIMetrics *)min_width
{
    CSPUIMetrics * value = [self.properties objectForKey:@"min_width"];
    if ( nil == value )
    {
        return nil;
//		return [CSPUIMetrics pixel:0.0f];
//		return [CSPUIMetrics percent:100];
    }

    return value;
}

- (CSPUIMetrics *)max_width
{
    CSPUIMetrics * value = [self.properties objectForKey:@"max_width"];
    if ( nil == value )
    {
        return nil;
//		return [CSPUIMetrics wrapContent];
//		return [CSPUIMetrics percent:100];
    }

    return value;
}

- (CSPUIMetrics *)h
{
    CSPUIMetrics * value = [self.properties objectForKey:@"h"];
//    if ( nil == value )
//    {
////		return [CSPUIMetrics wrapContent];
//        return [CSPUIMetrics percent:100];
//    }

    return value;
}

- (CSPUIMetrics *)min_height
{
    CSPUIMetrics * value = [self.properties objectForKey:@"min_height"];
    if ( nil == value )
    {
        return nil;
//		return [CSPUIMetrics pixel:0.0f];
//		return [CSPUIMetrics percent:100];
    }

    return value;
}

- (CSPUIMetrics *)max_height
{
    CSPUIMetrics * value = [self.properties objectForKey:@"max_height"];
    if ( nil == value )
    {
        return nil;
//		return [CSPUIMetrics wrapContent];
//		return [CSPUIMetrics percent:100];
    }

    return value;
}

- (NSString *)position
{
    return [self.properties objectForKey:@"position"];
}

- (NSString *)composition
{
    return [self.properties objectForKey:@"composition"];
}

- (CSPUIMetrics *)margin_left
{
    return [self.properties objectForKey:@"margin_left"];
}

- (CSPUIMetrics *)margin_right
{
    return [self.properties objectForKey:@"margin_right"];
}

- (CSPUIMetrics *)margin_top
{
    return [self.properties objectForKey:@"margin_top"];
}

- (CSPUIMetrics *)margin_bottom
{
    return [self.properties objectForKey:@"margin_bottom"];
}

- (CSPUIMetrics *)padding_left
{
    return [self.properties objectForKey:@"padding_left"];
}

- (CSPUIMetrics *)padding_right
{
    return [self.properties objectForKey:@"padding_right"];
}

- (CSPUIMetrics *)padding_top
{
    return [self.properties objectForKey:@"padding_top"];
}

- (CSPUIMetrics *)padding_bottom
{
    return [self.properties objectForKey:@"padding_bottom"];
}

- (NSString *)align
{
    return [self.properties objectForKey:@"align"];
}

- (NSString *)v_align
{
    return [self.properties objectForKey:@"v_align"];
}

- (NSString *)floating
{
    return [self.properties objectForKey:@"float"];
}

- (NSString *)v_floating
{
    return [self.properties objectForKey:@"v_float"];
}

- (NSString *)orientation
{
    return [self.properties objectForKey:@"orientation"];
}

- (NSString *)gravity {
    return [self.properties objectForKey:@"gravity"];
}

- (NSString *)aboveOf {
    return [self.properties objectForKey:@"above"];
}

- (NSString *)belowOf {
    return [self.properties objectForKey:@"below"];
}

- (NSString *)leftOf {
    return [self.properties objectForKey:@"left"];
}

- (NSString *)rightOf {
    return [self.properties objectForKey:@"right"];
}

- (NSString *)alignTop {
    return [self.properties objectForKey:@"aligin-top"];
}

- (NSString *)alignLeft {
    return [self.properties objectForKey:@"aligin-left"];
}

- (NSString *)alignRight {
    return [self.properties objectForKey:@"aligin-right"];
}

- (NSString *)alignBottom {
    return [self.properties objectForKey:@"aligin-bottom"];
}

- (NSString *)alignParentLeft {
    return [self.properties objectForKey:@"aligin-parent-left"];
}

- (NSString *)alignParentTop {
    return [self.properties objectForKey:@"aligin-parent-top"];
}

- (NSString *)alignParentRight {
    return [self.properties objectForKey:@"aligin-parent-right"];
}

- (NSString *)alignParentBottom {
    return [self.properties objectForKey:@"aligin-parent-bottom"];
}

- (NSString *)alginCenter {
    return [self.properties objectForKey:@"parent-center"];
}

- (NSString *)centerHorizontal {
    return [self.properties objectForKey:@"horizontal-center"];
}

- (NSString *)centerVertical {
    return [self.properties objectForKey:@"vertical-center"];
}

#pragma mark -

- (CSPUIStyleBlockN)X
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        if ( value )
        {
            [self.properties setObject:value forKey:@"x"];
        }
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)Y
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        if ( value )
        {
            [self.properties setObject:value forKey:@"y"];
        }
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)W
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        if ( value )
        {
            [self.properties setObject:value forKey:@"w"];
        }
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)H
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        if ( value )
        {
            [self.properties setObject:value forKey:@"h"];
        }
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)MIN_HEIGHT
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        if ( value )
        {
            [self.properties setObject:value forKey:@"min_height"];
        }
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)MIN_WIDTH
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        if ( value )
        {
            [self.properties setObject:value forKey:@"min_width"];
        }
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)MAX_HEIGHT
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        if ( value )
        {
            [self.properties setObject:value forKey:@"max_height"];
        }
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)MAX_WIDTH
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        if ( value )
        {
            [self.properties setObject:value forKey:@"max_width"];
        }
        return self;
    };

    return [block copy];
}


- (CSPUIStyleBlockN)POSITION
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        [self.properties setObject:first forKey:@"position"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)COMPOSITION
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        [self.properties setObject:first forKey:@"composition"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)MARGIN
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        [self.properties setObject:value forKey:@"margin_left"];
        [self.properties setObject:value forKey:@"margin_right"];
        [self.properties setObject:value forKey:@"margin_top"];
        [self.properties setObject:value forKey:@"margin_bottom"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)MARGIN_TOP
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        [self.properties setObject:value forKey:@"margin_top"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)MARGIN_BOTTOM
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        [self.properties setObject:value forKey:@"margin_bottom"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)MARGIN_LEFT
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        [self.properties setObject:value forKey:@"margin_left"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)MARGIN_RIGHT
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        [self.properties setObject:value forKey:@"margin_right"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)PADDING
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        [self.properties setObject:value forKey:@"padding_left"];
        [self.properties setObject:value forKey:@"padding_right"];
        [self.properties setObject:value forKey:@"padding_top"];
        [self.properties setObject:value forKey:@"padding_bottom"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)PADDING_TOP
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        [self.properties setObject:value forKey:@"padding_top"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)PADDING_BOTTOM
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        [self.properties setObject:value forKey:@"padding_bottom"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)PADDING_LEFT
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        [self.properties setObject:value forKey:@"padding_left"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)PADDING_RIGHT
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        CSPUIMetrics * value = [CSPUIMetrics fromString:(NSString *) first];
        [self.properties setObject:value forKey:@"padding_right"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)ALIGN
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        [self.properties setObject:first forKey:@"align"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)V_ALIGN
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        [self.properties setObject:first forKey:@"v_align"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)FLOATING
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        [self.properties setObject:first forKey:@"float"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)V_FLOATING
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        [self.properties setObject:first forKey:@"v_float"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)ORIENTATION
{
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        [self.properties setObject:first forKey:@"orientation"];
        return self;
    };

    return [block copy];
}

- (CSPUIStyleBlockN)GRAVITY {
    CSPUIStyleBlockN block = ^ CSPUIStyle * ( id first, ... )
    {
        [self.properties setObject:first forKey:@"gravity"];
        return self;
    };

    return [block copy];
}

#pragma mark -

- (void)mergeToStyle:(CSPUIStyle *)style
{
    if ( nil == style )
        return;

    style.CSS( self.properties );
}

@end