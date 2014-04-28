//
//  OTSPhoneWeRockMainVC.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-10-26.
//
//



#import "OTSPhoneWeRockMainVC.h"

#import "OTSPhoneWeRockMainView.h"
#import "OTSPhoneWeRockResultNormalView.h"

#import "OTSPhoneWeRockInventoryVC.h"
#import "OTSPhoneWeRockRuleVC.h"
#import "OTSPhoneWeRockGameVC.h"
#import "OTSPhoneWeRockBubbleView.h"
#import "GameViewController.h"
#import "OTSPhoneWebRockInventoryCell.h"
#import "OTSWeRockService.h"
#import "RockResultV2.h"
#import "RockProductV2.h"
#import "RockCouponVO.h"
#import "OTSBaseServiceResult.h"
#import "StorageBoxVO.h"
#import "AwardsResult.h"

#import "GlobalValue.h"
#import "TheStoreAppAppDelegate.h"
#import "SDImageView+SDWebCache.h"
#import "LocalCartItemVO.h"
#import "OTSWrBoxPageGetter.h"
#import "RockGameVO.h"
#import "OTSAudioPlayer.h"
#import "TheStoreAppAppDelegate.h"
#import "DoTracking.h"
#import "GTMBase64.h"
#import "RockPrizeProductVO.h"

#define ROCK_RESULT_INVALID_STR     @"这次没摇出什么东东，再摇摇看吧～"
#define ROCK_ADD_CART_OK_STR        @"加入购物车成功!"
#define URL_BASE_MALL_NO_ONE                        @"http://m.1mall.com/mw/product/"
#define URL_BASE_MALL_NO_GROUP                      @"http://m.1mall.com/mw/groupdetail/"

@interface OTSWRTimedBoxItem : NSObject
@property (retain) StorageBoxVO *item;
@property int                   minutes;

@end

@implementation OTSWRTimedBoxItem
@synthesize item = _item;


- (void)dealloc
{
    [_item release];
    [super dealloc];
}

@end

//---------------------------------------------------------------------------
@interface OTSPhoneWeRockMainVC ()
{
    BOOL            _isLoginWhenRockResult; // 摇出结果时是否登录
    BOOL            _isActivatingGame;
    BOOL            _isEnteringBox;
}
@property (retain) OTSPhoneWeRockMainView                   *mainView;
@property (retain) OTSPhoneWeRockResultNormalView           *resultNormalView;

@property (retain) RockResultV2                             *rockResult;
@property (retain) NSMutableArray                           *timeTipItems;    // 时间提醒集合, item type = OTSWRTimedBoxItem
@property (retain) RockGameVO                               *rockGameVO;
@property BOOL                  isRocking;
@property (nonatomic, retain)CLLocationManager* locationManager;
@property (nonatomic, retain)NSNumber* groupOnAreaID;


-(IBAction)rockNow;
-(IBAction)enterInventory;      // 进入寄存箱
-(IBAction)enterRule;           // 进入规则说明
-(IBAction)enterGame;           // 进入游戏
@end

@implementation OTSPhoneWeRockMainVC
@synthesize inventoryBtn = _inventoryBtn;
@synthesize gameBtn = _gameBtn;

@synthesize bubbleView = _bubbleView;
@synthesize mainView = _mainView;
@synthesize resultNormalView = _resultNormalView;

@synthesize rockResult = _rockResult;
@synthesize timeTipItems = _timeTipItems;
@synthesize rockGameVO = _rockGameVO;
@synthesize isRocking = _isRocking;
@synthesize gameVc;

#pragma mark - 动作

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}


-(IBAction)rockNow
{
    LOG_THE_METHORD;
    if (self.isRocking)
    {
        return;
    }
    if ([CLLocationManager locationServicesEnabled]) {
        [self.loadingView showInView:self.view];
        [_locationManager setDelegate:self];
        [self.locationManager startUpdatingLocation];
    }else{
        [OTSUtility alert:@"定位功能未开启"];
    }
    
}

-(IBAction)enterInventory
{
    LOG_THE_METHORD;
    
    if (![self loginIfNot])
    {
        _isEnteringBox = YES;
        return;
    }
    [[OTSPhoneRuntimeData sharedInstance].boxPager requestToTheEnd];
    OTSPhoneWeRockInventoryVC *vc = [[[OTSPhoneWeRockInventoryVC alloc] init] autorelease];
    [vc setQuitTaget:self action:@selector(naviBackAction:)];
    [self pushVC:vc animated:YES];
    
    
    //    //[self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:OTS_VIEW_ANIM_KEY];
    //    [self.view addSubview:vc.view];
}

-(IBAction)enterRule
{
    LOG_THE_METHORD;
    
    OTSPhoneWeRockRuleVC *vc = [[[OTSPhoneWeRockRuleVC alloc] init] autorelease];
    [self pushVC:vc animated:YES];
}

