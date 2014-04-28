//
//  EditGoodsReceiver.h
//  TheStoreApp
//
//  Created by jiming huang on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodReceiverVO.h"
//#import "ProvinceVO.h"
//#import "CityVO.h"
//#import "CountyVO.h"
#import "UserManage.h"
#import "YWAddressService.h"



#define FROM_CHECK_ORDER    1

@interface EditGoodsReceiver : OTSBaseViewController
<UIActionSheetDelegate
, UIAlertViewDelegate
, UIGestureRecognizerDelegate
, UIScrollViewDelegate> 
{
    GoodReceiverVO *m_GoodsReceiverVO;//传入参数
    IBOutlet UIScrollView *m_ContentView;//
    IBOutlet UIButton *m_ProvinceBtn;//
	IBOutlet UIButton *m_CityBtn;//
	IBOutlet UIButton *m_DistrictBtn;//
    IBOutlet UITextField *m_NameField;//
	IBOutlet UITextField *m_AddressField;//
	IBOutlet UITextField *m_MobileField;//
	IBOutlet UITextField *m_PhoneField;//
    IBOutlet UIButton *m_DeleteBtn;//
    IBOutlet UIPickerView *m_ProvincePickerView;//
	IBOutlet UIPickerView *m_CityPickerView;//
	IBOutlet UIPickerView *m_DistrictPickerView;//
    IBOutlet UILabel *m_TitleLabel;//
    UIActionSheet *m_ProvinceActionSheet;
	UIActionSheet *m_CityActionSheet;
	UIActionSheet *m_DistrictActionSheet;
    
    int m_ThreadState;
    BOOL m_ThreadRunning;
    
    /*ProvinceVO*/ AddressInfo *m_SelectedProvince;
	/*CityVO*/ AddressInfo *m_SelectedCity;
	/*CountyVO*/ AddressInfo *m_SelectedDistrict;
	NSArray *m_ProvinceArray;
	NSArray *m_CityArray;
	NSArray *m_DistrictArray;
    
    int provinceSelectedRow;
    int citySelectedRow;
    int districtSelectedRow;
    
    int provinceFrontRow;
    int cityFrontRow;
    int districtFrontRow;
    
//    CLGeocoder *m_Geocoder;
    NSMutableArray *m_Lngs;
    NSMutableArray *m_Lats;
    
    int m_FromTag;
    NSString *m_CurrentProvince;
    
    BOOL        isProvinceChanged;
    BOOL        isFromCart;
    BOOL        backToCart;
    NSArray * distributionArray; //保存不能配送的商品（只读）
    NSArray * m_SelectedGift;// 购物车中的赠品，需要从购物车中传入过来
}
@property(nonatomic,retain) GoodReceiverVO *m_GoodsReceiverVO;
@property(nonatomic,retain) NSArray * distributionArray; //无法配送的商品列表
@property(nonatomic,retain) NSArray * m_SelectedGift;// 购物车中的赠品，需要从购物车中传入过来
@property(retain)NSMutableArray *m_Lngs;
@property(retain)NSMutableArray *m_Lats;
@property int m_FromTag;//传入参数
@property BOOL        isFromCart;//传入参数
@property BOOL        backToCart;//传入参数

-(void)initEditGoodsReceiver;
-(IBAction)returnBtnClicked:(id)sender;
-(IBAction)setProvince:(id)sender;
-(IBAction)setCity:(id)sender;
-(IBAction)setDistrict:(id)sender;
-(IBAction)clickFinishSettingProvince:(id)sender;
-(IBAction)clickFinishSettingCity:(id)sender;
-(IBAction)clickFinishSettingDistrict:(id)sender;
-(IBAction)cancelSettingProvince:(id)sender;
-(IBAction)cancelSettingCity:(id)sender;
-(IBAction)cancelSettingDistrict:(id)sender;
-(IBAction)deleteBtnClicked:(id)sender;
-(void)getUserLocation;
-(void)viewMoveUpAddress;
-(void)viewMoveUpMobile;
-(void)viewMoveUpPhone;
-(void)viewMoveDown;
-(void)closeKeyBorad;
-(void)setUpThread;
-(void)stopThread;
@end
