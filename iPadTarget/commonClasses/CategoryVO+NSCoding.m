//
//  CategoryVO+NSCoding.m
//  yhd
//
//  Created by  on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CategoryVO+NSCoding.h"

@implementation CategoryVO (NSCoding)
- (void) encodeWithCoder:(NSCoder *)encoder {  
    [encoder encodeObject:nid forKey:@"nid"]; 
    [encoder encodeObject:categoryName forKey:@"categoryName"];
} 

- (id)initWithCoder:(NSCoder *)decoder {   
    
    self = [super init];  
    if (self){  
        NSNumber *anid = [decoder decodeObjectForKey:@"nid"];  
        self.nid=anid;  
        
        NSString *acategoryName =   [decoder decodeObjectForKey:@"categoryName"];  
        self.categoryName=acategoryName;  
        
          
    }  
    return self;  
    
}
- (id) copyWithZone: (NSZone*)zone{  
    //return self;//浅拷贝  
    CategoryVO *cate = [[[self class] allocWithZone:zone] init];    
    [cate setNid:nid];  
    [cate setCategoryName:categoryName];  
      
    return cate;   
} 
@end
