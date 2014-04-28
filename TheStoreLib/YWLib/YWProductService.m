//
//  YWProductService.m
//  TheStoreApp
//
//  Created by LinPan on 13-7-22.
//
//

#import "YWProductService.h"
#import "SpecialRecommendInfo.h"
#import "ResponseInfo.h"
#import "SpecialRecommendInfo.h"
#import "Page.h"
#import "CategoryInfo.h"
#import "AdFloorInfo.h"
#import "ProductInfo.h"
#import "CommentInfo.h"
#import "PromotionInfo.h"
#import "ConditionInfo.h"
#import "GiftInfo.h"
#import "CartInfo.h"
@implementation YWProductService

- (Page *)getHomeSpcecialList
{
     DebugLog(@"test520 自动登陆 YWProductService getHomeSpcecialList");
    
    
    ResponseInfo *response = [self startRequestWithMethod:@"gethomepage&city=c1001&area=c1001"];
    DebugLog(@"gethomepage response==> %@",response);
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSMutableArray *resultList = [[[NSMutableArray alloc] init] autorelease];
        
        NSDictionary *dataDic = response.data;
        NSDictionary *jiaoDianTuDic = dataDic[@"index_jiaodiantu"];
        NSArray *specials = jiaoDianTuDic[@"specials"];
        for (NSDictionary *dic in specials)
        {
            SpecialRecommendInfo *specialInfo = [[SpecialRecommendInfo alloc] init];
            specialInfo.specialId = [dic[@"id"] stringValue];
            specialInfo.imageUrl = dic[@"image_url"];
            specialInfo.name = dic[@"name"];
            specialInfo.type = [dic[@"type"] intValue];
            specialInfo.sindex = [dic[@"sindex"] intValue];
            specialInfo.specialType = [dic[@"specialtype"] intValue];
            specialInfo.brandId = [dic[@"brandid"] intValue];
            specialInfo.catalogId = [dic[@"catalogid"] intValue];
            specialInfo.productId = [dic[@"productid"] intValue];
            
            [resultList addObject:specialInfo];
            [specialInfo release];
        }
        
        //楼层广告
        NSMutableArray *adFloorList = [[[NSMutableArray alloc] init] autorelease];
        NSArray *floorArr = dataDic[@"index_ggl"];
        for (NSDictionary *dic in floorArr)
        {
            AdFloorInfo *floor = [[AdFloorInfo alloc] init];
            NSDictionary *tiltDic = dic[@"title"];
            floor.titleImgUrl = tiltDic[@"image_url"];
            floor.title = tiltDic[@"name"];
        
            NSMutableArray *productListInAd = [[[NSMutableArray alloc] init] autorelease];
            NSArray *indexArr = @[@"3",@"1",@"2"];
            for (int i = 0;  i < 3;  ++i)
            {
                NSString *ggl = [NSString stringWithFormat:@"index_ggl_ggw_%d",[indexArr[i] intValue]];
                
                NSDictionary * p1Dic = dic[ggl];
                SpecialRecommendInfo *specialInfo = [[SpecialRecommendInfo alloc] init];
                specialInfo.specialId = [p1Dic[@"id"] stringValue];
                specialInfo.imageUrl = p1Dic[@"image_url"];
                specialInfo.name = p1Dic[@"name"];
                specialInfo.type = [p1Dic[@"type"] intValue];
                specialInfo.sindex = [p1Dic[@"sindex"] intValue];
                specialInfo.specialType = [p1Dic[@"specialtype"] intValue];
                
                specialInfo.brandId = [p1Dic[@"brandid"] intValue];
                specialInfo.catalogId = [p1Dic[@"catalogid"] intValue];
                specialInfo.productId = [p1Dic[@"productid"] intValue];
                
                [productListInAd addObject: specialInfo];
                [specialInfo release];
            }
            //换一下大小图的顺序
//            if (productListInAd.count > 3)
//            {
//                SpecialRecommendInfo *info = productListInAd[0];
//                [productListInAd replaceObjectAtIndex:0 withObject:productListInAd[2]];
//                [productListInAd replaceObjectAtIndex:2 withObject:info];
//            }
            floor.productList = productListInAd;
            
            NSString *keyword = dic[@"keyword"];
            floor.keywordList = [keyword componentsSeparatedByString:@","];
            
            [adFloorList addObject:floor];
            [floor release];
        }
        Page *page = [[Page alloc] init];
        page.objList = resultList;
        page.adFloorList = adFloorList;
        return [page autorelease];
    }
    
    //Test
