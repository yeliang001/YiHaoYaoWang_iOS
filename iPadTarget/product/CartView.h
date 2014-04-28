//
//  CartView.h
//  yhd
//
//  Created by  on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  

#import <UIKit/UIKit.h>
#import "CartVO.h"

@class DataHandler;
@protocol CartViewDelegate <NSObject>

- (void)openCartViewController;
@end

// CLASS_DESC: the view which dock at right side of product list
@interface CartView : UIView<UITabBarDelegate>{
//    NSMutableArray *productArray;
//    NSMutableDictionary *productCountDic;
    BOOL isExtend;//是否为展开状态；
    UIScrollView *scrollView;
    UIButton *closeBut;
    UIButton *jiesuanBut;
    UIButton *openBut;
    //UIButton *lookBut;
    UILabel *label1;
    UILabel *totleLabel;
    UIView *topView;
    UITabBar *tabBar;
    UITabBarItem *tabBarItem;
    DataHandler *dataHandler;
    id<CartViewDelegate> cartViewDelegate;
}
//@property(nonatomic,retain)NSMutableArray *productArray;
@property(nonatomic,assign)id<CartViewDelegate> cartViewDelegate;
-(void)reloadData;
-(void)setCartCount:(NSInteger)count;
-(id)initWithDefault;
@end
