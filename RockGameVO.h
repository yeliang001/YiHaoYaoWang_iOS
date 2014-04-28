//
//  RockGameVO.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-1.
//
//

#import <Foundation/Foundation.h>
@class CommonRockResultVO;

typedef enum {
    kRockGameNotFinished = 0        // 0-未完成
    , kRockGameFinished             // 1-已完成
}OTSRockGameStatus;

@interface RockGameVO : NSObject
@property (retain) NSNumber     *couponNum;
@property (retain) NSNumber     *nid;
@property (retain) NSNumber     *userId;            // 用户ID
@property (retain) NSNumber     *gameStatus;        // 游戏状态：1-已完成；0-未完成
@property (retain) NSDate       *createTime;        // 创建时间
@property (retain) NSDate       *updateTime;        // 修改时间
@property (retain) CommonRockResultVO   *commonRockResultVO;    // 结果状态
@property (retain) NSMutableArray       *rockGameProdList;  // 当前活动的商品集合, item type = RockGameProductVO

//
-(OTSRockGameStatus)getStatus;
@end



