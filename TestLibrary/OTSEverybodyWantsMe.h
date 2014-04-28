
#import "NSObject+OTS.h"
#import <QuartzCore/QuartzCore.h>


// 常量
#define NAVIGATION_BAR_HEIGHT       44.f
#define NAVIGATION_BTN_MARGIN_X     5.f
#define NAVIGATION_BTN_MARGIN_Y     7.f
#define NAVIGATION_BTN_WIDTH        50.f
#define NAVIGATION_BTN_HEIGHT       30.f


// ===============通知================
#define OTS_NOTIFY_ROCK_BUY_NOW             @"OTSNotifyRockBuyNow"              // 摇摇购立即购买
#define OTS_NOTIFY_ROCK_PRODUCT_CHANGE      @"OTSNotifyRockBuyProductChange"    // 摇摇购产品切换
#define OTS_NOTIFY_ROCK_PREV_PAGE           @"OTSNotifyRockBuyPrevPage"              // 摇摇购切换到上一页
#define OTS_NOTIFY_ROCK_NEXT_PAGE           @"OTSNotifyRockBuyNextPage"              // 摇摇购切换到下一页
// 购物车
#define OTS_NOTIFY_CART_LOAD                @"cartload"
#define OTS_NOTIFY_CART_ENTER               @"EnterCart"
#define OTS_NOTIFY_CART_NUM                 @"cart_num"
#define OTS_NOTIFY_CART_CHANGED             @"CartChanged"

#define OTS_NOTIFY_PROVINCE_CHANGED             @"ProvinceChanged"
#define OTS_NOTIFY_IMAGE_CACHE_RETRIEVED        @"OtsImageCacheRetrieved"

#define OTS_VC_REMOVED                          @"OtsVcRemoved"                // vc管理中，vc被移除
#define OTS_ENTER_ORDER_DETAIL                  @"ots_enter_order_detail"       // 进入订单详情
// ===============通知================


// 网龙appid
#define OTS_NET_DRAGON_APP_ID               1028

// color
#define OTS_VERY_LIGHT_GRAY     [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1]
#define OTS_LIGHT_GRAY     [UIColor colorWithRed:200./255 green:200./255 blue:200./255 alpha:1]

#define OTS_COLOR_FROM_RGB(rgbValue) \
[UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 \
blue:((float)((rgbValue) & 0xFF))/255.0 \
alpha:1.0]

// 方法定义
#define CURRENT_METHOD_NAME [NSStringFromSelector(_cmd) substringToIndex:[NSStringFromSelector(_cmd) rangeOfString:@":" options:NSLiteralSearch].location]
#define PROVINCE_ID [GlobalValue getGlobalValueInstance].provinceId
#define TRADER [GlobalValue getGlobalValueInstance].trader

// RELEASE AND SET NIL
#define OTS_SAFE_RELEASE(_obj) if ((_obj)) {[(_obj) release]; (_obj) = nil;}

// 其他
#define OTS_MAGIC_TAG_NUMBER        201206
#define OTS_VIEW_ANIM_KEY           @"Reveal"
#define OTS_MONEY_STR_MORMAT        @"￥%.2f"
#define OTS_DEFAULT_PRODUCT_IMG     @"defaultimg85.png"

// 字符串
#define OTS_SHAKE_BUY_INVITE_STR    @"我正在使用1号店1起摇，原价%.2f元的%@摇摇价只要%.2f元。来帮我一起摇吧！http://goo.gl/mXO0g"

// DEBUG
/////////////////////////////////LOG DEFINE BEGIN///////////////////////////////
#ifdef DEBUG
#define DebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DebugLog(...)
#endif

#define AlwaysLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#ifdef DEBUG
#define DebugAlertLog(fmt, ...)  { UIAlertView *alert = [[OTSAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#define DebugAlertLog(...)
#endif
/////////////////////////////////LOG DEFINE END///////////////////////////////

////////IOS VERSION////////
#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_4_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_4_0 550.32
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
#define IF_IOS4_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_4_0) \
{ \
__VA_ARGS__ \
}
#else
#define IF_IOS4_OR_GREATER(...)
#endif

#define IF_PRE_IOS4(...)  \
if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iPhoneOS_4_0)  \
{ \
__VA_ARGS__ \
}

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_5_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_5_0 674.0
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
#define IF_IOS5_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_5_0) \
{ \
__VA_ARGS__ \
}
#else
#define IF_IOS5_OR_GREATER(...)
#endif

#define IF_PRE_IOS5(...)  \
if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iPhoneOS_5_0)  \
{ \
__VA_ARGS__ \
}
////////IOS VERSION////////
