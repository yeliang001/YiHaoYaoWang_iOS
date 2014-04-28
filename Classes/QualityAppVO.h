//
//  QualityAppVO.h
//  TheStoreApp
//
//  Created by xuexiang on 12-7-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QualityAppVO : NSObject {
	NSString *appName;//应用名称
	NSString *appLinkUrl;//应用链接
	NSString *appExplain;//应用说明
	NSString *appIconUrl;//应用IconUrl
}
@property(nonatomic, retain)NSString *appName;
@property(nonatomic, retain)NSString *appLinkUrl;
@property(nonatomic, retain)NSString *appExplain;
@property(nonatomic, retain)NSString *appIconUrl;
@end
