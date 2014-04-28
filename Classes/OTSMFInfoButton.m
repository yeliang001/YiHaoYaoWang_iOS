//
//  OTSMFInfoButton.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSMFInfoButton.h"

@implementation OTSMFInfoButton
@synthesize groupBuyLogoIv, orderCodeLbl, orderDateLbl, orderCountLbl, orderPriceLbl, button;
@synthesize delegate;

-(IBAction)mfDetailInfoAction:(id)sender
{
    
    SEL handlerSel = @selector(handleInfoBtnClicked);
    if ([delegate respondsToSelector:handlerSel])
    {
        [delegate performSelector:handlerSel];
    }
}

-(void)makeGroupBuyLogoVisible:(BOOL)aMakeVisible
{
    groupBuyLogoIv.hidden = !aMakeVisible;
    
    if (groupBuyLogoIv.hidden)
    {
        orderCodeLbl.frame = CGRectMake(groupBuyLogoIv.frame.origin.x, orderCodeLbl.frame.origin.y, orderCodeLbl.frame.size.width, orderCodeLbl.frame.size.height);
    }
    else
    {
        orderCodeLbl.frame = CGRectMake(CGRectGetMaxX(groupBuyLogoIv.frame) + 10, orderCodeLbl.frame.origin.y, orderCodeLbl.frame.size.width, orderCodeLbl.frame.size.height);
    }
}

-(void)dealloc
{
    [groupBuyLogoIv release];
    [orderCodeLbl release];
    [orderDateLbl release];
    [orderPriceLbl release];
    [orderCountLbl release];
    
    [super dealloc];
}

@end
