//
//  OnlinePayViewController.h
//  yhd
//
//  Created by dev dev on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface OnlinePayViewController : BaseViewController <UIWebViewDelegate>
{
    NSNumber* mGateWayId;
    NSNumber* mOrderId;
    //IBOutlet UIWebView* mPayWebView;
    IBOutlet UIView * mtopbarView;
}

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,retain)NSNumber* mGateWayId;
@property(nonatomic,retain)NSNumber* mOrderId;

-(IBAction)backClicked:(id)sender;
@end