-(IBAction)enterGame
{
    UIDeviceHardware *hardware=[[UIDeviceHardware alloc] init];
    //NSRange range = [[hardware platformString] rangeOfString:@"iPhone"];
    //    if (range.length <= 0) {
    //        [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
    //        [AlertView showAlertView:nil alertMsg:@"您的设备不支持此项功能,感谢您对1号店的支持!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
    //    }else
    {
        self.gameVc = [[[GameViewController alloc] init] autorelease] ;
        self.gameVc.rockGameVO=self.rockGameVO;
        [self pushVC:gameVc animated: YES fullScreen:YES];
    }
    [hardware release];
}
-(void)enterDetail{
//    if (![self loginIfNot]) {
//        return;
//    }
    if (self.rockResult.getResultType == kRockResultGroupon && self.rockResult.grouponVOList.count > 0)    // 团购
    {
        GrouponVO * grouponVO = [self.rockResult.grouponVOList objectAtIndex:0];
        NSMutableArray *products=[[NSMutableArray alloc] init];
        [products addObject:grouponVO];
        [grouponVO release];
        
        if ([grouponVO.siteType intValue] == 2) {               // 一号商城商品
            //更新团购最新浏览信息
            [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadAddGrouponBrowse:) toTarget:self withObject:grouponVO];
            NSString *urlStr;
            if ([GlobalValue getGlobalValueInstance].token == nil) {
                urlStr = [URL_BASE_MALL_NO_GROUP stringByAppendingFormat:@"%@/%@_%d",grouponVO.nid,self.groupOnAreaID,30];
            }else {
                // 对 token 进行base64加密
                NSData *b64Data = [GTMBase64 encodeData:[[GlobalValue getGlobalValueInstance].token dataUsingEncoding:NSUTF8StringEncoding]];
                NSString* b64Str = [[[NSString alloc] initWithData:b64Data encoding:NSUTF8StringEncoding] autorelease];
                
                urlStr = [URL_BASE_MALL_NO_GROUP stringByAppendingFormat:@"%@/%@_%@_%d",grouponVO.nid,self.groupOnAreaID,b64Str,30];
                
            }
            grouponVO.mallURL = urlStr;
            DebugLog(@"enterWap -- url is:\n%@",urlStr);
            [SharedDelegate enterWap:1 invokeUrl:urlStr isClearCookie:YES];
        }else {                                                 // 自营团购商品
            GroupBuyProductDetail *grouponDetail=[[[GroupBuyProductDetail alloc] initWithNibName:@"GroupBuyProductDetail" bundle:nil] autorelease];
            [grouponDetail setM_AreaId:self.groupOnAreaID];
            [grouponDetail setM_Products:products];
            [grouponDetail setM_CurrentIndex:0];
            [grouponDetail setM_FromTag:FROM_ROCKBUY_TO_DETAIL];
            [grouponDetail setIsFullScreen:YES];
            [self pushVC:grouponDetail animated:YES fullScreen:YES];
        }
         
    }else if (self.rockResult.getResultType == kRockResultSale || self.rockResult.getResultType == kRockResultNormal){    // 商城促销和商城普通商品
        ProductVO *productVO = [self resultProduct];
        //defence
        if (productVO == nil)
        {
            return;
        }
        DebugLog(@"enter 1mall!!!!");
        NSString *urlStr;
        NSString* landingPageId;
        if (productVO.promotionId) {
            landingPageId = productVO.promotionId;
        }else{
            landingPageId = @"";
        }
        if ([GlobalValue getGlobalValueInstance].token == nil) {
            urlStr = [URL_BASE_MALL_NO_ONE stringByAppendingFormat:@"%@/%@/%@?osType=30",productVO.productId,[GlobalValue getGlobalValueInstance].provinceId,landingPageId];
        }else {
            // 对 token 进行base64加密
            NSData *b64Data = [GTMBase64 encodeData:[[GlobalValue getGlobalValueInstance].token dataUsingEncoding:NSUTF8StringEncoding]];
            NSString* b64Str = [[[NSString alloc] initWithData:b64Data encoding:NSUTF8StringEncoding] autorelease];
            
            urlStr = [URL_BASE_MALL_NO_ONE stringByAppendingFormat:@"%@/%@/%@?token=%@&osType=30",productVO.productId,[GlobalValue getGlobalValueInstance].provinceId,landingPageId,b64Str];
            
        }
        productVO.mallDefaultURL = urlStr;
        DebugLog(@"enterWap -- url is:\n%@",urlStr);
        [SharedDelegate enterWap:4 invokeUrl:urlStr isClearCookie:YES];
    }
}

-(void)handleRockResultAction:(OTSRockReultActionType)anActionType resultObject:(id)aResultObj
{
    LOG_THE_METHORD;
    
    switch (anActionType)
    {
        case kRockReultActionVanish:
        {
            // what service to use??? -- 本次迭代(8)不做
            [OTSUtility alertWhenDebug:@"不支持，接口还没做"];
        }
            break;
            
        case kRockReultActionAddToCart:
        {
            [self requestAddToCart];
        }
            break;
            
        case kRockReultActionAddToFav:
        {
            [self requestAddToFav];
        }
            break;
            
        case kRockReultActionGetTicket:
        {
            [self requestGetTicket];
        }
            break;
            
        case kRockReultActionActivateGame:
        {
            [self requestActivateGame];
        }
            break;
            
        case kRockReultActionToDetail:
        {
            [self enterDetail];
        }
            break;
        case kRockReultActionCheckPrize:
        {
            [self requestPrizeResult];
        }
            break;
        case kRockReultActionRockNow:{
            [self rockNow];
        }
            break;
        default:
            break;
    }
}









#pragma mark - UI更新
-(void)updateUI
{
    [self.loadingView hide];
    
    if (self.rockResult == nil || ![self.rockResult isValid] )
    {
        // error handling
        [OTSUtility alertWhenDebug:ROCK_RESULT_INVALID_STR];
        return;
    }
    
    [self performInThreadBlock:^{
        
        if ([self.rockResult getResultType] != kRockResultNormal)
        {
            [OTSAudioPlayer playSoundFileInBundle:@"win" type:@"mp3"];
        }
        
    }];
    
    [self showResultByType:self.rockResult.getResultType];
}



//-(void)simulateUpdateUI
//{
//    [self hideLoading];
//
//    int rndValue = arc4random() % 5;
//    DebugLog(@"rand num:%d", rndValue);
//
//    [self showResultByType:rndValue];
//    //[self showResultByType:kWeRockResultTicket];
//
//}



