//
//  UnionProductItemVO.m
//  TheStoreApp
//
//  Created by yuan jun on 13-5-15.
//
//

#import "UnionProductItemVO.h"

@implementation UnionProductItemVO
@synthesize productId;
@synthesize num;
-(NSString*)toXML{
    NSMutableString* string=[NSMutableString stringWithString:@"<com.yihaodian.mobile.vo.cart.UnionProductItemVO>"];
    if ([self productId]!=nil) {
        [string appendFormat:@"<productId>%@</productId>",[self productId]];
    }
    if ([self num]!=nil) {
        [string appendFormat:@"<num>%@</num>",[self num]];
    }
    [string appendString:@"</com.yihaodian.mobile.vo.cart.UnionProductItemVO>"];
    return string;
}
-(void)dealloc{
    OTS_SAFE_RELEASE(productId);
    OTS_SAFE_RELEASE(num);
    [super dealloc];
}
@end
