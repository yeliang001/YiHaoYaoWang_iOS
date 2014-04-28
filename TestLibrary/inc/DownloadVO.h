//
//  DownloadVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DownloadVO : NSObject {
@private
	NSString * canUpdate;
	NSString * downloadUrl;
	NSString * forceUpdate;
	NSString * remark;
}
@property(retain,nonatomic)NSString * canUpdate;
@property(retain,nonatomic)NSString * downloadUrl;
@property(retain,nonatomic)NSString * forceUpdate;
@property(retain,nonatomic)NSString * remark;
@end
