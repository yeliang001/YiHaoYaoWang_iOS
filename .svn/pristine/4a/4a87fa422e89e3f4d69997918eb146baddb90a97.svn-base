//
//  URLSchemeForPad.h
//  TheStoreApp
//
//  Created by towne on 13-5-7.
//
//

#import <Foundation/Foundation.h>


typedef enum _URLType{
    EURLtype_PadAlixPay
}URLType;


@interface URLSchemeForPad : NSObject{
    URLType urlType;
    NSArray* pramaArr;
}
+(id)sharedScheme;
-(void)parseWithURL:(NSURL*)url;

@end
