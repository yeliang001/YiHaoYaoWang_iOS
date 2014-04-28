//
//  JSTrackingPrama.m
//  TheStoreApp
//
//  Created by xuexiang on 13-1-11.
//
//

#import "JSTrackingPrama.h"
#import "GlobalValue.h"
#import "Trader.h"
#import "UserVO.h"
#import "OTSUtility.h"
#define HOSTURL @"http://tracker.yihaodian.com/tracker/info.do?1=1"
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define PramaType_Dic 0
#define PramaType_varPrama 1

@interface JSTrackingPrama ()
@property(nonatomic, retain)NSMutableArray* extraPramaArr;
@property(nonatomic)NSInteger pramaType;    // 标识传参类型，使用哪一个组装方法。 1.普通 2.可变参数
@end

@implementation JSTrackingPrama
@synthesize ieVersion;        
@synthesize platform;
@synthesize tracker_u;
@synthesize gu_id;
@synthesize merchant_id;
@synthesize session_id;
@synthesize exField10;
@synthesize infoPreviousUrl;
@synthesize infoTrackerSrc;
@synthesize endUserId;        
@synthesize extField6;
@synthesize cookie;
@synthesize fee;
@synthesize provinceId;
@synthesize cityId;
@synthesize infoPageId;       
@synthesize productId;
@synthesize linkPosition;
@synthesize buttonPosition;
@synthesize attachedInfo;
@synthesize jsoncallback;
@synthesize url;
@synthesize internalKeyWord;
@synthesize resultSum;
@synthesize orderCode;
@synthesize URLstr;
@synthesize otherPramaDic;
@synthesize trackingType;
@synthesize extraPramaArr;
@synthesize pramaType;

static NSString* staticPreviousURL = nil;
static NSString* staticFormerPreviousURL = nil;
static NSString* staticCategoryListURL = nil;
static NSString* staticSearchListURL = nil;

