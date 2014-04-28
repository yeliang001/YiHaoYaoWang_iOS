//
//  SeriesProductVO.m
//  TheStoreApp
//
//  Created by xuexiang on 12-11-30.
//
//

#import "SeriesProductVO.h"

@implementation SeriesProductVO

@synthesize serialVersionUID;
@synthesize nid;
@synthesize mainProductID;
@synthesize subProductID;
@synthesize productVO;
@synthesize productColor;
@synthesize productSize;


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:serialVersionUID forKey:@"serialVersionUID"];
    [aCoder encodeObject:nid forKey:@"nid"];
    [aCoder encodeObject:mainProductID forKey:@"mainProductID"];
    [aCoder encodeObject:subProductID forKey:@"subProductID"];
    [aCoder encodeObject:productVO forKey:@"productVO"];
    [aCoder encodeObject:productColor forKey:@"productColor"];
    [aCoder encodeObject:productSize forKey:@"productSize"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self.serialVersionUID = [aDecoder decodeObjectForKey:@"serialVersionUID"];
    self.nid = [aDecoder decodeObjectForKey:@"nid"];
    self.mainProductID = [aDecoder decodeObjectForKey:@"mainProductID"];
    self.subProductID = [aDecoder decodeObjectForKey:@"subProductID"];
    self.productVO = [aDecoder decodeObjectForKey:@"productVO"];
    self.productColor = [aDecoder decodeObjectForKey:@"productColor"];
    self.productSize = [aDecoder decodeObjectForKey:@"productSize"];
    return self;
}
-(void)dealloc{
    if (serialVersionUID != nil) {
        [serialVersionUID release];
    }
    if (nid != nil) {
        [nid release];
    }
    if (mainProductID != nil) {
        [mainProductID release];
    }
    if (subProductID != nil) {
        [subProductID release];
    }
    if (productVO != nil) {
        [productVO release];
    }
    if (productColor != nil) {
        [productColor release];
    }
    if (productSize != nil) {
        [productSize release];
    }
    [super dealloc];
}
@end
