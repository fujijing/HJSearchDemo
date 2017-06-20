//
// Created by 罗宋汤 on 14-1-18.
// Copyright (c) 2014 chanjet. All rights reserved.
//


#import "CSPPackage.h"
#import "NSObject+CSPProperty.h"
#import "NSArray+CSPExtension.h"

#pragma mark -

CSPPackage * csp = nil;

#pragma mark -

@implementation NSObject(AutoLoading)

+ (BOOL)autoLoad
{
    return YES;
}

@end

#pragma mark -

@interface CSPPackage()
{
    NSMutableArray * _loadedPackages;
}

AS_SINGLETON( CSPPackage )

@end

@implementation CSPPackage

DEF_SINGLETON( CSPPackage )

+ (void)load
{
//    [CSPPackage sharedInstance];
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        _loadedPackages = [NSMutableArray nonRetainingArray];
        
        csp = self;
        
        [self loadClasses];
    }
    
    return self;
}

- (void)dealloc
{
    [_loadedPackages removeAllObjects];
}

- (void)loadClasses
{
    const char * autoLoadClasses[] = {
            "CSPLogger",
            "CSPLocalization",
            "CSPService",
            "CSPModel",
            "CSPController",
            NULL
    };

    NSUInteger total = 0;

    for ( NSInteger i = 0;; ++i )
    {
        const char * className = autoLoadClasses[i];
        if ( NULL == className )
            break;

        Class classType = NSClassFromString( [NSString stringWithUTF8String:className] );
        if ( classType )
        {
            BOOL succeed = [classType autoLoad];
            if ( succeed )
            {
                [_loadedPackages addObject:classType];
            }
        }

        total += 1;
    }
}

@end