//
//  OTSOnlinePayNotifier.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-8-23.
//
//

#import <Foundation/Foundation.h>

@class OrderV2;

// DESC_CLASS: class for notifying user oneline payment order
@interface OTSOnlinePayNotifier : NSObject

@property(retain)NSMutableArray                   *orders;        // orders in processing
@property(nonatomic, assign)int                 appBadgeNumber;    // number of badges for notified orders

//@property(readonly) int storeOrderCount;
//@property(readonly) int mallOrderCount;

@property(nonatomic) int storeOrderCount;
@property(nonatomic) int mallOrderCount;

-(int)storeMfOrderCount;    // 有物流的order Count (1号店)
-(int)mallMfOrderCount;     // 有物流的order Count (1号商城)

+ (OTSOnlinePayNotifier *)sharedInstance;
+(NSNumber*)orderIdForNotification:(UILocalNotification*)aNotification;

-(void)retrieveOrders;  // retrieve orders
-(void)retrieveOrdersForceCleanUp:(BOOL)aForceCleanup;
-(void)cancelRetrieveOrders;

-(void)reset;

-(void)addNotificationForOrder:(OrderV2*)anOrder;               // add notification
-(void)addNotificationForOrder:(OrderV2*)anOrder needUpdate:(BOOL)aNeedUpdate;  // add notification and update badge
-(void)addNotificationForOrderByID:(long long int)anOrderID;    // add notification

-(void)removeNotificationWithOrderID:(long long int)anOrderID;      // remove notification
-(void)removeAllNotification;                                       // remove all notification

-(void)refreshAllNotificationsForOrders:(NSArray*)aOrders; // refresh all notifications
-(void)refreshAllNotificationsForOrders:(NSArray*)aOrders forceCleanUp:(BOOL)aForceCleanUp; // refresh all notifications force remove all?

-(int)notifyOrdersCount;         //this order count is for badge display

-(void)handleRecievedNotification:(UILocalNotification*)aLocalNotification;
@end


#define OTS_ONLINE_PAY_LOCAL_NOTIFY_KEY         @"OTS_ONLINE_PAY_LOCAL_NOTIFY_KEY" // key for local notification's userinfo
#define OTS_NOTIFY_MY_ORDER_BADGE_CHANGED       @"OTS_NOTIFY_MY_ORDER_BADGE_CHANGED"