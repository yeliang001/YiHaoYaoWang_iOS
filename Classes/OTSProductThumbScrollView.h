//
//  OTSProductThumbScrollView.h
//  TheStoreApp
//
//  Created by yiming dong on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSProductThumbScrollView : UIView

@property(nonatomic, assign)NSMutableArray *orderItems;//not owned
@property(nonatomic, retain)UIScrollView* scrollView;
-(id)initWithPos:(CGPoint)aPos;
+(int)myHeight;
@end
