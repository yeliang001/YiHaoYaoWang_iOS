//
//  NSMutableArray+OTS.m
//  TheStoreApp
//
//  Created by towne on 12-11-21.
//
//

#import "NSMutableArray+Stack.h"


@implementation NSMutableArray (Stack)

- (void) push: (id)item {
    [self addObject:item];
}

- (id) pop {
    id item = nil;
    if ([self count] != 0) {
        item = [[[self lastObject] retain] autorelease];
        [self removeLastObject];
    }
    return item;
}

- (id) peek {
    id item = nil;
    if ([self count] != 0) {
        item = [[[self lastObject] retain] autorelease];
    }
    return item;
}

@end
