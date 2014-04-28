//
//  Page.h
//  ProtocolDemo
//
//  Created by vsc on 11-1-30.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>

/* ###########################  要实现文件缓存需将objList对应的实体类实现<NSCoding>协议 ###############################*/
@interface Page : NSObject <NSCoding>{
 @private
	NSNumber * currentPage;
	NSMutableArray * objList;
	NSNumber * pageSize;
	NSNumber * totalSize;
}
@property(retain,nonatomic)NSNumber         * currentPage;
@property(retain,nonatomic)NSMutableArray   * objList;
@property(retain,nonatomic)NSNumber         * pageSize;
@property(retain,nonatomic)NSNumber         * totalSize;

//首页中楼层广告数据，药店使用
@property (retain, nonatomic)NSMutableArray *adFloorList;


// extra
@property (retain) NSMutableDictionary      *userInfo;
@end

#define PAGE_USER_INFO_ORDER_TYPE   @"PAGE_USER_INFO_ORDER_TYPE"
