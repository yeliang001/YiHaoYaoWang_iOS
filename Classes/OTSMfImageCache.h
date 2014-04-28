//
//  OTSMfImageCache.h
//  TheStoreApp
//
//  Created by yiming dong on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTSMfImageCache : NSObject
{
    NSMutableDictionary* imageCache;
}

+ (OTSMfImageCache *)sharedInstance;

+(void)addImage:(UIImage*)aImage forKey:(id)aKey;
+(UIImage*)imageForKey:(id)aKey;
+(void)cleanUp;
+(void)tryLooseWeight;
@end
