//
//  OTSOnlinePayNotifyCanceller.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-8-31.
//
//

#import "OTSOnlinePayNotifyCanceller.h"
#import "OTSOnlinePayNotifier.h"

@implementation OTSOrderCancelInfo
@synthesize orderID = _orderID, cancelDate = _cancelDate;
-(void)dealloc
{
    [_cancelDate release];
    [super dealloc];
}
@end


////////////////////////////////////////////////////////////
static BOOL isAddOK = NO;

@interface OTSOnlinePayNotifyCanceller ()
@property(nonatomic, retain)NSMutableArray  *timers;
@end

@implementation OTSOnlinePayNotifyCanceller
@synthesize orderCancelInfos = _orderCancelInfos, timers = _timers;
-(id)init
{
    if (self = [super init])
    {
        _orderCancelInfos = [[NSMutableArray alloc] initWithCapacity:10];
        _timers = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    return self;
}

-(void)dealloc
{
    [self reset];
    [_timers release];
    [_orderCancelInfos release];
    
    [super dealloc];
}

-(NSTimer*)timerForOrderID:(long long int)aOrderID
{
    NSTimer* theTimer = nil;
    for (NSTimer *timer in self.timers)
    {
        OTSOrderCancelInfo *info = timer.userInfo;
        if (info && info.orderID == aOrderID)
        {
            theTimer = timer;
            break;
        }
    }
    
    return theTimer;
}

-(void)handleTimerFired:(NSTimer*)theTimer
{
    NSLog(@"whoops, holy shit, it works...");
    OTSOrderCancelInfo* info = theTimer.userInfo;
    if (info)
    {
        [[OTSOnlinePayNotifier sharedInstance] removeNotificationWithOrderID:info.orderID];
    }
    
}

-(BOOL)addCancelTimerWithInfo:(OTSOrderCancelInfo*)aInfo
{
    [self performSelectorOnMainThread:@selector(doAddCancelTimerWithInfo:) withObject:aInfo waitUntilDone:YES];
    return isAddOK;
}

-(BOOL)doAddCancelTimerWithInfo:(OTSOrderCancelInfo*)aInfo
{
    NSAssert(aInfo && aInfo.cancelDate, @"<addCancelTimerWithInfo> param error");
    
    isAddOK = NO;
    if ([self timerForOrderID:aInfo.orderID])
    {
        return isAddOK; // already has timer for the order
    }
    
    NSDate *now = [NSDate date];
    
    NSLog(@"now:%@, cancelDate:%@", now, aInfo.cancelDate);
    if ([now compare:aInfo.cancelDate] != NSOrderedDescending)
    {
        NSLog(@"timer need to be created!");
        NSTimer *timer = [[NSTimer alloc] initWithFireDate:aInfo.cancelDate interval:0 target:self selector:@selector(handleTimerFired:) userInfo:aInfo repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        //NSTimer *timer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(handleTimerFired:) userInfo:aInfo repeats:NO];

        
        //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(handleTimerFired:) userInfo:aInfo repeats:NO];
        
       // NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(handleTimerFired:) userInfo:nil repeats:NO];
        
        [self.timers addObject:timer];
        [timer release];
        isAddOK = YES;
    }
    
    return isAddOK;
}

-(void)scheduleCancelingForOrderWithID:(long long int)aOrderID atDate:(NSDate*)aCancelDate
{
    NSAssert(aOrderID > 0 && aCancelDate, @"<scheduleCancelingForOrderWithID> invalid param");
    
    OTSOrderCancelInfo* cancelInfo = [[[OTSOrderCancelInfo alloc] init] autorelease];
    cancelInfo.orderID = aOrderID;
    cancelInfo.cancelDate = aCancelDate;
    
    if ([self addCancelTimerWithInfo:cancelInfo])
    {
        [self.orderCancelInfos addObject:cancelInfo];
    }
}



-(void)stopCancelingForOrderWithID:(long long int)aOrderID
{
    NSTimer* theTimer = [self timerForOrderID:aOrderID];
    
    if (theTimer)
    {
        id info = [theTimer userInfo];
        //NSLog(@"timer retain:%d", [theTimer.userInfo retainCount]);
        [theTimer invalidate];
        //NSLog(@"timer retain:%d", [theTimer.userInfo retainCount]);
        [self.orderCancelInfos removeObject:info];
        //NSLog(@"timer retain:%d", [theTimer.userInfo retainCount]);
        [self.timers removeObject:theTimer];
    }
}

-(void)stopAll
{
    for (NSTimer *timer in self.timers)
    {
        [timer invalidate];
    }
    
    [self.timers removeAllObjects];
}

-(void)startAll
{
    [self stopAll];
    
    NSLog(@"start all ~~~~");
    for (OTSOrderCancelInfo * info in self.orderCancelInfos)
    {
        [self addCancelTimerWithInfo:info];
    }
}

-(void)reset
{
    [self stopAll];
    [self.orderCancelInfos removeAllObjects];
    [self.timers removeAllObjects];
}

#pragma mark - singleton methods
static OTSOnlinePayNotifyCanceller *sharedInstance = nil;

+ (OTSOnlinePayNotifyCanceller *)sharedInstance
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
