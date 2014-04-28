//
//  ProductVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-1-19.
//  Copyright 2011 vsc. All rights reserved.
//

#import "ProductVO.h"
#import "ProductRatingVO.h"

@implementation ProductVO
@synthesize product600x600Url;
@synthesize product380x380Url;
@synthesize product80x80Url;
@synthesize advertisement;
@synthesize brandName;
@synthesize canBuy;
@synthesize cnName;
@synthesize code;
@synthesize description;
@synthesize enName;
@synthesize hotProductUrl;
@synthesize hotProductUrlForWinSys;
@synthesize maketPrice;
@synthesize merchantId;
@synthesize merchantIds;
@synthesize midleDefaultProductUrl;
@synthesize midleProductUrl;
@synthesize miniDefaultProductUrl;
@synthesize price;
@synthesize productId;
@synthesize rating;
@synthesize shoppingCount;
@synthesize promotionId;
@synthesize promotionPrice;
@synthesize isYihaodian;
@synthesize experienceCount;
@synthesize score;
@synthesize buyCount;
@synthesize hasGift;//是否有赠品，0没有，1有
@synthesize stockNumber;//商品库存
@synthesize mobileProductType;//商品类型 1表示为1起摇商品
@synthesize rockJoinPeopleNum;//该商品的1起摇参加人数
@synthesize totalQuantityLimit;//商品的限制数量(赠品的限制数量)，根据限制类型来设置，若赠品类型为-1，则返回"限量当前库存xx个"，若为2则返回"每日限量xx个"，若为1则返回"限量xx个"
@synthesize quantity;//赠品的赠送数量
@synthesize isSoldOut;//赠品是否已售完
@synthesize isGift;//商品是否为赠品，1表示为赠品，0表示否，主要用于在订单中标识是否为赠品
@synthesize promotionSalePercent;//促销已售百分比=已销售数量/促销限制数量
@synthesize stockDesc;
@synthesize purchaseAmount = _purchaseAmount;
@synthesize hasCash;       //满减活动  ""或者NULL表示没有满减活动其他表示满减活动的名称
@synthesize hasRedemption; //商品是否参与换购，1表示为是，0表示否，主要用于在订单中标识是否参与换购
@synthesize colorList;            // 系列产品所有尺寸属性集合,数组对象为SeriesColorVO
@synthesize sizeList;             // 系列商品集合,数组对象为nsstring
@synthesize seriesProductVOList;  // 系列商品集合,数组对象为SeriesProductVO
@synthesize famousSalePrice;      // 名品特卖价格
@synthesize merchantInfoVO;       // 商家信息
@synthesize isMingPin;                   // 0-非名品特卖；1-名品特卖（空表示不是特价商品取商城价）
@synthesize mingPinRemainTimes;          // 距离名品特卖结束时间(毫秒)
@synthesize mallDefaultURL;      // 店中店地址
@synthesize offerName;//N元n件活动名称
@synthesize isFresh; //是否生鲜商品  1-是，0-不是
@synthesize cmsPointProduct;//CMS积分兑换商品 1-是、0-不是
@synthesize activitypoint ;//商品需要的积分
@synthesize startTime;     //促销开始时间
@synthesize endTime;       //促销结束时间
@synthesize canSecKill;           //商品是否可以秒杀 true/false
@synthesize ifSecKill;           //商品是否是秒杀

