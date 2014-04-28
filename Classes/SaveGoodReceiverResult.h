//
//  SaveGoodReceiverResult.h
//  TheStoreApp
//
//  Created by towne on 13-3-18.
//
//

#import <Foundation/Foundation.h>

@interface SaveGoodReceiverResult : NSObject{
@private
    NSNumber *resultCode;
    NSString *errorInfo;
    NSArray  *productList;
}

@property(nonatomic,retain) NSNumber *resultCode;
@property(nonatomic,retain) NSString *errorInfo;
@property(nonatomic,retain) NSArray  *productList;
@end
