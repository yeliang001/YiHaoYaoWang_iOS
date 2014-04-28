//
//  OTSChangePayButton.h
//  MakePayBtn
//
//  Created by yiming dong on 12-8-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSChangePayButton : UIView
@property(nonatomic, retain)UIButton    *payButton;
@property(nonatomic, retain)UIButton    *changePayButton;

-(id)initWithLongButton:(BOOL)aIsLongButton;
@end
