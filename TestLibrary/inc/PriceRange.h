//
//  PriceRange.h
//  TheStoreApp
//
//  Created by jiming huang on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceRange : NSObject {
@private
    NSNumber *start;
    NSNumber *end;
}

@property(retain,nonatomic) NSNumber *start;
@property(retain,nonatomic) NSNumber *end;
@end
