//
//  VerifyCodeVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VerifyCodeVO : NSObject {
@private
	NSString * codeUrl;
	NSString * tempToken;
}
@property(retain,nonatomic)NSString * codeUrl;
@property(retain,nonatomic)NSString * tempToken;
@end
