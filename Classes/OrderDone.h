//
//  OrderDone.h
//  TheStoreApp
//
//  Created by towne on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
@protocol OrderDoneDelegate <NSObject>
-(void)orderDoneToOrderDetail:(NSNumber *)onlineOrderId;
@end

@interface OrderDone : OTSBaseViewController{
    NSNumber * onlineOrderId;
    id<OrderDoneDelegate> m_delegate;
}
@property(nonatomic,retain) NSNumber *onlineOrderId;
@property(nonatomic, assign) id<OrderDoneDelegate> m_delegate;

-(IBAction)checkOrder:(id)sender;
@end
