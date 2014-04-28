//
//  URLScheme.m
//  TheStoreApp
//
//  Created by xuexiang on 13-4-10.
//
//

#import "URLScheme.h"
#import "AlixPayResult.h"
#import "OTSUtility.h"
#import "TheStoreAppAppDelegate.h"
#import "OTSProductDetail.h"
#import "OTSNNPiecesVC.h"
#import "CategoryProductsViewController.h"
#import "GrouponAreaVO.h"
#import "GlobalValue.h"

#define ALIXPAYOK     1
#define ALIXPAYERROR  2


@interface URLScheme ()
@property(nonatomic)BOOL isNeedChangeProvince;
@end

@implementation URLScheme
static URLScheme* scheme;

+(id)sharedScheme{
    @synchronized(self){
        if (scheme==nil) {
            scheme=[[self alloc] init];
        }
    }
    return scheme;
}
-(void)parseWithURL:(NSURL*)url{
    NSArray* components = [[[url absoluteString] substringFromIndex:6] componentsSeparatedByString:@"/"];
    if (components.count > 0) {
        NSString* typeStr = [OTSUtility safeObjectAtIndex:0 inArray:components];
        pramaArr = [[OTSUtility safeObjectAtIndex:1 inArray:components] componentsSeparatedByString:@"_"];
        if ([typeStr isEqualToString:@"cms"]) {
            urlType = EURLType_CMS;
            [self enterCMS];
        }else if ([typeStr isEqualToString:@"product"]){
            urlType = EURLtype_Product;
            [self enterProductDetail];
        }else if ([typeStr isEqualToString:@"groupon"]){
            urlType = EURLtype_Goupon;
            [self enterGroupon];
        }else if ([typeStr isEqualToString:@"rockhomepage"]){
            urlType = EURLtype_RockBuy;
            [self enterRockBuy];
        }else if ([typeStr isEqualToString:@"search"]){
            urlType = EURLtype_Search;
            [self enterSearch];
        }else if ([typeStr isEqualToString:@"promofree"]){
            urlType = EURLtype_PromoFree;
            [self enterPromofree];
        }else if ([typeStr isEqualToString:@"promonn"]){
            urlType = EURLtype_PromoNN;
            [self enterNNPiece];
        }else if ([typeStr isEqualToString:@"promocutoff"]){
            urlType = EURLtype_PromoCutOff;
            [self enterPromoCutOff];
        }else if ([typeStr isEqualToString:@"safepay"]){
            urlType = EURLtype_AlixPay;
            [self enterSafePayDeal:url];
        }
        else{
            DebugLog(@"typeStr is: %@      NO NONONONONONONONONONONONONONONONONO NONONONONONONONONONONONONONONONONO NONONONONONONONONONONONONONONONO",typeStr);
        }
    }
    
}

