//
// Created by wow on 13-12-16.
// Copyright (c) 2013 chanjet. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NSObject+CSPProperty.h"


#pragma mark -

#undef	PRINT_CALLSTACK
#define PRINT_CALLSTACK( __n )	[CSPRuntime printCallstack:__n]

#undef	BREAK_POINT
#define BREAK_POINT()			[CSPRuntime breakPoint];

#undef	BREAK_POINT_IF
#define BREAK_POINT_IF( __x )	if ( __x ) { [CSPRuntime breakPoint]; }

#pragma mark -

@interface CSPCallFrame : NSObject

AS_INT( TYPE_UNKNOWN )
AS_INT( TYPE_OBJC )
AS_INT( TYPE_NATIVEC )

@property (nonatomic, assign) NSUInteger	type;
@property (nonatomic, retain) NSString *	process;
@property (nonatomic, assign) NSUInteger	entry;
@property (nonatomic, assign) NSUInteger	offset;
@property (nonatomic, retain) NSString *	clazz;
@property (nonatomic, retain) NSString *	method;

+ (id)parse:(NSString *)line;
+ (id)unknown;

@end

#pragma mark -

@interface CSPTypeEncoding : NSObject

AS_INT( UNKNOWN )
AS_INT( OBJECT )
AS_INT( NSNUMBER )
AS_INT( NSSTRING )
AS_INT( NSARRAY )
AS_INT( NSDICTIONARY )
AS_INT( NSDATE )

+ (NSUInteger)typeOf:(const char *)attr;
+ (NSUInteger)typeOfAttribute:(const char *)attr;
+ (NSUInteger)typeOfObject:(id)obj;

+ (NSString *)classNameOf:(const char *)attr;
+ (NSString *)classNameOfAttribute:(const char *)attr;

+ (Class)classOfAttribute:(const char *)attr;

+ (BOOL)isAtomClass:(Class)clazz;

@end


#pragma mark -

@interface CSPRuntime : NSObject

+ (id)allocByClass:(Class)clazz;
+ (id)allocByClassName:(NSString *)clazzName;

+ (NSArray *)allClasses;
+ (NSArray *)allSubClassesOf:(Class)clazz;

+ (NSArray *)callstack:(NSUInteger)depth;
+ (NSArray *)callframes:(NSUInteger)depth;

+ (void)printCallstack:(NSUInteger)depth;
+ (void)breakPoint;

@end