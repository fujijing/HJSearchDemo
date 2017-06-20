//
// Created by wow on 13-12-16.
// Copyright (c) 2013 chanjet. All rights reserved.
//


#import <objc/runtime.h>
#import "NSObject+CSPJSON.h"
#import "SLCorePreprocessorMacros.h"
#import "CSPRuntime.h"
#import "NSDictionary+CSPExtension.h"
#import "JSONKit.h"
#import "NSObject+CSPTypeConversion.h"
#import "CSPPrecompile.h"

TT_FIX_CATEGORY_BUG(NSObject_CSPJSON)

@implementation NSObject (CSPJSON)


+ (id)objectsFromArray:(id)arr
{
    if ( nil == arr )
        return nil;

    if ( NO == [arr isKindOfClass:[NSArray class]] )
        return nil;

    NSMutableArray * results = [NSMutableArray array];

    for (__strong NSObject * obj in (NSArray *)arr )
    {
        if ( [obj isKindOfClass:[NSDictionary class]] )
        {
            obj = [self objectFromDictionary:obj];
            if ( obj )
            {
                [results addObject:obj];
            }
        }
        else
        {
            [results addObject:obj];
        }
    }

    return results;
}

+ (id)objectFromDictionary:(id)dict
{
    if ( nil == dict )
    {
        return nil;
    }

    if ( NO == [dict isKindOfClass:[NSDictionary class]] )
    {
        return nil;
    }

    return [(NSDictionary *)dict objectForClass:[self class]];
}

+ (id)objectFromString:(id)str
{
    if ( nil == str )
    {
        return nil;
    }

    if ( NO == [str isKindOfClass:[NSString class]] )
    {
        return nil;
    }

    NSObject * obj = [(NSString *)str objectFromJSONString];
    if ( nil == obj )
    {
        return nil;
    }

    if ( [obj isKindOfClass:[NSDictionary class]] )
    {
        return [(NSDictionary *)obj objectForClass:[self class]];
    }
    else if ( [obj isKindOfClass:[NSArray class]] )
    {
        NSMutableArray * array = [NSMutableArray array];

        for ( NSObject * elem in (NSArray *)obj )
        {
            if ( [elem isKindOfClass:[NSDictionary class]] )
            {
                NSObject * result = [(NSDictionary *)elem objectForClass:[self class]];
                if ( result )
                {
                    [array addObject:result];
                }
            }
        }

        return array;
    }
    else if ( [CSPTypeEncoding isAtomClass:[obj class]] )
    {
        return obj;
    }

    return nil;
}

+ (id)objectFromData:(id)data
{
    if ( nil == data )
    {
        return nil;
    }

    if ( NO == [data isKindOfClass:[NSData class]] )
    {
        return nil;
    }

    NSObject * obj = [(NSData *)data objectFromJSONData];
    if ( obj && [obj isKindOfClass:[NSDictionary class]] )
    {
        return [(NSDictionary *)obj objectForClass:[self class]];
    }

    return nil;
}

+ (id)objectFromAny:(id)any
{
    if ( [any isKindOfClass:[NSArray class]] )
    {
        return [self objectsFromArray:any];
    }
    else if ( [any isKindOfClass:[NSDictionary class]] )
    {
        return [self objectFromDictionary:any];
    }
    else if ( [any isKindOfClass:[NSString class]] )
    {
        return [self objectFromString:any];
    }
    else if ( [any isKindOfClass:[NSData class]] )
    {
        return [self objectFromData:any];
    }

    return any;
}

- (id)objectToDictionary
{
    return [self objectToDictionaryUntilRootClass:nil];
}

