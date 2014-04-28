//
//  FacetValue.h
//  TheStoreApp
//
//  Created by jiming huang on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacetValue : NSObject {
@private
    NSNumber *nid;
    NSString *name;
    NSNumber *num;
}

@property(retain,nonatomic) NSNumber *nid;
@property(retain,nonatomic) NSString *name;
@property(retain,nonatomic) NSNumber *num;
@end
