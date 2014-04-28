//
//  UpdateStroageBoxResult.m
//  TheStoreApp
//
//  Created by xuexiang on 13-5-15.
//
//

#import "UpdateStroageBoxResult.h"

@implementation UpdateStroageBoxResult
@synthesize errorCode;
@synthesize errorInfo;
-(void)dealloc{
    OTS_SAFE_RELEASE(errorCode);
    OTS_SAFE_RELEASE(errorInfo);
    [super dealloc];
}
@end
