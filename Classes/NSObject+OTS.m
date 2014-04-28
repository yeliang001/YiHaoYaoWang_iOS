//
//  NSObject+OTS.m
//  TheStoreApp
//
//  Created by yiming dong on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSObject+OTS.h"

#pragma mark - 延时执行方法1
void RunBlockAfterDelay(NSTimeInterval delay, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delay),
                   dispatch_get_current_queue(), block);
}

#pragma mark - 延时执行方法2
@implementation NSObject (OTS)

- (void)otsPerformBlock:(void (^)(void))block
             afterDelay:(NSTimeInterval)delay
{
    block = [[block copy] autorelease];
    [self performSelector:@selector(otsFireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

- (void)otsFireBlockAfterDelay:(void (^)(void))block {
    block();
}




// 线程函数
-(void)otsMemorySafeThreadFunction:(id)aTagetActionObj
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    [[aTagetActionObj retain] autorelease]; // maybe uneccesary, but for security
    
    id target = [((NSArray*)aTagetActionObj) objectAtIndex:0];
    
    NSString* selStr = [((NSArray*)aTagetActionObj) objectAtIndex:1];
    SEL selector = NSSelectorFromString(selStr);
    
    id argument = [((NSArray*)aTagetActionObj) objectAtIndex:2];
    
    BOOL isArgumentNil = [[((NSArray*)aTagetActionObj) objectAtIndex:3] boolValue];
    
    if ([target respondsToSelector:selector])
    {
        if (isArgumentNil)
        {
            // this case, nil is converted to NSNull Object to pass as param
            [target performSelector:selector withObject:nil];
        }
        else
        {
            [target performSelector:selector withObject:argument];
        }
    }
    
    [pool drain];
}


// 开新线程(内存安全)
-(void)otsDetatchMemorySafeNewThreadSelector:(SEL)aSelector toTarget:(id)aTarget withObject:(id)anArgument
{
    AlwaysLog(@"target class:%@", [[aTarget class] description]); // 在此检查target
    
    if (aTarget && aSelector && [aTarget respondsToSelector:aSelector])
    {
        [self performInThreadBlock:^(id obj){
            [aTarget performSelector:aSelector withObject:obj];
        } withObject:anArgument];
        
        return;

    }
}

- (NSException *)tryCatch:(void (^)())block
{
	NSException *result = nil;
	
	@try
    {
		block();
	}
	@catch (NSException *e)
    {
		result = e;
	}
	
	return result;
}

- (NSException *)tryCatch:(void (^)())block finally:(void(^)())aFinisheBlock
{
	NSException *result = nil;
	
	@try
    {
		block();
	}
	@catch (NSException *e)
    {
		result = e;
	}
    @finally
    {
        aFinisheBlock();
    }
	
	return result;
}

-(void)performInMainBlock:(void(^)())aInMainBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        aInMainBlock();
        
    });
}

-(void)performInThreadBlock:(void(^)())aInThreadBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        aInThreadBlock();
        
    });
}

-(void)performInThreadBlock:(void(^)(id obj))aInThreadBlock withObject:(id)anObject
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        aInThreadBlock(anObject);
        
    });
}


-(void)performInThreadBlock:(void(^)())aInThreadBlock completionInMainBlock:(void(^)())aCompletionInMainBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        aInThreadBlock();
        
        [[NSRunLoop mainRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];//the next time through the run loop.
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            aCompletionInMainBlock();
            
        });
    });
}

- (void)performBlock:(void (^)(void))completionInMainBlock
          afterDelay:(NSTimeInterval)delay
{
    completionInMainBlock = [[completionInMainBlock copy] autorelease];
    [self performSelector:@selector(FireBlockAfterDelay:)
               withObject:completionInMainBlock
               afterDelay:delay];
}

- (void)FireBlockAfterDelay:(void (^)(void))completionInMainBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        completionInMainBlock();
    });
    
}
@end
