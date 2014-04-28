//
//  NewAddressSheet.h
//  yhd
//
//  Created by jun yuan on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodReceiverVO.h"
#import "WEPopoverController.h"
#import "ProvinceChooseAddressViewController.h"
#import "CityChooseAddressViewController.h"
#import "CountyChooseAddressViewController.h"
#import "DataHandler.h"
@interface NewAddressSheet : BaseViewController<UIPickerViewDataSource
,UIPickerViewDelegate
,UITextFieldDelegate
,UIAlertViewDelegate
,ProvinceChooseAddressDelegate
,CityChooseAddressDelegate
,CountyChooseAddressDelegate>
{
    NSArray * mprovince;//provicevo
    NSArray * mcity;//CityVO
    NSArray * mcounty;//CountyVO
    IBOutlet UIPickerView* mpickerview1;
    IBOutlet UITextField* mtextField1;
    int mproviceselectedindex;
    IBOutlet UIPickerView* mpickerview2;
    IBOutlet UITextField* mtextField2;
    int mcityselectedindex;
    IBOutlet UIPickerView* mpickerview3;
    IBOutlet UITextField* mtextField3;
    int mcountyselectedindex;
    GoodReceiverVO * mnewgoodreceive;//if edit this property need to be init;
    IBOutlet UILabel * mTitleLabel;
    
    IBOutlet UITextField * mreceiveNameTextField;
    IBOutlet UITextField * maddressTextField;
    IBOutlet UITextField * mreceivePhone;
    IBOutlet UITextField * mreceiveMobile;
    
    BOOL isnewAddress;//yes newaddress; no editaddress 
    
    IBOutlet UIView * mChangeLocationView;//because shanghai has no three.
    IBOutlet UIView * mHiddenView;//because shanghai has no three.
    NSMutableArray * m_Lngs;
    NSMutableArray * m_Lats;
    
    WEPopoverController * mPopOverController;
    WEPopoverController * mCityPopOverController;
    WEPopoverController * mCountyPopOverController;
    
    ProvinceVO* mchangedProvinceVO;
    
    BOOL isShowingBack;
    IBOutlet UIButton * mbackButton;
    IBOutlet UIButton * mcloseButton;
    
    BOOL isNotLimited;//this is used in userCenter
    DataHandler *datahandler;

}
@property(nonatomic,retain)NSArray * mprovince;
@property(nonatomic,retain)NSArray * mcity;
@property(nonatomic,retain)NSArray * mcounty;
@property(nonatomic,retain)GoodReceiverVO* mnewgoodreceive;
@property(nonatomic,assign)BOOL isnewAddress;
@property(nonatomic,assign)BOOL isShowingBack;
@property(nonatomic,assign)BOOL isNotLimited;
@property(nonatomic,retain)WEPopoverController* mPopOverController;
@property(nonatomic,retain)WEPopoverController* mCityPopOverController;
@property(nonatomic,retain)WEPopoverController* mCountyPopOverController;
-(void)showgoodreceive;
-(IBAction)downpickerviewClicked:(id)sender;
-(IBAction)okClicked:(id)sender;
-(IBAction)closeClicked:(id)sender;
-(IBAction)backClicked:(id)sender;
-(int)checkTelephone;
-(void)transaddresstolatandlongWithSelector:(SEL)aSelector;
@end