-(ProductVO*)clone
{
    ProductVO *clone = [[[ProductVO alloc] init] autorelease];
    
    clone.product600x600Url = self.product600x600Url;
    clone.product380x380Url = self.product380x380Url;
    clone.product80x80Url = self.product80x80Url;
    clone.advertisement = self.advertisement;
    clone.brandName = self.brandName;
    clone.canBuy = self.canBuy;
    clone.cnName = self.cnName;
    clone.code = self.code;
    clone.description = self.description;
    clone.enName = self.enName;
    clone.hotProductUrl = self.hotProductUrl;
    clone.hotProductUrlForWinSys = self.hotProductUrlForWinSys;
    clone.maketPrice = self.maketPrice;
    clone.merchantId = self.merchantId;
    clone.merchantIds = self.merchantIds;
    clone.midleDefaultProductUrl = self.midleDefaultProductUrl;
    clone.midleProductUrl = self.midleProductUrl;
    clone.miniDefaultProductUrl = self.miniDefaultProductUrl;
    clone.price = self.price;
    clone.productId = self.productId;
    clone.rating = self.rating;
    clone.shoppingCount = self.shoppingCount;
    clone.promotionId = self.promotionId;
    clone.promotionPrice = self.promotionPrice;
    clone.isYihaodian = self.isYihaodian;
    clone.experienceCount = self.experienceCount;
    clone.score = self.score;
    clone.buyCount = self.buyCount;
    clone.hasGift = self.hasGift;
    clone.stockNumber = self.stockNumber;
    clone.mobileProductType = self.mobileProductType;
    clone.rockJoinPeopleNum = self.rockJoinPeopleNum;
    clone.totalQuantityLimit = self.totalQuantityLimit;
    clone.quantity = self.quantity;
    clone.isSoldOut = self.isSoldOut;
    clone.isGift = self.isGift;
    clone.promotionSalePercent = self.promotionSalePercent;
    clone.stockDesc = self.stockDesc;
    clone.purchaseAmount = self.purchaseAmount;
    clone.hasCash = self.hasCash;
    clone.hasRedemption = self.hasRedemption;
    clone.colorList = self.colorList;
    clone.sizeList = self.sizeList;
    clone.seriesProductVOList = self.seriesProductVOList;
    clone.famousSalePrice = self.famousSalePrice;
    clone.merchantInfoVO = self.merchantInfoVO;
    clone.isMingPin = self.isMingPin;
    clone.mingPinRemainTimes = self.mingPinRemainTimes;
    clone.mallDefaultURL =  self.mallDefaultURL;
    clone.isFresh = self.isFresh;
    clone.startTime = self.startTime;
    clone.endTime = self.endTime;
    
    return clone;
}
-(NSString *)toXML
{
    // NSMutableString *string=[[[NSMutableString alloc] initWithString:@"<com.yihaodian.mobile.vo.product.ProductVO>"] autorelease];
    NSMutableString *string=[[[NSMutableString alloc] initWithString:@""] autorelease];
    if ([self productId]!=nil) {
        [string appendFormat:@"<productId>%@</productId>",[self productId]];
    }
    if ([self promotionId]!=nil) {
        [string appendFormat:@"<promotionId>%@</promotionId>",[self promotionId]];
    }
    if ([self merchantId]!=nil) {
        [string appendFormat:@"<merchantId>%@</merchantId>",[self merchantId]];
    }
    //    [string appendString:@"</com.yihaodian.mobile.vo.product.ProductVO>"];
    return string;
}
-(NSString*)miniURL
{
    return miniDefaultProductUrl;
}

-(NSString*)mallURL
{
    return mallDefaultURL;
}

-(NSString*)realPromotionID
{
    self.promotionId = self.promotionId ? self.promotionId : @"";
    return promotionId;
}

-(BOOL)isTheSameWithProduct:(ProductVO*)aProductVO
{
    return [self.productId intValue] == [aProductVO.productId intValue]
    && [self.realPromotionID isEqualToString:aProductVO.realPromotionID];
}

-(BOOL)isInPromotion
{
    return promotionId && [promotionId length] > 0;
}

