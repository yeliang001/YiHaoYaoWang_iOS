//
//  VirtualService.m
//  TheStoreApp
//
//  Created by zhengchen on 11-12-2.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//

#import "VirtualService.h"
#import "XStream.h"

@implementation VirtualService

+(Page *) getHomeHotPointList{
    NSString *result = @"<com.yihaodian.mobile.vo.core.Page>"
    "<currentPage>1</currentPage>"
    "<pageSize>5</pageSize>"
    "<totalSize>8</totalSize>"
    "<objList>"
    "<com.yihaodian.mobile.vo.product.HotPointVO>"
    "<hotProduct>"
    "<productId>20110902399</productId>"
    "<merchantIds/>"
    "<cnName></cnName>"
    "<hotProductUrl>http://m.yihaodian.com/images/hot5/20110923/440x190x100.png</hotProductUrl>"
    "<hotProductUrlForWinSys>http://m.yihaodian.com/images/hot5/20110923/300x300_100.png</hotProductUrlForWinSys>"
    "<maketPrice>0.0</maketPrice>"
    "<price>0.0</price>"
    "<canBuy>true</canBuy>"
    "<description></description>"
    "<advertisement></advertisement>"
    "</hotProduct>"
    "<title>街旁分享活动规则</title>"
    "<detailUrl>http://m.yihaodian.com/showdesc</detailUrl>"
    "<type>2</type>"
    "</com.yihaodian.mobile.vo.product.HotPointVO>"
    "<com.yihaodian.mobile.vo.product.HotPointVO>"
    "<hotProduct>"
    "<productId>1</productId>"
    "<merchantIds/>"
    "<cnName></cnName>"
    "<hotProductUrl>http://m.yihaodian.com/images/hot5/20110923/440x190x100.png</hotProductUrl>"
    "<hotProductUrlForWinSys>http://m.yihaodian.com/images/hot5/20110923/300x300_100.png</hotProductUrlForWinSys>"
    "<maketPrice>0.0</maketPrice>"
    "<price>0.0</price>"
    "<canBuy>true</canBuy>"
    "<description></description>"
    "<advertisement></advertisement>"
    "</hotProduct>"
    "<title>街旁分享活动规则</title>"
    "<detailUrl>http://m.yihaodian.com/showdesc</detailUrl>"
    "<type>2</type>"
    "</com.yihaodian.mobile.vo.product.HotPointVO>"
    "<com.yihaodian.mobile.vo.product.HotPointVO>"
    "<hotProduct>"
    "<productId>1</productId>"
    "<merchantIds/>"
    "<cnName></cnName>"
    "<hotProductUrl>http://m.yihaodian.com/images/hot5/20110923/440x190x100.png</hotProductUrl>"
    "<hotProductUrlForWinSys>http://m.yihaodian.com/images/hot5/20110923/300x300_100.png</hotProductUrlForWinSys>"
    "<maketPrice>0.0</maketPrice>"
    "<price>0.0</price>"
    "<canBuy>true</canBuy>"
    "<description></description>"
    "<advertisement></advertisement>"
    "</hotProduct>"
    "<title>街旁分享活动规则</title>"
    "<detailUrl>http://m.yihaodian.com/actdesc/2011070105</detailUrl>"
    "<type>2</type>"
    "</com.yihaodian.mobile.vo.product.HotPointVO>"
    "<com.yihaodian.mobile.vo.product.HotPointVO>"
    "<hotProduct>"
    "<productId>2011070701</productId>"
    "<merchantIds/>"
    "<hotProductUrl>http://m.yihaodian.com/images/hot5/20110707/440x190.jpg</hotProductUrl>"
    "<hotProductUrlForWinSys>http://m.yihaodian.com/images/hot5/20110707/300x300.jpg</hotProductUrlForWinSys>"
    "<maketPrice>0.0</maketPrice>"
    "<price>0.0</price>"
    "<canBuy>true</canBuy>"
    "<description></description>"
    "<advertisement></advertisement>"
    "</hotProduct>"
    "<title></title>"
    "<detailUrl>http://m.yihaodian.com/page/greetings</detailUrl>"
    "<type>2</type>"
    "</com.yihaodian.mobile.vo.product.HotPointVO>"
    "<com.yihaodian.mobile.vo.product.HotPointVO>"
    "<hotProduct>"
    "<productId>2011070103</productId>"
    "<merchantIds/>"
    "<hotProductUrl>http://m.yihaodian.com/images/hot5/20110628/440x190_03.jpg</hotProductUrl>"
    "<hotProductUrlForWinSys>http://m.yihaodian.com/images/hot5/20110628/300x300_03.jpg</hotProductUrlForWinSys>"
    "<maketPrice>0.0</maketPrice>"
    "<price>0.0</price>"
    "<canBuy>true</canBuy>"
    "<description></description>"
    "<advertisement></advertisement>"
    "</hotProduct>"
    "<title>厨卫产品全场5折惊爆价</title>"
    "<detailUrl>http://m.yihaodian.com/act/2011070103</detailUrl>"
    "<type>1</type>"
    "</com.yihaodian.mobile.vo.product.HotPointVO>"
    "</objList>"
    "</com.yihaodian.mobile.vo.core.Page>";
    
    XStream  *stream = [XStream getInstance];
    Page * page = (Page *)[[stream fromXML: [result  dataUsingEncoding:NSUTF8StringEncoding] ] retain];
    return  [page autorelease];
}

