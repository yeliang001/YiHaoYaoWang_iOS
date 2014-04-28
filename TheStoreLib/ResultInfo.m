//
//  ResultInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-8-6.
//
//

#import "ResultInfo.h"

@implementation ResultInfo


- (void)dealloc
{
//    [_responseCode release];
    [_resultObject release];
    [super dealloc];
}

- (NSString *)errorStr
{
    NSString *error;
    
    switch (_resultCode)
    {
        case 2:
             error = @"请先登陆";
            break;
        case 3:
            error = @"请重新登陆"; //token不正确
            break;
        case 4:
            error = @"系统繁忙,请稍后";
            break;
        case 5:
            error = @"您的地址数量达到最大值了";
            break;
        case 6:
            error = @"添加地址失败";
            break;
        case 7:
            error = @"删除地址失败";
            break;
        case 8:
            error = @"修改地址失败";
            break;
        case 9:
            error = @"商品已收藏";
            break;
        case 10:
            error = @"参数校验失败";
            break;
        case 11:
            error = @"添加收藏失败";
            break;
        case 12:
            error = @"未找到对应的商家信息";
            break;
        case 20:
            error = @"系统出错";
            break;
        case 21:
            error = @"用户名不规范";
            break;
        case 22:
            error = @"邮箱不符合规则";
            break;
        case 23:
            error = @"密码不符合规则";
            break;
        case 24:
            error = @"IP不符合规则";
            break;
        case 25:
            error = @"目前IP注册次数超过限制";
            break;
        case 26:
            error = @"用户名已存在";
            break;
        case 27:
            error = @"邮箱已存在";
            break;
        case 28://连接redis异常或者插入数据库异常
            error = @"系统繁忙，请稍后";
            break;
        case 31:
            error = @"参数为空";
            break;
        case 32:
            error = @"用户名不存在";
            break;
        case 33:
            error = @"该帐户已被禁用";
            break;
        case 34:
            error = @"密码错误";
            break;
        case 35:
            error = @"系统繁忙，请稍后"; //同28
            break;
        case 40:
            error = @"该商品已下架，请修改购物车后重新下单！";
            break;
        case 41:
            error = @"商品数量不一致，请重新下单！";
            break;
        case 42:
            error = @"该用户尚未添加收货地址，请添加收货地址！";
            break;
        case 43:
            error = @"该用户尚未添加收货地址，请添加收货地址！";
            break;
        case 44:
            error = @"未找到指定地址信息，请检查订单地址信息是否有误！"; //已经告诉服务器
            break;
        case 45:
            error = @"购物车商品为空，请修改购物车后重新下单！";
            break;
        case 46://-这个就是你那边汇总的商品总金额跟服务端的不一致。
            error = @"您修改了购物车数据！请重新下单！";
            break;
        case 47:
            error = @"该商品不支持货到付款，请重新选择支付方式后重新下单！";
            break;
        case 48:
            error = @"该商品不支持货到刷卡，请重新选择支付方式后重新下单！";
            break;
        case 49:
            error = @"商品缺货，请修改购物车后重新下单";
        case 77:
            error = @"发票信息校验失败";
            break;
        case 702:
            error = @"促销信息校验失败";
            break;
        default:
            error = @"未知错误";
            break;
    }
    return error;
}

@end
