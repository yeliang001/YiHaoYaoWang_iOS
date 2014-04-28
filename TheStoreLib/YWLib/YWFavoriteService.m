//
//  YWFavoriteService.m
//  TheStoreApp
//
//  Created by LinPan on 13-8-17.
//
//

#import "YWFavoriteService.h"
#import "ResponseInfo.h"
#import "FavoriteResultInfo.h"
#import "FavoriteProductInfo.h"
@implementation YWFavoriteService


- (NSInteger)addFavorite:(NSDictionary *)paramDic
{
//    NSString * requestMethod = [NSString stringWithFormat:@"customer.addfav%@",[self convertParam2String:paramDic]];
    ResponseInfo *response = [self startRequestWithMethod:@"customer.addfav" param:paramDic];
    
    NSDictionary *dataDic = response.data;
    DebugLog(@"customer.addfav %@",dataDic);
    //ca。 如果result ＝ 9 表示已经收藏过了，服务器居然当作求情失败处理，，fuck。。。现在特殊处理下
    NSString *result = dataDic[@"result"];
    if ([result intValue] == 9)
    {
        return 9;
    }
    
    if (response.isSuccessful  && response.statusCode == 200)
    {
        NSDictionary *dataDic = response.data;
        DebugLog(@"customer.addfav %@",dataDic);
        NSString *result = dataDic[@"result"];
        return [result intValue];
    }
    return 0;
}

- (FavoriteResultInfo *)getMyFavoriteList:(NSDictionary *)paramDic
{
//    NSString * requestMethod = [NSString stringWithFormat:@"customer.getfavlist%@",[self convertParam2String:paramDic]];
    ResponseInfo *response = [self startRequestWithMethod:@"customer.getfavlist" param:paramDic];
    
    FavoriteResultInfo *resultInfo = [[FavoriteResultInfo alloc] init];
    resultInfo.responseCode = response.statusCode;
    resultInfo.bRequestStatus = response.isSuccessful;
    resultInfo.responseDesc = response.desc;
    
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSDictionary *dataDic = response.data;
        DebugLog(@"customer.getfavlist %@",dataDic);
        
        resultInfo.totalCount = [dataDic[@"recordcount"] intValue];
        
        NSMutableArray *favoriteList = [[NSMutableArray alloc] init];
        NSArray *favoriteArr = dataDic[@"favorite_list"];
        for (NSDictionary *favoriteDic in favoriteArr)
        {
            NSDictionary *dic = favoriteDic[@"favorite"];
            FavoriteProductInfo *favorite = [[FavoriteProductInfo alloc] init];
            favorite.addTime = dic[@"addTime"];
            favorite.catId = dic[@"catId"];
            favorite.catalogId = dic[@"catalogId"];
            favorite.favorCatId = dic[@"favorCatId"];
            favorite.flag = dic[@"flag"];
            favorite.goodsId = dic[@"goodsId"];
            favorite.favoriteId = dic[@"id"];
            favorite.newUserNote = dic[@"newUserNote"];
            favorite.nowPrice = dic[@"nowPrice"];
            favorite.oldUserNote = dic[@"oldUserNote"];
            favorite.pid = dic[@"pid"];
            favorite.popularity = dic[@"popularity"];
            favorite.price = dic[@"price"];
            favorite.productImgUrl = dic[@"productImgUrl"];
            favorite.productName = dic[@"productName"];
            favorite.siteId = dic[@"siteId"];
            favorite.userId = dic[@"userId"];
            favorite.userName = dic[@"userName"];
            favorite.userNote = dic[@"userNote"];
            favorite.userTagName = dic[@"userTagName"];
            favorite.venderId = dic[@"venderId"];
            favorite.venderName = dic[@"venderName"];
            
            [favoriteList addObject:favorite];
            [favorite release];
            
            //商品状态
            favorite.status = [favoriteDic[@"status"] intValue];
            //库存信息
            NSArray *stockArr = favoriteDic[@"stock_info"];
            if (stockArr.count > 0)
            {
                favorite.stockInfo = stockArr[0];
            }
        }
        
        resultInfo.favoriteList = favoriteList;
        [favoriteList release];
    }
    return [resultInfo autorelease];
}


- (BOOL)delFavorite:(NSDictionary *)paramDic
{
//    NSString * requestMethod = [NSString stringWithFormat:@"customer.delfav%@",[self convertParam2String:paramDic]];
    ResponseInfo *response = [self startRequestWithMethod:@"customer.delfav" param:paramDic];
    
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSDictionary *dataDic = response.data;
        DebugLog(@"customer.delfav %@",dataDic);
        
        NSString *result = dataDic[@"result"];
        if ([result intValue] > 0)
        {
            return YES;
        }
    }
    return NO;
}

@end
