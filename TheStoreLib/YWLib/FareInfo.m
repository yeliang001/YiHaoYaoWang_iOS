//
//  FareInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-9-13.
//
//

#import "FareInfo.h"

@implementation FareInfo


- (void)dealloc
{
    [_totalReturnMoney release];
    [_totalMoney release];
    [_totalCount release];
    [_goodsId release];
    [super dealloc];
}
@end
