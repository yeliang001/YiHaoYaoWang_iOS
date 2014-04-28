//
//  OTSDataChecker.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-9-25.
//
//

#import "OTSDataChecker.h"
#import "ProductVO.h"
#import "OTSServiceHelper.h"
#import "GlobalValue.h"

@interface OTSDataChecker ()
@property(retain)NSMutableArray *errors;
-(void)handleError:(NSString*)anErrorDescription;
@end

@implementation OTSDataChecker
@synthesize errors = _errors;

-(BOOL)checkProductVO:(ProductVO*)aProductVO methodName:(NSString*)aMethodName
{
    NSAssert(aProductVO, @"product vo is nil");
    
    if ([aProductVO.price floatValue] <= 0
        || (aProductVO.promotionPrice && [aProductVO.promotionPrice floatValue] <= 0 && ![aProductVO isInPromotion]))
    {
        NSString* errorStr = [NSString stringWithFormat:@"product price error {id:%@, price:%@, promotionPrice:%@, promotionId:%@}", aProductVO.productId
                              , aProductVO.price
                              , aProductVO.promotionPrice
                              , aProductVO.promotionId];
        
        NSDictionary *errorDic = [NSDictionary dictionaryWithObjectsAndKeys:errorStr, @"errorInfo" ,aMethodName ,@"methodName", nil];
        [self.errors addObject:errorDic];
        
        return NO;
    }
    
    return YES;
}

-(void)handleErrorsWithBlock:(void(^)(NSString* aErrorInfo ,NSString* aMethodName))aBlock
{
    NSMutableArray *theArray=[NSMutableArray arrayWithArray:self.errors];
    for (NSDictionary *dic in theArray)
    {
        aBlock([dic objectForKey:@"errorInfo"], [dic objectForKey:@"methodName"]);
    }
    
    [self.errors removeAllObjects];
}

-(void)handleError:(NSString*)anErrorDescription
{
    DebugLog(@"{{Data Check Error}}\n%@", anErrorDescription);
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [[OTSServiceHelper sharedInstance] addFeedback:[GlobalValue getGlobalValueInstance].token feedbackcontext:anErrorDescription];
//    });
}

#pragma mark - singleton methods
static OTSDataChecker *sharedInstance = nil;

+ (OTSDataChecker *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
            sharedInstance->_errors = [[NSMutableArray alloc] initWithCapacity:10];
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