- (id)objectToDictionaryUntilRootClass:(Class)rootClass
{
    NSMutableDictionary * result = [NSMutableDictionary dictionary];

    if ( [self isKindOfClass:[NSDictionary class]] )
    {
        NSDictionary * dict = (NSDictionary *)self;

        for ( NSString * key in dict.allKeys )
        {
            NSObject * obj = [dict objectForKey:key];
            if ( obj )
            {
                NSUInteger propertyType = [CSPTypeEncoding typeOfObject:obj];
                if ( CSPTypeEncoding.NSNUMBER == propertyType )
                {
                    [result setObject:obj forKey:key];
                }
                else if ( CSPTypeEncoding.NSSTRING == propertyType )
                {
                    [result setObject:obj forKey:key];
                }
                else if ( CSPTypeEncoding.NSARRAY == propertyType )
                {
                    NSMutableArray * array = [NSMutableArray array];

                    for ( NSObject * elem in (NSArray *)obj )
                    {
                        NSDictionary * dict = [elem objectToDictionaryUntilRootClass:rootClass];
                        if ( dict )
                        {
                            [array addObject:dict];
                        }
                        else
                        {
                            if ( [CSPTypeEncoding isAtomClass:[elem class]] )
                            {
                                [array addObject:elem];
                            }
                        }
                    }

                    [result setObject:array forKey:key];
                }
                else if ( CSPTypeEncoding.NSDICTIONARY == propertyType )
                {
                    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

                    for ( NSString * key in ((NSDictionary *)obj).allKeys )
                    {
                        NSObject * val = [(NSDictionary *)obj objectForKey:key];
                        if ( val )
                        {
                            NSDictionary * subresult = [val objectToDictionaryUntilRootClass:rootClass];
                            if ( subresult )
                            {
                                [dict setObject:subresult forKey:key];
                            }
                            else
                            {
                                if ( [CSPTypeEncoding isAtomClass:[val class]] )
                                {
                                    [dict setObject:val forKey:key];
                                }
                            }
                        }
                    }

                    [result setObject:dict forKey:key];
                }
                else if ( CSPTypeEncoding.NSDATE == propertyType )
                {
                    [result setObject:[obj description] forKey:key];
                }
                else
                {
                    obj = [obj objectToDictionaryUntilRootClass:rootClass];
                    if ( obj )
                    {
                        [result setObject:obj forKey:key];
                    }
                    else
                    {
                        [result setObject:[NSDictionary dictionary] forKey:key];
                    }
                }
            }
//			else
//			{
//				[result setObject:[NSNull null] forKey:key];
//			}
        }
    }
    else
    {
        for ( Class clazzType = [self class];; )
        {
            if ( rootClass )
            {
                if ( clazzType == rootClass )
                    break;
            }
            else
            {
                if ( [CSPTypeEncoding isAtomClass:clazzType] )
                    break;
            }

            unsigned int		propertyCount = 0;
            objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );

            for ( NSUInteger i = 0; i < propertyCount; i++ )
            {
                const char *	name = property_getName(properties[i]);
                const char *	attr = property_getAttributes(properties[i]);

                NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                NSUInteger		propertyType = [CSPTypeEncoding typeOf:attr];

                NSObject * obj = [self valueForKey:propertyName];
                if ( obj )
                {
                    if ( CSPTypeEncoding.NSNUMBER == propertyType )
                    {
                        [result setObject:obj forKey:propertyName];
                    }
                    else if ( CSPTypeEncoding.NSSTRING == propertyType )
                    {
                        [result setObject:obj forKey:propertyName];
                    }
                    else if ( CSPTypeEncoding.NSARRAY == propertyType )
                    {
                        NSMutableArray * array = [NSMutableArray array];

                        for ( NSObject * elem in (NSArray *)obj )
                        {
                            NSUInteger elemType = [CSPTypeEncoding typeOfObject:elem];

                            if ( CSPTypeEncoding.NSNUMBER == elemType )
                            {
                                [array addObject:elem];
                            }
                            else if ( CSPTypeEncoding.NSSTRING == elemType )
                            {
                                [array addObject:elem];
                            }
                            else
                            {
                                NSDictionary * dict = [elem objectToDictionaryUntilRootClass:rootClass];
                                if ( dict )
                                {
                                    [array addObject:dict];
                                }
                                else
                                {
                                    if ( [CSPTypeEncoding isAtomClass:[elem class]] )
                                    {
                                        [array addObject:elem];
                                    }
                                }
                            }
                        }

                        [result setObject:array forKey:propertyName];
                    }
                    else if ( CSPTypeEncoding.NSDICTIONARY == propertyType )
                    {
                        NSMutableDictionary * dict = [NSMutableDictionary dictionary];

                        for ( NSString * key in ((NSDictionary *)obj).allKeys )
                        {
                            NSObject * val = [(NSDictionary *)obj objectForKey:key];
                            if ( val )
                            {
                                NSDictionary * subresult = [val objectToDictionaryUntilRootClass:rootClass];
                                if ( subresult )
                                {
                                    [dict setObject:subresult forKey:key];
                                }
                                else
                                {
                                    if ( [CSPTypeEncoding isAtomClass:[val class]] )
                                    {
                                        [dict setObject:val forKey:key];
                                    }
                                }
                            }
                        }

                        [result setObject:dict forKey:propertyName];
                    }
                    else if ( CSPTypeEncoding.NSDATE == propertyType )
                    {
                        [result setObject:[obj description] forKey:propertyName];
                    }
                    else
                    {
                        obj = [obj objectToDictionaryUntilRootClass:rootClass];
                        if ( obj )
                        {
                            [result setObject:obj forKey:propertyName];
                        }
                        else
                        {
                            [result setObject:[NSDictionary dictionary] forKey:propertyName];
                        }
                    }
                }
//				else
//				{
//					[result setObject:[NSNull null] forKey:propertyName];
//				}
            }

            free( properties );

            clazzType = class_getSuperclass( clazzType );
            if ( nil == clazzType )
                break;
        }
    }

    return result.count ? result : nil;
}

