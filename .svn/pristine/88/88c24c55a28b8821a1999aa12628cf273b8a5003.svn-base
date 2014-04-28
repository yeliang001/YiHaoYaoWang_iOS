//
//  GroupBuyProductDetail.h
//  TheStoreApp
//
//  Created by jiming huang on 12-2-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define FROM_GROUPON_HOMEPAGE_TO_DETAIL   0
#define FROM_CMS_TO_DETAIL   1
#define FROM_URLSCHEME_TO_DETAIL 2
#define FROM_ROCKBUY_TO_DETAIL 3

#import <UIKit/UIKit.h>
#import "GrouponVO.h"
#import "UserManage.h"
#import "GroupBuyService.h"
#import "ShareActionSheet.h"
#import "GroupBuyCheckOrder.h"

@interface GroupBuyProductDetail : OTSBaseViewController<UIWebViewDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate> {
@private
    NSNumber *m_AreaId;//传入参数，地区id
    NSArray *m_Products;//传入参数，首页当前分类下所有商品
    int m_CurrentIndex;//传入参数，当前商品的索引
    GrouponVO *m_grouponVO;
    IBOutlet UIButton *m_ReturnBtn;//
    IBOutlet UIButton *m_ShareBtn;//
    IBOutlet UIButton *m_PreviousBtn;//
    IBOutlet UIButton *m_NextBtn;//
    IBOutlet UIView *m_BottomView;//
    IBOutlet UILabel *m_PriceLabel;//
    IBOutlet StrikeThroughLabel *m_MarketPriceLabel;//
    IBOutlet UIButton *m_BuyBtn;//
    UIActionSheet *m_ActionSheet;
    IBOutlet UIPickerView *m_PickerView;//
    UIButton *m_ColorSizeBtn;
    IBOutlet UIView *m_DetailView;//
    IBOutlet UIWebView *m_DetailWebView;//
	IBOutlet UITextView *textView;
    UIScrollView *m_ScrollView;
    UIScrollView *m_CurrentScrollView;
    
    NSMutableDictionary *m_Dictionary;
    bool m_ThreadIsRunning;
    NSInteger m_CurrentState;
    ShareActionSheet *m_Share;
    NSTimer *m_Timer;
    NSInteger m_RemainTime;
    NSString *m_SelCorlor;
    NSString *m_SelSize;
    NSString *m_CurColor;
    NSString *m_CurSize;
    NSInteger m_ColorIndex;
    BOOL isDirectOrder;
    
    //UserManage *m_UserManager;
    GroupBuyService *m_Service;
    //GroupBuyCheckOrder *m_CheckOrder;
    NSNumber *m_ProvinceId;//团购省份id
    int m_FromTag;//传入参数，标志从哪里进入团购详情
}

@property(nonatomic,retain) NSNumber *m_AreaId;
@property(nonatomic,retain) NSArray *m_Products;
@property int m_CurrentIndex;
@property(nonatomic, retain)GrouponVO *m_grouponVO;
@property int m_FromTag;//传入参数，标志从哪里进入团购详情

-(void)initProductDetail;
-(IBAction)returnBtnClicked:(id)sender;
-(IBAction)shareBtnClicked:(id)sender;
-(IBAction)previousBtnClicked:(id)sender;
-(IBAction)nextBtnClicked:(id)sender;
-(void)initPickerView:(UIPickerView *)pickerView;
-(IBAction)returnToMainView:(id)sender;

-(void)setUpThread;
-(void)stopThread;
@end
