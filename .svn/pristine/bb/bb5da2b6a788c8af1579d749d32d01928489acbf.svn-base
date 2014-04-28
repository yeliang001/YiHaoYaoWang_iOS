//
//  CartNum.m
//  TheStoreApp
//
//  Created by tianjsh on 11-3-7.
//  Copyright 2011 VSC. All rights reserved.
//

#import "CartNum.h"


@implementation CartNum
#pragma mark 初始化购物车数量
-(void)init:(UIViewController *)cartView{
    if (cartViewController==nil) {
		cartViewController=cartView;
	}
}
#pragma mark 设置购物车数量
-(void)setCartNum:(NSString *)num{
    if (cartViewController!=nil) {		
		cartViewController.tabBarItem.badgeValue=num;
	}
}
@end
