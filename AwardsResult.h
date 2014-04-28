//
//  AwardsResult.h
//  TheStoreApp
//
//  Created by xuexiang on 13-4-22.
//
//

#import <Foundation/Foundation.h>

@interface AwardsResult : NSObject
/**
 * 0-失败；1-成功；-1-该deviceCode未中奖
 */
//private Integer resultCode;
@property(retain, nonatomic)NSNumber* resultCode;
@end
