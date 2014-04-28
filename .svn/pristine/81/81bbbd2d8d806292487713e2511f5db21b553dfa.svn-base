//
//  ResponseInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-7-16.
//
//

#import <Foundation/Foundation.h>

@interface ResponseInfo : NSObject

@property (assign, nonatomic) BOOL isSuccessful;
@property (assign, nonatomic) int statusCode;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *desc;
@property (assign, nonatomic) id data;

- (id)initWithSuccessfulStatus:(BOOL)isSuccessful
                      statusCode:(int)code
                        userId:(NSString *)aUserId
                     description:(NSString *)desc
                            data:(id)aData;

@end
