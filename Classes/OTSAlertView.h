//
//  OTSAlertView.h
//  TheStoreApp
//
//  Created by yiming dong on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTSAlertView : UIAlertView
{
    BOOL    isDelegateRetained;
}

-(void)retainDelegate; // IMPORTANT:仅在alertView不被delegate retain时调用，否则将造成retain cycle！！！ dym 12.07.20.
@end
