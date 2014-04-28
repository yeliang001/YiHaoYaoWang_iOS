//
//  OTSInvocationOperation.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-8-20.
//
//

#import "OTSInvocationOperation.h"

@interface OTSInvocationOperation ()
@property(assign)   id      target;
@property(assign)   SEL     selector;
@property(retain)   id      object;
@end



@implementation OTSInvocationOperation
@synthesize userInfo = _userInfo, target = _target, selector = _selector, object = _object;
@dynamic operationID, caller;

#pragma mark - operationID
-(int)operationID
{
    if (_userInfo)
    {
        OTSInvocationOperationInfo* info = [[_userInfo allValues] lastObject];
        if (info)
        {
            return info.operationID;
        }
    }
    
    return OTS_INVALID_OPERATION_ID;
}

-(void)setOperationID:(int)operationID
{
    if (_userInfo)
    {
        OTSInvocationOperationInfo* info = [[_userInfo allValues] lastObject];
        if (info)
        {
            info.operationID = operationID;
        }
    }
}

#pragma mark - caller
-(id)caller
{
    if (_userInfo)
    {
        OTSInvocationOperationInfo* info = [[_userInfo allValues] lastObject];
        if (info)
        {
            return info.caller;
        }
    }
    
    return nil;
}

-(void)setCaller:(id)caller
{
    if (_userInfo)
    {
        OTSInvocationOperationInfo* info = [[_userInfo allValues] lastObject];
        if (info)
        {
            info.caller = caller;
        }
    }
}

-(id)result
{
    return [_userInfo objectForKey:OTS_OPERATION_RESULT_KEY];
}

#pragma mark - memory

-(void)dealloc
{
    [_userInfo release];
    [_object release];
    
    [super dealloc];
}

#pragma mark - discription
-(NSString*)description
{
    id result = [self result];
    return [NSString stringWithFormat:@"id:%d, caller:%@, returned:{%@}", self.operationID, self.caller, result];
}


#pragma mark - get return object
-(id)objectWithReturnValue:(void*)aValue target:(id)aTarget selector:(SEL)aSelector
{
    id returnedObject = nil;
    
    if (aTarget && aSelector && [aTarget respondsToSelector:aSelector])
    {
        NSMethodSignature *sig = [[aTarget class] instanceMethodSignatureForSelector:aSelector];
        const char *returnType = sig.methodReturnType;
        
        if( !strcmp(returnType, @encode(void)) )
        {
            returnedObject =  nil;
        }
        else if( !strcmp(returnType, @encode(id)) )
        {
            returnedObject = aValue;
        }
        else
        {
            if( !strcmp(returnType, @encode(BOOL)) )
            {
                returnedObject = [NSNumber numberWithBool:(BOOL)aValue];
            }
            else if( !strcmp(returnType, @encode(NSInteger)) )
            {
                returnedObject = [NSNumber numberWithInteger:(NSInteger)aValue];
            }
            else
            {
                returnedObject = nil; // NOTICE: currently not surpport other type....dym
            }
        }
    }
    
    return returnedObject;
}

//-(id)objectForAction:(SEL)anAction target:(id)aTarget object:(id)anObject
//{
//    if (anAction == nil || aTarget == nil || ![aTarget respondsToSelector:anAction])
//    {
//        return nil;
//    }
//    
//    NSMethodSignature *sig = [[aTarget class] instanceMethodSignatureForSelector:anAction];
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
//    [invocation setTarget:aTarget];
//    [invocation setSelector:anAction];
//    
//    NSUInteger argCount = [sig numberOfArguments];
//    if (argCount > 2)
//    {
//        [invocation setArgument:anObject atIndex:2];
//    }
//    
//    
//    [invocation retainArguments];
//    [invocation invoke];
//    
//    const char *returnType = sig.methodReturnType;
//    id returnValue = nil;
//    
//    if( !strcmp(returnType, @encode(void)))
//    {
//        returnValue =  nil;
//    }
//    else if( !strcmp(returnType, @encode(id)))
//    {
//        [invocation getReturnValue:&returnValue];
//    }
//    else
//    {
//        NSUInteger length = [sig methodReturnLength];
//        
//        void *buffer = (void *)malloc(length);
//        
//        [invocation getReturnValue:buffer];
//        
//        if( !strcmp(returnType, @encode(BOOL)))
//        {
//            returnValue = [NSNumber numberWithBool:*((BOOL*)buffer)];
//        }
//        else if( !strcmp(returnType, @encode(NSInteger)))
//        {
//            returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
//        }
//        returnValue = [NSValue valueWithBytes:buffer objCType:returnType];
//    }
//    
//    return returnValue;
//}

#pragma mark - main
-(void)main
{
    [super main];
    
    if (_target && [_target respondsToSelector:_selector])
    {
        id result = [_target performSelector:_selector withObject:_object];
        result = [self objectWithReturnValue:result target:_target selector:_selector];
        
        if (result)
        {
            [_userInfo setObject:result forKey:OTS_OPERATION_RESULT_KEY];
        }
    }
    
    [self performSelectorOnMainThread:@selector(notifyFinished:) withObject:self waitUntilDone:YES];
}

-(void)notifyFinished:(id)anObject
{
    [[NSNotificationCenter defaultCenter] postNotificationName:OTS_NOTIFY_OPERATION_FINISHED object:anObject];
}

- (id)initWithTarget:(id)target selector:(SEL)sel object:(id)arg
{
    self = [super init];
    if (self)
    {
        _target = target;
        _selector = sel;
        _object = [arg retain];
    }
    
    return self;
}

@end


#pragma mark - OTSInvocationOperationInfo
@implementation OTSInvocationOperationInfo
@synthesize operationID = _operationID, caller = _caller;

-(id)initWithCaller:(id)aCaller
{
    self = [super init];
    if (self)
    {
        _caller = aCaller;  // not owned
    }
    
    return self;
}
@end
