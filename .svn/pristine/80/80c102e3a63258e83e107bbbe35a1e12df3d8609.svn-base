//
//  OTSPhoneRuntimeData.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-8.
//
//

#import "OTSPhoneRuntimeData.h"
#import "OTSWrBoxPageGetter.h"

@implementation OTSPhoneRuntimeData
@synthesize boxPager = _boxPager;


#pragma mark - singleton methods
static OTSPhoneRuntimeData *sharedInstance = nil;

+ (OTSPhoneRuntimeData *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
            sharedInstance.boxPager = [[[OTSWrBoxPageGetter alloc] init] autorelease];
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
