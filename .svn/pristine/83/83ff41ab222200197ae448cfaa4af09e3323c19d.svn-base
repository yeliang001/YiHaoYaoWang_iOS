//
//  ErrorStrings.m
//  TheStoreApp
//
//  Created by zhengchen on 11-11-28.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//

#import "ErrorStrings.h"
#import "GlobalValue.h"

@implementation ErrorStrings

+(NSString*) getCartError:(int)code{
    switch (code) {
        case 0://购买失败
			return @"购买失败";
		case -1://您的信用过低
			return @"您的信用过低";
		case -2://只有黄金会员才能购买此产品
			return @"只有黄金会员才能购买此产品";
		case -3://此产品为特价商品,购买数量超过限制
			return @"此产品为特价商品,购买数量超过限制";
		case -4://此产品只能使用返利购买，您的返利不足
			return @"此产品只能使用返利购买，您的返利不足";
		case -5://此产品只限上海（崇明、长兴和横沙除外）地区配送
			return @"此产品只限上海（崇明、长兴和横沙除外）地区配送";
		case -6:
			return @"此产品为赠品，不能购买";
		case -7:
			return @"此产品为主系列产品，不能购买";
		case -8:
			return @"此产品为特价商品，购买数量超过限制";
		case -9:
			return @"当订单中包含[10元虚拟卡]与其他非卡类商品时，每个订单限购一张[10元虚拟卡],请修改商品数量";
		case -10:
			return @"由于活动限制，无法添加该商品" ;
		case -11:
			return @"此产品每日一款活动的商品,添加购物车出错";
		case -12:
			return @"对不起，当前商家或者仓库不能覆盖您所在的地区，请选择其它商家";
		case -13:
			return @"对不起，没有覆盖到您所在地区的商家，请选择别的省份";
		case -14:
			return @"对不起，中信积分不足,不能购买" ;
		case -15:
			return @"您的收货地址所在的商家目前不销售" ;
		case -16:
			return @"您已购买或加入购物车的数量超过限购数量" ;
		case -17:
			return @"您加入购物车的数量超过该商品在您的公司的剩余数量";
		case -21:
			return @"库存不足"; 
        case -22:
            return @"活动已结束，请参加其他促销活动";
        case -23:
            return @"您已经参加过活动，不能重复参加";
        case -24:
            return @"抱歉！您不满足限制条件，不能参加活动";
        case -25:
            return @"您已超过活动累积次数，不能重复参加";
        case -26:
            return @"您购买的商品超过限购数量";
        case -27:
            return @"您的购物车中已经存在同一活动的活动商品，此活动每笔订单只能购买一款活动商品。";//@"您购买的商品超过限购种类";
        case -28:
            return @"您购买的商品已超额，不能继续购买";
        case -29:
            return @"您购买的商品已超过今日限额，不能继续购买";
		case 99:
			if ([GlobalValue getGlobalValueInstance].errorType==0) {
				return @"网络异常，请重新登录";
			}else {
				return @"服务器内部错误，请稍候再试";
			}
			break;
		default:
			return @"购买失败";
    }
}

@end
