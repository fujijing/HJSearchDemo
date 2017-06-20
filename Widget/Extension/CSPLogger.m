//
// Created by wow on 13-12-16.
// Copyright (c) 2013 chanjet. All rights reserved.
//


#import "CSPLogger.h"
#import "NSArray+CSPExtension.h"
#import "CSPSystemInfo.h"

DEF_PACKAGE( CSPPackage, CSPLogger, logger );

#pragma mark -

#undef	MAX_BACKLOG
#define MAX_BACKLOG	(50)

#pragma mark -

@implementation CSPBacklog

@synthesize level = _level;
@synthesize time = _time;
@synthesize text = _text;

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.level = CSPLogLevelNone;
        self.time = [NSDate date];
        self.text = nil;
    }
    return self;
}

- (void)dealloc
{
    self.time = nil;
    self.text = nil;
}

- (NSString *)levelString
{
    if ( CSPLogLevelInfo == self.level )
    {
        return @"INFO";
    }
    else if ( CSPLogLevelPerf == self.level )
    {
        return @"PERF";
    }
    else if ( CSPLogLevelWarn == self.level )
    {
        return @"WARN";
    }
    else if ( CSPLogLevelError == self.level )
    {
        return @"ERROR";
    }

    return @"SYSTEM";
}

@end

#pragma mark -

@interface CSPLogger()
{
    BOOL				_showLevel;
    BOOL				_showModule;

    BOOL				_enabled;
    NSMutableArray *	_backlogs;
    NSUInteger			_indentTabs;
}

- (void)printLogo;

@end

#pragma mark -

@implementation CSPLogger

DEF_SINGLETON( CSPLogger );

@synthesize showLevel = _showLevel;
@synthesize showModule = _showModule;

@synthesize enabled = _enabled;
@synthesize backlogs = _backlogs;
@synthesize indentTabs = _indentTabs;

+ (BOOL)autoLoad
{
    [[CSPLogger sharedInstance] printLogo];

    return YES;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
#if __CSP_DEVELOPMENT__
		self.showLevel = YES;
		self.showModule = NO;
	#else	// #if __CSP_DEVELOPMENT__
        self.showLevel = YES;
        self.showModule = NO;
#endif	// #if __CSP_DEVELOPMENT__

        self.enabled = YES;
        self.backlogs = [NSMutableArray array];
        self.indentTabs = 0;
    }
    return self;
}

- (void)dealloc
{
    self.backlogs = nil;
}

- (void)printLogo
{
#if TARGET_OS_IPHONE
    fprintf( stderr, "%s	\n", [CSPSystemInfo OSVersion].UTF8String );
    fprintf( stderr, "%s	\n", [CSPSystemInfo deviceModel].UTF8String );
    fprintf( stderr, "    												\n" );
    fprintf( stderr, "UUID: %s	\n", [CSPSystemInfo deviceUUID].UTF8String );
    fprintf( stderr, "Home: %s	\n", [NSBundle mainBundle].bundlePath.UTF8String );
    fprintf( stderr, "    												\n" );
#endif	// #if TARGET_OS_IPHONE
}

- (void)toggle
{
    _enabled = _enabled ? NO : YES;
}

- (void)enable
{
    _enabled = YES;
}

- (void)disable
{
    _enabled = NO;
}

- (void)indent
{
    _indentTabs += 1;
}

- (void)indent:(NSUInteger)tabs
{
    _indentTabs += tabs;
}

- (void)unindent
{
    if ( _indentTabs > 0 )
    {
        _indentTabs -= 1;
    }
}

- (void)unindent:(NSUInteger)tabs
{
    if ( _indentTabs < tabs )
    {
        _indentTabs = 0;
    }
    else
    {
        _indentTabs -= tabs;
    }
}

