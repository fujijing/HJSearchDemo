
#import "NSObject+CSPTypeConversion.h"
#import "NSArray+CSPExtension.h"
#import "SLCorePreprocessorMacros.h"

TT_FIX_CATEGORY_BUG(NSObject_CSPTypeConversion)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(CSPTypeConversion)

- (NSNumber *)asNSNumber
{
	if ( [self isKindOfClass:[NSNumber class]] )
	{
		return (NSNumber *)self;
	}
	else if ( [self isKindOfClass:[NSString class]] )
	{
		return [NSNumber numberWithLongLong:[(NSString *)self longLongValue]];
	}
	else if ( [self isKindOfClass:[NSDate class]] )
	{
		return [NSNumber numberWithDouble:[(NSDate *)self timeIntervalSince1970]];
	}
	else if ( [self isKindOfClass:[NSNull class]] )
	{
		return [NSNumber numberWithInteger:0];
	}

	return nil;
}

- (NSString *)asNSString
{
	if ( [self isKindOfClass:[NSNull class]] )
		return nil;

	if ( [self isKindOfClass:[NSString class]] )
	{
		return (NSString *)self;
	}
	else if ( [self isKindOfClass:[NSData class]] )
	{
		NSData * data = (NSData *)self;
		return [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
	}
	else
	{
		return [NSString stringWithFormat:@"%@", self];	
	}
}

- (NSDate *)asNSDate
{
	if ( [self isKindOfClass:[NSDate class]] )
	{
		return (NSDate *)self;
	}
	else if ( [self isKindOfClass:[NSString class]] )
	{
		NSDate * date = nil;
				
		if ( nil == date )
		{
			NSString * format = @"yyyy-MM-dd HH:mm:ss z";
			NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:format];
			[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

			date = [formatter dateFromString:(NSString *)self];
		}

		if ( nil == date )
		{
			NSString * format = @"yyyy/MM/dd HH:mm:ss z";
			NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:format];
			[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
			
			date = [formatter dateFromString:(NSString *)self];
		}
        
		if ( nil == date )
		{
			NSString * format = @"yyyy-MM-dd HH:mm:ss";
			NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:format];
			[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
			
			date = [formatter dateFromString:(NSString *)self];
		}

		if ( nil == date )
		{
			NSString * format = @"yyyy/MM/dd HH:mm:ss";
			NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:format];
			[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
			
			date = [formatter dateFromString:(NSString *)self];
		}

		return date;

//		NSTimeZone * local = [NSTimeZone localTimeZone];
//		return [NSDate dateWithTimeInterval:(3600 + [local secondsFromGMT])
//								  sinceDate:[dateFormatter dateFromString:text]];
	}
	else
	{
		return [NSDate dateWithTimeIntervalSince1970:[self asNSNumber].doubleValue];
	}
	
	return nil;	
}

- (NSData *)asNSData
{
    if ( [self isKindOfClass:[NSString class]] )
    {
        return [(NSString *)self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    }
    else if ( [self isKindOfClass:[NSData class]] )
    {
        return (NSData *)self;
    }

    return nil;
}

- (NSArray *)asNSArray
{
	if ( [self isKindOfClass:[NSArray class]] )
	{
		return (NSArray *)self;
	}
	else
	{
		return [NSArray arrayWithObject:self];
	}
}

- (NSArray *)asNSArrayWithClass:(Class)clazz
{
//	if ( [self isKindOfClass:[NSArray class]] )
//	{
//		NSMutableArray * results = [NSMutableArray array];
//
//		for ( NSObject * elem in (NSArray *)self )
//		{
//			if ( [elem isKindOfClass:[NSDictionary class]] )
//			{
//				NSObject * obj = [[self class] objectFromDictionary:elem];
//				[results addObject:obj];
//			}
//		}
//		
//		return results;
//	}

	return nil;
}

- (NSMutableArray *)asNSMutableArray
{
	if ( [self isKindOfClass:[NSMutableArray class]] )
	{
		return (NSMutableArray *)self;
	}
	
	return nil;
}

- (NSMutableArray *)asNSMutableArrayWithClass:(Class)clazz
{
	NSArray * array = [self asNSArrayWithClass:clazz];
	if ( nil == array )
		return nil;

	return [NSMutableArray arrayWithArray:array];
}

- (NSDictionary *)asNSDictionary
{
	if ( [self isKindOfClass:[NSDictionary class]] )
	{
		return (NSDictionary *)self;
	}

	return nil;
}

- (NSMutableDictionary *)asNSMutableDictionary
{
	if ( [self isKindOfClass:[NSMutableDictionary class]] )
	{
		return (NSMutableDictionary *)self;
	}
	
	NSDictionary * dict = [self asNSDictionary];
	if ( nil == dict )
		return nil;

	return [NSMutableDictionary dictionaryWithDictionary:dict];
}

@end
