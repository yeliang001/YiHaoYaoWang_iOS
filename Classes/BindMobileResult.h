//
//  BindMobileResult.h
//  TheStoreApp
//
//  Created by towne on 12-11-1.
//
//

#import <Foundation/Foundation.h>

@interface BindMobileResult : NSObject{
    NSNumber *resultCode;
    NSString *errorInfo;
    NSNumber *phoneNum;
}
@property(nonatomic,retain) NSNumber *resultCode;
@property(nonatomic,retain) NSString *errorInfo;
@property(nonatomic,retain) NSNumber *phoneNum;

@end
