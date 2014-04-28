//
//  OTSPhoneWebRock.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-10-30.
//
//

#ifndef TheStoreApp_OTSPhoneWebRock_h
#define TheStoreApp_OTSPhoneWebRock_h

//0-促销商品；1-抵用券；2-游戏；3-普通商品
typedef enum
{
    kWeRockResultDisCount = 0       // 0-促销商品
    , kWeRockResultTicket = 1       // 1-抵用券
    , kWeRockResultGame = 2         // 2-游戏
    , kWeRockResultNormal = 3       // 3-普通商品
    , kWeRockResultGroupon          // 4-团购商品列表
    , kWeRockResultPrize            // 5-奖品列表
    , kWeRockResultSale             // 6-特价商品列表
    , kWeRockResultFree
    , kWeRockResultPrizeSuccess     // 领取奖品成功
    , kWeRockResultPrrzeFaild       // 领取奖品失败
}OTSWeRockResultType;

#define SIMULATE_WE_ROCK_BUSSINESS      0      // 1--模拟接口   0--真实接口

#endif
