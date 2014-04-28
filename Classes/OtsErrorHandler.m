//
//  OtsErrorHandler.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-9-6.
//
//

#import "OtsErrorHandler.h"

@implementation OtsErrorHandler

-(void)alert:(NSString*)aMessage
{
    [self performSelectorOnMainThread:@selector(doAlert:) withObject:aMessage waitUntilDone:YES];
}

-(void)doAlert:(NSString*)aMessage
{
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:nil message:aMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [[av autorelease] show];
}

-(void)alertNilObject
{
    [self alert:@"网络数据异常，请稍候再试"];
}

-(void)alertLandingPageCanOnlyBuyOne
{
    [self alert:@"该活动只能购买1类商品"];
}

#pragma mark - singleton methods
static OtsErrorHandler *sharedInstance = nil;

+ (OtsErrorHandler *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
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
