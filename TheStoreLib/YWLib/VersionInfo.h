//
//  VersionInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-9-30.
//
//

#import <Foundation/Foundation.h>

@interface VersionInfo : NSObject

@property (assign, nonatomic) NSInteger miniVersion;
@property (assign, nonatomic) NSInteger version;
@property (copy, nonatomic) NSString *versionStr;
@property (copy, nonatomic) NSString *updateUrl;
@property (copy, nonatomic) NSString *versionDesc;

- (BOOL)needUpdate;
- (BOOL)mustUpdate;

@end
