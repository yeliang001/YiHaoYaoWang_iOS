//
//  GrouponSerialVO.h
//  TheStoreApp
//
//  Created by jiming huang on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrouponSerialVO : NSObject <NSCoding> {
@private NSNumber *nid;//团购系列产品id
@private NSNumber *grouponId;//团购id
@private NSNumber *mainProductId;//主系列产品id
@private NSNumber *subProductId;//子系列产品id
@private NSString *productColor;//产品颜色
@private NSString *productSize;//产品尺寸
@private NSNumber *upperSaleNum;//最高购买数
@private NSNumber *boughtNum;//已经出售数
}

@property(nonatomic,retain) NSNumber *nid;
@property(nonatomic,retain) NSNumber *grouponId;
@property(nonatomic,retain) NSNumber *mainProductId;
@property(nonatomic,retain) NSNumber *subProductId;
@property(nonatomic,retain) NSString *productColor;
@property(nonatomic,retain) NSString *productSize;
@property(nonatomic,retain) NSNumber *upperSaleNum;
@property(nonatomic,retain) NSNumber *boughtNum;

-(NSMutableDictionary *)dictionaryFromVO;
+(id)voFromDictionary:(NSMutableDictionary *)mDictionary;
@end