#if __CSP_DEVELOPMENT__
- (void)file:(NSString *)file line:(NSUInteger)line function:(NSString *)function level:(CSPLogLevel)level format:(NSString *)format, ...
#else	// #if __CSP_DEVELOPMENT__
- (void)level:(CSPLogLevel)level format:(NSString *)format, ...
#endif	// #if __CSP_DEVELOPMENT__
{
#if (__ON__ == __CSP_LOG__)
	
	if ( nil == format || NO == [format isKindOfClass:[NSString class]] )
		return;

	va_list args;
	va_start( args, format );

#if __CSP_DEVELOPMENT__
	[self file:file line:line function:function level:level format:format args:args];
#else	// #if __CSP_DEVELOPMENT__
	[self level:level format:format args:args];
#endif	// #if __CSP_DEVELOPMENT__

	va_end( args );

#endif	// #if (__ON__ == __CSP_LOG__)
}

#if __CSP_DEVELOPMENT__
- (void)file:(NSString *)file line:(NSUInteger)line function:(NSString *)function level:(CSPLogLevel)level format:(NSString *)format args:(va_list)args
#else	// #if __CSP_DEVELOPMENT__
- (void)level:(CSPLogLevel)level format:(NSString *)format args:(va_list)args
#endif	// #if __CSP_DEVELOPMENT__
{
#if (__ON__ == __CSP_LOG__)
	
	if ( NO == _enabled )
		return;
	
// formatting

	NSMutableString * text = [NSMutableString string];
	NSMutableString * tabs = nil;
	
	if ( _indentTabs > 0 )
	{
		tabs = [NSMutableString string];
		
		for ( int i = 0; i < _indentTabs; ++i )
		{
			[tabs appendString:@"\t"];
		}
	}
	
	NSString * module = nil;

#if __CSP_DEVELOPMENT__
	module = [[file lastPathComponent] stringByDeletingPathExtension];
#endif	// #if __CSP_DEVELOPMENT__

	if ( self.showLevel || self.showModule )
	{
		NSMutableString * temp = [NSMutableString string];

		if ( self.showLevel )
		{
			if ( CSPLogLevelInfo == level )
			{
				[temp appendString:@"[INFO]"];
			}
			else if ( CSPLogLevelPerf == level )
			{
				[temp appendString:@"[PERF]"];
			}
			else if ( CSPLogLevelWarn == level )
			{
				[temp appendString:@"[WARN]"];
			}
			else if ( CSPLogLevelError == level )
			{
				[temp appendString:@"[ERROR]"];
			}
		}

		if ( self.showModule )
		{
			if ( module && module.length )
			{
				[temp appendFormat:@" [%@]", module];
			}
		}
		
		if ( temp.length )
		{
			NSString * temp2 = [temp stringByPaddingToLength:((temp.length / 8) + 1) * 8 withString:@" " startingAtIndex:0];
			[text appendString:temp2];
		}
	}

	if ( tabs && tabs.length )
	{
		[text appendString:tabs];
	}

	NSString * content = [[NSString alloc] initWithFormat:(NSString *)format arguments:args];
	if ( content && content.length )
	{
		[text appendString:content];
	}
	
	if ( [text rangeOfString:@"\n"].length )
	{
		[text replaceOccurrencesOfString:@"\n"
							  withString:[NSString stringWithFormat:@"\n%@", tabs ? tabs : @"\t\t"]
								 options:NSCaseInsensitiveSearch
								   range:NSMakeRange( 0, text.length )];
	}
	
	// print to console
	
	fprintf( stderr, [text UTF8String], NULL );
	fprintf( stderr, "\n", NULL );

	// back log
	
#if __CSP_DEVELOPMENT__
	if (CSPLogLevelInfo == level || CSPLogLevelError == level || CSPLogLevelWarn == level )
	{
		CSPBacklog * log = [[CSPBacklog alloc] init];
		if ( log )
		{
			log.level = level;
			log.text = text;
			log.module = module;
			log.file = file;
			log.line = line;
			log.func = function;
			
			[_backlogs pushTail:log];
			[_backlogs keepTail:MAX_BACKLOG];
		}
	}
#endif	// #if __CSP_DEVELOPMENT__
#endif	// #if (__ON__ == __CSP_LOG__)
}

@end