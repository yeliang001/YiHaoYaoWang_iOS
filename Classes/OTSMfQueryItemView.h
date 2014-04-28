//
//  OTSMfQueryItemView.h
//  TheStoreApp
//
//  Created by yiming dong on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderV2;
@class OTSMFInfoButton;
@class OTSProductThumbScrollView;
@class OTSImagedLabel;
@class OTSMfStackLabel;
@class MyOrderInfo;

@interface OTSMfQueryItemView : UIView

@property(nonatomic, assign)MyOrderInfo*    order;
@property(nonatomic, retain)UINib*      titleBtnNib;
@property(nonatomic, retain)OTSMFInfoButton* infoButton;
@property(nonatomic, retain)OTSProductThumbScrollView* productThumbScrollView;
@property(nonatomic, retain)OTSImagedLabel* imgLbl;
@property(nonatomic, retain)OTSMfStackLabel* packageInfoLbl;

@property(nonatomic, retain)NSArray* statusMessages;

-(id)initWithFrame:(CGRect)aFrame order:(MyOrderInfo *)aOrder;
@end
