//
//  FavoriteResultInf.m
//  TheStoreApp
//
//  Created by LinPan on 13-8-17.
//
//

#import "FavoriteResultInfo.h"

@implementation FavoriteResultInfo

- (void)dealloc
{
    [_favoriteList release];
    [_responseDesc release];
    [super dealloc];
}

@end
