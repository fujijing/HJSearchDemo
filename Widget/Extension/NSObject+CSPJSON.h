//
// Created by wow on 13-12-16.
// Copyright (c) 2013 chanjet. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSObject (CSPJSON)

+ (id)objectsFromArray:(id)arr;
+ (id)objectFromDictionary:(id)dict;
+ (id)objectFromString:(id)str;
+ (id)objectFromData:(id)data;
+ (id)objectFromAny:(id)any;

- (id)objectToDictionary;
- (id)objectToString;
- (id)objectToData;
- (id)objectZerolize;

- (id)objectToDictionaryUntilRootClass:(Class)rootClass;
- (id)objectToStringUntilRootClass:(Class)rootClass;
- (id)objectToDataUntilRootClass:(Class)rootClass;
- (id)objectZerolizeUntilRootClass:(Class)rootClass;

- (id)serializeObject;
+ (id)unserializeObject:(id)obj;

@end