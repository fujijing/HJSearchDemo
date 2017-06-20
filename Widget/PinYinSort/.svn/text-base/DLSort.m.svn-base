//
// Created by evan on 15/4/12.
// Copyright (c) 2015 evan. All rights reserved.
//

#import "DLSort.h"
#import "PinyinHelper.h"
#import "NSArray+CSPExtension.h"


@implementation DLSort {
    NSMutableDictionary *_cachePinyinDict;
    NSMutableDictionary *_indexedObjects;
    NSMutableDictionary *_allLetters;
    NSMutableArray *_objectsInitials;
}

+ (id)instance
{
    static DLSort *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^(){
        _instance = [[DLSort alloc] init];
    });
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _allLetters = [[NSMutableDictionary alloc] init];
        //初始化数据
        for(char c = 'A'; c <= 'Z'; c++ )
        {
            _allLetters[[NSString stringWithFormat:@"%c",c]] = @1;
        }
    }
    return self;
}

- (NSMutableArray *)getLetters
{
    if (_objectsInitials) return _objectsInitials;
    else return [NSMutableArray array];
}

- (NSMutableDictionary *)getLetterKeyForValue
{
    if (_indexedObjects) return _indexedObjects;
    else return [NSMutableDictionary dictionary];
}

- (NSArray *)sort:(NSArray *)objects
{
    if (objects == nil || objects.count == 0) return objects;

    @synchronized (_cachePinyinDict) {
        if (_cachePinyinDict == nil) {
            _cachePinyinDict = [[NSMutableDictionary alloc] init];
        }
    }

    NSArray *dataObjects;

    NSString *field = @"name";

    NSMutableArray * sortedObjects = [NSMutableArray arrayWithArray:objects];
    NSUInteger count = [objects count];
    if (count == 1) {
        [sortedObjects addObject:objects[0]];
    }

    objects = [sortedObjects sortedArrayUsingComparator:^NSComparisonResult(NSObject * obj1, NSObject * obj2) {
        NSString *name1 = [obj1 valueForKey:field];
        NSString *name2 = [obj2 valueForKey:field];
        if (name1 == nil || name1.length == 0) {
            name1 = @" ";
        }
        if (name2 == nil || name2.length == 0) {
            name2 = @" ";
        }

        NSString * p1 = [_cachePinyinDict objectForKey:name1];
        NSString * p2 = [_cachePinyinDict objectForKey:name2];

        if (p1 == nil)
        {
            p1 = [[PinyinHelper getPinyin:name1 isXingshi:YES] join:@" "];
            if (p1 == nil)
            {
                _cachePinyinDict[name1] = @"z-z-z-z-z-z-z-z-z-z-z-z-z-z";
            }
            else
            {
                _cachePinyinDict[name1] = p1;
            }
        }
        if (p2 == nil) {
            p2 = [[PinyinHelper getPinyin:name2 isXingshi:YES] join:@" "];
            if (p2 == nil)
            {
                _cachePinyinDict[name2] = @"z-z-z-z-z-z-z-z-z-z-z-z-z-z";
            }
            else
            {
                _cachePinyinDict[name2] = p2;
            }
        }

        NSComparisonResult result = [p1 compare:p2 options:NSCaseInsensitiveSearch];
        if (result == NSOrderedSame) {
            result = [name1 localizedCompare:name2];
        }
        return result;
    }];

    if (count == 1) {
        [sortedObjects removeLastObject];
        objects = sortedObjects;
    }

    dataObjects = objects;
    return [self reloadDataWithObjects:dataObjects];
}

- (NSArray *)reloadDataWithObjects:(NSArray *)objects
{
    if (objects == nil || objects.count == 0) return objects;

    NSString *field = @"name";
    NSMutableDictionary * pinyinDict = [[NSMutableDictionary alloc] init];
    [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString * name = [obj valueForKey:field];
        if (name == nil || name.length == 0) {
            name = @" ";
        }
        NSString * p = [_cachePinyinDict objectForKey:name];
        pinyinDict[name] = [p substringToIndex:1];
    }];

    // calculate needed initials
    NSArray * allLetters = [pinyinDict.allValues sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
        return [obj1 compare:obj2];
    }];

    NSMutableArray *initials = [NSMutableArray array];

    for (NSString *property in allLetters) {
        if ([property length]) {
            NSString *initial = property;
            if (! _allLetters[initial]) {
                initial = @"#";
            }

            if (![initials containsObject:initial]) {
                [initials addObject:initial];
            }
        }
    }

    // 如果有"#",则把#放到最后面
    if ([initials containsObject:@"#"])
    {
        [initials removeObject:@"#"];
        [initials addObject:@"#"];
    }

    _objectsInitials = initials;

    _indexedObjects = [NSMutableDictionary dictionary];

    // create dictionary with objects grouped by initial
    for (NSString *initial in _objectsInitials) {
        NSMutableArray * filteredForInitial = [[NSMutableArray alloc] init];
        [_indexedObjects setObject:filteredForInitial forKey:initial];
    }

    [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString * name = [obj valueForKey:field];
        if (name == nil || name.length == 0) {
            name = @" ";
        }

        NSString * initialWords = [pinyinDict objectForKey: name];

        if (! [initials containsObject:initialWords]) {
            initialWords = @"#";
        }

        NSMutableArray * filteredForInitial = _indexedObjects[initialWords];
        if (filteredForInitial) {
            [filteredForInitial addObject:obj];
        }
    }];
    return objects;
}
@end