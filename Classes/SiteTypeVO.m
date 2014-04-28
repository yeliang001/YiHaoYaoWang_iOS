//
//  SiteTypeVO.m
//  TheStoreApp
//
//  Created by xuexiang on 12-11-30.
//
//

#import "SiteTypeVO.h"

@implementation SiteTypeVO
@synthesize nid;
@synthesize name;
@synthesize serialVersionUID;;
-(void)dealloc{
    if (nid != nil) {
        [nid release];
    }
    if (name != nil) {
        [name release];
    }
    if (serialVersionUID != nil) {
        [serialVersionUID release];
    }
    [super dealloc];
}
@end
