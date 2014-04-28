//
//  CheckSecKillResult.h
//  TheStoreApp
//
//  Created by towne on 13-5-13.
//
//

#import <Foundation/Foundation.h>

@interface CheckSecKillResult : NSObject{
   @private
    NSString  *  ifSecKill; //是否为秒杀活动或商品
    NSDate   * startDate; //秒杀活动开始时促销开始时间(一号店间)
    NSDate   * endDate;   //秒杀活动结束时间(一号店促销活动结束时间)
    NSString * canSecKill; //秒杀商品是否能够被秒杀
}

@property(nonatomic,retain) NSString *   ifSecKill;
@property(nonatomic,retain) NSDate *startDate;
@property(nonatomic,retain) NSDate *endDate;
@property(nonatomic,retain) NSString *   canSecKill;

@end
