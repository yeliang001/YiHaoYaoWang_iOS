//
//  InvoiceVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//

#import "InvoiceVO.h"


@implementation InvoiceVO

@synthesize amount;//发票金额
@synthesize content;//发票内容
@synthesize nid;//发票Id
@synthesize mcsiteid;//网站Id (1:1号店;2:药网)
@synthesize title;//发票抬头
@synthesize type;//发票类型 1表示3c 0表示普通商品

-(void)dealloc{
    if(amount!=nil){
        [amount release];
    }
    if(content!=nil){
        [content release];
    }
    if(nid!=nil){
        [nid release];
    }
    if(mcsiteid!=nil){
        [mcsiteid release];
    }
    if(title!=nil){
        [title release];
    }
    if (type!=nil) {
        [type release];
        type=nil;
    }
    [super dealloc];
}

@end
