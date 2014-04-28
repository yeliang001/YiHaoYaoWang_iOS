//
//  OTSDataChecker.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-9-25.
//
//

#import <Foundation/Foundation.h>

@class ProductVO;


@interface OTSDataChecker : NSObject

+ (OTSDataChecker *)sharedInstance;


-(BOOL)checkProductVO:(ProductVO*)aProductVO methodName:(NSString*)aMethodName;
-(void)handleErrorsWithBlock:(void(^)(NSString* aErrorInfo ,NSString* aMethodName))aBlock;
@end
