//
//  SenderMethodBody.h
//  TheStoreApp
//
//  Created by linyy on 11-2-9.
//  Copyright 2011 vsc. All rights reserved.
//	对应Trader实体后传的参数的一个结构体，为一个类型、值对应结构的结构体

#import <Foundation/Foundation.h>


@interface SenderMethodBody : NSObject {
	NSString * methodType;//属性的类型(string或int或long或list)
	NSMutableArray * methodValue;//属性的值，如果methodType为list，则集合里再传一个SenderMethodBody结构体，否则传一个NSString * 或者 NSNumber
}
@property(retain,nonatomic)NSString * methodType;
@property(retain,nonatomic)NSMutableArray * methodValue;
- (id)init;
@end
