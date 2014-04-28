//
//  OTSOnlinePayNotifyCanceller.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-8-31.
//
//

#import <Foundation/Foundation.h>

@interface OTSOrderCancelInfo : NSObject
@property (nonatomic, assign)   long long int   orderID;
@property (nonatomic, copy)     NSDate          *cancelDate;
@end

@interface OTSOnlinePayNotifyCanceller : NSObject

@property(nonatomic, retain)NSMutableArray      *orderCancelInfos;

+ (OTSOnlinePayNotifyCanceller *)sharedInstance;

// add a order for cancel
-(void)scheduleCancelingForOrderWithID:(long long int)aOrderID atDate:(NSDate*)aCancelDate;
-(void)stopCancelingForOrderWithID:(long long int)aOrderID;

-(void)stopAll; // stop all timer
-(void)startAll; // start all timer
-(void)reset;   // stop all timer and reset orderCancelInfos

@end
