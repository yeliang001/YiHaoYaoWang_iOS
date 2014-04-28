//
//  OTSMfImageCache.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSMfImageCache.h"

@implementation OTSMfImageCache

+(void)addImage:(UIImage*)aImage forKey:(id)aKey
{
    if (aImage && aKey)
    {
        [[self sharedInstance]->imageCache setObject:aImage forKey:aKey];
    }
}

+(UIImage*)imageForKey:(id)aKey
{
    if (aKey)
    {
        return [[self sharedInstance]->imageCache objectForKey:aKey];
    }
    
    return nil;
}

+(void)cleanUp
{
    [[self sharedInstance]->imageCache removeAllObjects];
}

#define STANDARD_BODY_WEIGHT    50
+(void)tryLooseWeight
{
    NSMutableDictionary* imgCache = [self sharedInstance]->imageCache;
    if ([imgCache count] > STANDARD_BODY_WEIGHT)
    {
        NSArray* keys = [imgCache allKeys];
        int count = [keys count];
        
        // reduce cache to half of its size
        for (int i = 0; i < count / 2; i++)
        {
            id key = [keys objectAtIndex:i];
            [imgCache removeObjectForKey:key];
        }
    }
}

#pragma mark - singleton methods
static OTSMfImageCache *sharedInstance = nil;

+ (OTSMfImageCache *)sharedInstance
{ 
    @synchronized(self) 
    { 
        if (sharedInstance == nil) 
        { 
            sharedInstance = [[self alloc] init]; 
            sharedInstance->imageCache = [[NSMutableDictionary alloc] initWithCapacity:10];
        } 
    } 
    
    return sharedInstance; 
} 

+ (id)allocWithZone:(NSZone *)zone 
{ 
    @synchronized(self) 
    { 
        if (sharedInstance == nil) 
        { 
            sharedInstance = [super allocWithZone:zone]; 
            return sharedInstance; 
        } 
    } 
    
    return nil; 
} 

- (id)copyWithZone:(NSZone *)zone 
{ 
    return self; 
} 

- (id)retain 
{ 
    return self; 
} 

- (NSUInteger)retainCount 
{ 
    return NSUIntegerMax; 
} 

- (oneway void)release
{ 
} 

- (id)autorelease 
{ 
    return self; 
}
@end