#pragma mark - begin,  ignroe the above
-(void)appendTheProperty{
    switch (self.trackingType) {
        case EJStracking_HomePage:
            self.infoTrackerSrc = [NSString stringWithFormat:@"http://m.yihaodian.com_%@",self.provinceId];
            self.url = @"http://m.yihaodian.com";
            break;
        case EJStracking_CategoryRoot:          // 需传入额外mcsiteId，分类ID
        {
            NSString* mcsiteId;
            NSString* categoryId;
            if (self.pramaType == PramaType_Dic) {
                mcsiteId = [self.otherPramaDic objectForKey:@"mcsiteId"];
                categoryId = [self.otherPramaDic objectForKey:@"categoryId"];
            }else if (self.pramaType == PramaType_varPrama){
                mcsiteId = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
                categoryId = [OTSUtility safeObjectAtIndex:1 inArray:self.extraPramaArr];
            }
            //self.infoPreviousUrl = @"视具体情况而定";
            if (staticPreviousURL != nil) {
                self.infoPreviousUrl = staticPreviousURL;
            }
            self.linkPosition = @"getCategoryByRootCategoryId";
            self.url =[NSString stringWithFormat:@"getCategoryByRootCategoryId_%@_%@",mcsiteId,categoryId];
            break;
        }
        case EJStracking_CategoryProductList:   // 需设置resultSum，额外传入三级分类ID, currentPage
        {
            NSString* categoryId;
            NSString* currentPage;
            
            if (self.pramaType == PramaType_Dic) {
                categoryId = [self.otherPramaDic objectForKey:@"categoryId"];
                currentPage = [self.otherPramaDic objectForKey:@"currentPage"];
            }else if (self.pramaType == PramaType_varPrama) {
                categoryId = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
                currentPage = [OTSUtility safeObjectAtIndex:1 inArray:self.extraPramaArr];
            }
            
            self.infoPreviousUrl = [NSString stringWithFormat:@"getCategoryByRootCategoryId_%@",categoryId];
            self.infoTrackerSrc = [NSString stringWithFormat:@"productList_%@_%@_%@_%@",self.provinceId,categoryId,self.resultSum,currentPage];
            self.linkPosition = @"productList";
            self.url = [NSString stringWithFormat:@"productList_%@_%@_%@",self.provinceId,categoryId,currentPage];
            break;
        }
        case EJStracking_ProductDetail:         // 需设置 productId  merchantId
        {
            if (staticPreviousURL != nil) {
                self.infoPreviousUrl = staticPreviousURL;
            }
            //self.infoPreviousUrl = @"视具体情况而定";
            self.linkPosition = @"getProductDetail";
            self.infoPageId = @"1";
            self.url = [NSString stringWithFormat:@"getProductDetail_%@_%@",self.provinceId,productId];
            break;
        }
        case EJStracking_Filiter:               //
        {
            //self.infoPreviousUrl = @"视具体情况而定";
            if (staticPreviousURL != nil) {
                self.infoPreviousUrl = staticPreviousURL;
            }
            self.infoTrackerSrc = @"searchFilter";
            self.buttonPosition = @"searchFilter";
            break;
        }
        case EJStracking_Search:                // 需设置internalKeyWord,resultSum, 额外传入currentPage
        {
            NSString* currentPage;
            if (self.pramaType == PramaType_Dic) {
                currentPage = [self.otherPramaDic objectForKey:@"currentPage"];
            }else if (self.pramaType == PramaType_varPrama) {
                currentPage = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
            }
            
            self.infoPreviousUrl = @"http://m.yihaodian.com";
            self.infoTrackerSrc = [NSString stringWithFormat:@"search_%@_%@_%@_%@",self.provinceId,self.internalKeyWord,self.resultSum,currentPage];
            self.buttonPosition = @"search";
            self.url = [NSString stringWithFormat:@"searchProduct_%@_%@_%@",self.provinceId, self.internalKeyWord,currentPage];
            break;
        }
        case EJStracking_SearchAgain:           // 需设置internalKeyWord,resulrSum, 额外传入currentPage
        {
            NSString* currentPage;
            if (self.pramaType == PramaType_Dic) {
                currentPage = [self.otherPramaDic objectForKey:@"currentPage"];
            }else if (self.pramaType == PramaType_varPrama) {
                currentPage = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
            }
            
            self.infoTrackerSrc = [NSString stringWithFormat:@"secondSearch_%@_%@_%@_%@",self.provinceId,self.internalKeyWord, self.resultSum, currentPage];
            //self.infoPreviousUrl = @"是具体情况而定";
            if (staticPreviousURL != nil) {
                self.infoPreviousUrl = staticPreviousURL;
            }
            self.url = [NSString stringWithFormat:@"searchProduct_%@_%@_%@",self.provinceId, self.internalKeyWord, currentPage];
            self.buttonPosition = @"secondSearch";
            break;
        }
        case EJStracking_AddCart:               // 需设置productId
            if (staticPreviousURL != nil) {
                self.url = staticPreviousURL;
            }
            if (staticFormerPreviousURL != nil) {
                self.infoPreviousUrl = staticFormerPreviousURL;
            }
            self.buttonPosition = @"cartAdd";
            break;
        case EJStracking_addCart_inCategory:               // 需设置productId
            if (staticPreviousURL != nil) {
                self.url = staticPreviousURL;
            }
            if (staticCategoryListURL != nil) {
                self.infoPreviousUrl = staticCategoryListURL;
            }
            self.buttonPosition = @"cartAdd";
            break;
        case EJStracking_addCart_inSearch:               // 需设置productId
            if (staticPreviousURL != nil) {
                self.url = staticPreviousURL;
            }
            if (staticCategoryListURL != nil) {
                self.infoPreviousUrl = staticSearchListURL;
            }
            self.buttonPosition = @"cartAdd";
            break;
        case EJStracking_addCart_inDetail:{               // 需设置productId
            if (staticPreviousURL != nil) {
                self.infoPreviousUrl = staticPreviousURL;
            }
            self.url = [NSString stringWithFormat:@"getProductDetail_%@_%@",self.provinceId,self.productId];
//            if (staticFormerPreviousURL != nil) {
//                self.infoPreviousUrl = staticFormerPreviousURL;
//            }
            self.buttonPosition = @"cartAdd";
            break;
        }
        case EJStracking_AddFavourite:{
            if (staticPreviousURL != nil) {
                self.url = staticPreviousURL;
            }
            if (staticFormerPreviousURL != nil) {
                self.infoPreviousUrl = staticFormerPreviousURL;
            }
            self.buttonPosition = @"Addfav";
            break;
        }
        
            break;
        case EJStracking_AddFavourite_inDetail:{
            if (staticPreviousURL != nil) {
                self.infoPreviousUrl = staticPreviousURL;
            }
            self.url = [NSString stringWithFormat:@"getProductDetail_%@_%@",self.provinceId,self.productId];
            self.buttonPosition = @"Addfav";
            break;
        }
            
        case EJStracking_FavouriteList:{
            self.infoTrackerSrc = @"myfavourite";
            self.url = @"myfavourite";
            self.infoPreviousUrl = @"http://m.yihaodian.com";
            break;
        }
            
        case EJStrakcing_EnterCart:
            if (staticPreviousURL != nil) {
                self.infoPreviousUrl = staticPreviousURL;
            }
            self.url = @"viewcart";
            break;
            break;
        case EJStracking_GroupLogo:
            self.infoTrackerSrc = [NSString stringWithFormat:@"getCurrentGrouponList_%@",productId];
            self.infoPreviousUrl = @"http://m.yihaodian.com";
            self.url = [NSString stringWithFormat:@"getCurrentGrouponList_%@",self.provinceId];
            self.buttonPosition = @"groupon";
            break;
        case EJStracking_History:
            self.infoTrackerSrc = @"history";
            self.url = @"history";
            self.buttonPosition = @"history";
            self.infoPreviousUrl = @"http://m.yihaodian.com";
            break;
        case EJStracking_CheckOrder:
            self.infoPreviousUrl = @"getSessionCart";
            self.url = @"createSessionOrder";
            self.linkPosition = @"createSessionOrder";
            break;
        case EJStracking_SaveReciveToOrder:     // 需额外传入goodReceiverId
        {
            id goodReceiverId;
            
            if (self.pramaType == PramaType_Dic) {
                goodReceiverId = [self.otherPramaDic objectForKey:@"goodReceiverId"];
            }else if (self.pramaType == PramaType_varPrama) {
                goodReceiverId = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
            }
            
            self.infoPreviousUrl = @"createSessionOrder";
            self.url = [NSString stringWithFormat:@"saveGoodReceiverToSessionOrder_%@",goodReceiverId];
            self.buttonPosition = @"saveGoodReceiverToSessionOrder";
            break;
        }
        case EJStracking_CheckPayment:          // 需额外传入goodReceiverId (不合理)
        {
            if (staticPreviousURL != nil) {
                self.infoPreviousUrl = staticPreviousURL;
            }
            self.url = @"getPaymentMethodsForSessionOrder";
            self.buttonPosition = @"getPaymentMethodsForSessionOrder";
            break;
        }
        case EJStracking_SavePayment:           // 需传入额外的methodID, gatewayId
        {
            NSString* methodID;
            NSString* gatewayId;
            
            if (self.pramaType == PramaType_Dic) {
                methodID = [self.otherPramaDic objectForKey:@"methodID"];
                gatewayId = [self.otherPramaDic objectForKey:@"gatewayId"];
            }else if (self.pramaType == PramaType_varPrama) {
                methodID = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
                gatewayId = [OTSUtility safeObjectAtIndex:1 inArray:self.extraPramaArr];
            }
            
            self.infoPreviousUrl = @"getPaymentMethodsForSessionOrder";
            self.url = [NSString stringWithFormat:@"savePaymentToSessionOrder_%@_%@",methodID, gatewayId];
            self.buttonPosition = @"savePaymentToSessionOrder";
            break;
        }
        case EJStracking_SaveCoupon:            // 需传入额外的couponNumber
        {
            NSString* couponNumber;
            
            if (self.pramaType == PramaType_Dic) {
                couponNumber = [self.otherPramaDic objectForKey:@"couponNumber"];
            }else if (self.pramaType == PramaType_varPrama) {
                couponNumber = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
            }
            
            if (staticPreviousURL != nil) {
                self.infoPreviousUrl = staticPreviousURL;
            }
            //self.infoPreviousUrl = @"视具体情况而定";
            self.url = [NSString stringWithFormat:@"saveCouponToSessionOrder_%@",couponNumber];
            self.buttonPosition = @"saveCouponToSessionOrder";
            break;
        }
        case EJStracking_SaveInvoice:           // 需传入额外的invoiceTitle,invoiceContent,invoiceAmount
        {
            NSString* invoiceTitle;
            NSString* invoiceContent;
            NSString* invoiceAmount;
            
            if (self.pramaType == PramaType_Dic) {
                invoiceTitle = [self.otherPramaDic objectForKey:@"invoiceTitle"];
                invoiceContent = [self.otherPramaDic objectForKey:@"invoiceContent"];
                invoiceAmount = [self.otherPramaDic objectForKey:@"invoiceAmount"];
            }else if (self.pramaType == PramaType_varPrama) {
                invoiceTitle = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
                invoiceContent = [OTSUtility safeObjectAtIndex:1 inArray:self.extraPramaArr];
                invoiceAmount = [OTSUtility safeObjectAtIndex:2 inArray:self.extraPramaArr];
            }
            NSString* titleEncode = [invoiceContent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString* contentEncode = [invoiceContent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            if (staticPreviousURL != nil) {
                self.infoPreviousUrl = staticPreviousURL;
            }
            //self.infoPreviousUrl = @"视具体情况而定";
            self.url = [NSString stringWithFormat:@"saveInvoiceToSessionOrder_%@_%@_%@",titleEncode,contentEncode,invoiceAmount];
            self.buttonPosition = @"saveInvoiceToSessionOrder";
            break;
        }
        case EJStracking_SubmitOrder:           // 需设置orderCode
            //self.infoPreviousUrl = @"视具体情况而定";
            if (staticPreviousURL != nil) {
                self.infoPreviousUrl = staticPreviousURL;
            }
            self.url = @"submitOrder";
            self.buttonPosition = @"submitOrder";
            break;
        case EJStracking_OrderDone:             // 奇了怪了，啥都不用传，找徐浥宁确认
            break;
        case EJStracking_GroupList:             // 需传入额外的areaId, categoryId
        {
            NSString* areaId;
            NSString* categoryId;
            
            if (self.pramaType == PramaType_Dic) {
                areaId = [self.otherPramaDic objectForKey:@"areaId"];
                categoryId = [self.otherPramaDic objectForKey:@"categoryId"];
            }else if (self.pramaType == PramaType_varPrama) {
                areaId = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
                categoryId = [OTSUtility safeObjectAtIndex:1 inArray:self.extraPramaArr];
            }
            
           // self.infoPreviousUrl = @"视具体情况而定";
            if (staticPreviousURL != nil) {
                self.infoPreviousUrl = staticPreviousURL;
            }
            self.url = [NSString stringWithFormat:@"getCurrentGrouponList_%@_%@",areaId, categoryId];
            self.linkPosition = @"getCurrentGrouponList";
            break;
        }
        case EJStracking_GroupDetail:           // 需传入额外的areaId, categoryId, grouponId
        {
            NSString* areaId;
            NSString* categoryId;
            NSString* grouponId;
            
            if (self.pramaType == PramaType_Dic) {
                areaId = [self.otherPramaDic objectForKey:@"areaId"];
                categoryId = [self.otherPramaDic objectForKey:@"categoryId"];
                grouponId = [self.otherPramaDic objectForKey:@"grouponId"];
            }else if (self.pramaType == PramaType_varPrama) {
                areaId = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
                categoryId = [OTSUtility safeObjectAtIndex:1 inArray:self.extraPramaArr];
                grouponId = [OTSUtility safeObjectAtIndex:2 inArray:self.extraPramaArr];
            }
            
            self.infoPreviousUrl = [NSString stringWithFormat:@"getCurrentGrouponList_%@_%@",areaId,categoryId];
            self.url = [NSString stringWithFormat:@"getGrouponDetail_%@_%@",areaId,grouponId];
            self.linkPosition = @"getGrouponDetail";
            break;
        }
        case EJStracking_CreatGroupOrder:       // 需传入额外的areaId，grouponId,serialId，
        {
            NSString* areaId;
            NSString* grouponId;
            NSString* serialId;
            
            if (self.pramaType == PramaType_Dic) {
                areaId = [self.otherPramaDic objectForKey:@"areaId"];
                grouponId = [self.otherPramaDic objectForKey:@"grouponId"];
                serialId = [self.otherPramaDic objectForKey:@"serialId"];
            }else if (self.pramaType == PramaType_varPrama) {
                areaId = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
                grouponId = [OTSUtility safeObjectAtIndex:1 inArray:self.extraPramaArr];
                serialId = [OTSUtility safeObjectAtIndex:2 inArray:self.extraPramaArr];
            }
            
            self.infoPreviousUrl = [NSString stringWithFormat:@"getGrouponDetail_%@_%@",areaId,grouponId];
            self.url = [NSString stringWithFormat:@"createGrouponOrder_%@_%@_%@",areaId,grouponId,serialId];
            self.buttonPosition = @"createGrouponOrder";
            break;
        }
        case EJStracking_SubmitGroupOrder:      // 需设置orderCode,传入额外的areaId，grouponId,serialId，quantity，receiverId，payByAccount，grouponRemarke，gateWayId。 有点多，蛋都碎一地了
        {
            
            NSString* areaId;
            NSString* grouponId;
            NSString* serialId;
            NSString* quantity;
            NSString* receiverId;
            NSString* payByAccount;
            NSString* grouponRemarke;
            NSString* gateWayId;
            
            if (self.pramaType == PramaType_Dic) {
                areaId = [self.otherPramaDic objectForKey:@"areaId"];
                grouponId = [self.otherPramaDic objectForKey:@"grouponId"];
                serialId = [self.otherPramaDic objectForKey:@"serialId"];
                quantity = [self.otherPramaDic objectForKey:@"quantity"];
                receiverId = [self.otherPramaDic objectForKey:@"receiverId"];
                payByAccount = [self.otherPramaDic objectForKey:@"payByAccount"];
                grouponRemarke = [self.otherPramaDic objectForKey:@"grouponRemarke"];
                gateWayId = [self.otherPramaDic objectForKey:@"gateWayId"];
            }else if (self.pramaType == PramaType_varPrama) {
                areaId = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
                grouponId = [OTSUtility safeObjectAtIndex:1 inArray:self.extraPramaArr];
                serialId = [OTSUtility safeObjectAtIndex:2 inArray:self.extraPramaArr];
                quantity = [OTSUtility safeObjectAtIndex:3 inArray:self.extraPramaArr];
                receiverId = [OTSUtility safeObjectAtIndex:4 inArray:self.extraPramaArr];
                payByAccount = [OTSUtility safeObjectAtIndex:5 inArray:self.extraPramaArr];
                grouponRemarke = [OTSUtility safeObjectAtIndex:6 inArray:self.extraPramaArr];
                gateWayId = [OTSUtility safeObjectAtIndex:7 inArray:self.extraPramaArr];
            }
            
            self.infoPreviousUrl = [NSString stringWithFormat:@"createGrouponOrder_%@_%@_%@",areaId,grouponId,serialId];
            self.url = [NSString stringWithFormat:@"submitGrouponOrder_%@_%@_%@_%@_%@_%@_%@_%@",areaId,grouponId,serialId,quantity,receiverId,payByAccount,grouponRemarke,gateWayId];
            self.buttonPosition = @"submitGrouponOrder";
            break;
        }
        case EJStracking_Login:
            //self.infoPreviousUrl = @"视具体情况而定";
            if (staticPreviousURL != nil) {
                self.infoPreviousUrl = staticPreviousURL;
            }
            self.url = @"loginPage";
            self.infoTrackerSrc = [NSString stringWithFormat:@"loginPage_%@",self.provinceId];
            self.linkPosition = @"loginPage";
            break;
        case EJStracking_Register:
            //self.infoPreviousUrl = @"视具体情况而定";
            if (staticPreviousURL != nil) {
                self.infoPreviousUrl = staticPreviousURL;
            }
            self.url = @"registerPage";
            self.infoTrackerSrc = [NSString stringWithFormat:@"registerPage_%@",self.provinceId];
            self.linkPosition = @"registerPage";
            break;
        case EJStracking_AD_HotPage:{
            self.infoPreviousUrl = @"http://m.yihaodian.com";
            NSString* CMSId;
            if (self.pramaType == PramaType_Dic) {
                CMSId = [self.otherPramaDic objectForKey:@"nid"];
            }else if (self.pramaType == PramaType_varPrama) {
                CMSId = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
            }
            self.url = [NSString stringWithFormat:@"mw/cms/%@",CMSId];
            //self.url = [NSString stringWithFormat:@"getHomeHotPointList_%@",self.provinceId];
            self.linkPosition = @"getHomeHotPointList";
            break;
        }
        case EJStracking_AD_Food:{
            self.infoPreviousUrl = @"http://m.yihaodian.com";
            //self.url = [NSString stringWithFormat:@"getHomeSelection_%@",self.provinceId];
            NSString* CMSId;
            if (self.pramaType == PramaType_Dic) {
                CMSId = [self.otherPramaDic objectForKey:@"nid"];
            }else if (self.pramaType == PramaType_varPrama) {
                CMSId = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
            }
            self.url = [NSString stringWithFormat:@"mw/cms/%@",CMSId];
            self.linkPosition = @"getFood";
            break;
        }
        case EJStracking_AD_General:{
            self.infoPreviousUrl = @"http://m.yihaodian.com";
            NSString* CMSId;
            if (self.pramaType == PramaType_Dic) {
                CMSId = [self.otherPramaDic objectForKey:@"nid"];
            }else if (self.pramaType == PramaType_varPrama) {
                CMSId = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
            }
            self.url = [NSString stringWithFormat:@"mw/cms/%@",CMSId];
            //self.url = @"getHomeHotElement_1";
            self.linkPosition = @"getNonfood";
            break;
        }
        case EJStracking_AD_CE:{
            self.infoPreviousUrl = @"http://m.yihaodian.com";
            //self.url = @"getHomeHotElement_2";
            NSString* CMSId;
            if (self.pramaType == PramaType_Dic) {
                CMSId = [self.otherPramaDic objectForKey:@"nid"];
            }else if (self.pramaType == PramaType_varPrama) {
                CMSId = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
            }
            self.url = [NSString stringWithFormat:@"mw/cms/%@",CMSId];
            self.linkPosition = @"getCE";
            break;
        }
        case EJStracking_keyWord_Food:{
            self.infoPreviousUrl = @"http://m.yihaodian.com";
            //self.url = [NSString stringWithFormat:@"getHomeSelection_%@",self.provinceId];
            NSString* keyWord;
            if (self.pramaType == PramaType_Dic) {
                keyWord = [self.otherPramaDic objectForKey:@"nid"];
            }else if (self.pramaType == PramaType_varPrama) {
                keyWord = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
            }
            if (keyWord != nil) {
                keyWord = [keyWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            self.url = [NSString stringWithFormat:@"mw/adword/%@",keyWord];
            self.linkPosition = @"getFood";
            break;
        }
        case EJStracking_keyWord_General:{
            self.infoPreviousUrl = @"http://m.yihaodian.com";
            NSString* keyWord;
            if (self.pramaType == PramaType_Dic) {
                keyWord = [self.otherPramaDic objectForKey:@"nid"];
            }else if (self.pramaType == PramaType_varPrama) {
                keyWord = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
            }
            if (keyWord != nil) {
                keyWord = [keyWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            self.url = [NSString stringWithFormat:@"mw/adword/%@",keyWord];
            //self.url = @"getHomeHotElement_1";
            self.linkPosition = @"getNonfood";
            break;
        }
        case EJStracking_keyWord_CE:{
            self.infoPreviousUrl = @"http://m.yihaodian.com";
            //self.url = @"getHomeHotElement_2";
            NSString* keyWord;
            if (self.pramaType == PramaType_Dic) {
                keyWord = [self.otherPramaDic objectForKey:@"nid"];
            }else if (self.pramaType == PramaType_varPrama) {
                keyWord = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
            }
            if (keyWord != nil) {
                keyWord = [keyWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            self.url = [NSString stringWithFormat:@"mw/adword/%@",keyWord];
            self.linkPosition = @"getCE";
            break;
        }
        case EJStracking_TopBrand:{              // 需设置productId
//            self.infoPreviousUrl = [NSString stringWithFormat:@"getHomeHotPointList_%@",self.provinceId];;
//            //self.url = [NSString stringWithFormat:@"homeHotProduct_%@_%@",self.provinceId,productId];
//            NSString* CMSId;
//            if (self.pramaType == PramaType_Dic) {
//                CMSId = [self.otherPramaDic objectForKey:@"nid"];
//            }else if (self.pramaType == PramaType_varPrama) {
//                CMSId = [OTSUtility safeObjectAtIndex:0 inArray:self.extraPramaArr];
//            }
//            self.url = [NSString stringWithFormat:@"mw/cms/%@",CMSId];
//            self.linkPosition = [NSString stringWithFormat:@"homeHotProduct_%@",productId];
//            self.infoTrackerSrc = [NSString stringWithFormat:@"homeHotProduct_%@_%@",self.provinceId,productId];
            
            self.infoTrackerSrc = @"brandflagship";
            self.buttonPosition = @"brandflagship";
            self.url = @"brandflagship";
            self.infoPreviousUrl = @"http://m.yihaodian.com";
            break;
        }
        case EJStracking_CrazyShopping:{
            
            self.infoTrackerSrc = @"dailydeal";
            self.buttonPosition = @"dailydeal";
            self.url = @"dailydeal";
            self.infoPreviousUrl = @"http://m.yihaodian.com";
            break;
        }
        case EJStracking_RockBuy:
            self.infoPreviousUrl = @"http://m.yihaodian.com";
            self.url = [NSString stringWithFormat:@"getRockProductList_%@",self.provinceId];
            self.linkPosition = @"getRockProductList";
            break;
            
        case EJStracking_Scan:{
            self.infoTrackerSrc = @"scan";
            self.buttonPosition = @"scan";
            self.url = @"scan";
            self.infoPreviousUrl = @"http://m.yihaodian.com";
            break;
        }
        case EJStracking_MF:{
            self.infoTrackerSrc = @"tracking";
            self.buttonPosition = @"tracking";
            self.url = @"tracking";
            self.infoPreviousUrl = @"http://m.yihaodian.com";
            break;
        }
        default:
            break;
    }
}

-(NSURL*)toURL{
    // 所搜关键字的转码
    if (self.internalKeyWord != nil) {
        NSString* keyWord = [internalKeyWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.internalKeyWord = keyWord;
    }
    [self appendTheProperty];
    
    // 生成URL
    self.URLstr = [HOSTURL stringByAppendingFormat:@"&ieVersion=%@",self.ieVersion];
    self.URLstr = [URLstr stringByAppendingFormat:@"&platform=%@",self.platform];
    self.URLstr = [URLstr stringByAppendingFormat:@"&tracker_u=%@",self.tracker_u];
//    if (self.gu_id != nil) {
//        self.URLstr = [URLstr stringByAppendingFormat:@"&gu_id=%@",self.gu_id];
//    }
    if (self.exField10 != nil) {
        self.URLstr = [URLstr stringByAppendingFormat:@"&exField10=%@",self.exField10];
    }
    if (self.endUserId != nil) {
        self.URLstr = [URLstr stringByAppendingFormat:@"&endUserId=%@",self.endUserId];
    }
    if (self.provinceId != nil) {
        self.URLstr = [URLstr stringByAppendingFormat:@"&provinceId=%@",self.provinceId];
    }
    if (self.infoPreviousUrl != nil) {
        NSString* urlStr;
        NSRange range = [self.infoPreviousUrl rangeOfString:@"http://m.yihaodian.com"];  // 避免和首页的冲突
        if (range.location == NSNotFound) {
            urlStr = [@"http://m.yihaodian.com/" stringByAppendingString:self.infoPreviousUrl]; // 所有的 url 添加前缀
        }else{
            urlStr = self.infoPreviousUrl;
        }
        self.URLstr = [URLstr stringByAppendingFormat:@"&infoPreviousUrl=%@",urlStr];
    }
    if (self.infoTrackerSrc != nil) {
        self.URLstr = [URLstr stringByAppendingFormat:@"&infoTrackerSrc=%@",self.infoTrackerSrc];
    }
    if (self.infoPageId != nil) {
        self.URLstr = [URLstr stringByAppendingFormat:@"&infoPageId=%@",self.infoPageId];
    }
    if (self.productId != nil) {
        self.URLstr = [URLstr stringByAppendingFormat:@"&productId=%@",self.productId];
    }
    if (self.merchant_id != nil) {
        self.URLstr = [URLstr stringByAppendingFormat:@"&curMerchantId=%@",self.merchant_id];
    }
    if (self.linkPosition != nil) {
        self.URLstr = [URLstr stringByAppendingFormat:@"&linkPosition=%@",self.linkPosition];
    }
    if (self.buttonPosition != nil) {
        self.URLstr = [URLstr stringByAppendingFormat:@"&buttonPosition=%@",self.buttonPosition];
    }
    if (self.url != nil) {
        NSString* urlStr;
        
        NSRange range = [self.url rangeOfString:@"http://m.yihaodian.com"];  // 避免和首页的冲突
        if (range.location == NSNotFound) {
            urlStr = [@"http://m.yihaodian.com/" stringByAppendingString:self.url]; // 所有的 url 添加前缀
        }else{
            urlStr = self.url;
        }
        self.URLstr = [URLstr stringByAppendingFormat:@"&url=%@",urlStr];
        
        // 保存上次和上上次的URL,进入详情及在详情中加入购物车不改变 setStaticPreUrl 的值
        if (staticPreviousURL != nil) {
            [self setStaticFormerPreviousURL:staticPreviousURL];
        }
        if (self.trackingType != EJStracking_ProductDetail && self.trackingType != EJStracking_addCart_inDetail) {
            [self setStaticPreUrl:urlStr];
        }
        
        
        
        // 分类和搜索的区别记住
        if (self.trackingType == EJStracking_CategoryProductList) {
            [self setStaticCategoryListURL:urlStr];
        }else if (self.trackingType == EJStracking_Search || self.trackingType == EJStracking_SearchAgain){
            [self setStaticSearchListURL:urlStr];
        }
    }
    if (self.internalKeyWord != nil) {
        self.URLstr = [URLstr stringByAppendingFormat:@"&internalKeyword=%@",self.internalKeyWord];
    }
    if (self.resultSum != nil) {
        self.URLstr = [URLstr stringByAppendingFormat:@"&resultSum=%@",self.resultSum];
    }
    if (self.orderCode != nil) {
        self.URLstr = [URLstr stringByAppendingFormat:@"&orderCode=%@",self.orderCode];
    }
    NSLog(@"the tracker url is:%@",self.URLstr);
    return [NSURL URLWithString:self.URLstr];
}
-(id)initWithJSType:(JSTrackingType)type extraPramaDic:(NSMutableDictionary*)dic{
    self = [super init];
    self.pramaType = 0;
    self.trackingType  = type;
    self.otherPramaDic = dic;
    // 初始化固定的参数
    self.ieVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
    if (isPad) {
        self.platform = [NSString stringWithFormat:@"ipadSystem%@",systemVersion];
    }else{
        self.platform = [NSString stringWithFormat:@"iosSystem%@",systemVersion];
    }
    self.endUserId = [GlobalValue getGlobalValueInstance].currentUser.userId;
    self.provinceId = [GlobalValue getGlobalValueInstance].provinceId;
    self.tracker_u = [GlobalValue getGlobalValueInstance].trader.unionKey;
    //self.gu_id = [GlobalValue getGlobalValueInstance].deviceToken;
    self.exField10 = [GlobalValue getGlobalValueInstance].deviceToken;
    
    return self;
}
-(id)initWithJSType:(JSTrackingType)type extraPrama:(id)firstOther, ...{  // 暂时没用这个方法,现在用了,上面那个方法不用了。其实也可以用。
    self = [super init];
    self.pramaType = 1;
    self.trackingType  = type;
    self.extraPramaArr = [NSMutableArray array];
    
    // 初始化固定的参数
    self.ieVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
    if (isPad) {
        self.platform = [NSString stringWithFormat:@"ipadSystem%@",systemVersion];
    }else{
        self.platform = [NSString stringWithFormat:@"iosSystem%@",systemVersion];
    }
    self.endUserId = [GlobalValue getGlobalValueInstance].currentUser.userId;
    self.provinceId = [GlobalValue getGlobalValueInstance].provinceId;
    self.tracker_u = [GlobalValue getGlobalValueInstance].trader.unionKey;
    //self.gu_id = [GlobalValue getGlobalValueInstance].deviceToken;
    self.exField10 = [GlobalValue getGlobalValueInstance].deviceToken;
    
    // 初始化额外参数
    va_list args;
    va_start(args,firstOther);
    if (firstOther != nil) {
        [self.extraPramaArr addObject:[NSString stringWithFormat:@"%@",firstOther]];
        id nextobj = nil;
        while ((nextobj = va_arg(args, id)) != nil) {
            [self.extraPramaArr addObject:[NSString stringWithFormat:@"%@",nextobj]];
        }
    }
    return self;
}

-(void)setStaticPreUrl:(NSString*)aUrl{
    if (staticPreviousURL != nil) {
        [staticPreviousURL release];
    }
    staticPreviousURL = [aUrl retain];
}

-(void)setStaticFormerPreviousURL:(NSString*)aUrl{
    if (staticFormerPreviousURL != nil) {
        [staticFormerPreviousURL release];
    }
    staticFormerPreviousURL = [aUrl retain];
}
-(void)setStaticSearchListURL:(NSString*)aUrl{
    if (staticSearchListURL != nil) {
        [staticSearchListURL release];
    }
    staticSearchListURL = [aUrl retain];
}
-(void)setStaticCategoryListURL:(NSString*)aUrl{
    if (staticCategoryListURL != nil) {
        [staticCategoryListURL release];
    }
    staticCategoryListURL = [aUrl retain];
}
-(void)dealloc{
    self.ieVersion = nil;
    self.platform = nil;
    self.tracker_u = nil;
    self.gu_id = nil;
    self.merchant_id = nil;
    self.session_id = nil;
    self.exField10 = nil;
    self.infoPreviousUrl = nil;
    self.infoTrackerSrc = nil;
    self.endUserId = nil;
    self.extField6 = nil;
    self.cookie = nil;
    self.fee = nil;
    self.provinceId = nil;
    self.cityId = nil;
    self.infoPageId = nil;
    self.productId = nil;
    self.linkPosition = nil;
    self.buttonPosition = nil;
    self.attachedInfo = nil;
    self.jsoncallback = nil;
    self.url = nil;
    self.internalKeyWord = nil;
    self.resultSum = nil;
    self.orderCode = nil;
    self.URLstr = nil;
    self.otherPramaDic = nil;
    self.extraPramaArr = nil;
    [super dealloc];
}
@end

@implementation NSMutableDictionary (JSTracking)

-(void)setSafeObject:(id)aObject forKey:(NSString *)nameStr{
    if (aObject != nil) {
        [self setObject:aObject forKey:nameStr];
    }else{
        [self setObject:@"" forKey:nameStr];
    }
}
@end
