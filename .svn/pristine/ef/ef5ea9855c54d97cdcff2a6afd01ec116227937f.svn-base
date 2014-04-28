//
//  AlertView.m
//  TheStoreApp
//
//  Created by jiming huang on 12-2-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AlertView.h"
#import "GlobalValue.h"
#import "OTSAlertView.h"

@implementation AlertView

+(void)showAlertView:(NSString *)alertTitle alertMsg:(NSString *)alertMsg buttonTitles:(NSArray *)buttonTitles alertTag:(int)tag {
	[[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
    UIAlertView * alert = nil;
    switch (tag) {
        case ALERTVIEW_TAG_COMMON:
            alert = [[OTSAlertView alloc]initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            break;
            
        default:
            break;
    }
    
    if (alert)
    {
        alert.tag = tag;
        [alert show];
        [alert release];
        //alert = nil;
    }
}
@end