//    NSMutableArray *resultList = [[[NSMutableArray alloc] init] autorelease];
//    SpecialRecommendInfo *specialInfo = [[SpecialRecommendInfo alloc] init];
//    specialInfo.specialId = @"123";
//    specialInfo.imageUrl = @"http://www.111.com.cn/cmsPage/show.do?pageId=50270";
//    specialInfo.name = @"测试";
//    specialInfo.type = 1;
//    specialInfo.sindex = 2;
//    specialInfo.specialType = 3;
//    [resultList addObject:specialInfo];
//    [specialInfo release];
//    Page *page = [[Page alloc] init];
//    page.objList = resultList;
//    return [page autorelease];
    return nil;
}

- (Page *)getCategory
{
    ResponseInfo *response = [self startRequestWithMethod:@"products.category.getcategory"];
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSMutableArray *resultList = [[[NSMutableArray alloc] init] autorelease];
        
        NSDictionary *dataDic = response.data;
        NSArray *categoryList = dataDic[@"categorylist"];
        for (NSDictionary *dic in categoryList)
        {
            CategoryInfo *categoryInfo = [[CategoryInfo alloc] init];
            categoryInfo.cid = [dic[@"id"] stringValue];
            categoryInfo.parentId = [dic[@"parentId"] stringValue];
            categoryInfo.type = [dic[@"type"] stringValue];
            categoryInfo.name = dic[@"name"];
            categoryInfo.imageUrl = dic[@"imageUrl"];
            
            [resultList addObject:categoryInfo];
            [categoryInfo release];
        }
        
        Page *page = [[Page alloc] init];
        page.objList = resultList;
        return [page autorelease];
    }
    return nil;
}



