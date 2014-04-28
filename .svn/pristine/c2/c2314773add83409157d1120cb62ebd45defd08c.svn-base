//
//  SeriesColorVO.m
//  TheStoreApp
//
//  Created by xuexiang on 12-12-31.
//
//

#import "SeriesColorVO.h"

@implementation SeriesColorVO
@synthesize color;
@synthesize picUrl;

-(void)dealloc{
    OTS_SAFE_RELEASE(color);
    OTS_SAFE_RELEASE(picUrl);
    [super dealloc];
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:color forKey:@"color"];
    [aCoder encodeObject:picUrl forKey:@"picUrl"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self.color = [aDecoder decodeObjectForKey:@"color"];
    self.picUrl = [aDecoder decodeObjectForKey:@"picUrl"];
    return self;
}
@end
