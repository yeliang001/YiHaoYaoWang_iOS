//
//  GlobalValue.m
//  TheStoreApp
//
//  Created by linyy on 11-2-22.
//  Copyright 2011 vsc. All rights reserved.
//

#import "GlobalValue.h"
#import "Trader.h"
#import "ShareToMicroBlog.h"
#import "OTSWrBoxPageGetter.h"
#import "OTSUserSwitcher.h"
#import "NSMutableArray+Stack.h"
#import "UserVO.h"


@implementation GlobalValue

@dynamic token;
@synthesize storeToken = _storeToken;
@synthesize provinceId;
@synthesize gpsProvinceStr;
@synthesize orderId;
@synthesize trader;
@synthesize status;
@synthesize errorType;
@synthesize errorString;
@synthesize userPassword;
@synthesize userName;
@synthesize categotyTitles;
@synthesize myStoreIndex;
@synthesize toOrderFromPage;
@synthesize toJiePangFromPage;
@synthesize toActivityFromPage;
@synthesize isFirstInCategory;
@synthesize isNeedReload;
@synthesize isFirstLoad;
@synthesize isFromMyOrder;
@synthesize downloadVO;
@synthesize haveAlertViewInShow;
@synthesize hotPage;
@synthesize sinaUserName;
@synthesize sinaPassword;
@synthesize jiePangUserName;
@synthesize jiePangPassword;
@synthesize mbService;
@synthesize width;
@synthesize height;
@synthesize localCartFileName;
@synthesize lastRefreshTime;
@synthesize nickName;
@synthesize userImg;
@synthesize isUnionLogin;
@synthesize bankVOList = _bankVOList;
@synthesize cateLeveltrackArray;
@synthesize shouldDownLoadIcon;
@synthesize deviceToken;
@synthesize currentUser;
@synthesize sessionID;
@synthesize alixpayOrderId;
@synthesize isFromOrderDetailForAlix;
@synthesize isFromOrderGROUPDetailForAlix;
@synthesize isFromOrderSuccessForAlix;

+(GlobalValue *)getGlobalValueInstance{  
	static GlobalValue * instance;  
	@synchronized(self){  
		if (instance==nil){
			instance=[[GlobalValue alloc]init];
		}
		return instance;  
	}  
}

+(BOOL) useVirtualService{
    return NO;
}


/// 这样使用token 为了区分1号店喝1号商城 ，药店直接忽视，使用ywToken ，艹，尼玛。。。。
- (NSString*)token
{
    return [OTSUserSwitcher sharedInstance].currentToken;
}

- (NSInteger)currentRepertory
{
    NSInteger repertory;
    switch ([provinceId intValue])
    {
        case 2:case 3:case 4:case 32:case 8:case 9:case 10:case 11:case 16:case 17:case 26:case 27:case 28:case 29:case 30:
            repertory = 233900;
            break;
        case 1:case 5:case 6:case 13:
            repertory = 15;
            break;
        case 14:case 15:case 18:case 19:case 20: case 21:case 22:case 7:case 12:case 23:case 24:case 25:
            repertory = 13;
            break;
        default:
            repertory = 15;
            break;
    }
    
    return repertory;
}





@end