-(void)doShowResultViewByType:(OTSWeRockResultType)aResultType
{
    // 判断0元大奖
    if (aResultType == kWeRockResultDisCount) {
        if (self.rockResult.rockProductV2List.count > 0)
        {
            RockProductV2 *rockProduct = [self.rockResult.rockProductV2List objectAtIndex:0];
            if ([rockProduct.prodcutVO.promotionPrice intValue] <= 0)
            {
                aResultType = kWeRockResultFree;
            }
        }
    }
    
    
    // 创建view
    [self.mainView removeFromSuperview];
    
    [self.resultNormalView removeFromSuperview];
    self.resultNormalView = [OTSPhoneWeRockResultNormalView viewFromNibWithOwner:self type:aResultType rockResult:self.rockResult];
    //self.resultNormalView.rockResult = self.rockResult;
    self.resultNormalView.frame = self.mainView.frame;
    self.resultNormalView.delegate = self;
    
    // 更新view数据显示
    switch (aResultType)
    {
        case kWeRockResultDisCount:
        case kWeRockResultFree:
        {
            if (self.rockResult.rockProductV2List.count > 0)
            {
                RockProductV2 *rockProduct = [self.rockResult.rockProductV2List objectAtIndex:0];
                
                self.resultNormalView.productPriceLabel.text = [NSString stringWithFormat:@"%.2f", [rockProduct.prodcutVO.promotionPrice floatValue]];
                [self.resultNormalView setMarketPrice:[NSString stringWithFormat:@"%.2f",[rockProduct.prodcutVO.price floatValue]]];
                // self.resultNormalView.productMarketPriceLabel.text = [NSString stringWithFormat:@"%.2f", [rockProduct.prodcutVO.maketPrice floatValue]];
                self.resultNormalView.resultNameLabel.text = rockProduct.prodcutVO.cnName;
                NSString *imgUrlStr = rockProduct.prodcutVO.midleDefaultProductUrl;
                if (imgUrlStr == nil) {
                    imgUrlStr = rockProduct.prodcutVO.miniDefaultProductUrl;
                }
                if (imgUrlStr == nil) {
                    [self.resultNormalView.productPictureIV setImage:[UIImage imageNamed:@"defaultimg85.png"]];
                }else
                    [self.resultNormalView.productPictureIV setImageWithURL:[NSURL URLWithString:imgUrlStr]];
                
                // 倒计时时间需要心跳更新!!!
                int interval = [rockProduct.productAging longLongValue] / 1000.f;   //000.0f;  // 毫秒---》秒
                [rockProduct updateMyExpTime];
                self.resultNormalView.productCountDownLabel.text = [OTSUtility timeStringFromInterval:interval];
                // 限制数量取哪个字段？？？
            }
        }
            break;
            
        case kWeRockResultTicket:
        {
            if (self.rockResult.couponVOList.count > 0)
            {
                RockCouponVO *ticket = [self.rockResult.couponVOList objectAtIndex:0];
                // name
                self.resultNormalView.resultNameLabel.text = ticket.couponVO.description;
                // price
                self.resultNormalView.ticketPriceLabel.text = [NSString stringWithFormat:@"%d", [ticket.couponVO.amount intValue]];
                // time&time format
                /*  fix bug 0100000 开始时间 － 过期时间 异常
                 NSDateFormatter *DateFormat = [[NSDateFormatter alloc] init];
                 [DateFormat setDateFormat:@"yyyy.MM.dd"];
                 NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
                 
                 NSString *beginDate = [self stringFromDate:ticket.couponVO.beginTime];
                 beginDate = beginDate ? beginDate : [DateFormat stringFromDate:[NSDate date]];
                 */
                NSString *beginDate = [self stringFromDate:ticket.couponVO.beginTime];
                beginDate = beginDate ? beginDate : @"到期时间";
                NSString *endDate = [self stringFromDate:ticket.couponVO.expiredTime];
                
                if (beginDate) {
                    self.resultNormalView.ticketTimeLabel.text = [NSString stringWithFormat:@"%@ : %@", beginDate, endDate];
                }
                else {
                    self.resultNormalView.ticketTimeLabel.text = [NSString stringWithFormat:@"%@ - %@", beginDate, endDate];
                }
                // 限制数量取哪个字段？？？
            }
        }
            break;
            
        case kWeRockResultGame:
        {
            // do nothing???
        }
            break;
            
        case kWeRockResultSale:
        case kWeRockResultNormal:
        {
            if (self.rockResult.productVOList.count > 0)
            {
                ProductVO *prodcutVO = [self.rockResult.productVOList objectAtIndex:0];
                
                self.resultNormalView.productPriceLabel.text = [NSString stringWithFormat:@"%.2f", [prodcutVO.price floatValue]];
                //   self.resultNormalView.productMarketPriceLabel.text = [NSString stringWithFormat:@"%.2f", [prodcutVO.maketPrice floatValue]];
                self.resultNormalView.resultNameLabel.text = prodcutVO.cnName;
                
                NSString *imgUrlStr = prodcutVO.midleDefaultProductUrl;
                if (imgUrlStr == nil) {
                    imgUrlStr = prodcutVO.miniDefaultProductUrl;
                }
                if (imgUrlStr == nil) {
                    [self.resultNormalView.productPictureIV setImage:[UIImage imageNamed:@"defaultimg85.png"]];
                }else
                    [self.resultNormalView.productPictureIV setImageWithURL:[NSURL URLWithString:imgUrlStr]];
                
                
            }
        }
            break;
        case kWeRockResultGroupon:
        {
            if (self.rockResult.grouponVOList.count > 0)
            {
                GrouponVO *prodcutVO = [self.rockResult.grouponVOList objectAtIndex:0];
                
                self.resultNormalView.resultNameLabel.text = prodcutVO.name;
                NSString *imgUrlStr = prodcutVO.miniImageUrl;
                if (imgUrlStr == nil) {
                    imgUrlStr = prodcutVO.middleImageUrl;
                }
                if (imgUrlStr == nil) {
                    [self.resultNormalView.groupProductIV setImage:[UIImage imageNamed:@"defaultimg85.png"]];
                }else
                    [self.resultNormalView.groupProductIV setImageWithURL:[NSURL URLWithString:imgUrlStr]];
                [self.resultNormalView.groupPriceLabel setText:[NSString stringWithFormat:@"￥%@",prodcutVO.price]];
                [self.resultNormalView.groupCountLabel setText:[NSString stringWithFormat:@"%@人已购买",prodcutVO.peopleNumber]];
                
            }
        }
            break;
        case kWeRockResultPrize:
        {
            if (self.rockResult.prizeProductVOList.count > 0)
            {
                RockPrizeProductVO *prodcutVO = [self.rockResult.prizeProductVOList objectAtIndex:0];
                
               // self.resultNormalView.productPriceLabel.text = [NSString stringWithFormat:@"%.2f", [prodcutVO.price floatValue]];
                //   self.resultNormalView.productMarketPriceLabel.text = [NSString stringWithFormat:@"%.2f", [prodcutVO.maketPrice floatValue]];
                self.resultNormalView.resultNameLabel.text = prodcutVO.prizeName;
                
                NSString *imgUrlStr = prodcutVO.prizeUrl;
                [self.resultNormalView.groupProductIV setImageWithURL:[NSURL URLWithString:imgUrlStr]];
                
            }
        }
            break;
            
        default:
            break;
    }
    //[self.view addSubview:self.resultNormalView];
    [self.view insertSubview:self.resultNormalView belowSubview:self.naviBar];
}

