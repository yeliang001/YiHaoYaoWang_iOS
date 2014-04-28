//
//  OTSClassInvoker.m
//  TheStoreApp
//
//  Created by yiming dong on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSClassInvoker.h"

@implementation OTSClassInvoker
@synthesize invokeClasses;

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL aSelector = [invocation selector];

    if (theRespondClass)
    {
        id service = [[[theRespondClass alloc] init] autorelease];
        if ([service respondsToSelector:aSelector])
        {
            [invocation invokeWithTarget:service];
        }
    }
    else
    {
        [self doesNotRecognizeSelector:aSelector];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector 
{
    for (Class cls in invokeClasses)
    {
        NSMethodSignature *sig = [cls instanceMethodSignatureForSelector:aSelector];
        if (sig)
        {
            theRespondClass = cls;
            return sig;
        }
    }
    
    theRespondClass = NULL;
    return nil;
}

@end