- (id)objectZerolize
{
    return [self objectZerolizeUntilRootClass:nil];
}

- (id)objectZerolizeUntilRootClass:(Class)rootClass
{
    for ( Class clazzType = [self class];; )
    {
        if ( rootClass )
        {
            if ( clazzType == rootClass )
                break;
        }
        else
        {
            if ( [CSPTypeEncoding isAtomClass:clazzType] )
                break;
        }

        unsigned int		propertyCount = 0;
        objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );

        for ( NSUInteger i = 0; i < propertyCount; i++ )
        {
            const char *	name = property_getName(properties[i]);
            const char *	attr = property_getAttributes(properties[i]);

            NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            NSUInteger		propertyType = [CSPTypeEncoding typeOfAttribute:attr];

            if ( CSPTypeEncoding.NSNUMBER == propertyType )
            {
                [self setValue:[NSNumber numberWithInt:0] forKey:propertyName];
            }
            else if ( CSPTypeEncoding.NSSTRING == propertyType )
            {
                [self setValue:@"" forKey:propertyName];
            }
            else if ( CSPTypeEncoding.NSARRAY == propertyType )
            {
                [self setValue:[NSMutableArray array] forKey:propertyName];
            }
            else if ( CSPTypeEncoding.NSDICTIONARY == propertyType )
            {
                [self setValue:[NSMutableDictionary dictionary] forKey:propertyName];
            }
            else if ( CSPTypeEncoding.NSDATE == propertyType )
            {
                [self setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:propertyName];
            }
            else if ( CSPTypeEncoding.OBJECT == propertyType )
            {
                Class clazz = [CSPTypeEncoding classOfAttribute:attr];
                if ( clazz )
                {
                    NSObject * newObj = [[clazz alloc] init];
                    [self setValue:newObj forKey:propertyName];
                }
                else
                {
                    [self setValue:nil forKey:propertyName];
                }
            }
            else
            {
                [self setValue:nil forKey:propertyName];
            }
        }

        free( properties );

        clazzType = class_getSuperclass( clazzType );
        if ( nil == clazzType )
            break;
    }

    return self;
}

- (id)objectToString
{
    return [self objectToStringUntilRootClass:nil];
}