-(void)showResultByType:(OTSWeRockResultType)aResultType
{
    __block BOOL canShowResult = NO;
    
    [self performInThreadBlock:^{
        
        // 判断摇出来的东东是否有效（改为在点添加购物车的时候判断）
        [self addRockResultToBox];  // 加寄存箱
        canShowResult = YES;//[self checkResultIsValid:aResultType];
        
    } completionInMainBlock:^{
        
        if (canShowResult)
        {
            [self doShowResultViewByType:aResultType];
        }
        
    }];
    
}


- (id)retain
{
    DebugLog(@"before retain >>>>>>>this retain count:%d", [self retainCount]);
    return [super retain];
}

- (oneway void)release
{
    DebugLog(@"before release >>>>>>>this retain count:%d", [self retainCount]);
    [super release];
}



#pragma mark - 内存及视图管理
- (void)dealloc
{
    [[OTSPhoneRuntimeData sharedInstance].boxPager reset];
    //ISSUE #4801 EXC_BAD_ACCESS
    OTS_SAFE_RELEASE(gameVc);
    OTS_SAFE_RELEASE(_mainView);
    OTS_SAFE_RELEASE(_resultNormalView);
    OTS_SAFE_RELEASE(_inventoryBtn);
    OTS_SAFE_RELEASE(_gameBtn);
    OTS_SAFE_RELEASE(_bubbleView);
    
    OTS_SAFE_RELEASE(_rockResult);
    OTS_SAFE_RELEASE(_timeTipItems);
    OTS_SAFE_RELEASE(_rockGameVO);
    
    OTS_SAFE_RELEASE(_bgImageView);
    OTS_SAFE_RELEASE(_locationManager);
    [_ruleBtn release];
    [super dealloc];
}



