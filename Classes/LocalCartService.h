//
//  LocalCart.h
//  TheStoreApp
//
//  Created by linyy on 11-7-6.
//  Copyright 2011年 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sqlite3Handle.h"
@class LocalCartItemVO;

@interface LocalCartService : NSObject {
    
@private NSMutableArray * localCartArray;

}

-(NSData *)generateASingleTipWithLocalCartItemVO:(LocalCartItemVO *)aLocalTipVO;					// 创建本地购物车
-(void)appendToExistsFileWithFilePath:(NSString *)aFilePath item:(LocalCartItemVO *)aLocalTipVO;	// 添加一条商品信息
-(int)getLocalCartNumberWithFilePath:(NSString *)aFilePath;											// 获取本地所有商品总数
-(float)getLocalCartTotalPriceWithFilePath:(NSString *)aFilePath;									// 获取本地所有商品总价
-(void)cleanLocalCartWithFilePath:(NSString *)aFilePath;											// 清空本地购物车
-(void)deleteLocalCartWithFilePath:(NSString *)aFilePath item:(LocalCartItemVO *)aLocalTipVO;		// 删除一条商品信息
-(void)deleteLocalCartWithFilePath:(NSString *)aFilePath productId:(NSNumber *)productId;
-(void)updateLocalCartWithFilePath:(NSString *)aFilePath item:(LocalCartItemVO *)aLocalTipVO;		// 更新一条商品信息
-(NSMutableArray *)getLocalCartArrayWithFilePath:(NSString *)aFilePath;								// 获取本地购物车信息
-(void)cleanLocalCartArray;		// 清空本地商品数组
-(NSMutableArray *)getLocalCartProductIdsWithFilePath:(NSString *)aFilePath;
-(NSMutableArray *)getLocalCartMerchantIdsWithFilePath:(NSString *)aFilePath;
-(void)changeLocalCartWithFilePath:(NSString *)aFilePath productVOList:(NSArray *)productVOList;

//新增 本地购物车商品 <－> 内存数据库 SQLITE3 API
- (BOOL)saveLocalCartToSqlite3:(LocalCartItemVO *)aLocalTipVO;                      //添加一条商品
- (int)getLocalCartNumberFromSqlite3;			                                    //获取本地所有商品总数
- (float)getLocalCartTotalPriceFromSqlite3;		                                    //获取本地所有商品总价
- (BOOL)deleteLocalCartByProductIdFromSqlite3:(NSNumber *)productId;                //删除一条商品
- (BOOL)cleanLocalCartFromSqlite3;                                                 //清空本地购物车
- (void)queryLocalCartByIdCountFromSqlite3:(LocalCartItemVO *)aLocalTipVO;                  //查询本地数据库是否有相同的productid,有则更新数量，没有则插入
- (NSMutableArray *) getLocalCartSynDateFromSqlite3;
- (BOOL)updateLocalCartItemToSqlite3:(LocalCartItemVO *)aLocalTipVO;                //更新一条商品信息
- (void)changeLocalCartItemToSqlite3:(NSArray *)productVOList;                      //更新一批商品信息
- (NSMutableArray *)queryLocalCartFromSqlite3;                                      //查询所有本地购物车
- (LocalCartItemVO *)queryLocalCartItemByIdFromSqlite3:(NSNumber *)productId;       //获取一条商品信息
@end

@interface LocalCartService(private)



@end