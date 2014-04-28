//
//  AwardsResult.m
//  TheStoreApp
//
//  Created by xuexiang on 13-4-22.
//
//

#import "AwardsResult.h"

@implementation AwardsResult
@synthesize resultCode;
-(void)dealloc{
    [resultCode release];
    [super dealloc];
}
@end
