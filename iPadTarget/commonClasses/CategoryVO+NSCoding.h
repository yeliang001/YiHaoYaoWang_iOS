//
//  CategoryVO+NSCoding.h
//  yhd
//
//  Created by  on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CategoryVO.h"

@interface CategoryVO (NSCoding)
- (void) encodeWithCoder:(NSCoder *)encoder ;
- (id)initWithCoder:(NSCoder *)decoder ; 
- (id) copyWithZone: (NSZone*)zone;
@end
