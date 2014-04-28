//
//  GoodReceiver.h
//  GoodReceiver
//
//  Created by yangxd on 11-2-15.
//  Updated by yangxd on 11-3-11.
//  Updated by yangxd on 11-06-14  去除成功时的提示框
//  Copyright 2011 vsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@class GoodReceiverVO;
@class AddressService;
@class OrderService;
@class Trader;
@class ProvinceVO;
@class CityVO;
@class CountyVO;
@class UserManage;
@class EditGoodsReceiver;

#define FROM_CHECK_ORDER    1
#define FROM_MY_STORE  2

@interface GoodReceiver : OTSBaseViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UILabel *m_TitleLabel;//
    IBOutlet UIScrollView *m_ScrollView;//
    IBOutlet UIView *m_InfoView;//
    UIView *m_NewAddressView;//添加收货地址的提示view
    UIButton *m_CurrentBtn;
    
    EditGoodsReceiver *m_EditGoodsReceiver;
    BOOL isFromGroupon;//传入参数，是否从团购过来
    int m_FromTag;//传入参数，从1号店进入或是从检查订单进入
    NSNumber *m_DefaultReceiverId;//传入参数，默认收货地址id
    
    int m_ThreadState;
    BOOL m_ThreadRunning;
    
	NSArray *m_ReceiverArray;
    
    NSString *m_CurrentProvince;
    
    int m_CurrentIndex;    
    bool done;
    NSArray * distributionArray; //保存不能配送的商品（只读）
    bool mo_Address;
    BOOL isFromCart;
    BOOL backToCart;//返回购物车标示
    NSArray * m_SelectedGift;// 购物车中的赠品，需要从购物车中传入过来
}
@property BOOL isFromGroupon;//传入参数，是否从团购过来
@property BOOL isFromCart;//传入参数，是否从购物车过来
@property int m_FromTag;//传入参数，从1号店进入或是从检查订单进入
@property BOOL backToCart;//参数，返回购物车标示
@property(nonatomic,retain) EditGoodsReceiver *m_EditGoodsReceiver;
@property(nonatomic,retain) NSNumber *m_DefaultReceiverId;//传入参数，默认收货地址id
@property(nonatomic,retain) NSArray * distributionArray;//保存不能配送的商品（只读）
@property(nonatomic,retain) NSArray * m_SelectedGift;// 购物车中的赠品，需要从购物车中传入过来
-(void)initGoodReceiver;
-(IBAction)returnBtnClicked:(id)sender;
-(IBAction)enterAddGoodsReceiver:(id)sender;
-(void)setUpThread;
-(void)stopThread;
@end