- (void)viewDidLoad
{
    
    self.isFullScreen = YES;
    //    [SharedDelegate requestGPS];
    [[OTSPhoneRuntimeData sharedInstance].boxPager reset];
    _bgImageView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, ApplicationWidth, ApplicationHeight-NAVIGATION_BAR_HEIGHT);
    if (iPhone5) {
        [_bgImageView setImage:[UIImage imageNamed:@"wrBg5@2x.png"]];
        //[_gameBtn setFrame:CGRectMake(202, ApplicationHeight-65, 68, 58)];
        [_ruleBtn setFrame:CGRectMake(202, ApplicationHeight-65, 68, 58)];
        [_inventoryBtn setFrame:CGRectMake(59, ApplicationHeight-67, 70, 58)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateExpireTime) name:kNotifyWRInventoryCellUpdateTime object:nil];

    // ui
    [super viewDidLoad];
    
    // add motion view ,to detect motion
    OTSPhoneMotionableView *motiionView = [[[OTSPhoneMotionableView alloc] initWithDelegate:self] autorelease];
    [self.view addSubview:motiionView];
    
    // adjust view frame offset y
    float statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect selfRC = self.view.frame;
    selfRC = CGRectOffset(selfRC, 0, statusHeight);
    self.view.frame = selfRC;
    
    // main view
    self.mainView = [OTSPhoneWeRockMainView viewFromXibWithOwner:self];
    //[self.view addSubview:self.mainView];
    [self.view insertSubview:self.mainView belowSubview:self.naviBar];
    
    CGRect mainViewRc = self.mainView.frame;
    mainViewRc.origin.x = (self.view.frame.size.width - mainViewRc.size.width) / 2;
    mainViewRc.origin.y = 14;//CGRectGetMaxY(self.naviBar.frame) + (ApplicationHeight-440)/2;
    self.mainView.frame = mainViewRc;
    
    // add rule button
    UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *ruleBtnImage = [UIImage imageNamed:@"wrNaviShackBtn"];
    [ruleBtn setImage:ruleBtnImage forState:UIControlStateNormal];
    ruleBtn.frame = CGRectMake(280
                               , (self.naviBar.frame.size.height - ruleBtnImage.size.height) / 2
                               , ruleBtnImage.size.width
                               , ruleBtnImage.size.height);
    [ruleBtn addTarget:self action:@selector(rockNow) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:ruleBtn];
    
    // bubbleView
    CGRect bubbleRect = self.bubbleView.frame;
    [self.bubbleView removeFromSuperview];
    self.bubbleView = [OTSPhoneWeRockBubbleView viewFromNibWithOwner:self];
    self.bubbleView.frame = bubbleRect;
    [self.view addSubview:self.bubbleView];
    [self.view bringSubviewToFront:self.bubbleView];
    
    
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.timeTipItems = [[[NSMutableArray alloc] init] autorelease];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginSuccess:) name:NOTIFY_LOGIN_SUCCESS object:nil];
    
    [self.naviBar.leftNaviBtn addTarget:self action:@selector(naviBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 获取团购地区ID
    [self performInThreadBlock:^{
        self.groupOnAreaID = [[OTSServiceHelper sharedInstance]
                              getGrouponAreaIdByProvinceId:[GlobalValue getGlobalValueInstance].trader
                              provinceId:[GlobalValue getGlobalValueInstance].provinceId];
        self.groupOnAreaID = [self.groupOnAreaID isKindOfClass:[NSNull class]] ? nil : self.groupOnAreaID;
    }];
    [self viewWillAppear:NO];
}

-(void)naviBackAction:(id)sender
{
    //[self popSelfAnimated:YES];
    [SharedDelegate.tabBarController removeViewControllerWithAnimation:[OTSNaviAnimation animationPushFromLeft]];
}

-(void)handleLoginSuccess:(NSNotification*)aNotification
{
    [self viewWillAppear:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    //[[OTSPhoneRuntimeData sharedInstance].boxPager requestToTheEnd];
    
    // 如果没有登录，清除自动跳转标志
    if ([GlobalValue getGlobalValueInstance].token == nil)
    {
        _isActivatingGame = NO;
        _isEnteringBox = NO;
    }
    
    if (_isActivatingGame)
    {
        [self requestActivateGame];
    }
    else
    {
        [self checkIsGameActivatedForced:YES];
    }
    
    if (_isEnteringBox)
    {
        _isEnteringBox = NO;
        [self enterInventory];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidUnload
{
    [self setInventoryBtn:nil];
    [self setGameBtn:nil];
    
    self.mainView = nil;
    
    self.resultNormalView = nil;
    
    [self setBubbleView:nil];
    [self setBgImageView:nil];
    [self setRuleBtn:nil];
    [super viewDidUnload];
}

#pragma mark - 摇动事件处理
-(void)handleMotionEvent
{
    //触发摇动
    //[[[[UIAlertView alloc] initWithTitle:@"我被你咬了一下" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease] show];
    [self rockNow];
}





#pragma mark - 心跳刷新
-(void)updateExpireTime
{
    // XXX:待检验逻辑
    static int timeCount = 0;
    
    if (timeCount >= 60)    // 60秒检查一次提示
    {
        NSArray * items = [[OTSPhoneRuntimeData sharedInstance].boxPager allPageItems];
        for (StorageBoxVO *item in items)
        {
            BOOL hasTipped = [self checkHasTimeTippedItem:item];
            if (!hasTipped)
            {
                NSDate *expireDate = item.expireTime;
                [self.bubbleView showWithInterval:[expireDate timeIntervalSinceNow]];
                DebugLog(@"Tipped.................%@", expireDate);
                break;
            }
        }
        
        timeCount = 0;
    }
    
    timeCount++;
}

// 提醒时间
-(int)tipTimeForMinutes:(int)aMinutes
{
    if (aMinutes < 60 && aMinutes >= 30)
    {
        return 60;
    }
    else if (aMinutes < 30 && aMinutes >= 15)
    {
        return 30;
    }
    else if (aMinutes < 15 && aMinutes >= 0)
    {
        return 15;
    }
    
    return 0;
}

//是否提醒过了
-(BOOL)checkHasTimeTippedItem:(StorageBoxVO*)aStorageBox
{
    BOOL hasTipped = YES; // default is yes
    BOOL hasSameItem = NO;
    if (aStorageBox)
    {
        NSDate *expireDate = aStorageBox.expireTime;
        int intervalMinutes = [expireDate timeIntervalSinceNow] / 60; // in minutes
        
        if (intervalMinutes < 60) // less than 1 hour
        {
            int currentTipTime = [self tipTimeForMinutes:intervalMinutes];
            for (OTSWRTimedBoxItem *timedItem in self.timeTipItems)
            {
                if ([timedItem.item isTheSame:aStorageBox])
                {
                    hasSameItem = YES;
                    int tippedTime = timedItem.minutes;
                    
                    if (tippedTime <= 0 || tippedTime > currentTipTime)
                    {
                        //not tipped yet, shuld tip
                        timedItem.minutes = currentTipTime;
                        hasTipped = NO;
                        break;
                    }
                }
            }
            
            if (!hasSameItem)
            {
                // no item recorded, should tip
                OTSWRTimedBoxItem *newTimedItem = [[[OTSWRTimedBoxItem alloc] init] autorelease];
                newTimedItem.item = aStorageBox;
                newTimedItem.minutes = currentTipTime;
                [self.timeTipItems addObject:newTimedItem];
                
                hasTipped = NO;
            }
            
        }
        
        
        if (!hasTipped)
        {
            //[self.bubbleView showWithInterval:[expireDate timeIntervalSinceNow]];
        }
    }
    
    return hasTipped;
}



#pragma mark - 接口调用
-(BOOL)checkResultIsValid:(OTSWeRockResultType)aResultType
{
    if (aResultType == kWeRockResultNormal || aResultType == kWeRockResultGame)
    {
        return YES;
    }
    
    [self.loadingView showInView:self.view];
    
    BOOL canShowResult = NO;
    
    switch (aResultType)
    {
        case kWeRockResultDisCount:
        {
            //RockProductV2 *rockProduct = nil;
            NSArray *products = self.rockResult.rockProductV2List;
            NSMutableArray *results = [NSMutableArray arrayWithCapacity:5];
            
            if (products && products.count > 0)
            {
                if ([GlobalValue getGlobalValueInstance].token)
                {
                    //for (RockProductV2 * theProduct in products)
                    RockProductV2 * theProduct = [products objectAtIndex:0];
                    {
                        //检查此结果是否有效
                        CheckRockResultResult* result = [[OTSWeRockService myInstance]
                                                         checkRockResult:[GlobalValue getGlobalValueInstance].token
                                                         productId:theProduct.prodcutVO.productId
                                                         promotionId:theProduct.prodcutVO.promotionId
                                                         type:[NSNumber numberWithInt:kWrCheckRockProduct] couponActiveId:[NSNumber numberWithInt:0]];
                        if (result.isSuccess)
                        {
                            //rockProduct = theProduct;   //有效
                            // 加入寄存箱
                            [self addProductToBox:theProduct];
                            
                            canShowResult = YES;
                            break;
                        }
                        else
                        {
                            [results addObject:result];
                        }
                    }
                }
                //                else
                //                {
                //                    rockProduct = [self.rockResult.rockProductV2List objectAtIndex:0];
                //                }
                
            }
            
            if (!canShowResult)
            {
                // 提示用户结果不合法
                [self performInMainBlock:^{
#ifdef DEBUG
                    NSMutableString *alertMessage = [NSMutableString string];
                    for (CheckRockResultResult *result in results)
                    {
                        [alertMessage appendFormat:@"%@\n", result.errorInfo];
                    }
                    
                    if (alertMessage.length <= 0)
                    {
                        [alertMessage appendString:@"促销商品结果list为空ya，不应该ya～"];
                    }
                    
                    [OTSUtility alert:alertMessage];
#else
                    [OTSUtility alert:ROCK_RESULT_INVALID_STR];
#endif
                }];
                
                // 没有合法的结果，重摇！！stupid logic, fucking...
            }
            
        }
            break;
            
        case kWeRockResultTicket:
        {
            RockCouponVO *rockTicket = nil;
            NSArray *tickets = self.rockResult.couponVOList;
            if (tickets && tickets.count > 0)
            {
                rockTicket = [tickets objectAtIndex:0];
                
                CheckRockResultResult* result = [[OTSWeRockService myInstance]
                                                 checkRockResult:[GlobalValue getGlobalValueInstance].token
                                                 productId:[NSNumber numberWithInt:0]
                                                 promotionId:nil
                                                 type:[NSNumber numberWithInt:kWrCheckRockTicket]
                                                 couponActiveId:rockTicket.activityId];
                if (!result.isSuccess)
                {
                    [self performInMainBlock:^{
                        
                        if (result.errorInfo)
                        {
                            [OTSUtility alert:result.errorInfo];
                        }
                        else
                        {
                            [OTSUtility alertWhenDebug:@"抵用券结果list为空wo，不应该wo～"];
                        }
                        
                    }];
                }
                else
                {
                    // 抵用券不加入寄存箱
                    //[self addTicketToBox:rockTicket];
                    
                    canShowResult = YES;
                }
                
            }
        }
            break;
            
        default:
            break;
    }
    
    [self.loadingView hide];
    
    if (!canShowResult)
    {
        self.rockResult = nil;
        [self.resultNormalView removeFromSuperview];
        //[self.view addSubview:self.mainView];
        [self.view insertSubview:self.mainView belowSubview:self.naviBar];
    }
    
    return canShowResult;
}

-(void)checkIsGameActivatedForced:(BOOL)aForceCheck
{
    self.gameBtn.enabled = NO;
    
    //ISSUE #4779 
    [self performInThreadBlock:^(){
        
        if (aForceCheck || self.rockGameVO == nil)
        {
            self.rockGameVO = [[OTSWeRockService myInstance]
                               getRockGameByToken:[GlobalValue getGlobalValueInstance].token
                               type:[NSNumber numberWithInt:1]];
        }
        
    } completionInMainBlock:^() {
        
        if ([self isGameActivated])
        {
            // 游戏已激活
            self.gameBtn.enabled = YES;
            
            if (_isActivatingGame)
            {
                _isActivatingGame = NO;
                [self enterGame];
            }
        }
        else
        {
            //未激活
        }
    }];
    //    [self performInThreadBlock:^{
    //
    //        if (aForceCheck || self.rockGameVO == nil)
    //        {
    //            self.rockGameVO = [[OTSWeRockService myInstance]
    //                                getRockGameByToken:[GlobalValue getGlobalValueInstance].token
    //                               type:[NSNumber numberWithInt:1]];
    //        }
    //
    //
    //        if ([self isGameActivated])
    //        {
    //            // 游戏已激活
    //            [self performInMainBlock:^{
    //                self.gameBtn.enabled = YES;
    //
    //                if (_isActivatingGame)
    //                {
    //                    _isActivatingGame = NO;
    //                    [self enterGame];
    //                }
    //            }];
    //        }
    //        else
    //        {
    //            //未激活
    //        }
    //    }];
}
-(void)requestRockResultV2:(CLLocationCoordinate2D)coordinate{
    self.isRocking = YES;
    
    
    [self performInThreadBlock:^{
        
        [OTSAudioPlayer playSoundFileInBundle:@"shake_buy_start" type:@"mp3"];
        
        
        if ([GlobalValue getGlobalValueInstance].token) {
            self.rockResult = [[OTSWeRockService myInstance]
                               getRockResultV3:[GlobalValue getGlobalValueInstance].token lng:[NSNumber numberWithDouble:coordinate.longitude] lat:[NSNumber numberWithDouble:coordinate.latitude]];
        }else{
            self.rockResult = [[OTSWeRockService myInstance]
                                getRockResultV3:[GlobalValue getGlobalValueInstance].trader provinceId:[GlobalValue getGlobalValueInstance].provinceId lng:[NSNumber numberWithDouble:coordinate.longitude] lat:[NSNumber numberWithDouble:coordinate.latitude]];
        }
        
        
        DebugLog(@"%@", self.rockResult);
        
        _isLoginWhenRockResult = ([GlobalValue getGlobalValueInstance].token != nil);
        
    } completionInMainBlock:^{
        
        
        [self updateUI];
        
        self.isRocking = NO;
    }];
}
-(void)requestPrizeResult{
    __block AwardsResult* result;
    [self performInThreadBlock:^{
        result = [[[OTSWeRockService myInstance]getAwardsResults:[GlobalValue getGlobalValueInstance].trader]retain];
    }completionInMainBlock:^{
        if (result.resultCode.intValue == 1) {
            [self doShowResultViewByType:kWeRockResultPrizeSuccess];
        }else
            [self doShowResultViewByType:kWeRockResultPrrzeFaild];
        OTS_SAFE_RELEASE(result);
    }];
    
}
-(void)requestRockResult
{
    self.isRocking = YES;
    [self.loadingView showInView:self.view];
    
    [self performInThreadBlock:^{
        
        [OTSAudioPlayer playSoundFileInBundle:@"shake_buy_start" type:@"mp3"];
        
        
        self.rockResult = [[OTSWeRockService myInstance]
                           getRockResultV2:[GlobalValue getGlobalValueInstance].trader
                           provinceId:[GlobalValue getGlobalValueInstance].provinceId
                           token:[GlobalValue getGlobalValueInstance].token];
        
        DebugLog(@"%@", self.rockResult);
        
        _isLoginWhenRockResult = ([GlobalValue getGlobalValueInstance].token != nil);
        
    } completionInMainBlock:^{
        
        
        [self updateUI];
        
        self.isRocking = NO;
    }];
}

-(void)requestGetTicket
{
    if (![self loginIfNot])
    {
        return;
    }
    
    // defence
    if (self.rockResult.couponVOList.count <= 0)
    {
        return;
    }
    
    [self.loadingView showInView:self.view];
    
    RockCouponVO *rockTicket = [self.rockResult.couponVOList objectAtIndex:0];
    
    __block AddCouponByActivityIdResult *result = nil;
    [self performInThreadBlock:^{
        
        result = [[OTSWeRockService myInstance] addCouponByActivityId:[GlobalValue getGlobalValueInstance].token activityId:rockTicket.activityId];
        [result retain];
        
    } completionInMainBlock:^{
        
        [self.loadingView hide];
        
        if (result.isSuccess)
        {
            [OTSUtility alert:@"领取成功!"];
            [[OTSPhoneRuntimeData sharedInstance].boxPager reset];
            [[OTSPhoneRuntimeData sharedInstance].boxPager requestToTheEnd];
        }
        else
        {
            if (result.errorInfo)
            {
                [OTSUtility alert:result.errorInfo];
            }
            else
            {
                [OTSUtility alert:@"领取失败!"];
            }
        }
        OTS_SAFE_RELEASE(result);
    }];
}


-(void)requestAddToFav
{
    if (![self loginIfNot])
    {
        return;
    }
    
    ProductVO *product = [self resultProduct];
    
    //defence
    if (product == nil)
    {
        return;
    }
    
    [self.loadingView showInView:self.view];
    
    __block int result = 0;
    [self performInThreadBlock:^{
        
        result = [[OTSServiceHelper sharedInstance] addFavorite:[GlobalValue getGlobalValueInstance].token tag:@"" productId:product.productId];
        
    } completionInMainBlock:^{
        
        [self.loadingView hide];
        
        NSDictionary *resultHandleDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"收藏成功", [NSNumber numberWithInt:1]
                                         , @"收藏失败", [NSNumber numberWithInt:0]
                                         , @"商品已收藏", [NSNumber numberWithInt:-1]
                                         , nil];
        NSString *resultStr = [resultHandleDic objectForKey:[NSNumber numberWithInt:result]];
        if (resultStr)
        {
            [OTSUtility alert:resultStr];
        }
    }];
    
    JSTrackingPrama* prama = [[JSTrackingPrama alloc]initWithJSType:EJStracking_AddFavourite extraPrama:nil];
    [prama setProductId:product.productId];
    [DoTracking doJsTrackingWithParma:prama];
}

-(void)requestAddToCart
{
    ProductVO *product = [self resultProduct];
    
    //defence
    if (product == nil)
    {
        return;
    }
    
    
    if (self.rockResult.getResultType != kRockResultNormal && ![self loginIfNot])
    {
        return;
    }
    
    if (!_isLoginWhenRockResult) // 如果摇出结果时未登录，则需要检查结果
    {
        if ( ![self checkResultIsValid:[self.rockResult.resultType intValue]])
        {
            return;
        }
    }
    
    if ([GlobalValue getGlobalValueInstance].token == nil) // 未登录
    {
        // 加入本地购物车
        LocalCartItemVO * newLocalCartItem = [[[LocalCartItemVO alloc] initWithProductVO:product
                                                                                quantity:@"1"] autorelease];
        
        [SharedDelegate addProductToLocal:newLocalCartItem];
        [OTSUtility alert:ROCK_ADD_CART_OK_STR];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cartload" object:nil];
    }
    else
    {
        [self.loadingView showInView:self.view];
        
        __block AddProductResult *result = nil;
        [self performInThreadBlock:^{
            CartService*cSer=[[CartService alloc] init];
            result = [cSer addSingleProduct:[GlobalValue getGlobalValueInstance].token
                                                           productId:product.productId
                                                          merchantId:product.merchantId
                                                            quantity:[NSNumber numberWithInt:1]
                                                         promotionid:product.promotionId];
            [result retain];
            [cSer release];
            
            if (result.isSuccess && product.promotionId && [product.promotionId rangeOfString:@"landingpage"].location!=NSNotFound) {
                [[OTSWeRockService myInstance]updateStroageBoxProductType:[GlobalValue getGlobalValueInstance].token promotionIdList:[NSMutableArray arrayWithObject:product.promotionId] productIdList:[NSMutableArray arrayWithObject:product.productId] productStatus:[NSNumber numberWithInt:1]];
            }
            
        } completionInMainBlock:^{
            
            [self.loadingView hide];
            
            if (result.isSuccess)
            {
                [OTSUtility alert:ROCK_ADD_CART_OK_STR];
                
                StorageBoxVO *boxItem = [[OTSPhoneRuntimeData sharedInstance].boxPager getItemWithProduct:product];
                boxItem.rockProductV2.rockProductType = [NSNumber numberWithInt:kRockProductHasAddCart];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cartload" object:nil];
            }
            else
            {
                [OTSUtility alert:result.errorInfo];
            }
            
            [result release];
            
        }];
        //加入购物车数据统计
        JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_AddCart extraPramaDic:nil]autorelease];
        [prama setProductId:product.productId];
        [prama setMerchant_id:[NSString stringWithFormat:@"%@",product.merchantId]];
        [DoTracking doJsTrackingWithParma:prama];
    }
}



-(void)requestActivateGame
{
    _isActivatingGame = YES;
    
    if (![self loginIfNot])
    {
        return;
    }
    
    if ([self isGameActivated])   // 游戏已激活
    {
        _isActivatingGame = NO;
        [self enterGame];
        return;
    }
    
    [self.loadingView showInView:self.view];
    
    __block int result = 0;
    [self performInThreadBlock:^{
        
        result = [[OTSWeRockService myInstance] createRockGame:[GlobalValue getGlobalValueInstance].token];
        
    } completionInMainBlock:^{
        
        [self.loadingView hide];
        
        if (result == kCreateRockGameOK)
        {
            [OTSUtility alert:@"激活成功!"];
        }
        else if (result == kCreateRockGameFailed)
        {
            [OTSUtility alert:@"激活失败!"];
        }
        else if (result == kCreateRockGameServerError)
        {
            //[OTSUtility alert:@"激活失败，server内部错误!"];
        }
        
        // 检查激活状态，如果激活，直接进入游戏
        [self checkIsGameActivatedForced:YES];
        
    }];
}


-(void)addRockResultToBox
{
    if (self.rockResult
        && self.rockResult.resultType
        && [GlobalValue getGlobalValueInstance].token)
    {
        int resultType = [self.rockResult.resultType intValue];
        switch (resultType)
        {
            case kWeRockResultDisCount:
            {
                if (self.rockResult.rockProductV2List && self.rockResult.rockProductV2List.count > 0)
                {
                    RockProductV2 *rockProduct = [self.rockResult.rockProductV2List objectAtIndex:0];
                    [self addProductToBox:rockProduct];
                }
            }
                break;
                
            case kWeRockResultTicket:
            {
                // 抵用券不加寄存箱
                //                if (self.rockResult.couponVOList && self.rockResult.couponVOList.count > 0)
                //                {
                //                    RockCouponVO *rockTicket = [self.rockResult.couponVOList objectAtIndex:0];
                //                    [self addTicketToBox:rockTicket];
                //                }
            }
                break;
                
            default:
                break;
        }
    }
}

- (AddStorageBoxResult *)addProductToBox:(RockProductV2 *)theProduct
{
    AddStorageBoxResult *addResult = [[OTSWeRockService myInstance]
                                      addStorageBox:[GlobalValue getGlobalValueInstance].token
                                      productId:theProduct.prodcutVO.productId
                                      promotionId:theProduct.prodcutVO.promotionId
                                      couponNumber:nil
                                      type:[NSNumber numberWithInt:kRockBoxAddProduct]
                                      couponActiveId:[NSNumber numberWithInt:0]];
    
    DebugLog(@"add box result: %d", [addResult.resultCode intValue]);
    
    if (addResult && addResult.isSuccess)
    {
        StorageBoxVO *boxVO = [[[StorageBoxVO alloc] init] autorelease];
        boxVO.type = [NSNumber numberWithInt:kRockBoxItemProduct];
        boxVO.rockProductV2 = theProduct;
        
        [[OTSPhoneRuntimeData sharedInstance].boxPager addBoxItem:boxVO];
    }
    
    return addResult;
}

- (AddStorageBoxResult *)addTicketToBox:(RockCouponVO *)rockTicket
{
    AddStorageBoxResult *addResult = [[OTSWeRockService myInstance]
                                      addStorageBox:[GlobalValue getGlobalValueInstance].token
                                      productId:nil
                                      promotionId:nil
                                      couponNumber:rockTicket.couponVO.number
                                      type:[NSNumber numberWithInt:kRockBoxAddTicket]
                                      couponActiveId:rockTicket.activityId];
    
    DebugLog(@"add box result: %d", [addResult.resultCode intValue]);
    
    // 未领取的抵用券不再加入到本地寄存箱
    //    if (addResult && addResult.isSuccess)
    //    {
    //        StorageBoxVO *boxVO = [[[StorageBoxVO alloc] init] autorelease];
    //        boxVO.type = [NSNumber numberWithInt:kRockBoxItemTicket];
    //        boxVO.rockCouponVO = rockTicket;
    //
    //        [[OTSPhoneRuntimeData sharedInstance].boxPager addBoxItem:boxVO];
    //    }
    
    return addResult;
}

#pragma mark - location delegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation{
    DebugLog(@"the lng is: %lf, the lat is: %lf", newLocation.coordinate.longitude, newLocation.coordinate.latitude);
    [self.locationManager stopUpdatingLocation];
    [self.locationManager setDelegate:nil];
    [self requestRockResultV2:newLocation.coordinate];
    //[self requestRockResult];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self.locationManager stopUpdatingLocation];
    [self.locationManager setDelegate:nil];
    [self requestRockResult];
}
#pragma mark - 帮助方法