#pragma mark - tool function
-(void)toTabIndex:(int)pageIndex{
    if (SharedDelegate.tabBarController.selectedIndex != pageIndex) {
        SharedDelegate.tabBarController.selectedIndex = pageIndex;
        [SharedDelegate.tabBarController selectItemAtIndex:pageIndex];
    }
}
-(NSNumber*)strToNumber:(NSString*)str{ // string to number
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number=[formatter numberFromString:str];
    [formatter release];
    return number;
}
-(void)checkAndHandleProvince:(NSString*)provinceIdStr{  // 需要切换省份返回 YES ,否则返回 NO
    
    NSNumber *provinceId=[self strToNumber:provinceIdStr];
    
    if ([GlobalValue getGlobalValueInstance].provinceId.intValue != provinceId.intValue) {  // 如果不是当前省份。要切换省份，切换到首页
        //根据省份ID获取省份省份名称
        [self toTabIndex:0];
        NSString *listPath=[[NSBundle mainBundle] pathForResource:@"ProvinceID" ofType:@"plist"];
        NSMutableDictionary *provinceDic=[[[NSMutableDictionary alloc] initWithContentsOfFile:listPath] autorelease];
        NSString* provinceName = [OTSUtility safeObjectAtIndex:0 inArray:[provinceDic allKeysForObject:provinceIdStr]];
        if (provinceName && ![provinceName isEqualToString:@""]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ProvinceChanged" object:provinceName];
            self.isNeedChangeProvince = YES;
        }
    }else{
        self.isNeedChangeProvince = NO;
    }
}
-(void)maskToCorrectVC:(OTSBaseViewController*)aVC isFullScreen:(BOOL)isFullScreen{  // 将对应页面加到合适的位置
    
    OTSBaseViewController* curVC = (OTSBaseViewController*)SharedDelegate.tabBarController.selectedViewController;
    if(self.isNeedChangeProvince){// 如果切换省份，切换到首页
        //[curVC.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
        HomePage*homepage=(HomePage*)[SharedDelegate.tabBarController.viewControllers objectAtIndex:0];
        [homepage pushVC:aVC animated:NO fullScreen:isFullScreen];
    }else
        if ([curVC isKindOfClass:[PhoneCartViewController class]]) { // 如果是购物车，关掉检查订单页面
            [SharedDelegate enterCartWithUpdate:NO];
            [curVC pushVC:aVC animated:NO fullScreen:isFullScreen];
        }else{
            [curVC pushVC:aVC animated:NO fullScreen:isFullScreen];
        }
}
#pragma mark - entrances function
-(void)enterCMS{ // 进入CMS页面
    [self toTabIndex:0];
    HomePage*homepage=(HomePage*)[SharedDelegate.tabBarController.viewControllers objectAtIndex:0];
    NSString* promotionId = [OTSUtility safeObjectAtIndex:0 inArray:pramaArr];
    NSString* provinceIdStr = [OTSUtility safeObjectAtIndex:1 inArray:pramaArr];
    [self checkAndHandleProvince:provinceIdStr];
    [homepage enterCelebrateView:[NSString stringWithFormat:@"http://m.yihaodian.com/mw/cms/%@/30/%@",promotionId,provinceIdStr]];
}
-(void)enterProductDetail{  // 进入商品详情页面
    // 进入商品详情页的参数
    NSString *promotionId;
    long productId=[[OTSUtility safeObjectAtIndex:0 inArray:pramaArr] longLongValue];
    NSString *provinceIdStr = [OTSUtility safeObjectAtIndex:1 inArray:pramaArr];
    [self checkAndHandleProvince:provinceIdStr];
    
    if (pramaArr.count==3) {
        promotionId=[OTSUtility safeObjectAtIndex:2 inArray:pramaArr];
        if (promotionId == nil || [promotionId isEqualToString:@"0"]) {
            promotionId=@"";
        }
    }else{
        promotionId=@"";
    }
    OTSProductDetail *productDetail=[[[OTSProductDetail alloc] initWithProductId:productId promotionId:promotionId fromTag:PD_FROM_OTHER] autorelease];
    [self maskToCorrectVC:productDetail isFullScreen:NO];
}
-(void)enterGroupon{    // 进入团购页面
    
    NSNumber* areaId = [self strToNumber:[OTSUtility safeObjectAtIndex:1 inArray:pramaArr]];
    NSNumber* grouponId = [self strToNumber:[OTSUtility safeObjectAtIndex:0 inArray:pramaArr]];
    
    __block NSArray* areaArr;
    
    [self performInThreadBlock:^{
       areaArr  = [[[OTSServiceHelper sharedInstance] getGrouponAreaList:[GlobalValue getGlobalValueInstance].trader] retain];
    } completionInMainBlock:^{
        if (areaArr && areaArr.count > 0) {
            for (GrouponAreaVO* avo in areaArr) {
                if (avo.nid.intValue == areaId.intValue) {
                    [self checkAndHandleProvince:[NSString stringWithFormat:@"%@",avo.provinceId]];
                    [areaArr release];
                    break;
                }
            }
        }else{
            [areaArr release];
        }
     
    }];
    
    
    GrouponVO * grouponVO = [[GrouponVO alloc] init];
    [grouponVO setNid:grouponId];
    [grouponVO setAreaId:areaId];
    
    NSMutableArray *products=[[NSMutableArray alloc] init];
    [products addObject:grouponVO];
    [grouponVO release];
    
    [SharedDelegate enterGrouponDetailWithAreaId:areaId products:products currentIndex:0 fromTag:FROM_URLSCHEME_TO_DETAIL isFullScreen:YES];
}
-(void)enterRockBuy{  // 进入摇摇购页面
    [SharedDelegate enterRockBuy];
}
-(void)enterSearch{     // 进入搜索页面
    NSString* keyWord= [[OTSUtility safeObjectAtIndex:0 inArray:pramaArr]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (keyWord!=nil) {
        SearchResult *searchResult=[[[SearchResult alloc] initWithKeyword:keyWord fromTag:FROM_URLSCHEME] autorelease];
        self.isNeedChangeProvince = NO;
        [self maskToCorrectVC:searchResult isFullScreen:NO];
    }
}
-(void)enterPromofree{  // 进入赠品页面
    // 现在还木有对应的页面，在客户端
}

-(void)enterSafePayDeal:(NSURL*)url {
        
    AlixPayResult *  result = [self resultFromURL:url];
    MyStoreViewController * controller = (MyStoreViewController *)[SharedDelegate.tabBarController.viewControllers objectAtIndex:3];
    NSString * onlineAlixPayOrderId = [GlobalValue getGlobalValueInstance].alixpayOrderId;
    if (result) {
            //是否支付成功
        if (9000 == result.statusCode) {
            [controller enterOrderDone:onlineAlixPayOrderId];
        }
        //如果支付失败,可以通过result.statusCode查询错误码
        else {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:result.statusMessage
                                                                    delegate:self
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
            alertView.tag = ALIXPAYERROR;
            [alertView show];
            [alertView release];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == ALIXPAYERROR) {
        SharedDelegate.m_GpsAlertDisAble = NO;
	}
}


//将url数据封装成AlixPayResult使用,允许外部商户自行优化
- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [[[AlixPayResult alloc] initWithResultString:query] autorelease];
}

-(void)enterNNPiece{    // 进入N元N件页面
    NSNumber* promotionId = [self strToNumber:[OTSUtility safeObjectAtIndex:0 inArray:pramaArr]];
    NSNumber* levelId = [self strToNumber:[OTSUtility safeObjectAtIndex:1 inArray:pramaArr]];
    
    OTSNNPiecesVC* vc = [[[OTSNNPiecesVC alloc] init] autorelease];
    [vc setPromotionId:promotionId];
    [vc setPromotionLevelId:levelId];
    [vc setNnpiecesTitle:@"促销活动"];
    self.isNeedChangeProvince = NO;
    [self maskToCorrectVC:vc isFullScreen:NO];
}
-(void)enterPromoCutOff{

    NSNumber* promotionId = [self strToNumber:[OTSUtility safeObjectAtIndex:0 inArray:pramaArr]];
    
    CategoryProductsViewController *cateProduct = [[[CategoryProductsViewController alloc] init] autorelease] ;
    [cateProduct setCateId:[NSNumber numberWithInt:0]];
    [cateProduct setTitleLableText:@"促销活动"];
    [cateProduct setTitleText:@"促销活动"];
    [cateProduct setCanJoin:NO];
    [cateProduct setPromotionId:promotionId];
    [cateProduct setIsCashPromotionList:YES];
    [cateProduct setIsFailSatisfyFullDiscount:YES];
    
    [self setIsNeedChangeProvince:NO];
    [self maskToCorrectVC:cateProduct isFullScreen:YES];
}

//-(void)handleSchemeUrl:(NSURL*)url{
//    [self parseWithURL:url];
//    switch (urlType) {
//        case EURLType_CMS:{
//
//            break;
//        }
//        case EURLtype_Product:{
//
//            break;
//        }
//        case EURLtype_Goupon:{
//
//            break;
//        }
//        case EURLtype_RockBuy:{
//
//            break;
//        }
//        case EURLtype_Search:{
//
//            break;
//        }
//        case EURLtype_PromoFree:{
//
//            break;
//        }
//        case EURLtype_PromoNN:{
//
//            break;
//        }
//        case EURLtype_PromoCutOff:{
//            
//            break;
//        }
//        default:
//            break;
//    }
//}
@end
