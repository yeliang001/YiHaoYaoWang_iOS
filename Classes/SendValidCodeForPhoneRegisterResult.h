//
//  SendValidCodeForPhoneRegisterResult.h
//  TheStoreApp
//
//  Created by towne on 12-11-1.
//
//

#import <Foundation/Foundation.h>

@interface SendValidCodeForPhoneRegisterResult : NSObject{
    NSNumber *resultCode;
    NSString *errorInfo;
}
@property(nonatomic,retain) NSNumber *resultCode;
@property(nonatomic,retain) NSString *errorInfo;

@end
