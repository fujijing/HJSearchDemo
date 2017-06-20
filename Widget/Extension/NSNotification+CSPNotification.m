//
// Created by wow on 13-12-16.
// Copyright (c) 2013 chanjet. All rights reserved.
//


#import "NSNotification+CSPNotification.h"
#import "SLCorePreprocessorMacros.h"
#import "CSPLogger.h"
//#import "CSPUISignal.h"

TT_FIX_CATEGORY_BUG(NSNotification_CSPNotification)

@implementation NSNotification (CSPNotification)

- (BOOL)is:(NSString *)name
{
    return [self.name isEqualToString:name];
}

- (BOOL)isKindOf:(NSString *)prefix
{
    return [self.name hasPrefix:prefix];
}

@end

#pragma mark -

@implementation NSObject(CSPNotification)

+ (NSString *)NOTIFICATION
{
    return [self NOTIFICATION_TYPE];
}

+ (NSString *)NOTIFICATION_TYPE
{
    return [NSString stringWithFormat:@"notify.%@.", [self description]];
}

- (void)handleNotification:(NSNotification *)notification
{
}

- (void)observeNotification:(NSString *)notificationName
{
    NSArray * array = [notificationName componentsSeparatedByString:@"."];
    if ( array && array.count > 1 )
    {
//		NSString * prefix = (NSString *)[array objectAtIndex:0];
        NSString * clazz = (NSString *)[array objectAtIndex:1];
        NSString * name = (NSString *)[array objectAtIndex:2];

#if defined(__CSP_SELECTOR_STYLE2__) && __CSP_SELECTOR_STYLE2__
		{
			NSString * selectorName;
			SEL selector;

			selectorName = [NSString stringWithFormat:@"handleNotification_%@_%@:", clazz, name];
			selector = NSSelectorFromString(selectorName);

			if ( [self respondsToSelector:selector] )
			{
				[[NSNotificationCenter defaultCenter] addObserver:self
														 selector:selector
															 name:notificationName
														   object:nil];
				return;
			}

			selectorName = [NSString stringWithFormat:@"handleNotification_%@:", clazz];
			selector = NSSelectorFromString(selectorName);

			if ( [self respondsToSelector:selector] )
			{
				[[NSNotificationCenter defaultCenter] addObserver:self
														 selector:selector
															 name:notificationName
														   object:nil];
				return;
			}
		}
	#endif	// #if defined(__CSP_SMART_SELECTOR2__) && __CSP_SMART_SELECTOR2__

#if defined(__CSP_SELECTOR_STYLE1__) && __CSP_SELECTOR_STYLE1__
		{
			// TODO:
		}
	#endif	// #if defined(__CSP_SMART_SELECTOR1__) && __CSP_SMART_SELECTOR1__
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:notificationName
                                               object:nil];
}

- (void)unobserveNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)unobserveAllNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (BOOL)postNotification:(NSString *)name
{
    INFO( @"notification, %@", name );

    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
    return YES;
}

+ (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    INFO( @"notification, %@", name );

    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    return YES;
}

- (BOOL)postNotification:(NSString *)name
{
    return [[self class] postNotification:name];
}

- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    return [[self class] postNotification:name withObject:object];
}

@end