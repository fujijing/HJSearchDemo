//
// Created by wow on 13-12-16.
// Copyright (c) 2013 chanjet. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CSPPrecompile.h"
#import "CSPPackage.h"
#import "NSObject+CSPProperty.h"

#pragma mark -

AS_PACKAGE( CSPPackage, CSPLogger, logger );

#pragma mark -

typedef enum
{
    CSPLogLevelNone		= 0,
    CSPLogLevelInfo		= 100,
    CSPLogLevelPerf		= 200,
    CSPLogLevelWarn		= 300,
    CSPLogLevelError	= 400
} CSPLogLevel;

#pragma mark -

#if __CSP_LOG__

#if __CSP_DEVELOPMENT__

#undef	CC
#define CC( ... )		[[CSPLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:CSPLogLevelNone format:__VA_ARGS__];

#undef	INFO
#define INFO( ... )		[[CSPLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:CSPLogLevelInfo format:__VA_ARGS__];

#undef	PERF
#define PERF( ... )		[[CSPLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:CSPLogLevelPerf format:__VA_ARGS__];

#undef	WARN
#define WARN( ... )		[[CSPLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:CSPLogLevelWarn format:__VA_ARGS__];

#undef	ERROR
#define ERROR( ... )	[[CSPLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:CSPLogLevelError format:__VA_ARGS__];

#undef	PRINT
#define PRINT( ... )	[[CSPLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:CSPLogLevelNone format:__VA_ARGS__];

#else	// #if __CSP_DEVELOPMENT__

#undef	CC
#define CC( ... )		[[CSPLogger sharedInstance] level:CSPLogLevelNone format:__VA_ARGS__];

#undef	INFO
#define INFO( ... )		[[CSPLogger sharedInstance] level:CSPLogLevelInfo format:__VA_ARGS__];

#undef	PERF
#define PERF( ... )		[[CSPLogger sharedInstance] level:CSPLogLevelPerf format:__VA_ARGS__];

#undef	WARN
#define WARN( ... )		[[CSPLogger sharedInstance] level:CSPLogLevelWarn format:__VA_ARGS__];

#undef	ERROR
#define ERROR( ... )	[[CSPLogger sharedInstance] level:CSPLogLevelError format:__VA_ARGS__];

#undef	PRINT
#define PRINT( ... )	[[CSPLogger sharedInstance] level:CSPLogLevelNone format:__VA_ARGS__];

#endif	// #if __CSP_DEVELOPMENT__

#undef	VAR_DUMP
#define VAR_DUMP( __obj )	PRINT( [__obj description] );

#undef	OBJ_DUMP
#define OBJ_DUMP( __obj )	PRINT( [__obj objectToDictionary] );

#else	// #if __CSP_LOG__

#undef	CC
#define CC( ... )

#undef	INFO
#define INFO( ... )

#undef	PERF
#define PERF( ... )

#undef	WARN
#define WARN( ... )

#undef	ERROR
#define ERROR( ... )

#undef	PRINT
#define PRINT( ... )

#undef	VAR_DUMP
#define VAR_DUMP( __obj )

#undef	OBJ_DUMP
#define OBJ_DUMP( __obj )

#endif	// #if __CSP_LOG__

#undef	TODO
#define TODO( desc, ... )

#pragma mark -

@interface CSPBacklog : NSObject
@property (nonatomic, retain) NSString *		module;
@property (nonatomic, assign) CSPLogLevel		level;
@property (nonatomic, readonly) NSString *		levelString;
@property (nonatomic, retain) NSString *		file;
@property (nonatomic, assign) NSUInteger		line;
@property (nonatomic, retain) NSString *		func;
@property (nonatomic, retain) NSDate *			time;
@property (nonatomic, retain) NSString *		text;
@end

#pragma mark -

@interface CSPLogger : NSObject

AS_SINGLETON( CSPLogger )

@property (nonatomic, assign) BOOL				showLevel;
@property (nonatomic, assign) BOOL				showModule;
@property (nonatomic, assign) BOOL				enabled;
@property (nonatomic, retain) NSMutableArray *	backlogs;
@property (nonatomic, assign) NSUInteger		indentTabs;

- (void)toggle;
- (void)enable;
- (void)disable;

- (void)indent;
- (void)indent:(NSUInteger)tabs;
- (void)unindent;
- (void)unindent:(NSUInteger)tabs;

#if __CSP_DEVELOPMENT__
- (void)file:(NSString *)file line:(NSUInteger)line function:(NSString *)function level:(CSPLogLevel)level format:(NSString *)format, ...;
- (void)file:(NSString *)file line:(NSUInteger)line function:(NSString *)function level:(CSPLogLevel)level format:(NSString *)format args:(va_list)args;
#else	// #if __CSP_DEVELOPMENT__
- (void)level:(CSPLogLevel)level format:(NSString *)format, ...;
- (void)level:(CSPLogLevel)level format:(NSString *)format args:(va_list)args;
#endif
@end

//#define CSPLog
//void CSPLog( NSString * format, ... );