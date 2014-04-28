//
//  InvoiceVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InvoiceVO : NSObject {
@private
	NSNumber * amount;//发票金额
	NSString * content;//发票内容
	NSNumber * nid;//发票Id
	NSNumber * mcsiteid;//网站Id (1:1号店;2:药网)
	NSString * title;//发票抬头
}
@property(retain,nonatomic)NSNumber * amount;//发票金额
@property(retain,nonatomic)NSString * content;//发票内容
@property(retain,nonatomic)NSNumber * nid;//发票Id
@property(retain,nonatomic)NSNumber * mcsiteid;//网站Id (1:1号店;2:药网)
@property(retain,nonatomic)NSString * title;//发票抬头
@end
