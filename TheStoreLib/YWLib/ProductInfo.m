//
//  ProductInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-8-5.
//
//

#import "ProductInfo.h"
#import "GlobalValue.h"
#import "YWConst.h"

@implementation SeriesProductInfo
@end



@implementation ProductInfo

- (void)dealloc
{
    [_productId release];
    [_name release];
    [_category release];
    [_brandId release];
    [_brandName release];
    [_productImageUrl release];
    [_time release];
    [_price release];
    [_marketPrice release];
    [_status release];
    [_store release];
    [_saleType release];
    [_showPic release];
    [_subTotalScore release];
    [_littlePic release];
    [_userGrade release];
    [_userGradeCount release];
    [_comments release];
    [_commentList release];
    [_salesCount release];
    [_attribute release];
//    [_specialStatus release];
    [_filter release];
    [_prescription release];
    [_morePrice release];
    
    [_categoryId release];
    [_categoryName release];
    [_color release];
    [_count release];
    [_gift release];
    [_mainImg1 release];
    [_mainImg2 release];
    [_mainImg3 release];
    [_mainImg4 release];
    [_mainImg5 release];
    [_mainImg6 release];
    [_mainInfo release];
    [_mainPush release];
    [_productNO release];
    [_recommendPrice release];
    [_saleInfo release];
    [_saleService release];
    [_sellType release];
//    [_seriesId release];
//    [_seriesName release];
    [_size release];
    [_sellerId release];
    [_taocanList release];
    [_unit release];
    [_desc release];
    [_weight release];
    [_itemId release];
    [_currentStore release];
    
    [_middleDetailImgList release];
    [_largeDetailImgList release];
    
    [_activityDesc release];
    [_promotions release];
    
    [super dealloc];
}


- (BOOL)isOnSale
{
    //8 表示上架商品
    return [_status intValue] == 8;
}

//当前商品的当前位置的库存
//各个仓对应库存  "1_0,2_0,3_0,4_0,5_0"
- (NSInteger)stockNum
{
    //用逗号分割成各个仓库数组
    NSArray *storeArr = [_store componentsSeparatedByString:@","];
    for (NSString * storeStr in storeArr)
    {
        if (![storeStr isKindOfClass:[NSNull class]])
        {
            NSArray *sArr = [storeStr componentsSeparatedByString:@"_"];
            if (sArr.count >= 2)
            {
                if ([sArr[0] intValue] == [GlobalValue getGlobalValueInstance].currentRepertory)
                {
                    return [sArr[1] intValue];
                }
                
                if ([sArr[0] intValue] == 999)
                {
                    return [sArr[1] intValue];
                }
            }
        }
        
    }
    return 0;
}

- (BOOL)isOTC
{
    return [_prescription intValue] == 16;
}



- (NSString *)getGroupImage
{
    NSString *baseUrl = @"http://p4.maiyaole.com/img/group/";
    NSString *p1 = [_productId substringToIndex:_productId.length - 3];
    baseUrl = [baseUrl stringByAppendingString:[NSString stringWithFormat:@"%@/%@/300_200.jpg",p1,_productId]];
    return baseUrl;
}


///** * http://p4.maiyaole.com/img/group/1150/1150748/300_200.jpg * 路径组成:http://p4.maiyaole.com/img/group/(product_id/1000)/product_id/类型 <br> * 类型有原图org_org.jpg ;450*800 300*200 180*120 115*77 50*34 195*130 *  * @param 0.原图；1.150*800；2.320*200；3.195*130；4.180*120；5.115*77；6.50*34； * @return 返回图片路径 */
//public String getImgUrl(int type)
//{
//    StringBuilder urlBuilder = new StringBuilder("http://p4.maiyaole.com/img/group/");
//    if (null != product_id && product_id.length() > 3)
//    {
//        int len = product_id.length();String subID = product_id.substring(0, len - 3);
//        urlBuilder.append(subID).append("/").append(product_id).append("/");switch (type)
//        {
//            case 0:urlBuilder.append("org_org.jpg");
//            break;
//            case 1:urlBuilder.append("450_800.jpg");
//            break;
//            case 2:urlBuilder.append("300_200.jpg");break;
//            case 3:urlBuilder.append("195_130.jpg");break;
//            case 4:urlBuilder.append("180_120.jpg");break;
//            case 5:urlBuilder.append("115_77.jpg");break;
//            case 6:urlBuilder.append("50_34.jpg");break;
//            default:urlBuilder.append("300_200jpg");break;
//        }
//    }return urlBuilder.toString();
//}


#pragma mark -- 系列品操作
- (NSArray *)getSeriesValueByName:(NSString *)name
{
    if (_seriesValues == nil)
    {
        return nil;
    }
    NSString *valueStr = _seriesValues[name];
    if (valueStr)
    {
        return [valueStr componentsSeparatedByString:@","];
    }
    return nil;
}


- (BOOL)isSeriesProductInProductList
{
    if (_specialStatus == 3)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isSeriesProductInProductDetail
{
    return (_specialStatus & 2) == 2;
}

//给activityDesc付值时 确定hasGift 和 hasReduce 的值
- (void)setActivityDesc:(NSString *)activityDesc
{
    if ( ![activityDesc isKindOfClass:[NSNull class]] &&  ![activityDesc isEqualToString:_activityDesc])
    {
        [_activityDesc release];
        _activityDesc = [activityDesc copy];
        
        if (activityDesc && activityDesc.length > 0)
        {
            NSArray *activityArr = [activityDesc componentsSeparatedByString:@","];
            for (NSString *activity in activityArr)
            {
                NSArray *arr = [activity componentsSeparatedByString:@"_"];
                if (arr.count == 3)
                {
                    NSString *activityType = arr[1];
                    [self setActivity:[activityType intValue]];
                }
            }
        }
    }
}

- (void)setActivity:(kYaoPromotionType)type
{
    switch (type)
    {
        case kYaoPromotion_MJ:_hasReduce = YES;return;
        case kYaoPromotion_MEJ:_hasReduce = YES;return;
        case kYaoPromotion_MJJ:_hasReduce = YES;return;
        case kYaoPromotion_MMEJ:_hasReduce = YES;return;
        case kYaoPromotion_MMJJ:_hasReduce = YES;return;
        case kYaoPromotion_MZ:_hasGift = YES;return;
        case kYaoPromotion_MEZ:_hasGift = YES;return;
        case kYaoPromotion_MJZ:_hasGift = YES;return;
        default:break;
    }
}

//- (BOOL)isJoinPromotion
//{
//    if (_promotionIdOfGift != 0 || _promotionIdOfReduce != 0)
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}

@end
