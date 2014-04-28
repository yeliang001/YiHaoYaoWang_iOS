//
//  SaveGoodReceiverResult.m
//  TheStoreApp
//
//  Created by towne on 13-3-18.
//
//

#import "SaveGoodReceiverResult.h"

@implementation SaveGoodReceiverResult

@synthesize resultCode,errorInfo,productList;

-(void)dealloc
{
    if (resultCode!=nil) {
        [resultCode release];
        resultCode=nil;
    }
    if (errorInfo!=nil) {
        [errorInfo release];
        errorInfo=nil;
    }
    
    if(productList != nil){
        [productList release];
        productList = nil;
    }
    [super dealloc];
}

@end
