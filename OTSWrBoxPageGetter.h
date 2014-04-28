//
//  OTSWrBoxPageGetter.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-8.
//
//

#import <Foundation/Foundation.h>

@class StorageBoxVO;
@class ProductVO;

@interface OTSWrBoxPageGetter : NSObject

-(BOOL)canRequestPage;
-(void)reset;
-(void)requestPage;
-(void)requestToTheEnd;
-(NSArray*)allPageItems;
-(int)totalPageItemsCount;

-(void)addBoxItem:(StorageBoxVO*)aBoxItem;
-(StorageBoxVO*)getItemWithProduct:(ProductVO*)aProductVO;

-(BOOL)isRunning;

@end


#define NOTIFY_STORAGE_BOX_CHANGED  @"NOTIFY_STORAGE_BOX_CHANGED" // 寄存箱变化通知