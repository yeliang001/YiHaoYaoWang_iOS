//
//  DataHandler.h
//  JyPay
//
//  Created by mxy on 11-10-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "sqlite3.h"
#import "MobClick.h"
#define kDataFilename    @"data.sqlite3"
#define kLocalCartFilename    @"localCart.plist"
#define kUserFilename    @"user.plist"

#define kCateButFontSize 18
#define kCateTableWidth 242//根类别列表宽度
#define kCateTableCellHeight 63//根类别列表cell高度
#define kCateTable2Height 660//二级类别列表高度
#define kCateDetailViewX 104
#define kCellButFontname   @"Helvetica"
#define kCellButFontsize  17

#define kShowCateDetailDuration  0.2f//二级分类列表页面出现时间
#define kShowRootCateDuration  0.2f//一级分类列表页面出现时间

#define kRedColor  [UIColor colorWithRed:204.0/255.0 green:0 blue:0 alpha:1.0]
#define kBlackColor  [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0]
#define kGrayColor  [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0]

#define kNotifyCartChange @"1"
#define kNotifyMallCartChange @"mallcartChanged"

#define kNotifyProvinceChange @"2"
#define kNotifyFilterChange @"3"
#define kNotifyCartReload @"4"
#define kNotifyProvincePop @"5"
#define kNotifyAppBecomeActive @"7"
#define kNotifySearchTextViewChange @"8"
#define kNotifyCartCacheChange @"19"
#define kNotifyTopViewShowUser          @"kNotifyTopViewShowUser"
#define kNotifyCancelGPS                @"kNotifyCancelGPS"
#define kNotifyDismissPopOverProvince   @"kNotifyDismissPopOverProvince"
#define YihaodianOnly                  @"仅1号药店商品"
#define TRACK_TYPE 5

#if (TRACK_TYPE == 0)
#define kTrackid @"10442025702"
#define kTrackName @"appstore_ipad"

#elif (TRACK_TYPE == 1)
#define kTrackid @"10179025705"
#define kTrackName @"同步助手_ipad"

#elif (TRACK_TYPE == 2)
#define kTrackid @"10833825707"
#define kTrackName @"91助手_ipad"

#elif (TRACK_TYPE == 3)
#define kTrackid @"10846625708"
#define kTrackName @"PP助手_ipad"

//#elif (TRACK_TYPE == 4)
//#define kTrackid @"10490729069"
//#define kTrackName @"艾德思奇_ipad"

#elif (TRACK_TYPE == 5)
#define kTrackid @"10111840233"
#define kTrackName @"快用_ipad"

#endif
    

#define MCRelease(x) [x release], x = nil


#if DEBUG
# define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif
@class ProvinceVO,CartVO,ProductVO,CartItemVO;

// CLASS_DESC:database helper class
@interface DataHandler : NSObject {
    sqlite3    *database;
    NSMutableDictionary *userDic;
    NSMutableDictionary *cateDic;//类别dic ，面包屑
    NSMutableDictionary *filterDic;//筛选dic 
    NSMutableArray *categories;
    NSInteger screenWidth;
    //ProvinceVO *province;
    CartVO *cart;
    NSArray *provinceArray;
    NSString* keyWord;
}
@property (nonatomic, retain)  NSMutableDictionary *userDic;
@property (nonatomic, retain)  NSMutableDictionary *cateDic;
@property (nonatomic, retain)  NSMutableDictionary *filterDic;
@property(nonatomic,retain)NSMutableArray *categories;
@property (nonatomic)  NSInteger screenWidth;
//@property (nonatomic, retain) ProvinceVO *province;
@property (nonatomic, retain) NSArray *provinceArray;
@property (nonatomic, retain) CartVO *cart;
@property(nonatomic,copy)NSString* keyWord;

+(DataHandler*)sharedDataHandler;

- (NSString *)dataFilePath:(NSString *)fileName;
-(NSString *)checkNetWorkType;
- (void)saveProvice;
- (void)addProductToCart:(ProductVO*)product buyCount:(NSInteger)buyCount;
- (void)updateProductQuantityToCart:(CartItemVO *)cartItem;
- (void)delProductFromCart:(CartItemVO *)cartItem;
//-(void)delAllProduct;
//sql
- (void)saveProductHistory:(ProductVO *)product;
- (void)saveProductHistory2:(NSNumber *)productid cnname:(NSString *)cnname midlepicurl:(NSString *)midlepicurl minipicurl:(NSString *)minipicurl price:(NSNumber *)price canbuy:(NSString *)canbuy;

- (NSMutableArray *)queryProductHistory;
- (ProductVO *)queryProductHistoryById:(NSNumber *)productId;
- (void)updateTimeHistory:(NSNumber *)productId;
- (void)updateHistory:(ProductVO *)product;

- (void)saveSearchHistory:(NSString *)name;
- (NSMutableArray *)querySearchHistory;
- (NSString *)querySearchHistoryByName:(NSString *)name;
- (void)updateTimeSearchHistory:(NSString *)name;
- (void)deleteSearchHistory;
- (void)deleteProductHistory;
-(BOOL)writeData:(NSData *)data toFile:(NSString *)fileName;
-(NSData *)dataFromFile:(NSString *)fileName;
-(NSArray*)paymentBankList;

// 清空购物车
-(void)resetCart;

//本地购物车设置商品数量
-(void)localCartProduct:(ProductVO *)product addCount:(int)count;
-(void)localCartProduct:(ProductVO *)product setCount:(int)count;
-(void)deleteLocalCartItem:(CartItemVO *)cartItemVO;
-(void)clearLocalCart;
@end

@interface NSString(MD5Addition)

- (NSString *) stringFromMD5;

@end
