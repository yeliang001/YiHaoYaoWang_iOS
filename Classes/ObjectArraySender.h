//
//  ObjectArraySender.h
//  TheStoreApp
//
//  Created by linyy on 11-2-2.
//  Copyright 2011 vsc. All rights reserved.
//	对应object-array标签

#import <Foundation/Foundation.h>

@class Trader;
@class GoodReceiverVO;
@interface ObjectArraySender : NSObject {
    @private Trader * trader;//一个Trader实体
    @private NSMutableArray * methodBodyArray;//一个所有内容为SenderMethodBody结构体的集合
}

@property(retain,nonatomic)Trader * trader;
@property(retain,nonatomic)NSMutableArray * methodBodyArray;

-(id)initWithObjectArraySender:(ObjectArraySender *)anotherSender;

@end