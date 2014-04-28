//
//  OTSUnionLoginView.h
//  TheStoreApp
//
//  Created by yiming dong on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSUnionLoginView : UIView
{
    id      delegate;
}
@property(nonatomic, assign)id      delegate;

-(void)setYPos:(int)aYPos;
@end