-(NSString *)stringFromDate:(NSDate *)anDate
{
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    NSString *anString = [dateFormatter stringFromDate:anDate];
    
    return anString;
}

-(BOOL)loginIfNot
{
    if ([GlobalValue getGlobalValueInstance].token==nil)
    {
        UserManage *userManage=[[[UserManage alloc] initWithNibName:@"UserManage" bundle:nil] autorelease];
        [userManage setLoginview];
        [userManage mysetCallTag:[NSNumber numberWithInt:kEnterLoginFromWeRock]];
        [self pushVC:userManage animated:YES];
        //        [userManage.view setFrame:CGRectMake(0, 20, 320, 460)];
        //        [self.view addSubview:userManage.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AccountAutoRetrieve" object:nil];
        
        return NO;
    }
    
    return YES;
}

-(ProductVO*)resultProduct
{
    OTSWeRockResultType resultType = [self.rockResult.resultType intValue];
    
    ProductVO *product = nil;
    if (resultType == kWeRockResultDisCount && self.rockResult.rockProductV2List.count > 0)
    {
        product = ((RockProductV2*)[self.rockResult.rockProductV2List objectAtIndex:0]).prodcutVO;
    }
    else if ((resultType == kWeRockResultNormal || resultType == kWeRockResultSale) && self.rockResult.productVOList.count > 0)
    {
        product = [self.rockResult.productVOList objectAtIndex:0];
    }
    
    return product;
}

-(BOOL)isGameActivated
{
    // RockGameVO 根据其中的 commonRockResultVO 判断(目前未定义)
    return self.rockGameVO && self.rockGameVO.gameStatus;
}




@end
