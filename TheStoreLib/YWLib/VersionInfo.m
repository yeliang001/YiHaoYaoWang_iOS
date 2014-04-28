//
//  VersionInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-9-30.
//
//

#import "VersionInfo.h"

@implementation VersionInfo

- (void)dealloc
{
    [_versionStr release];
    [_versionDesc release];
    [_updateUrl release];
    [super dealloc];
}

- (BOOL)needUpdate
{
    NSString *interVersionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"InterVersionNum"];
    NSInteger interVersionNum = [interVersionStr intValue];
    if (_version > interVersionNum && interVersionNum >= _miniVersion)
    {
        return YES;
    }
    return NO;
}

- (BOOL)mustUpdate
{

    NSString *interVersionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"InterVersionNum"];
    NSInteger interVersionNum = [interVersionStr intValue];
    if (_version > interVersionNum && interVersionNum < _miniVersion)
    {
        return YES;
    }
    return NO;
}

@end