-(BOOL)isLandingPage
{
    if ([self isInPromotion])
    {
        NSRange range = [promotionId rangeOfString:@"landingpage"];
        if (range.location != NSNotFound)
        {
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)isCanBuy
{
    return canBuy && [canBuy isEqualToString:@"true"];
}

-(BOOL)isGiftProduct
{
    return self.isGift && [self.isGift intValue] == 1;
}

-(BOOL)isProductSoldOut
{
    return self.isSoldOut && [self.isSoldOut intValue] == 1;
}

-(BOOL)isJoinCash
{
    return self.hasCash && self.hasCash.length>0;
}

-(BOOL)isJoinRedemption
{
    return self.hasRedemption && [self.hasRedemption intValue] == 1;
}

-(BOOL)isFreshProduct
{
    return self.isFresh && [self.isFresh intValue] == 1;
}

-(NSNumber*)realPrice
{
    return [self isInPromotion] ? promotionPrice : price;
}

//是否秒杀商品
-(BOOL)isSeckillProduct{
    
    if ([self startTime] && [self endTime]) {
        return YES;
    }
    return  NO;
    
}

//能否秒杀
-(BOOL)canSecKillProduct
{
    if([[self canSecKill] isEqualToString:@"false"]||[self canSecKill] ==nil)
    {
        return NO;
    }
    return YES;
}

//是否是秒杀商品
-(BOOL)ifSeckillProduct
{
    if([[self ifSecKill] isEqualToString:@"false"]||[self ifSecKill] == nil)
    {
        return NO;
    }
    return YES;
}

//秒杀结束
-(BOOL)SeckillEnd{
    BOOL sEND = YES;
    if ([self isSeckillProduct] && [self ifSeckillProduct]) {
        NSDate*  nowDate	= [NSDate date];//现在时间
        NSTimeInterval secondsBetweenDates =  [endTime timeIntervalSinceDate: nowDate];
//        NSLog(@"secondsBetweenDates %f",secondsBetweenDates);
        if (secondsBetweenDates>0) {
            sEND = NO;
        }
        else
            sEND = YES;
    }
    return sEND;
}

// 秒杀倒计时
-(NSString *)SeckillCountdown{
    
    NSString * countdown = @"";
    if ([self isSeckillProduct] && [self ifSeckillProduct]) {
        NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
        NSDate*  startDate	= [[NSDate alloc] init];//开始时间也就是现在时间
        //时区设置
        NSUInteger unitFlags =	NSHourCalendarUnit | NSMinuteCalendarUnit |
        NSSecondCalendarUnit | NSDayCalendarUnit;
//        NSDateComponents *cps = [ chineseClendar components:unitFlags fromDate:startDate  toDate:endTime  options:0];
        NSDateComponents *cps = [ chineseClendar components:unitFlags fromDate:startDate  toDate:endTime  options:0];
        NSInteger diffHour = [ cps hour ];
        NSInteger diffMin    = [ cps minute ];
        NSInteger diffSec   = [ cps second ];
        NSInteger diffDay   = [ cps day ];

        NSString * secValue;
        NSString * hourValue;
        NSString * minuteValue;
        //统一成两位数
        if(diffHour<10)
            hourValue = [NSString stringWithFormat:@"0%d",diffHour];
        else
            hourValue = [NSString stringWithFormat:@"%d",diffHour];
        if(diffMin<10)
            minuteValue = [NSString stringWithFormat:@"0%d",diffMin];
        else
            minuteValue = [NSString stringWithFormat:@"%d",diffMin];
        if(diffSec<10)
            secValue = [NSString stringWithFormat:@"0%d",diffSec];
        else
            secValue = [NSString stringWithFormat:@"%d",diffSec];
        
        [ startDate release ];
        [ chineseClendar release ];
        
        countdown = [NSString stringWithFormat:@"%d天%@小时%@分%@秒",diffDay,hourValue,minuteValue,secValue];
    }
    return countdown;
}

-(NSString*)priceStringTrimZero:(NSNumber*)aPrice
{
    NSString *priceStr = [NSString stringWithFormat:@"￥%.2f", [aPrice floatValue]];
    
    while (priceStr.length > 0)
    {
        NSString *lastStr = [priceStr substringFromIndex:(priceStr.length - 1)];
        if ([lastStr isEqualToString:@"."])
        {
            priceStr = [priceStr substringToIndex:(priceStr.length - 1)];
            break;
        }
        else if ([lastStr isEqualToString:@"0"])
        {
            priceStr = [priceStr substringToIndex:(priceStr.length - 1)];
        }
        else
        {
            break;
        }
    }
    
    return priceStr;
}

- (void)dealloc{
    if(advertisement!=nil){
        [advertisement release];
    }
    if(brandName!=nil){
        [brandName release];
    }
    if(canBuy!=nil){
        [canBuy release];
    }
    if(cnName!=nil){
        [cnName release];
    }
    if(code!=nil){
        [code release];
    }
    if(description!=nil){
        [description release];
    }
    if(enName!=nil){
        [enName release];
    }
    if(hotProductUrl!=nil){
        [hotProductUrl release];
    }
    if(hotProductUrlForWinSys!=nil){
        [hotProductUrlForWinSys release];
    }
    if(maketPrice!=nil){
        [maketPrice release];
    }
    if(merchantId!=nil){
        [merchantId release];
    }
    
    
    //    if(merchantIds!=nil){
    //        [merchantIds removeAllObjects];
    //        [merchantIds release];
    //    }
    
    OTS_SAFE_RELEASE(merchantIds);
    
    if(midleDefaultProductUrl!=nil){
        [midleDefaultProductUrl release];
    }
    if(midleProductUrl!=nil){
        [midleProductUrl removeAllObjects];
        [midleProductUrl release];
    }
    if(miniDefaultProductUrl!=nil){
        [miniDefaultProductUrl release];
    }
    if(price!=nil){
        [price release];
    }
    if(productId!=nil){
        [productId release];
    }
    if(rating!=nil){
        [rating release];
    }
    if(shoppingCount!=nil){
        [shoppingCount release];
    }
    if(productId != nil){
        [promotionId release];
    }
    if(promotionPrice != nil) {
        [promotionPrice release];
    }
    if(isYihaodian!=nil) {
        [isYihaodian release];
    }
    if(experienceCount!=nil) {
        [experienceCount release];
    }
    if(score!=nil) {
        [score release];
    }
    if (buyCount!=nil) {
        [buyCount release];
    }
    if (hasGift!=nil) {
        [hasGift release];
        hasGift=nil;
    }
    if (stockNumber!=nil) {
        [stockNumber release];
        stockNumber=nil;
    }
    if (mobileProductType!=nil) {
        [mobileProductType release];
        mobileProductType=nil;
    }
    if (rockJoinPeopleNum!=nil) {
        [rockJoinPeopleNum release];
        rockJoinPeopleNum=nil;
    }
    if (totalQuantityLimit!=nil) {
        [totalQuantityLimit release];
        totalQuantityLimit=nil;
    }
    if (quantity!=nil) {
        [quantity release];
        quantity=nil;
    }
    if (isSoldOut!=nil) {
        [isSoldOut release];
        isSoldOut=nil;
    }
    if (isGift!=nil) {
        [isGift release];
        isGift=nil;
    }
    if (promotionSalePercent!=nil) {
        [promotionSalePercent release];
        promotionSalePercent=nil;
    }
    
    [stockDesc release];
    if (product380x380Url!=nil) {
        [product380x380Url release];
    }
    if (product600x600Url!=nil) {
        [product600x600Url release];
    }
    if (product80x80Url!=nil) {
        [product80x80Url release];
    }
    
    OTS_SAFE_RELEASE(hasCash);
    OTS_SAFE_RELEASE(hasRedemption);
    
    OTS_SAFE_RELEASE(colorList);
    OTS_SAFE_RELEASE(sizeList);
    OTS_SAFE_RELEASE(seriesProductVOList);
    OTS_SAFE_RELEASE(famousSalePrice);
    OTS_SAFE_RELEASE(merchantInfoVO);
    OTS_SAFE_RELEASE(mallDefaultURL);
    OTS_SAFE_RELEASE(isMingPin);
    OTS_SAFE_RELEASE(mingPinRemainTimes);
    OTS_SAFE_RELEASE(isFresh);
    OTS_SAFE_RELEASE(activitypoint);
    OTS_SAFE_RELEASE(cmsPointProduct);
    OTS_SAFE_RELEASE(startTime);
    OTS_SAFE_RELEASE(endTime);
    OTS_SAFE_RELEASE(canSecKill);
    OTS_SAFE_RELEASE(ifSecKill);
	[super dealloc];
}

-(NSMutableDictionary *)dictionaryFromVO
{
    NSMutableDictionary *mDictionary=[[[NSMutableDictionary alloc] init] autorelease];
    if (advertisement!=nil) {
        [mDictionary setObject:advertisement forKey:@"advertisement"];
    }
    if (brandName!=nil) {
        [mDictionary setObject:brandName forKey:@"brandName"];
    }
    if (canBuy!=nil) {
        [mDictionary setObject:canBuy forKey:@"canBuy"];
    }
    if (cnName!=nil) {
        [mDictionary setObject:cnName forKey:@"cnName"];
    }
    if (code!=nil) {
        [mDictionary setObject:code forKey:@"code"];
    }
    if (description!=nil) {
        [mDictionary setObject:description forKey:@"description"];
    }
    if (enName!=nil) {
        [mDictionary setObject:enName forKey:@"enName"];
    }
    if (hotProductUrl!=nil) {
        [mDictionary setObject:hotProductUrl forKey:@"hotProductUrl"];
    }
    if (hotProductUrlForWinSys!=nil) {
        [mDictionary setObject:hotProductUrlForWinSys forKey:@"hotProductUrlForWinSys"];
    }
    if (merchantId!=nil) {
        [mDictionary setObject:merchantId forKey:@"merchantId"];
    }
    if (merchantIds!=nil) {
        [mDictionary setObject:merchantIds forKey:@"merchantIds"];
    }
    if (midleDefaultProductUrl!=nil) {
        [mDictionary setObject:midleDefaultProductUrl forKey:@"midleDefaultProductUrl"];
    }
    if (midleProductUrl!=nil) {
        [mDictionary setObject:midleProductUrl forKey:@"midleProductUrl"];
    }
    if (miniDefaultProductUrl!=nil) {
        [mDictionary setObject:miniDefaultProductUrl forKey:@"miniDefaultProductUrl"];
    }
    if (product600x600Url!=nil) {
        [mDictionary setObject:product600x600Url forKey:@"product600x600Url"];
    }
    if (product380x380Url!=nil) {
        [mDictionary setObject:product380x380Url forKey:@"product380x380Url"];
    }
    if (product80x80Url!=nil) {
        [mDictionary setObject:product80x80Url forKey:@"product80x80Url"];
    }
    if (maketPrice!=nil) {
        [mDictionary setObject:maketPrice forKey:@"maketPrice"];
    }
    if (price!=nil) {
        [mDictionary setObject:price forKey:@"price"];
    }
    if (promotionPrice!=nil) {
        [mDictionary setObject:promotionPrice forKey:@"promotionPrice"];
    }
    if (productId!=nil) {
        [mDictionary setObject:productId forKey:@"productId"];
    }
    if (rating!=nil) {
        [mDictionary setObject:[rating dictionaryFromVO] forKey:@"rating"];
    }
    if (shoppingCount!=nil) {
        [mDictionary setObject:shoppingCount forKey:@"shoppingCount"];
    }
    if (promotionId!=nil) {
        [mDictionary setObject:promotionId forKey:@"promotionId"];
    }
    if (isYihaodian!=nil) {
        [mDictionary setObject:isYihaodian forKey:@"isYihaodian"];
    }
    if (experienceCount!=nil) {
        [mDictionary setObject:experienceCount forKey:@"experienceCount"];
    }
    if (score!=nil) {
        [mDictionary setObject:score forKey:@"score"];
    }
    if (buyCount!=nil) {
        [mDictionary setObject:buyCount forKey:@"buyCount"];
    }
    if (hasGift!=nil) {
        [mDictionary setObject:hasGift forKey:@"hasGift"];
    }
    if (stockNumber!=nil) {
        [mDictionary setObject:stockNumber forKey:@"stockNumber"];
    }
    if (mobileProductType!=nil) {
        [mDictionary setObject:mobileProductType forKey:@"mobileProductType"];
    }
    if (rockJoinPeopleNum!=nil) {
        [mDictionary setObject:rockJoinPeopleNum forKey:@"rockJoinPeopleNum"];
    }
    if (totalQuantityLimit!=nil) {
        [mDictionary setObject:totalQuantityLimit forKey:@"totalQuantityLimit"];
    }
    if (quantity!=nil) {
        [mDictionary setObject:quantity forKey:@"quantity"];
    }
    if (isSoldOut!=nil) {
        [mDictionary setObject:isSoldOut forKey:@"isSoldOut"];
    }
    if (isGift!=nil) {
        [mDictionary setObject:isGift forKey:@"isGift"];
    }
    if (hasCash!=nil) {
        [mDictionary setObject:hasCash forKey:@"hasCash"];
    }
    if (hasRedemption!=nil) {
        [mDictionary setObject:hasRedemption forKey:@"hasRedemption"];
    }
    if (promotionSalePercent!=nil) {
        [mDictionary setObject:promotionSalePercent forKey:@"promotionSalePercent"];
    }
    if (stockDesc!=nil) {
        [mDictionary setObject:stockDesc forKey:@"stockDesc"];
    }
    
    if (colorList!=nil) {
        [mDictionary setObject:colorList forKey:@"colorList"];
    }
    if (sizeList!=nil) {
        [mDictionary setObject:sizeList forKey:@"sizeList"];
    }
    if (seriesProductVOList!=nil) {
        [mDictionary setObject:seriesProductVOList forKey:@"seriesProductVOList"];
    }
    if (famousSalePrice!=nil) {
        [mDictionary setObject:famousSalePrice forKey:@"famousSalePrice"];
    }
    if (merchantInfoVO!=nil) {
        [mDictionary setObject:[merchantInfoVO dictionaryFromVO] forKey:@"merchantInfoVO"];
    }
    if (isMingPin!=nil) {
        [mDictionary setObject:isMingPin forKey:@"isMingPin"];
    }
    if (mingPinRemainTimes != nil) {
        [mDictionary setObject:mingPinRemainTimes forKey:@"mingPinRemainTimes"];
    }
    if (mallDefaultURL!=nil) {
        [mDictionary setObject:mallDefaultURL forKey:@"mallDefaultURL"];
    }
    if (isFresh!=nil) {
        [mDictionary setObject:isFresh forKey:@"isFresh"];
    }
    if (startTime !=nil) {
        [mDictionary setObject:startTime forKey:@"startTime"];
    }
    if (endTime !=nil) {
        [mDictionary setObject:endTime forKey:@"endTime"];
    }
    
    return mDictionary;
}

-(BOOL)isLandingpage
{
    NSString *keyword = @"landingpage";
    if (self.promotionId && self.promotionId.length >= keyword.length)
    {
        if ([self.promotionId rangeOfString:keyword].location != NSNotFound)
        {
            return YES;
        }
    }
    
    return NO;
}


+(id)voFromDictionary:(NSMutableDictionary *)mDictionary
{
    ProductVO *vo=[[ProductVO alloc] autorelease];
    id object=[mDictionary objectForKey:@"advertisement"];
    if (object!=nil) {
        vo.advertisement=object;
    }
    object=[mDictionary objectForKey:@"brandName"];
    if (object!=nil) {
        vo.brandName=object;
    }
    object=[mDictionary objectForKey:@"canBuy"];
    if (object!=nil) {
        vo.canBuy=object;
    }
    object=[mDictionary objectForKey:@"cnName"];
    if (object!=nil) {
        vo.cnName=object;
    }
    object=[mDictionary objectForKey:@"code"];
    if (object!=nil) {
        vo.code=object;
    }
    object=[mDictionary objectForKey:@"description"];
    if (object!=nil) {
        vo.description=object;
    }
    object=[mDictionary objectForKey:@"enName"];
    if (object!=nil) {
        vo.enName=object;
    }
    object=[mDictionary objectForKey:@"hotProductUrl"];
    if (object!=nil) {
        vo.hotProductUrl=object;
    }
    object=[mDictionary objectForKey:@"hotProductUrlForWinSys"];
    if (object!=nil) {
        vo.hotProductUrlForWinSys=object;
    }
    object=[mDictionary objectForKey:@"merchantId"];
    if (object!=nil) {
        vo.merchantId=object;
    }
    object=[mDictionary objectForKey:@"merchantIds"];
    if (object!=nil) {
        vo.merchantIds=object;
    }
    object=[mDictionary objectForKey:@"midleDefaultProductUrl"];
    if (object!=nil) {
        vo.midleDefaultProductUrl=object;
    }
    object=[mDictionary objectForKey:@"midleProductUrl"];
    if (object!=nil) {
        vo.midleProductUrl=object;
    }
    object=[mDictionary objectForKey:@"miniDefaultProductUrl"];
    if (object!=nil) {
        vo.miniDefaultProductUrl=object;
    }
    object=[mDictionary objectForKey:@"product600x600Url"];
    if (object!=nil) {
        vo.product600x600Url=object;
    }
    object=[mDictionary objectForKey:@"product380x380Url"];
    if (object!=nil) {
        vo.product380x380Url=object;
    }
    object=[mDictionary objectForKey:@"product80x80Url"];
    if (object!=nil) {
        vo.product80x80Url=object;
    }
    object=[mDictionary objectForKey:@"maketPrice"];
    if (object!=nil) {
        vo.maketPrice=object;
    }
    object=[mDictionary objectForKey:@"price"];
    if (object!=nil) {
        vo.price=object;
    }
    object=[mDictionary objectForKey:@"promotionPrice"];
    if (object!=nil) {
        vo.promotionPrice=object;
    }
    object=[mDictionary objectForKey:@"productId"];
    if (object!=nil) {
        vo.productId=object;
    }
    object=[mDictionary objectForKey:@"rating"];
    if (object!=nil) {
        vo.rating=[ProductRatingVO voFromDictionary:object];
    }
    object=[mDictionary objectForKey:@"shoppingCount"];
    if (object!=nil) {
        vo.shoppingCount=object;
    }
    object=[mDictionary objectForKey:@"promotionId"];
    if (object!=nil) {
        vo.promotionId=object;
    }
    object=[mDictionary objectForKey:@"isYihaodian"];
    if (object!=nil) {
        vo.isYihaodian=object;
    }
    object=[mDictionary objectForKey:@"experienceCount"];
    if (object!=nil) {
        vo.experienceCount=object;
    }
    object=[mDictionary objectForKey:@"score"];
    if (object!=nil) {
        vo.score=object;
    }
    object=[mDictionary objectForKey:@"buyCount"];
    if (object!=nil) {
        vo.buyCount=object;
    }
    object=[mDictionary objectForKey:@"hasGift"];
    if (object!=nil) {
        vo.hasGift=object;
    }
    object=[mDictionary objectForKey:@"stockNumber"];
    if (object!=nil) {
        vo.stockNumber=object;
    }
    object=[mDictionary objectForKey:@"mobileProductType"];
    if (object!=nil) {
        vo.mobileProductType=object;
    }
    object=[mDictionary objectForKey:@"rockJoinPeopleNum"];
    if (object!=nil) {
        vo.rockJoinPeopleNum=object;
    }
    object=[mDictionary objectForKey:@"totalQuantityLimit"];
    if (object!=nil) {
        vo.totalQuantityLimit=object;
    }
    object=[mDictionary objectForKey:@"quantity"];
    if (object!=nil) {
        vo.quantity=object;
    }
    object=[mDictionary objectForKey:@"isSoldOut"];
    if (object!=nil) {
        vo.isSoldOut=object;
    }
    object=[mDictionary objectForKey:@"isGift"];
    if (object!=nil) {
        vo.isGift=object;
    }
    object=[mDictionary objectForKey:@"hasCash"];
    if (object!=nil) {
        vo.hasCash=object;
    }
    object=[mDictionary objectForKey:@"hasRedemption"];
    if (object!=nil) {
        vo.hasRedemption=object;
    }
    object=[mDictionary objectForKey:@"promotionSalePercent"];
    if (object!=nil) {
        vo.promotionSalePercent=object;
    }
    object=[mDictionary objectForKey:@"stockDesc"];
    if (object!=nil) {
        vo.stockDesc=object;
    }
    
    object=[mDictionary objectForKey:@"colorList"];
    if (object!=nil) {
        vo.colorList=object;
    }
    object=[mDictionary objectForKey:@"sizeList"];
    if (object!=nil) {
        vo.sizeList=object;
    }
    object=[mDictionary objectForKey:@"seriesProductVOList"];
    if (object!=nil) {
        vo.seriesProductVOList=object;
    }
    object=[mDictionary objectForKey:@"famousSalePrice"];
    if (object!=nil) {
        vo.famousSalePrice=object;
    }
    object=[mDictionary objectForKey:@"merchantInfoVO"];
    if (object!=nil) {
        vo.merchantInfoVO=[MerchantInfoVO voFromDictionary:object];;
    }
    object=[mDictionary objectForKey:@"isMingPin"];
    if (object!=nil) {
        vo.isMingPin=object;
    }
    object=[mDictionary objectForKey:@"mingPinRemainTimes"];
    if (object!=nil) {
        vo.mingPinRemainTimes=object;
    }
    object=[mDictionary objectForKey:@"mallDefaultURL"];
    if (object!=nil) {
        vo.mallDefaultURL = object;
    }
    object=[mDictionary objectForKey:@"isFresh"];
    if (object!=nil) {
        vo.isFresh = object;
    }
    object = [mDictionary objectForKey:@"startTime"];
    if (object!=nil) {
        vo.startTime = object;
    }
    object = [mDictionary objectForKey:@"endTime"];
    if (object!=nil) {
        vo.endTime = object;
    }
    return vo;
}
;
- (id)initWithCoder:(NSCoder *)aDecoder{
    self.advertisement=[aDecoder decodeObjectForKey:@"advertisement"];
    
    self.brandName=[aDecoder decodeObjectForKey:@"brandName"];
    
    self.canBuy=[aDecoder decodeObjectForKey:@"canBuy"];
    
    self.cnName=[aDecoder decodeObjectForKey:@"cnName"];
    
    self.code=[aDecoder decodeObjectForKey:@"code"];
    
    self.description=[aDecoder decodeObjectForKey:@"description"];
    
    self.enName=[aDecoder decodeObjectForKey:@"enName"];
    
    self.hotProductUrl=[aDecoder decodeObjectForKey:@"hotProductUrl"];
    
    self.hotProductUrlForWinSys=[aDecoder decodeObjectForKey:@"hotProductUrlForWinSys"];
    
    self.merchantId=[aDecoder decodeObjectForKey:@"merchantId"];
    
    self.merchantIds=[aDecoder decodeObjectForKey:@"merchantIds"];
    
    self.midleDefaultProductUrl=[aDecoder decodeObjectForKey:@"midleDefaultProductUrl"];
    
    self.midleProductUrl=[aDecoder decodeObjectForKey:@"midleProductUrl"];
    
    self.miniDefaultProductUrl=[aDecoder decodeObjectForKey:@"miniDefaultProductUrl"];
    
    self.product600x600Url=[aDecoder decodeObjectForKey:@"product600x600Url"];
    
    self.product380x380Url=[aDecoder decodeObjectForKey:@"product380x380Url"];
    
    self.product80x80Url=[aDecoder decodeObjectForKey:@"product80x80Url"];
    
    self.maketPrice=[aDecoder decodeObjectForKey:@"maketPrice"];
    
    self.price=[aDecoder decodeObjectForKey:@"price"];
    
    self.promotionPrice=[aDecoder decodeObjectForKey:@"promotionPrice"];
    
    self.productId=[aDecoder decodeObjectForKey:@"productId"];
    
    self.rating=[aDecoder decodeObjectForKey:@"rating"];
    
    self.shoppingCount=[aDecoder decodeObjectForKey:@"shoppingCount"];
    
    self.promotionId=[aDecoder decodeObjectForKey:@"promotionId"];
    
    self.isYihaodian=[aDecoder decodeObjectForKey:@"isYihaodian"];
    
    self.experienceCount=[aDecoder decodeObjectForKey:@"experienceCount"];
    
    self.score=[aDecoder decodeObjectForKey:@"score"];
    
    self.buyCount=[aDecoder decodeObjectForKey:@"buyCount"];
    
    self.hasGift=[aDecoder decodeObjectForKey:@"hasGift"];
    
    self.stockNumber=[aDecoder decodeObjectForKey:@"stockNumber"];
    
    self.mobileProductType=[aDecoder decodeObjectForKey:@"mobileProductType"];
    
    self.rockJoinPeopleNum=[aDecoder decodeObjectForKey:@"rockJoinPeopleNum"];
    
    self.totalQuantityLimit=[aDecoder decodeObjectForKey:@"totalQuantityLimit"];
    
    self.quantity=[aDecoder decodeObjectForKey:@"quantity"];
    
    self.isSoldOut=[aDecoder decodeObjectForKey:@"isSoldOut"];
    
    self.isGift=[aDecoder decodeObjectForKey:@"isGift"];
    
    self.hasCash=[aDecoder decodeObjectForKey:@"hasCash"];
    
    self.hasRedemption=[aDecoder decodeObjectForKey:@"hasRedemption"];
    
    self.promotionSalePercent=[aDecoder decodeObjectForKey:@"promotionSalePercent"];
    
    self.stockDesc=[aDecoder decodeObjectForKey:@"stockDesc"];
    
    self.colorList=[aDecoder decodeObjectForKey:@"colorList"];
    
    self.sizeList=[aDecoder decodeObjectForKey:@"sizeList"];
    
    self.seriesProductVOList=[aDecoder decodeObjectForKey:@"seriesProductVOList"];
    
    self.famousSalePrice=[aDecoder decodeObjectForKey:@"famousSalePrice"];
    
    self.merchantInfoVO=[aDecoder decodeObjectForKey:@"merchantInfoVO"];
    
    self.isMingPin=[aDecoder decodeObjectForKey:@"isMingPin"];
    
    self.mingPinRemainTimes=[aDecoder decodeObjectForKey:@"mingPinRemainTimes"];
    
    self.mallDefaultURL = [aDecoder decodeObjectForKey:@"mallDefaultURL"];
    
    self.isFresh = [aDecoder decodeObjectForKey:@"isFresh"];
    
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:advertisement forKey:@"advertisement"];
    
    [aCoder encodeObject:brandName forKey:@"brandName"];
    
    [aCoder encodeObject:canBuy forKey:@"canBuy"];
    
    [aCoder encodeObject:cnName forKey:@"cnName"];
    
    [aCoder encodeObject:code forKey:@"code"];
    
    [aCoder encodeObject:description forKey:@"description"];
    
    [aCoder encodeObject:enName forKey:@"enName"];
    
    [aCoder encodeObject:hotProductUrl forKey:@"hotProductUrl"];
    
    [aCoder encodeObject:hotProductUrlForWinSys forKey:@"hotProductUrlForWinSys"];
    
    [aCoder encodeObject:merchantId forKey:@"merchantId"];
    
    [aCoder encodeObject:merchantIds forKey:@"merchantIds"];
    
    [aCoder encodeObject:midleDefaultProductUrl forKey:@"midleDefaultProductUrl"];
    
    [aCoder encodeObject:midleProductUrl forKey:@"midleProductUrl"];
    
    [aCoder encodeObject:miniDefaultProductUrl forKey:@"miniDefaultProductUrl"];
    
    [aCoder encodeObject:product600x600Url forKey:@"product600x600Url"];
    
    [aCoder encodeObject:product380x380Url forKey:@"product380x380Url"];
    
    [aCoder encodeObject:product80x80Url forKey:@"product80x80Url"];
    
    [aCoder encodeObject:maketPrice forKey:@"maketPrice"];
    
    [aCoder encodeObject:price forKey:@"price"];
    
    [aCoder encodeObject:promotionPrice forKey:@"promotionPrice"];
    
    [aCoder encodeObject:productId forKey:@"productId"];
    
    [aCoder encodeObject:[rating dictionaryFromVO] forKey:@"rating"];
    
    [aCoder encodeObject:shoppingCount forKey:@"shoppingCount"];
    
    [aCoder encodeObject:promotionId forKey:@"promotionId"];
    
    [aCoder encodeObject:isYihaodian forKey:@"isYihaodian"];
    
    [aCoder encodeObject:experienceCount forKey:@"experienceCount"];
    
    [aCoder encodeObject:score forKey:@"score"];
    
    [aCoder encodeObject:buyCount forKey:@"buyCount"];
    
    [aCoder encodeObject:hasGift forKey:@"hasGift"];
    
    [aCoder encodeObject:stockNumber forKey:@"stockNumber"];
    
    [aCoder encodeObject:mobileProductType forKey:@"mobileProductType"];
    
    [aCoder encodeObject:rockJoinPeopleNum forKey:@"rockJoinPeopleNum"];
    
    [aCoder encodeObject:totalQuantityLimit forKey:@"totalQuantityLimit"];
    
    [aCoder encodeObject:quantity forKey:@"quantity"];
    
    [aCoder encodeObject:isSoldOut forKey:@"isSoldOut"];
    
    [aCoder encodeObject:isGift forKey:@"isGift"];
    
    [aCoder encodeObject:hasCash forKey:@"hasCash"];
    
    [aCoder encodeObject:hasRedemption forKey:@"hasRedemption"];
    
    [aCoder encodeObject:promotionSalePercent forKey:@"promotionSalePercent"];
    
    [aCoder encodeObject:stockDesc forKey:@"stockDesc"];
    
    [aCoder encodeObject:colorList forKey:@"colorList"];
    
    [aCoder encodeObject:sizeList forKey:@"sizeList"];
    
    [aCoder encodeObject:seriesProductVOList forKey:@"seriesProductVOList"];
    
    [aCoder encodeObject:famousSalePrice forKey:@"famousSalePrice"];
    
    [aCoder encodeObject:[merchantInfoVO dictionaryFromVO] forKey:@"merchantInfoVO"];
    
    [aCoder encodeObject:isMingPin forKey:@"isMingPin"];
    
    [aCoder encodeObject:mingPinRemainTimes forKey:@"mingPinRemainTimes"];
    
    [aCoder encodeObject:mallDefaultURL forKey:@"mallDefaultURL"];
    
    [aCoder encodeObject:isFresh forKey:@"isFresh"];
}

@end