+(DownloadVO*) getClientApplicationDownloadUrl{
    NSString * result = @"<com.yihaodian.mobile.vo.system.DownloadVO>"
    "<downloadUrl></downloadUrl>"
    "<canUpdate>false</canUpdate>"
    "<forceUpdate>false</forceUpdate>"
    "<remark></remark>"
    "</com.yihaodian.mobile.vo.system.DownloadVO>";
    XStream  *stream = [XStream getInstance];
    DownloadVO * obj = (DownloadVO *)[[stream fromXML:[result  dataUsingEncoding:NSUTF8StringEncoding]] retain];
    return  [obj autorelease];

}

+(NSString *) login{
    NSString * result = @"<string>1</string>";
    XStream  *stream = [XStream getInstance];
    NSString * obj = (NSString *)[[stream fromXML:[result  dataUsingEncoding:NSUTF8StringEncoding]] retain];
    return  [obj autorelease];
}

+(ProductVO*) getProductDetailComment{
    NSString * result = @"<com.yihaodian.mobile.vo.product.ProductVO>"
    "<productId>3681</productId>"
    "<merchantIds/>"
    "<maketPrice>0.0</maketPrice>"
    "<price>0.0</price>"
    "<canBuy>true</canBuy>"
    "<description></description>"
    "<rating>"
    "<totalExperiencesCount>30396</totalExperiencesCount>"
    "<goodExperiencesCount>30343</goodExperiencesCount>"
    "<middleExperiencesCount>30439</middleExperiencesCount>"
    "<badExperiencesCount>2</badExperiencesCount>"
    "<goodRating>0.9983</goodRating>"
    "<middleRating>0.0017</middleRating>"
    "<badRating>0.0</badRating>"
    "<top5Experience>"
    "<com.yihaodian.mobile.vo.product.ProductExperienceVO>"
    "<userName>GMHWBSBRZMBTXRBMCFSW</userName>"
    "<content>東西很好吃，贊一個！</content>"
    "<contentGood>東西很好吃，贊一個！</contentGood>"
    "<contentFail>暂时还没发现缺点哦！</contentFail>"
    "<createtime class=\"sql-timestamp\">2011-11-10 19:51:50.0</createtime>"
    "<ratingLog>5</ratingLog>"
    "</com.yihaodian.mobile.vo.product.ProductExperienceVO>"
    "<com.yihaodian.mobile.vo.product.ProductExperienceVO>"
    "<userName>HVEOOAPCNBEWMHVPKTJS</userName>"
    "<content>不错哟~</content>"
    "<contentGood>不错哟~</contentGood>"
    "<contentFail>暂时还没发现缺点哦！</contentFail>"
    "<createtime class=\"sql-timestamp\">2011-11-09 18:09:10.0</createtime>"
    "<ratingLog>5</ratingLog>"
    "</com.yihaodian.mobile.vo.product.ProductExperienceVO>"
    "<com.yihaodian.mobile.vo.product.ProductExperienceVO>"
    "<userName>XTJIVQXXPDRFAUYHVAYM</userName>"
    "<content>力推.....力推....</content>"
    "<contentGood>力推.....力推....</contentGood>"
    "<contentFail>暂时还没发现缺点哦！</contentFail>"
    "<createtime class=\"sql-timestamp\">2011-11-09 11:25:24.0</createtime>"
    "<ratingLog>5</ratingLog>"
    "</com.yihaodian.mobile.vo.product.ProductExperienceVO>"
    "<com.yihaodian.mobile.vo.product.ProductExperienceVO>"
    "<userName>RTFCBBBDPRLEPUMBTLAB</userName>"
    "<content>价格跟超市差不多 省的自己拎了</content>"
    "<contentGood>价格跟超市差不多 省的自己拎了</contentGood>"
    "<contentFail>暂时还没发现缺点哦！</contentFail>"
    "<createtime class=\"sql-timestamp\">2011-11-07 14:45:22.0</createtime>"
    "<ratingLog>5</ratingLog>"
    "</com.yihaodian.mobile.vo.product.ProductExperienceVO>"
    "<com.yihaodian.mobile.vo.product.ProductExperienceVO>"
    "<userName>CZXBSDPHBVEWENFCWQZF</userName>"
    "<content>爱吃的薯片，哈哈。。。。。。</content>"
    "<contentGood>爱吃的薯片，哈哈。。。。。。</contentGood>"
    "<contentFail>暂时还没发现缺点哦！</contentFail>"
    "<createtime class=\"sql-timestamp\">2011-11-07 13:07:01.0</createtime>"
    "<ratingLog>5</ratingLog>"
    "</com.yihaodian.mobile.vo.product.ProductExperienceVO>"
    "</top5Experience>"
    "</rating>"
    "<advertisement></advertisement>"
    "</com.yihaodian.mobile.vo.product.ProductVO>";
    XStream  *stream = [XStream getInstance];
    ProductVO * obj = (ProductVO *)[[stream fromXML:[result  dataUsingEncoding:NSUTF8StringEncoding]] retain];
    return  [obj autorelease];
}