- (ProductInfo *)getProductDetail:(NSDictionary *)paramDic
{
    NSString * requestMethod = [NSString stringWithFormat:@"products.getproduct%@",[self convertParam2String:paramDic]];
    ResponseInfo *response = [self startRequestWithMethod:requestMethod];
    
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSDictionary *dataDic = response.data;

        NSDictionary *productDic = dataDic[@"item_info"];
        if (productDic.count > 0)
        {
            ProductInfo *product = [[ProductInfo alloc] init];
            product.productId = [productDic[@"id"] stringValue];
            product.itemId = productDic[@"itemid"];
            NSString *name = productDic[@"productname"];
            product.name = [name isKindOfClass:[NSNull class]] ? @"无名字" : name;
            product.category = productDic[@"category"];
            product.brandId = productDic[@"brandId"];
            product.brandName = productDic[@"brandName"];
            product.time = productDic[@"time"];
            product.productImageUrl = productDic[@"img"];
            product.price = productDic[@"originalprice"];
            product.marketPrice = productDic[@"marketPrice"];
            product.status = productDic[@"status"];
            product.store = productDic[@"store"];
            product.saleType = productDic[@"saleType"];
            product.showPic = productDic[@"showPic"];
            product.subTotalScore = productDic[@"subTotalScore"];
            product.littlePic = productDic[@"littlePic"];
            product.userGrade = productDic[@"usergrade"];
            product.userGradeCount = productDic[@"usergradecount"];
            product.comments = productDic[@"comments"];
            product.salesCount = productDic[@"salesCount"];
            product.attribute = productDic[@"attribute"];
            product.specialStatus = [productDic[@"specialStatus"] intValue];
            product.filter = productDic[@"filter"];
            
            product.prescription = [productDic[@"prescription"] stringValue]; //处方药标记
            product.morePrice = productDic[@"morePrice"];
            
            product.categoryId = productDic[@"catalogid"];
            product.categoryName = productDic[@"categoryName"];
            product.color = productDic[@"color"];
            product.count = productDic[@"count"];
            product.gift = productDic[@"gift"];
            product.limitCount = [productDic[@"limitcount"] intValue];
            product.leastCount = [productDic[@"moq"] intValue];
            
            NSString *imgStr = productDic[@"mainimg1"];
            product.mainImg1 = [imgStr isKindOfClass:[NSNull class]]? nil : imgStr;
            imgStr = productDic[@"mainimg2"];
            product.mainImg2 = [imgStr isKindOfClass:[NSNull class]]? nil : imgStr;
            imgStr = productDic[@"mainimg3"];
            product.mainImg3 = [imgStr isKindOfClass:[NSNull class]]? nil : imgStr;
            imgStr = productDic[@"mainimg4"];
            product.mainImg4 = [imgStr isKindOfClass:[NSNull class]]? nil : imgStr;
            imgStr = productDic[@"mainimg5"];
            product.mainImg5 = [imgStr isKindOfClass:[NSNull class]]? nil : imgStr;
            imgStr = productDic[@"mainimg6"];
            product.mainImg6 = [imgStr isKindOfClass:[NSNull class]]? nil : imgStr;
            product.productNO = productDic[@"productno"];
            product.recommendPrice = productDic[@"recommendprice"];
            product.saleInfo = productDic[@"saleinfo"];
            product.saleService = productDic[@"saleservice"];
            product.sellType = productDic[@"selltype"];
//            product.seriesId = productDic[@"seriesid"];
//            product.seriesName = productDic[@"seriesname"];
            product.size = productDic[@"size"];
            product.sellerId = productDic[@"venderid"];
            product.taocanList = productDic[@"taocanList"];
            product.unit = productDic[@"unit"];
            product.weight = productDic[@"weight"];
            product.desc = dataDic[@"product_desc"];
            
            //商品辅图
            NSMutableArray *midImgList = [[NSMutableArray alloc] init];
            NSMutableArray *largeImgList = [[NSMutableArray alloc] init];
            
            NSArray *imgList = dataDic[@"product_picture"];
            for (NSDictionary *imgDic in imgList)
            {
                NSString *midImgStr = imgDic[@"image3"];
                NSString *largeImgStr = imgDic[@"image2"];
                
                [midImgList addObject:midImgStr];
                [largeImgList addObject:largeImgStr];
            }
            product.middleDetailImgList = midImgList;
            [midImgList release];
            product.largeDetailImgList = largeImgList;
            [largeImgList release];
            
            //系列商品的信息
            NSString *attrName = dataDic[@"main_attr"];
            if (attrName && attrName.length > 0)
            {
                product.seriesNames = [attrName componentsSeparatedByString:@","];
            }
            NSDictionary *attrVal = dataDic[@"main_attr_val"];
            if (attrVal && attrVal.count > 0)
            {
                product.seriesValues = attrVal;
            }
            
            NSArray *attrSource = dataDic[@"data_source"];
            if (attrSource.count > 0)
            {
                NSMutableArray *seriesProductArr = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in attrSource)
                {
                    SeriesProductInfo *seriesProduct = [[SeriesProductInfo alloc] init];
                    seriesProduct.seriesFlag = dic[@"attribute"];
                    seriesProduct.itemId = [dic[@"itemid"] intValue];
                    seriesProduct.pno = dic[@"pno"];
                    seriesProduct.stock = [dic[@"stock"] intValue];
                    
                    [seriesProductArr addObject:seriesProduct];
                    [seriesProduct release];
                }
                product.seriesProducts = seriesProductArr;
                [seriesProductArr release];
            }
            
            
            //促销信息
            NSMutableArray *resultPromotionArr = [[NSMutableArray alloc] init];
            
            NSArray *promotionArr = dataDic[@"promotion_info"];
            for (NSDictionary *dic  in promotionArr)
            {
                PromotionInfo *promotion = [[PromotionInfo alloc] init];
                promotion.promotionId = [dic[@"promotionId"] intValue];
                promotion.promotionType = [dic[@"promotionType"] intValue];
                promotion.promotionName = dic[@"promptionName"];
                
                //如果满减
                if (promotion.promotionType == kYaoPromotion_MEJ || promotion.promotionType == kYaoPromotion_MJJ)
                {
                    NSMutableArray *resultConditionArr = [[NSMutableArray alloc] init];
                    NSArray *mjArr = dic[@"proMjsets"];
                    for (NSDictionary *mjDic in mjArr )
                    {
                        ConditionInfo *condiction = [[ConditionInfo alloc] init];
                        condiction.promotionId = [mjDic[@"promotionId"] intValue];
                        condiction.type = mjDic[@"type"];
                        condiction.requirement = [mjDic[@"quantity"] intValue];
                        condiction.reward = [mjDic[@"price"] intValue];
                        [resultConditionArr addObject:condiction];
                        [condiction release];
                    }
                    promotion.conditions = resultConditionArr;
                    [resultConditionArr release];
                }
                else if (promotion.promotionType == kYaoPromotion_MJZ || promotion.promotionType == kYaoPromotion_MEZ)
                {
                    NSMutableArray *resultGiftArr = [[NSMutableArray alloc] init];
                    NSMutableArray *resultConditionArr = [[NSMutableArray alloc] init];
                    
                    NSArray *sourceGiftArr = dic[@"proGifts"];
                    for (NSDictionary *sourceGift in sourceGiftArr)
                    {
                        GiftInfo *gift = [[GiftInfo alloc] init];
                        gift.giftId = sourceGift[@"giftId"];
                        gift.giftName = sourceGift[@"giftName"];
                        gift.giftStatus = [sourceGift[@"giftStatus"] intValue];
                        gift.itemId = [sourceGift[@"itemId"] intValue];
                        gift.limitCount = [sourceGift[@"limitCount"] intValue];
                        gift.markPrice = [sourceGift[@"markPrice"] floatValue];
                        gift.price = [sourceGift[@"price"] floatValue];
                        gift.promotionId = [sourceGift[@"promotionId"] intValue];
                        gift.quantity = [sourceGift[@"quantity"] intValue];
                        gift.schemeId = [sourceGift[@"schemeId"] intValue];
                        gift.storeId = [sourceGift[@"storeId"] intValue];

                        [resultGiftArr addObject:gift];
                        [gift release];
                    }
                    promotion.gifts = resultGiftArr;
                    [resultGiftArr release];
                    
                    NSArray *sourceMZArr = dic[@"proMzsets"];
                    for (NSDictionary *sourceMZDic in sourceMZArr)
                    {
                        ConditionInfo *condiction = [[ConditionInfo alloc] init];
                        condiction.promotionId = [sourceMZDic[@"promotionId"] intValue];
                        condiction.type = sourceMZDic[@"type"];
                        condiction.requirement = [sourceMZDic[@"quantity"] intValue];
                        condiction.reward = [sourceMZDic[@"price"] intValue];
                        condiction.conditionId = [sourceMZDic[@"id"] intValue];
                        [resultConditionArr addObject:condiction];
                        [condiction release];
                    }
                    promotion.conditions = resultConditionArr;
                    [resultConditionArr release];
                    
                }
                
                [resultPromotionArr addObject:promotion];
                [promotion release];
            }
            product.promotions = resultPromotionArr;
            [resultPromotionArr release];
            
            
            return [product autorelease];
        }

    }
    return nil;
}

