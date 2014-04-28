//
//  ProductDescVO.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-8-15.
//
//

#import "ProductDescVO.h"

@implementation ProductDescVO
@synthesize tabDetail = _tabDetail
, serialVersionUID = _serialVersionUID
, tabName = _tabName
, tabType = _tabType;

-(void)dealloc
{
    [_tabDetail release];
    [_serialVersionUID release];
    [_tabName release];
    [_tabType release];
    
    [super dealloc];
}

@end