+(Page*) getUserInterestedProducts{
    NSString * result = @"<com.yihaodian.mobile.vo.core.Page>"
    "<currentPage>1</currentPage>"
    "<pageSize>10</pageSize>"
    "<totalSize>2</totalSize>"
    "<objList>"
    "<com.yihaodian.mobile.vo.product.ProductVO>"
    "<productId>4473</productId>"
    "<merchantIds/>"
    "<merchantId>1</merchantId>"
    "<code>0000044735</code>"
    "<cnName>棒棒娃 手撕牛肉(五香)36g</cnName>"
    "<midleDefaultProductUrl>http://d1.yihaodianimg.com/t1/2011/09/20/2676260_200x200.jpg</midleDefaultProductUrl>"
    "<miniDefaultProductUrl>http://d1.yihaodianimg.com/t1/2011/09/20/2676260_80x80.jpg</miniDefaultProductUrl>"
    "<maketPrice>19.0</maketPrice>"
    "<price>0.0</price>"
    "<canBuy>true</canBuy>"
    "<description></description>"
    "<advertisement></advertisement>"
    "</com.yihaodian.mobile.vo.product.ProductVO>"
    "<com.yihaodian.mobile.vo.product.ProductVO>"
    "<productId>3681</productId>"
    "<merchantIds/>"
    "<merchantId>1</merchantId>"
    "<code>0000036817</code>"
    "<cnName>乐事 得克萨斯烧烤味80g/袋</cnName>"
    "<midleDefaultProductUrl>http://d1.yihaodianimg.com/t1/2011/09/20/2676797_200x200.jpg</midleDefaultProductUrl>"
    "<miniDefaultProductUrl>http://d1.yihaodianimg.com/t1/2011/09/20/2676797_80x80.jpg</miniDefaultProductUrl>"
    "<maketPrice>6.9</maketPrice>"
    "<price>0.0</price>"
    "<canBuy>true</canBuy>"
    "<description></description>"
    "<advertisement></advertisement>"
    "</com.yihaodian.mobile.vo.product.ProductVO>"
    "</objList>"
    "</com.yihaodian.mobile.vo.core.Page>";
    XStream  *stream = [XStream getInstance];
    Page * obj = (Page *)[[stream fromXML:[result  dataUsingEncoding:NSUTF8StringEncoding]] retain];
    return  [obj autorelease];
}
@end