- (id)objectToStringUntilRootClass:(Class)rootClass
{
    NSString *	json = nil;
    NSUInteger	propertyType = [CSPTypeEncoding typeOfObject:self];

    if ( CSPTypeEncoding.NSNUMBER == propertyType )
    {
        json = [self asNSString];
    }
    else if ( CSPTypeEncoding.NSSTRING == propertyType )
    {
        json = [self asNSString];
    }
    else if ( CSPTypeEncoding.NSARRAY == propertyType )
    {
        NSMutableArray * array = [NSMutableArray array];

        for ( NSObject * elem in (NSArray *)self )
        {
            NSDictionary * dict = [elem objectToDictionaryUntilRootClass:rootClass];
            if ( dict )
            {
                [array addObject:dict];
            }
            else
            {
                if ( [CSPTypeEncoding isAtomClass:[elem class]] )
                {
                    [array addObject:elem];
                }
            }
        }

        #if __CSP_DEVELOPMENT__
        json = [array JSONStringWithOptions:JKSerializeOptionPretty error:NULL];
        #else
        json = [array JSONString];
        #endif
    }
    else if ( CSPTypeEncoding.NSDICTIONARY == propertyType )
    {
        NSDictionary * dict = [self objectToDictionaryUntilRootClass:rootClass];
        if ( dict )
        {
            #if __CSP_DEVELOPMENT__
            json = [dict JSONStringWithOptions:JKSerializeOptionPretty error:NULL];
            #else
            json = [dict JSONString];
            #endif
        }
    }
    else if ( CSPTypeEncoding.NSDATE == propertyType )
    {
        json = [self description];
    }
    else
    {
        NSDictionary * dict = [self objectToDictionaryUntilRootClass:rootClass];
        if ( dict )
        {
            #if __CSP_DEVELOPMENT__
            json = [dict JSONStringWithOptions:JKSerializeOptionPretty error:NULL];
            #else
            json = [dict JSONString];
            #endif
        }
    }

    if ( nil == json || 0 == json.length )
        return nil;

    return [NSMutableString stringWithString:json];
}

- (id)objectToData
{
    return [self objectToDataUntilRootClass:nil];
}

- (id)objectToDataUntilRootClass:(Class)rootClass
{
    NSString * string = [self objectToStringUntilRootClass:rootClass];
    if ( nil == string )
        return nil;

    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (id)serializeObject
{
    NSUInteger type = [CSPTypeEncoding typeOfObject:self];

    if ( CSPTypeEncoding.NSNUMBER == type )
    {
        return self;
    }
    else if ( CSPTypeEncoding.NSSTRING == type )
    {
        return self;
    }
    else if ( CSPTypeEncoding.NSDATE == type )
    {
        return self;
    }
    else if ( CSPTypeEncoding.NSARRAY == type )
    {
        NSArray *			array = (NSArray *)self;
        NSMutableArray *	result = [NSMutableArray array];

        for ( NSObject * elem in array )
        {
            NSObject * val = [elem serializeObject];
            if ( val )
            {
                [result addObject:val];
            }
        }

        return result;
    }
    else if ( CSPTypeEncoding.NSDICTIONARY == type )
    {
        NSDictionary *			dict = (NSDictionary *)self;
        NSMutableDictionary *	result = [NSMutableDictionary dictionary];

        for ( NSString * key in dict.allKeys )
        {
            NSObject * val = [dict objectForKey:key];
            NSObject * val2 = [val serializeObject];

            if ( val2 )
            {
                [result setObject:val2 forKey:key];
            }
        }

        return result;
    }
    else if ( CSPTypeEncoding.OBJECT == type )
    {
        return [self objectToDictionary];
    }

    return nil;
}

+ (id)unserializeObject:(id)obj
{
    NSUInteger type = [CSPTypeEncoding typeOfObject:obj];

    if ( CSPTypeEncoding.NSNUMBER == type )
    {
        return self;
    }
    else if ( CSPTypeEncoding.NSSTRING == type )
    {
        return [self objectFromString:obj];
    }
    else if ( CSPTypeEncoding.NSDATE == type )
    {
        return self;
    }
    else if ( CSPTypeEncoding.NSARRAY == type )
    {
        return [self objectsFromArray:obj];
    }
    else if ( CSPTypeEncoding.NSDICTIONARY == type )
    {
        return [self objectFromDictionary:obj];
    }
    else if ( CSPTypeEncoding.OBJECT == type )
    {
        return self;
    }

    return nil;
}

@end