//购物车里
- (CartInfo *)getProductDetailList:(NSDictionary *)paramDic
{
    NSLog(@"购物车获取商品信息 %@",paramDic);
    ResponseInfo *response = [self startRequestWithMethod:@"products.getproduct" param:paramDic];
    DebugLog(@"获取多个商品详细 %@",response);
    
    
    if (response.isSuccessful && response.statusCode == 200)
    {
        CartInfo * resultCartInfo = [[CartInfo alloc] init];
        
        NSDictionary *dataDic = response.data;
        //运费
        CGFloat fare = [dataDic[@"cart_fare"] floatValue];
        resultCartInfo.fare = fare;
        //总价
        CGFloat money = [dataDic[@"cart_money"] floatValue];
        resultCartInfo.money = money;
        //重量
        CGFloat weight = [dataDic[@"cart_weight"] floatValue];
        resultCartInfo.weight = weight;
        DebugLog(@"开始解析商品信息");
        //解析商品信息
        NSMutableArray *productArr = dataDic[@"item_list_info"];
        if ( productArr.count > 0)
        {
            
            NSMutableArray *resultArr = [[NSMutableArray alloc] init];
            for (NSDictionary *productDic in productArr)
            {
                
                if (productDic.count > 0)
                {
                    ProductInfo *product = [[ProductInfo alloc] init];
                    product.productId = [productDic[@"id"] stringValue];
                    product.itemId = productDic[@"itemid"];
                    NSString *name = productDic[@"productname"];
                    product.name = [name isKindOfClass:[NSNull class]] ? @"无名字" : name;
                    product.category = productDic[@"category"];
                    product.brandId = productDic[@"brandId"];
                    product.brandName = productDic[@"brandName"];
                    product.time = productDic[@"time"];
                    product.productImageUrl = productDic[@"img"];
                    product.price = productDic[@"originalprice"];
                    product.marketPrice = productDic[@"marketPrice"];
                    product.status = productDic[@"status"];
                    product.store = productDic[@"store"];
                    product.saleType = productDic[@"saleType"];
                    product.showPic = productDic[@"showPic"];
                    product.subTotalScore = productDic[@"subTotalScore"];
                    product.littlePic = productDic[@"littlePic"];
                    product.userGrade = productDic[@"userGrade"];
                    product.userGradeCount = productDic[@"usergradecount"];
                    product.comments = productDic[@"comments"];
                    product.salesCount = productDic[@"salesCount"];
                    product.attribute = productDic[@"attribute"];
                    product.specialStatus = [productDic[@"specialStatus"] intValue];
                    product.filter = productDic[@"filter"];
                    
                    product.prescription = [productDic[@"prescription"] stringValue];
                    product.morePrice = productDic[@"morePrice"];
                    product.categoryId = productDic[@"catalogid"];
                    product.categoryName = productDic[@"categoryName"];
                    product.color = productDic[@"color"];
                    product.count = productDic[@"count"];
                    product.gift = productDic[@"gift"];
                    product.mainImg1 = productDic[@"mainimg1"];
                    product.mainImg2 = productDic[@"mainimg2"];
                    product.mainImg3 = productDic[@"mainimg3"];
                    product.mainImg4 = productDic[@"mainimg4"];
                    product.mainImg5 = productDic[@"mainimg5"];
                    product.mainImg6 = productDic[@"mainimg6"];
                    product.productNO = productDic[@"productno"];
                    product.recommendPrice = productDic[@"recommendprice"];
                    product.saleInfo = productDic[@"saleinfo"];
                    product.saleService = productDic[@"saleservice"];
                    product.sellType = productDic[@"selltype"];
//                    product.seriesId = productDic[@"seriesid"];
//                    product.seriesName = productDic[@"seriesname"];
                    product.size = productDic[@"size"];
                    product.sellerId = productDic[@"venderid"];
                    product.taocanList = productDic[@"taocanList"];
                    product.unit = productDic[@"unit"];
                    product.weight = productDic[@"weight"];
                    product.desc = dataDic[@"product_desc"];
                    product.limitCount = [productDic[@"limitcount"] intValue];
                    product.leastCount = [productDic[@"moq"] intValue];
                    product.bigCatalogId = [productDic[@"bigcatalogid"] intValue];
                    [resultArr addObject:product];
                    [product release];
                }
            }
            
            resultCartInfo.productList = resultArr;
            [resultArr release];
            DebugLog(@"商品信息解析完毕");
        }
        
        //促销信息
        DebugLog(@"开始解析促销信息");
        NSMutableArray *resultPromotionArr = [[NSMutableArray alloc] init];
        NSDictionary *promotionDic = dataDic[@"promotion_info_cart"];
        if ( promotionDic.count > 0)
        {
            NSArray *promotions = promotionDic[@"promotions"];
            if (![promotions isKindOfClass:[NSNull class]] &&  promotions.count > 0)
            {
                DebugLog(@"开始解析promotion信息");
                for (NSDictionary *dic in promotions)
                {
                    PromotionInfo *promotionInfo = [[PromotionInfo alloc] init];
                    promotionInfo.promotionId = [dic[@"id"] intValue]; 
                    promotionInfo.promotionName = dic[@"name"];
                    promotionInfo.promotionDesc = dic[@"frontPrompt"];
                    promotionInfo.promotionResult = dic[@"behindPrompt"];
                    promotionInfo.giftCount = [dic[@"giftCount"] intValue];
                    
                    id scheme = dic[@"scheme"];
                    if (![scheme isKindOfClass:[NSNull class]])
                    {
                        promotionInfo.promotionCategory = [scheme intValue];
                    }
                    

                    promotionInfo.satisfy = [dic[@"satisfy"] intValue];
                    
                    NSDictionary *subDic = dic[@"promotion"];
                    if (![subDic isKindOfClass:[NSNull class]])
                    {
                        promotionInfo.promotionType = [subDic[@"schemeType"] intValue];
                    }
                    
                    //相关商品
                    NSMutableArray *resultProductList = [[NSMutableArray alloc] init];
                    NSArray *productListJson = dic[@"products"];
                    if (![productListJson isKindOfClass:[NSNull class]] && productListJson.count > 0)
                    {
                        CGFloat totalMoneyInPromotion = 0.0;
                        
                        for (NSDictionary *pDic in productListJson)
                        {
                            [resultProductList addObject: pDic[@"id"]]; //itemId
                            //把这个促销中的每个商品的总价加起来
                            totalMoneyInPromotion += [pDic[@"totalPrice"] floatValue];
                        }
                        promotionInfo.totalMoneyInPromotion = totalMoneyInPromotion;
                        promotionInfo.productItemIdArr = resultProductList;
                        [resultProductList release];
                    }
                    //梯度
                    DebugLog(@"开始解析梯度信息");
                    NSDictionary *conditionDic = dic[@"firstLevel"];
                    ConditionInfo *resultConditon = [[ConditionInfo alloc] init];
                    resultConditon.promotionId = [conditionDic[@"promotionId"] intValue];
                    resultConditon.type =  [conditionDic[@"type"] isKindOfClass:[NSNull class]]? 0 : [conditionDic[@"type"] intValue];
                    resultConditon.requirement = [conditionDic[@"quantity"] intValue];
                    resultConditon.reward = [conditionDic[@"price"] intValue];
                    promotionInfo.conditions = (NSMutableArray *)@[resultConditon];
                    [resultConditon release];
                    
                    //赠品
                    DebugLog(@"开始解析赠品信息");
                    NSMutableArray *resultGiftList = [[NSMutableArray alloc] init];
                    NSArray *jsonGifts = dic[@"giftList"];
                    if (![jsonGifts isKindOfClass:[NSNull class]] && jsonGifts.count > 0)
                    {
                        for (NSDictionary *sourceGift in jsonGifts)
                        {
                            GiftInfo *gift = [[GiftInfo alloc] init];
                            gift.giftId = sourceGift[@"giftId"];
                            gift.giftName = sourceGift[@"giftName"];
                            gift.giftStatus = [sourceGift[@"giftStatus"] intValue];
                            gift.itemId = [sourceGift[@"itemId"] intValue];
                            gift.limitCount = [sourceGift[@"limitCount"] intValue];
                            gift.markPrice = [sourceGift[@"markPrice"] floatValue];
                            gift.price = [sourceGift[@"price"] floatValue];
                            gift.promotionId = [sourceGift[@"promotionId"] intValue];
                            gift.quantity = [sourceGift[@"quantity"] intValue];
                            gift.schemeId = [sourceGift[@"schemeId"] intValue];
                            gift.storeId = [sourceGift[@"storeId"] intValue];
                            
                            [resultGiftList addObject:gift];
                            [gift release];
                        }
                        
                        promotionInfo.gifts = resultGiftList;
                        [resultGiftList release];
                    }
                    
                    
                    [resultPromotionArr addObject:promotionInfo];
                    [promotionInfo release];
                }
                
                resultCartInfo.promotionList = resultPromotionArr;
                [resultPromotionArr release];
            }
        }
        DebugLog(@"结束解析促销信息");
        return [resultCartInfo autorelease];
        
    }
    return nil;
}


