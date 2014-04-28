//
//  StartupPicVO.m
//  TheStoreApp
//
//  Created by yuan jun on 13-4-16.
//
//

#import "StartupPicVO.h"

@implementation StartupPicVO
@synthesize picUrl;
//@synthesize startDate;
//@synthesize endDate;
-(void)dealloc{
    OTS_SAFE_RELEASE(picUrl);
//    OTS_SAFE_RELEASE(startDate);
//    OTS_SAFE_RELEASE(endDate);
    [super dealloc];
}
@end
