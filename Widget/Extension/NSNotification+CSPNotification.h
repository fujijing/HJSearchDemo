//
// Created by wow on 13-12-16.
// Copyright (c) 2013 chanjet. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NSObject+CSPProperty.h"

#pragma mark -

#define AS_NOTIFICATION( __name )	AS_STATIC_PROPERTY( __name )
#define DEF_NOTIFICATION( __name )	DEF_STATIC_PROPERTY3( __name, @"notify", [self description] )

#undef	ON_NOTIFICATION
#define ON_NOTIFICATION( __notification ) \
		- (void)handleNotification:(NSNotification *)__notification

#undef	ON_NOTIFICATION2
#define ON_NOTIFICATION2( __filter, __notification ) \
		- (void)handleNotification_##__filter:(NSNotification *)__notification

#undef	ON_NOTIFICATION3
#define ON_NOTIFICATION3( __class, __name, __notification ) \
		- (void)handleNotification_##__class##_##__name:(NSNotification *)__notification

#pragma mark -

@interface NSNotification (CSPNotification)

- (BOOL)is:(NSString *)name;
- (BOOL)isKindOf:(NSString *)prefix;

@end

#pragma mark -

@interface NSObject(CSPNotification)

+ (NSString *)NOTIFICATION;
+ (NSString *)NOTIFICATION_TYPE;

- (void)handleNotification:(NSNotification *)notification;

- (void)observeNotification:(NSString *)name;
- (void)unobserveNotification:(NSString *)name;
- (void)unobserveAllNotifications;

+ (BOOL)postNotification:(NSString *)name;
+ (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;

- (BOOL)postNotification:(NSString *)name;
- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;

@end
