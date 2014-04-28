//
//  OrderV2.m
//  TheStoreApp
//
//  Created by yangxd on 11-6-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OrderV2.h"
#import <objc/runtime.h>

@implementation OrderV2

@synthesize gateway;

-(void)dealloc{
	if(gateway!=nil){
		[gateway release];
	}
	[super dealloc];
}


-(id)initWithOrderVO:(OrderVO*)anOrderVO
{
    self = [super init];
    if (self && anOrderVO)
    {
        int i;
        unsigned int propertyCount = 0;
        objc_property_t *propertyList = class_copyPropertyList([anOrderVO class], &propertyCount);
        
        for ( i = 0; i < propertyCount; i++ )
        {
            objc_property_t *thisProperty = propertyList + i;
            const char* propertyName = property_getName(*thisProperty);
            DebugLog(@"Person has a property: '%s'", propertyName);
            
            NSString *propertyStr = [[NSString alloc] initWithCString:propertyName encoding:NSUTF8StringEncoding];
            if (propertyStr)
            {
                id value = [anOrderVO valueForKey:propertyStr];
                if (value)
                {
                    [self setValue:value forKey:propertyStr];
                }
            }
            [propertyStr release];
        }
        
    }
    
    return self;
}

@end