- (NSDictionary *)getProductCommentList:(NSDictionary *)paramDic
{
    NSString * requestMethod = [NSString stringWithFormat:@"products.getproductcommentlist%@",[self convertParam2String:paramDic]];
    ResponseInfo *response = [self startRequestWithMethod:requestMethod];
    
    
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSMutableArray *resultList = [[[NSMutableArray alloc] init] autorelease];
        
        NSDictionary *dataDic = response.data;
        NSArray *commentList = dataDic[@"comment_list"];
        for (NSDictionary *dic in commentList)
        {
            CommentInfo *comment = [[CommentInfo alloc] init];
            comment.adminName = dic[@"adminName"];
            comment.allUserSocre = dic[@"allUserScore"];
            comment.allUserStatus = dic[@"allUserStatus"];
            comment.auditMode = dic[@"auditMode"];
            comment.auditing = dic[@"auditing"];
            comment.commentScore = dic[@"commentScore"];
            comment.commentScoreStatus = dic[@"commentScoreStatus"];
            comment.consultationType = dic[@"consultationType"];
            comment.content = dic[@"content"] ;
            comment.goodsId = dic[@"goodsId"] ;
            comment.grade = dic[@"grade"] ;
            comment.commentId = dic[@"id"];
            comment.isEmail = dic[@"isEmail"];
            comment.issuedDate = dic[@"issuedDate"];
            comment.mainimg4 = dic[@"mainimg4"];
            comment.nay = dic[@"nay"];
            comment.orderDate = dic[@"orderDate"];
            comment.orderId = dic[@"orderId"];
            comment.pId = dic[@"pId"];
            comment.priority = dic[@"priority"];
            comment.productName = dic[@"productName"];
            comment.putTopDate = dic[@"putTopDate"];
            comment.putTopScore = dic[@"putTopScore"];
            comment.putTopStatus = dic[@"putTopStatus"];
            comment.recommendedDate = dic[@"recommendedDate"];
            comment.recommendedScore = dic[@"recommendedScore"];
            comment.recommendedStatus = dic[@"recommendedStatus"];
            comment.releaseDate = dic[@"releaseDate"];
            comment.replyCount = dic[@"replyCount"];
            comment.replys = dic[@"replys"];
            comment.reviewType = dic[@"reviewType"];
            comment.rewardScore = dic[@"rewardScore"];
            comment.rewardScoreStatus = dic[@"rewardScoreStatus"];
            comment.scoreDate = dic[@"scoreDate"];
            comment.status = dic[@"status"];
            comment.subcatalog = dic[@"subcatalog"];
            comment.subject = dic[@"subject"];
            comment.top5Score = dic[@"top5Score"];
            comment.top5Status = dic[@"top5Status"];
            comment.userImg = dic[@"userImg"];
            comment.userIp = dic[@"userIp"];
            comment.userLevelId = dic[@"userLevelId"];
            comment.userName = dic[@"userName"];
            comment.yes = dic[@"yes"];
            
            [resultList addObject:comment];
            [comment release];
        }
        
        //好中差评分比率
        NSDictionary *commentClass = dataDic[@"comment_class_statistics"];
        NSInteger count = [commentClass[@"count"] intValue];
        NSInteger good = [commentClass[@"hao"] intValue];
        NSInteger middle = [commentClass[@"zhong"] intValue];
        NSInteger bad = [commentClass[@"cha"] intValue];
        
        NSDictionary *commentClassDic;
        
        if (count > 0)
        {
            commentClassDic = @{@"good" : [NSString stringWithFormat:@"%.2f",good * 1.0 / count],
                              @"middle" : [NSString stringWithFormat:@"%.2f",middle * 1.0 / count],
                                 @"bad" : [NSString stringWithFormat:@"%.2f",bad * 1.0 / count],
                          @"totalscore" : [NSString stringWithFormat:@"%.f",(good * 5 + middle * 3 + bad * 1)*1.0/count]};
        }
        else
        {
                      commentClassDic = @{@"good" : @"0.0",
                                        @"middle" : @"0.0",
                                           @"bad" : @"0.0",
                                    @"totalscore" : @"0.0"};
        }
        
        NSDictionary *resultDic = @{@"commentlist" : resultList, @"commentclass" : commentClassDic};
        
        return resultDic;
    }
    return nil;
}


 
// 参数 1）flag=1 productnos  不区分省份 获取商品的库存  返回格式： 商品编码_仓库编码_库存
// 2） flag=2 productnos province    区分省份获取商品库存   返回格式： 如上 
// 3） flag =3 productno province num  返回productNO 查询数量num 库存数量qty 库存有货无货状态status

- (NSMutableArray *)getProductInStock:(NSDictionary *)paramDic
{
    
    ResponseInfo *response = [self startRequestWithMethod:@"products.getinstock" param:paramDic];
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSDictionary *dataDic = response.data;
        DebugLog(@"getInstock %@",dataDic);

        
        if ([dataDic[@"result"] intValue] == 1)
        {
                NSArray *stockArr = dataDic[@"stock_info"];

                NSMutableArray *stockResultArr = [[NSMutableArray alloc] init];

                for (NSString *stockStr in stockArr)
                {
                    if (![stockStr isKindOfClass:[NSNull class]])
                    {
                        //截取数据，
                        NSArray *stockInfoArr = [stockStr componentsSeparatedByString:@"_"];
                        if (stockInfoArr.count >=3)
                        {
                            //库存信息是一个字典， productNo 标示商品  stock 标示该商品的数量
                            NSDictionary *resultDic = @{@"productNo":stockInfoArr[0],@"stock":stockInfoArr[2]};
                            [stockResultArr addObject:resultDic];
                        }
                    }
                   
                }
                return [stockResultArr autorelease];
        }
    }
    return nil;
}







@end
