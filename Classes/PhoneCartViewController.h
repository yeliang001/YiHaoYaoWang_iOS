//
//  PhoneCartViewController.h
//  TheStoreApp
//
//  Created by yuan jun on 12-11-21.
//
//

#import <UIKit/UIKit.h>
#import "OTSBaseViewController.h"
@class CheckOrder;
@class UserManage;
@class Gift;
@class OTSLoadingView;
@class CartInfo;
@interface PhoneCartViewController : OTSBaseViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>
{
    UITableView*cartTableView,*promotionTable;
//    NSMutableArray* m_ProductArray,*m_SelectedGift,*m_AllGiftArray,*RedemptionPromotionArray,*CashPromotionArray,*selectedRedemptionArray,*selectedCashPromotionArray,*merchantIdArray,*productIdArray,*currentSelCashArray;
    int m_CurrentIndex;
    CGFloat m_TotalPrice;//总价格
    int m_TotalCount;//总数量
    int m_ProductCount;//选择的商品数量
//    int totalNeedPoint;//积分总消耗
    CGFloat m_TotalWeight;//总重量
    CGFloat m_TotalCash;  //立减金额
//    double m_totalPriceMall;  //1mall商品总价
//    int m_totalQuantityMall;//1mall商品总件数
    BOOL m_HasAddress,m_hasRePromtion,m_DirectToOrder,cartOnLoading;
    UIImageView* emptyView;
    UIActionSheet *m_ActionSheet;
    UIPickerView* m_PickerView;
    UIImageView* feeImageView;
    UIView*tableFooter;
    UIButton*showFeeBtn;
    UIButton*editBtn;
    UIButton* accountBtn;
    UIButton* submitBtn,*m_CleanBtn;
    UILabel* productsNum;
    UILabel*totalWeight;
//    UILabel*pointNum;
    UILabel*bill;
//    NSMutableDictionary *hasJoinCash; //是否已经参加满减活动  index path 作key
//    NSMutableArray * distributionArray; //保存不能配送的商品（只读）
//    NSString * distributionError; //不能配送商品时候的提示信息
    
    CartInfo *_cartInfo;
    NSMutableArray *_selectedGiftList;
    
    
    //yaowang 标记是否有缺货
    BOOL _bSomeProductNoStock;
    
}
@property(nonatomic,retain) UITableView* cartTableView;
@property(nonatomic,retain) NSMutableArray * distributionArray;
@property(nonatomic,retain) NSString * distributionError;
@property(nonatomic,retain) NSMutableArray *localCartInfoArr;  //获取到本地购物车里的全部商品的数组
@property(nonatomic,retain) NSMutableArray *latestProductArr;  //获取到服务器的最新商品数据
@property(nonatomic,retain) NSMutableArray *productStockArr;   //商品的库存信息
@property(nonatomic,retain) NSMutableArray *cartProductArr;    //最终整合的购物车中商品数组，每个元素是字典，包含商品的productInfo对象和购买数量

-(void)showMainViewFromTabbarMaskAnimated:(BOOL)aAnimated;
-(void)refreshCart;

-(void)toastShowString:(NSString *)string;
@end
