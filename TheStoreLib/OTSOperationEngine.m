//
//  OTSOperationEngine.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-8-20.
//
//

#import "OTSOperationEngine.h"


static int sCurrenMaxOperationID = 0;

@interface OTSOperationEngine ()
@end


@implementation OTSOperationEngine
@synthesize theQueue = _theQueue;

#pragma mark - theQueue
-(NSOperationQueue*)theQueue
{
    if (_theQueue == nil)
    {
        _theQueue = [[NSOperationQueue alloc] init];
        [_theQueue setMaxConcurrentOperationCount:4];
        [_theQueue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
    }
    
    return _theQueue;
}



#pragma mark - operation management
-(int)doOperationForSelector:(SEL)aSelector target:(id)aTarget object:(id)aObject caller:(id)aCaller
{
    if (aSelector && aTarget && [aTarget respondsToSelector:aSelector])
    {
        OTSInvocationOperation* operation = [[[OTSInvocationOperation alloc] initWithTarget:aTarget selector:aSelector object:aObject] autorelease];
        
        OTSInvocationOperationInfo* info = [[[OTSInvocationOperationInfo alloc] initWithCaller:aCaller] autorelease];

        operation.userInfo = [NSMutableDictionary dictionaryWithObject:info forKey:OTS_OPERATION_USER_INFO_KEY];
        
        int operationID = [self addOperation:operation];
        NSLog(@"request added, id:%d", operationID);
        return operationID;
    }
    
    return OTS_INVALID_OPERATION_ID;
}

-(int)addOperation:(OTSInvocationOperation*)aOperation
{
    int operationID = OTS_INVALID_OPERATION_ID;
    
    if (aOperation)
    {
        sCurrenMaxOperationID++;
        @try
        {
            aOperation.operationID = sCurrenMaxOperationID;
            [self.theQueue addOperation:aOperation];
            [self.theQueue setSuspended:NO];
            
            operationID = aOperation.operationID;
        }
        @catch (NSException *exception)
        {
            //DebugLog(@"add operation failed with exception:%@", exception);
            operationID = OTS_INVALID_OPERATION_ID;
        }
    }
    
    return operationID;
}

-(BOOL)cancelOperation:(int)aOperationID
{
    for (OTSInvocationOperation* operation in self.theQueue.operations)
    {
        OTSInvocationOperationInfo* info = [[operation.userInfo allValues] lastObject];
        if (info && info.operationID == aOperationID)
        {
            [operation cancel];
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - observe operations finished
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    if (object == self.theQueue && [keyPath isEqualToString:@"operations"])
    {
        if ([self.theQueue.operations count] == 0)
        {
            // queue has completed
            [self performSelectorOnMainThread:@selector(notifyCompleted:) withObject:self waitUntilDone:YES];
        }
    }
    //crash #1414
    /*else
    {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }*/
}

-(void)notifyCompleted:(id)anObject
{
    [[NSNotificationCenter defaultCenter] postNotificationName:OTS_NOTIFY_OPERATION_QUEUE_FINISHED object:anObject];
}

#pragma mark - memory
-(void)dealloc
{
    [_theQueue release];
    
    [super dealloc];
}


#pragma mark - singleton methods
static OTSOperationEngine *sharedInstance = nil;

+ (OTSOperationEngine *)sharedInstance
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
