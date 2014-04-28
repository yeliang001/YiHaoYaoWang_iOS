//
//  YWSearchService.m
//  TheStoreApp
//
//  Created by LinPan on 13-8-5.
//
//

#import "YWSearchService.h"
#import "ResponseInfo.h"
#import "ProductInfo.h"
#import "ResultInfo.h"
#import "SearchResultInfo.h"
#import "RelationWordInfo.h"
@implementation YWSearchService

- (SearchResultInfo *)getSearchProductListWithParam:(NSDictionary *)paramDic
{
    ResponseInfo *response = [self startRequestWithMethod:@"products.getlist" param:paramDic];
    
    SearchResultInfo *resultInfo = [[SearchResultInfo alloc] init];
    resultInfo.bRequestStatus = response.isSuccessful;
    resultInfo.responseCode = response.statusCode;
    
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSMutableArray *resultList = [[NSMutableArray alloc] init];
        NSDictionary *dataDic = response.data;
        DebugLog(@"getSearchList %@",dataDic);
        resultInfo.totalCount = [dataDic[@"recordcount"] intValue];
        NSDictionary *itemList = dataDic[@"item_list_resp_info"];
        if (itemList && itemList.count > 0)
        {
            NSArray *productList = itemList[@"hits"];
            DebugLog(@"productList -- > %@",productList);
            if (productList && ![productList isKindOfClass:[NSNull class]] && productList.count > 0 )
            {
                for (NSDictionary *dic in productList)
                {
                    if (![dic isKindOfClass:[NSNull class]])
                    {
                        NSDictionary *productDic = dic[@"product"];
                        
                        ProductInfo *product = [[ProductInfo alloc] init];
                        product.productId = productDic[@"id"];
                        NSString *name = productDic[@"name"];
                        product.name = [name isKindOfClass:[NSNull class]] ? @"无名字" : name;
                        product.category = productDic[@"category"];
                        product.brandId = productDic[@"brandId"];
                        product.brandName = productDic[@"brandName"];
                        product.time = productDic[@"time"];
                        NSString *img = productDic[@"img"];
                        product.productImageUrl = [img isKindOfClass:[NSNull class]]?@"" : img;
                        product.price = productDic[@"price"];
                        product.marketPrice = productDic[@"marketPrice"];
                        product.status = productDic[@"status"];
                        product.store = productDic[@"store"];
                        product.saleType = productDic[@"saleType"];
                        product.showPic = productDic[@"showPic"];
                        product.subTotalScore = productDic[@"subTotalScore"];
                        product.littlePic = productDic[@"littlePic"];
                        product.userGrade = productDic[@"userGrade"];
                        product.comments = productDic[@"comments"];
                        product.salesCount = productDic[@"salesCount"];
                        product.attribute = productDic[@"attribute"];
                        product.specialStatus = productDic[@"specialStatus"];
                        product.filter = productDic[@"filter"];
                        product.prescription = productDic[@"prescription"];
                        product.morePrice = productDic[@"morePrice"];
                        product.productNO = productDic[@"productNo"];
                        product.specialStatus = [productDic[@"specialStatus"] intValue];
                        product.activityDesc = productDic[@"activityDesc"];
                        product.itemId = productDic[@"itemId"];
                        
                        [resultList addObject:product];
                        [product release];
                    }
                }
            }
        }

        resultInfo.productList = resultList;
        [resultList release];
    }
    return [resultInfo autorelease];
}


//自动补全
- (NSMutableArray *)getSearchKeyword:(NSDictionary *)paramDic
{
    ResponseInfo *response = [self startRequestWithMethod:@"autocomplate" param:paramDic];
    
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSMutableArray *resultList = [[NSMutableArray alloc] init];
        NSDictionary *dataDic = response.data;
        DebugLog(@"getSearchKeyword %@",dataDic);
        
        NSDictionary *itemList = dataDic[@"auto_complate_result"];
        NSArray *wordList = itemList[@"hits"];
        DebugLog(@"wordList -- > %@",wordList);
        for (NSDictionary *dic in wordList)
        {
            NSDictionary *wordDic = dic[@"suggest"];
            
            RelationWordInfo *relationWordInfo = [[RelationWordInfo alloc] init];
            relationWordInfo.relationWord = wordDic[@"word"];
            relationWordInfo.count  = [wordDic[@"count"] intValue];
            
            [resultList addObject:relationWordInfo];
            [relationWordInfo release];
        }
        
         return [resultList autorelease];
    }
   
    return nil;
}
@end
