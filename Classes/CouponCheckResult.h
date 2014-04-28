//
//  CouponSaveResultVO.h
//  TheStoreApp
//
//  Created by towne on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*
 抵用卷的相关验证：
 1.抵用卷保存验证
 resultCode=1，保存抵用券成功。
 resultCode=-1，抵用券输入错误。errorInfo=抵用券不存在 ，您是不是输错啦。
 resultCode=-2。errorInfo=抵用券为1号店抵用券，不可在药网使用哦。
 resultCode=-3。errorInfo=抵用券为药网抵用券，不可在1号店使用哦。
 resultCode=-4，抵用券没有生效。errorInfo=抵用券从yyyy-MM-dd HH:mm:ss才生效哦。
 resultCode=-5，抵用券已过期。errorInfo=抵用券已于yyyy-MM-dd HH:mm:ss过期。
 resultCode=-6，抵用券未激活。errorInfo=抵用券还未激活哦，请先激活抵用券。这次迭代不支持激活，需去前台激活。
 resultCode=-7。errorInfo=抵用券需激活后30分钟才可以使用哦。
 resultCode=-8，分类券不支持COD。errorInfo=抵用券不支持货到付款及货到刷卡。
 resultCode=-9。errorInfo=您的订单中已经用过抵用券咯。
 resultCode=-10。errorInfo=产品券不能与其他抵用券同时使用。
 resultCode=-11。errorInfo=产品券不能和仅可使用一张的抵用券同时使用。
 resultCode=-12。errorInfo=您已使用过抵用券，每个用户只能使用一次哦。（被自己使用了）
 resultCode=-13。errorInfo=该抵用券已被使用，请您重新输入抵用券号码 。（被别人使用了）
 resultCode=-14。errorInfo=您不是首次下单，不能使用新会员抵用券哦。
 resultCode=-15。errorInfo=抵用券要购物次数满足1次 ，您不满足条件无法使用。
 resultCode=-16。errorInfo=您当前的收货地址不能使用该抵用券，只能在XX地区使用哦。
 resultCode=-17。errorInfo=仅购买礼品卡或积分商品不能使用抵用券哦。
 resultCode=-18。errorInfo=本活动中您已经超过抵用券使用上限X次，请期待下次活动。
 resultCode=-19。errorInfo=您不能使用抵用券，要在特定网盟下才能使用。
 resultCode=-20。errorInfo=抵用券要求购买商品满XXX元（件）（不包含积分兑换商品及礼品卡)才能使用。
 resultCode=-21。errorInfo=实体卡只限同一人使用哦。
 resultCode=-22。errorInfo=系列抵用券需上一张XXX使用成功后（订单完成），才可使用。
 resultCode=-23。errorInfo=抵用券将于前一张券订单完成后第二天激活，请您明天再来使用。
 resultCode=-24。errorInfo=一件指定商品仅可使用一张产品券哦。
 resultCode=-25。errorInfo=抵用券要求XXXXXX（不包含积分及“积分+现金”兑换商品 及礼品卡）。
 resultCode=-26。errorInfo=长时间未操作，登录失效，请重新登录。此时，客户端需要重新登录，一般不会出现此情况。
 resultCode=-27。errorInfo=抵用券需要用户绑定手机验证。此时，客户端需要短信验证绑定手机。
 resultCode=-28。errorInfo=抵用券需要手机验证，每个用户当天只能获取3次短信动态密码哦，请您明天再试。
 resultCode=-29。errorInfo=抵用券需要手机验证，同一个手机号一天只能验证3次，请您明天再试。
 resultCode=-30。errorInfo=抵用券需要手机验证，验证码已发送至您的领券手机号xxxxxx，请查收并完成验证。
 resultCode=-31。errorInfo=很抱歉，系统出错，请重新选择使用抵用券。
 
 2.抵用卷的短信验证
 resultCode=1，短信发送成功。
 resultCode=-1。errorInfo=您输入的手机号码格式不正确，请重新输入。
 resultCode=-2。errorInfo=同一个用户一天只能验证3次，请您明天再试。
 resultCode=-3。errorInfo=同一个手机号一天只能验证3次，请您明天再试。
 resultCode=-4。errorInfo=每次验证需间隔5分钟，请您稍后再试。
 resultCode=-5。errorInfo=已有用户绑定此手机号码，请换其他号码再试。
 resultCode=-6。errorInfo=您还没有登录，请先登录再试。此时，客户端需要重新登录，一般不会出现此情况。
 resultCode=-7，服务器异常。errorInfo=短信发送失败。
 
 
 3.抵用卷的验证码验证
 resultCode=1，短信验证成功。
 resultCode=-1。errorInfo=您输入的验证码不对，请重新输入。
 resultCode=-2。errorInfo=同一个用户一天只能验证3次，请您明天再试。
 resultCode=-3。errorInfo=同一个手机号一天只能验证3次，请您明天再试。
 resultCode=-4。errorInfo=您输入的验证码已失效，请重新获取验证码。
 resultCode=-5。errorInfo=您还没有登录，请先登录再试。此时，客户端需要重新登录，一般不会出现此情况。
 resultCode=-6，服务器异常。errorInfo=短信验证失败。
 
 */

#import <Foundation/Foundation.h>

@interface CouponCheckResult : NSObject{
@private
    NSNumber     *resultCode;
    NSString     *errorInfo;
}
@property(retain)NSNumber      *resultCode;
@property(retain)NSString      *errorInfo;


@end

@interface CouponVerifyCheckCodeResult : CouponCheckResult

@end

@interface CouponGetCheckCodeResult:CouponCheckResult

@end

@interface CouponSaveResult : CouponCheckResult

@end

@interface CouponDeleteResult :  CouponCheckResult

@end

