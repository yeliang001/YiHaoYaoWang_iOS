//
//  EditGoodsReceiver.m
//  TheStoreApp
//
//  Created by jiming huang on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EditGoodsReceiver.h"
#import "RegexKitLite.h"
#import "AlertView.h"
#import "AddressService.h"
#import "OTSAlertView.h"
#import "OTSActionSheet.h"
#import "TheStoreAppAppDelegate.h"
#import "DoTracking.h"
#import "YWAddressService.h"
#import "AddressService.h"

#import "ResultInfo.h"

#define PROVINCE_SELECT_PICKER_TAG_VALUE 0
#define CITY_SELECT_PICKER_TAG_VALUE 1
#define DISTRICT_SELECT_PICKER_TAG_VALUE 2

#define ALERTVIEW_TAG_CANNOT_ORDER 1
#define ALERTVIEW_TAG_CANNOT_ORDER_WHEN_SAVE 2
#define ALERTVIEW_TAG_DELETE_RECEIVER 3
#define ALERTVIEW_TAG_ORDER_DISTRIBUTION 4
#define ALERTVIEW_TAG_ORDER_DISTRIBUTIONV2 5

#define THREAD_STATUS_GET_PROVINCE 100
#define THREAD_STATUS_GET_CITY 101
#define THREAD_STATUS_GET_DISTRICT 102
#define THREAD_STATUS_SAVE_RECEIVER 103
#define THREAD_STATUS_DELETE_RECEIVER 104
#define THREAD_STATUS_GET_RECEIVERLIST 105

//m_ContentView

@interface EditGoodsReceiver ()
@property(nonatomic,retain)UIView*  escapeView;
@end

@implementation EditGoodsReceiver
@synthesize m_GoodsReceiverVO;
@synthesize m_FromTag, escapeView, m_Lngs, m_Lats,distributionArray,isFromCart,m_SelectedGift;
@synthesize backToCart;






#pragma mark -
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        [self viewMoveDown];
        [self closeKeyBorad];
    }
	
	return YES;
}


#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // iphone5适配 - dym
    CGRect rc = m_ContentView.frame;
    rc.size.height = self.view.frame.size.height -  OTS_IPHONE_NAVI_BAR_HEIGHT;
    m_ContentView.frame = rc;
    
    [self initEditGoodsReceiver];
    
    //m_ContentView.bounces = NO;
    m_ContentView.alwaysBounceVertical = YES;
    m_ContentView.showsVerticalScrollIndicator = NO;
    
    // tap guesture
    self.escapeView = [[[UIView alloc] initWithFrame:m_ContentView.bounds] autorelease];
    escapeView.backgroundColor = [UIColor clearColor];
    [m_ContentView addSubview:escapeView];
    [m_ContentView sendSubviewToBack:escapeView];
    
    UITapGestureRecognizer* ges = [[[UITapGestureRecognizer alloc] init] autorelease];
    ges.delegate = self;
    [escapeView addGestureRecognizer:ges];
}

-(void)initEditGoodsReceiver
{
    m_SelectedProvince=[[AddressInfo alloc] init];
	m_SelectedCity=[[AddressInfo alloc] init];
	m_SelectedDistrict=[[AddressInfo alloc] init];
    provinceFrontRow=0;
    cityFrontRow=0;
    districtFrontRow=0;

    //当前省份
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *path=[paths objectAtIndex:0];
	NSString *filename=[path stringByAppendingPathComponent:@"SaveProvinceId.plist"];
	NSArray *mArray=[NSArray arrayWithContentsOfFile:filename];
	m_CurrentProvince = [[mArray objectAtIndex:0] retain];
    
    if (m_GoodsReceiverVO==nil)
    {
        //新建
        [m_TitleLabel setText:@"新建收货地址"];
        [m_ProvinceBtn setTitle:@"  省份" forState:0];
        [m_CityBtn setTitle:@"  城市" forState:0];
        [m_DistrictBtn setTitle:@"  地区" forState:0];
        [m_DeleteBtn setHidden:YES];
    }
    
    else
    {
        //编辑
        [m_TitleLabel setText:@"编辑收货地址"];
        [m_NameField setText:[m_GoodsReceiverVO receiveName]];
        [m_SelectedProvince setAddresssName:m_GoodsReceiverVO.provinceName];
		[m_SelectedProvince setAddressId:[m_GoodsReceiverVO.provinceId stringValue]];
		[m_ProvinceBtn setTitle:[NSString stringWithFormat:@"  %@",m_SelectedProvince.addresssName] forState:0];
        
        [m_SelectedCity setAddresssName:m_GoodsReceiverVO.cityName];
		[m_SelectedCity setAddressId:[m_GoodsReceiverVO.cityId stringValue]];
		if([m_SelectedCity.addresssName length]>=6)
        {
			[m_CityBtn setTitle:[NSString stringWithFormat:@"  %@...",[m_SelectedCity.addresssName substringToIndex:4]] forState:0];
		}
        else
        {
			[m_CityBtn setTitle:[NSString stringWithFormat:@"  %@",m_SelectedCity.addresssName] forState:0];
		}
        
        [m_SelectedDistrict setAddresssName:m_GoodsReceiverVO.countyName];
		[m_SelectedDistrict setAddressId:[m_GoodsReceiverVO.countyId stringValue]];
		if ([m_SelectedDistrict.addresssName length]>4)
        {
			[m_DistrictBtn setTitle:[NSString stringWithFormat:@" %@",[m_SelectedDistrict.addresssName substringToIndex:4]] forState:0];
		}
        else
        {
			[m_DistrictBtn setTitle:[NSString stringWithFormat:@"  %@",m_SelectedDistrict.addresssName] forState:0];
		}
        
        [m_GoodsReceiverVO setAddress1:[m_GoodsReceiverVO.address1 stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@%@",m_SelectedProvince.addresssName,m_SelectedCity.addresssName,m_SelectedDistrict.addresssName] withString:@""]];
		m_AddressField.text=m_GoodsReceiverVO.address1;
        
        if (m_GoodsReceiverVO.receiverMobile!=nil)
        {
			m_MobileField.text=m_GoodsReceiverVO.receiverMobile;
		}
        
        if (m_GoodsReceiverVO.receiverPhone!=nil)
        {
			m_PhoneField.text=m_GoodsReceiverVO.receiverPhone;
		}
        
        [m_DeleteBtn setHidden:NO];
        [m_ContentView setContentSize:CGSizeMake(320, CGRectGetMaxY(m_DeleteBtn.frame)+54)];
    }
    
    //不隐藏地区 yaowang
//    if (m_GoodsReceiverVO!=nil && [m_GoodsReceiverVO.provinceName isEqualToString:@"上海"])
//    {
//        //隐藏上海的地区选择
//        [m_DistrictBtn setHidden:YES];
//    }
//    else
//    {
        [m_DistrictBtn setHidden:NO];
//    }
    [self.view sendSubviewToBack:m_ContentView];
}

#pragma mark    返回按钮
-(IBAction)returnBtnClicked:(id)sender
{
    if (isFromCart)
    {
        
        if (backToCart)
        {
            [(PhoneCartViewController *)[SharedDelegate.tabBarController.viewControllers objectAtIndex:2] refreshCart];
            [(PhoneCartViewController *)[SharedDelegate.tabBarController.viewControllers objectAtIndex:2] showMainViewFromTabbarMaskAnimated:NO];
            self.backToCart = NO;
        }
        else
        {
            [self removeSubControllerClass:[CheckOrder class]];
            CheckOrder* checkOrderVC = [[[CheckOrder alloc]initWithNibName:@"CheckOrder" bundle:nil] autorelease];
            [checkOrderVC setM_UserSelectedGiftArray:m_SelectedGift];
            if ([self.distributionArray count] > 0) {
                [checkOrderVC setDistributionArray:[NSMutableArray arrayWithArray:distributionArray]];
            }
            checkOrderVC.isFullScreen = YES;
            checkOrderVC.m_HasAddress = YES;
            [SharedDelegate.tabBarController addViewController:checkOrderVC withAnimation:[OTSNaviAnimation animationPushFromRight]];
        }
        isFromCart = NO;
    }
    else
    {
    	[self popSelfAnimated:YES];
    }
}


#pragma mark    设置省份
-(IBAction)setProvince:(id)sender
{
	[self viewMoveDown];
	[self closeKeyBorad];
	
	m_ThreadState=THREAD_STATUS_GET_PROVINCE;
	[self setUpThread];
}

-(void)showPrvoince
{
	if(m_ProvinceArray==nil || [m_ProvinceArray isKindOfClass:[NSNull class]])
    {
        [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
		UIAlertView * addAlert=[[OTSAlertView alloc]initWithTitle:@"" message:@"获取省份失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[addAlert show];
		[addAlert release];
		return;
	}
    
    //为了适配iOS7
    if (ISIOS7)
    {
        m_ProvinceActionSheet=[[OTSActionSheet alloc]initWithTitle:@" \n\n \n \n \n \n \n \n \n \n \n \n \n"
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:nil];
    }
    else
    {
        m_ProvinceActionSheet=[[OTSActionSheet alloc]initWithTitle:@" \n\n \n \n \n \n \n \n \n \n"
                                                          delegate:self
                                                 cancelButtonTitle:@""
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:nil];

    }
    
    CGRect tempframe=CGRectMake(0, 40, 320, 216);
	[m_ProvincePickerView setFrame:CGRectMake(0, 0, 320, 216)];
	m_ProvincePickerView.tag=PROVINCE_SELECT_PICKER_TAG_VALUE;
	UIButton * tempbutton = [[UIButton alloc]initWithFrame:tempframe];
	
    UIButton * finishSetBtn = [[UIButton alloc]initWithFrame:CGRectMake(252, 5, 50, 30)];      //右边的完成操作按钮；
	[finishSetBtn setBackgroundImage:[UIImage imageNamed:@"red_short_btn.png"] forState:0];
	[finishSetBtn addTarget:self action:@selector(clickFinishSettingProvince:) forControlEvents:UIControlEventTouchUpInside];
	[finishSetBtn setTitle:@"完成" forState:0];
    
    UIButton * cancelSetBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, 50, 30)];
	[cancelSetBtn setBackgroundImage:[UIImage imageNamed:@"red_short_btn.png"] forState:0];
	[cancelSetBtn addTarget:self action:@selector(cancelSettingProvince:) forControlEvents:UIControlEventTouchUpInside];
	[cancelSetBtn setTitle:@"取消" forState:0];
	
    [m_ProvinceActionSheet addSubview:finishSetBtn];
    [m_ProvinceActionSheet addSubview:cancelSetBtn];
    [finishSetBtn release];
    [cancelSetBtn release];
    
    if(m_GoodsReceiverVO!=nil)
    {
        int i=-1;
        for (AddressInfo * pVO in m_ProvinceArray)
        {
            i++;
            if([pVO.addresssName isEqualToString:m_GoodsReceiverVO.provinceName])
            {
                provinceFrontRow=i;
            }
        }
    }
    [m_ProvincePickerView selectRow:provinceFrontRow inComponent:0 animated:NO];
    provinceSelectedRow=provinceFrontRow;
	[tempbutton addSubview:m_ProvincePickerView];
	[m_ProvinceActionSheet addSubview:tempbutton];
    [tempbutton release];
	[m_ProvinceActionSheet showInView:[UIApplication sharedApplication].keyWindow];
	[m_ProvinceActionSheet release];
}

-(IBAction)clickFinishSettingProvince:(id)sender{
    [m_ProvinceActionSheet dismissWithClickedButtonIndex:0 animated:NO];
    
    provinceFrontRow=provinceSelectedRow;
    NSString *selectdStr=((AddressInfo *)[m_ProvinceArray objectAtIndex:provinceSelectedRow]).addresssName;
    NSString *selectedProvinceId = ((AddressInfo *)[m_ProvinceArray objectAtIndex:provinceSelectedRow]).addressId
    ;
    DebugLog(@"选择地址%@ %@ ， 当前地址 %@  %@",selectdStr,selectedProvinceId,m_CurrentProvince ,[GlobalValue getGlobalValueInstance].provinceId);
    if (m_FromTag==FROM_CHECK_ORDER && [selectedProvinceId intValue] != [[GlobalValue getGlobalValueInstance].provinceId intValue]) //![selectdStr isEqualToString:m_CurrentProvince])
    {
        NSString *title=@"无法下订单";
        NSString *message=[NSString stringWithFormat:@"订单地址与收货省份%@不一致，无法下单。\n切换省份，会使您购物车中的部分商品价格变化或者不能购买",m_CurrentProvince];
        UIAlertView *alertView=[[OTSAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"修改地址" otherButtonTitles:@"更换省份", nil];
        [alertView setTag:ALERTVIEW_TAG_CANNOT_ORDER];
        [alertView show];
        [alertView release];
        return;
    }
    [m_ProvinceBtn setTitle:[NSString stringWithFormat:@"  %@",((AddressInfo *)[m_ProvinceArray objectAtIndex:provinceSelectedRow]).addresssName] forState:0];
    if (m_SelectedProvince!=nil)
    {
        [m_SelectedProvince release];
    }
    m_SelectedProvince=[[m_ProvinceArray objectAtIndex:provinceSelectedRow] retain];
    
    [m_CityBtn setTitle:@"  城市" forState:0];
    [m_DistrictBtn setTitle:@"  地区" forState:0];
//    if ([selectdStr isEqualToString:@"上海"]) {//隐藏上海的地区选择
//        [m_DistrictBtn setHidden:YES];
//    } else {
        [m_DistrictBtn setHidden:NO];
//    }
}

-(IBAction)cancelSettingProvince:(id)sender {
	[m_ProvinceActionSheet dismissWithClickedButtonIndex:0 animated:NO];
}

//切换省份
-(void)changeProvince
{
    provinceFrontRow=provinceSelectedRow;
    NSString *selectedStr=((AddressInfo *)[m_ProvinceArray objectAtIndex:provinceSelectedRow]).addresssName;
    [m_ProvinceBtn setTitle:[NSString stringWithFormat:@"  %@",selectedStr] forState:0];
    if (m_SelectedProvince!=nil)
    {
        [m_SelectedProvince release];
    }
    m_SelectedProvince=[[m_ProvinceArray objectAtIndex:provinceSelectedRow] retain];
    
    [m_CityBtn setTitle:@"  城市" forState:0];
    [m_DistrictBtn setTitle:@"  地区" forState:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProvinceChanged" object:selectedStr];
    
    isProvinceChanged = YES;
    [SharedDelegate enterCartWithUpdate:NO];
    
    if ([selectedStr isEqualToString:@"上海"]) {//隐藏上海的地区选择
        [m_DistrictBtn setHidden:YES];
    } else {
        [m_DistrictBtn setHidden:NO];
    }
}

-(void)changeProvinceWhenSave
{
    NSString *selectedStr=[[m_ProvinceBtn currentTitle] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProvinceChanged" object:selectedStr];
    [SharedDelegate enterCartWithUpdate:NO];
}

#pragma mark    设置城市
-(IBAction)setCity:(id)sender{
	[self viewMoveDown];
	[self closeKeyBorad];
	if([m_ProvinceBtn.currentTitle isEqualToString:@""] || [m_ProvinceBtn.currentTitle isEqualToString:@"  省份"]){
		return;
	}
	m_ThreadState=THREAD_STATUS_GET_CITY;
	[self setUpThread];
}

-(void)showCity
{
	
	if(m_CityArray==nil || [m_CityArray isKindOfClass:[NSNull class]]){
        [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
		UIAlertView * addAlert=[[OTSAlertView alloc]initWithTitle:@"" message:@"获取城市失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[addAlert show];
		[addAlert release];
		return;
	}
    
    //为了适配iOS7
    if (ISIOS7)
    {
        m_CityActionSheet = [[OTSActionSheet alloc]initWithTitle:@" \n\n \n \n \n \n \n \n \n \n \n \n \n \n"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:nil];
    }
    else
    {
        m_CityActionSheet = [[OTSActionSheet alloc]initWithTitle:@" \n\n \n \n \n \n \n \n \n \n"
                                                        delegate:self
                                               cancelButtonTitle:@""
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:nil];
    }
	
	CGRect tempframe = CGRectMake(0, 40, 320, 216);
	[m_CityPickerView setFrame:CGRectMake(0, 0, 320, 216)];
	m_CityPickerView.tag=CITY_SELECT_PICKER_TAG_VALUE;
	UIButton * tempbutton = [[UIButton alloc]initWithFrame:tempframe];
	
    UIButton * finishSetBtn = [[UIButton alloc]initWithFrame:CGRectMake(252, 5, 50, 30)];//右边的完成操作按钮；
	[finishSetBtn setBackgroundImage:[UIImage imageNamed:@"red_short_btn.png"] forState:0];
	[finishSetBtn addTarget:self action:@selector(clickFinishSettingCity:) forControlEvents:UIControlEventTouchUpInside];
	[finishSetBtn setTitle:@"完成" forState:0];
	
	UIButton * cancelSetBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, 50, 30)];
	[cancelSetBtn setBackgroundImage:[UIImage imageNamed:@"red_short_btn.png"] forState:0];
	[cancelSetBtn addTarget:self action:@selector(cancelSettingCity:) forControlEvents:UIControlEventTouchUpInside];
	[cancelSetBtn setTitle:@"取消" forState:0];
    
    [m_CityPickerView reloadComponent:0];
	[m_CityActionSheet addSubview:finishSetBtn];
    [m_CityActionSheet addSubview:cancelSetBtn];
    [finishSetBtn release];
    [cancelSetBtn release];
    
    if(m_GoodsReceiverVO!=nil)
    {
        int i=-1;
        for (AddressInfo *cVO in m_CityArray)
        {
            i++;
            if([cVO.addresssName isEqualToString:m_GoodsReceiverVO.cityName])
            {
                cityFrontRow=i;
            }
        }
    }
    [m_CityPickerView selectRow:cityFrontRow inComponent:0 animated:NO];
    citySelectedRow=cityFrontRow;
    [tempbutton addSubview:m_CityPickerView];
	[m_CityActionSheet addSubview:tempbutton];
    [tempbutton release];
	[m_CityActionSheet showInView:[UIApplication sharedApplication].keyWindow];
	[m_CityActionSheet release];
}

-(IBAction)clickFinishSettingCity:(id)sender
{
    cityFrontRow=citySelectedRow;
	[m_CityActionSheet dismissWithClickedButtonIndex:0 animated:NO];
    if (m_SelectedCity!=nil)
    {
        [m_SelectedCity release];
    }
    m_SelectedCity=[[m_CityArray objectAtIndex:citySelectedRow] retain];
    if ([m_SelectedCity.addresssName length]>=6)
    {
        [m_CityBtn setTitle:[NSString stringWithFormat:@"  %@...",[m_SelectedCity.addresssName substringToIndex:4]] forState:0];
    }
    else
    {
        [m_CityBtn setTitle:[NSString stringWithFormat:@"  %@",m_SelectedCity.addresssName] forState:0];
    }
    [m_DistrictBtn setTitle:@"  地区" forState:0];
}

-(IBAction)cancelSettingCity:(id)sender
{
	[m_CityActionSheet dismissWithClickedButtonIndex:0 animated:NO];
}

#pragma mark    设置区域
-(IBAction)setDistrict:(id)sender{
	[self viewMoveDown];
	[self closeKeyBorad];
	if([m_ProvinceBtn.currentTitle isEqualToString:@""] || [m_ProvinceBtn.currentTitle isEqualToString:@"  省份"]
	   || [m_CityBtn.currentTitle isEqualToString:@""] || [m_CityBtn.currentTitle isEqualToString:@"  城市"]){
		return;
	}
    m_ThreadState=THREAD_STATUS_GET_DISTRICT;
	[self setUpThread];
}

-(void)showDistrict{
	if(m_DistrictArray==nil || [m_DistrictArray isKindOfClass:[NSNull class]])
    {
        [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
		UIAlertView * addAlert=[[OTSAlertView alloc]initWithTitle:@"" message:@"获取地区失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[addAlert show];
		[addAlert release];
		return;
	}
    //为了适配iOS7
    if (ISIOS7)
    {
        m_DistrictActionSheet = [[OTSActionSheet alloc]initWithTitle:@" \n\n \n \n \n \n \n \n \n \n \n \n \n"
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:nil];
    }
    else
    {
        m_DistrictActionSheet = [[OTSActionSheet alloc]initWithTitle:@" \n\n \n \n \n \n \n \n \n \n"
                                                            delegate:self
                                                   cancelButtonTitle:@""
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:nil];

    }
    
    
		CGRect tempframe = CGRectMake(0, 40, 320, 216);
	[m_DistrictPickerView setFrame:CGRectMake(0, 0, 320, 216)];
	m_DistrictPickerView.tag=DISTRICT_SELECT_PICKER_TAG_VALUE;
	UIButton * tempbutton = [[UIButton alloc]initWithFrame:tempframe];
	
    UIButton * finishSetBtn = [[UIButton alloc]initWithFrame:CGRectMake(252, 5, 50, 30)];//右边的完成操作按钮；
	[finishSetBtn setBackgroundImage:[UIImage imageNamed:@"red_short_btn.png"] forState:0];
	[finishSetBtn addTarget:self action:@selector(clickFinishSettingDistrict:) forControlEvents:UIControlEventTouchUpInside];
	[finishSetBtn setTitle:@"完成" forState:0];
    
    UIButton * cancelSetBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, 50, 30)];
	[cancelSetBtn setBackgroundImage:[UIImage imageNamed:@"red_short_btn.png"] forState:0];
	[cancelSetBtn addTarget:self action:@selector(cancelSettingDistrict:) forControlEvents:UIControlEventTouchUpInside];
	[cancelSetBtn setTitle:@"取消" forState:0];
	
    [m_DistrictPickerView reloadComponent:0];
	[m_DistrictActionSheet addSubview:finishSetBtn];
    [m_DistrictActionSheet addSubview:cancelSetBtn];
    [finishSetBtn release];
    [cancelSetBtn release];
    
    if(m_GoodsReceiverVO!=nil)
    {
        int i=-1;
        for (AddressInfo *cVO in m_DistrictArray)
        {
            i++;
            if([cVO.addresssName isEqualToString:m_GoodsReceiverVO.countyName])
            {
                districtFrontRow=i;
            }
        }
    }
    [m_DistrictPickerView selectRow:districtFrontRow inComponent:0 animated:NO];
    districtSelectedRow=districtFrontRow;
    [tempbutton addSubview:m_DistrictPickerView];
	[m_DistrictActionSheet addSubview:tempbutton];
    [tempbutton release];
	[m_DistrictActionSheet showInView:[UIApplication sharedApplication].keyWindow];
	[m_DistrictActionSheet release];
}

-(IBAction)clickFinishSettingDistrict:(id)sender{
    districtFrontRow=districtSelectedRow;
	[m_DistrictActionSheet dismissWithClickedButtonIndex:0 animated:NO];
    if (m_SelectedDistrict!=nil) {
        [m_SelectedDistrict release];
    }
    
    // ------ ONLINE CRASH FIX -------(By:dym)
    // <ISSUE #1778>
    // Reason: *** -[__NSArrayM objectAtIndex:]: index 14 beyond bounds [0 .. 1]
    m_SelectedDistrict = [[OTSUtility safeObjectAtIndex:districtSelectedRow inArray:m_DistrictArray] retain];
    // ------ ONLINE CRASH FIX END -------
    
    if([m_SelectedDistrict.addresssName length]>4)
    {
        [m_DistrictBtn setTitle:[NSString stringWithFormat:@" %@",[m_SelectedDistrict.addresssName substringToIndex:4]] forState:0];
    }
    else
    {
        [m_DistrictBtn setTitle:[NSString stringWithFormat:@"  %@",m_SelectedDistrict.addresssName] forState:0];
    }
}

-(IBAction)cancelSettingDistrict:(id)sender{
	[m_DistrictActionSheet dismissWithClickedButtonIndex:0 animated:NO];
}

#pragma mark    保存
-(IBAction)doSubmitEdit:(id)sender
{
	[self viewMoveDown];
	[self closeKeyBorad];
    
	if ([m_NameField.text isEqualToString:@""]
        || [[m_NameField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]<1)
    {
        [AlertView showAlertView:nil alertMsg:@"收货人姓名不能为空" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
	}
    
    else if([[m_NameField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]>20)
    {
        [AlertView showAlertView:nil alertMsg:@"收货人姓名太长" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
    }
    
    else if([m_ProvinceBtn.currentTitle isEqualToString:@""] ||
            [m_ProvinceBtn.currentTitle isEqualToString:@"  省份"])
    {
        [AlertView showAlertView:nil alertMsg:@"请选择送货区域" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
	}
    
    else if([m_CityBtn.currentTitle isEqualToString:@""] ||
            [m_CityBtn.currentTitle isEqualToString:@"  城市"])
    {
        [AlertView showAlertView:nil alertMsg:@"请选择送货区域" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
	}
    
    else if(([m_DistrictBtn.currentTitle isEqualToString:@""]
             ||[m_DistrictBtn.currentTitle isEqualToString:@"  地区"])
            && ![m_ProvinceBtn.currentTitle isEqualToString:@"  上海"])
    {
        [AlertView showAlertView:nil alertMsg:@"请选择送货区域" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
	}
    
    else if([m_AddressField.text isEqualToString:@""]
            || [[m_AddressField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]<1)
    {
		[m_AddressField setText:@""];
        [AlertView showAlertView:nil alertMsg:@"收货地址不能为空，请重新输入" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
	}
    else if([[m_AddressField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]>100)
    {
        [AlertView showAlertView:nil alertMsg:@"地址信息太长" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
    }
    
    else if([m_MobileField.text length]<1 && [m_PhoneField.text length]<1)
    {
        [AlertView showAlertView:nil alertMsg:@"手机和电话号码不能同时为空，请重新输入" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
	}
    
    else if([m_MobileField.text length]>=1 && ![m_MobileField.text isMatchedByRegex:@"^[0-9]*$"])
    {
        [AlertView showAlertView:nil alertMsg:@"手机号码格式不正确" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
    }
    

    else if([m_MobileField.text length]>=1
            && (([[m_MobileField text]length]!=11)))
    {
        [AlertView showAlertView:nil alertMsg:@"手机号码格式不正确" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
    }
    else if([m_PhoneField.text length]>=1 && ![m_PhoneField.text isMatchedByRegex:@"^[0-9]*$"])
    {
        [AlertView showAlertView:nil alertMsg:@"电话号码格式不正确" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
    }
    
    else if([m_PhoneField.text length]>=1 && !([m_PhoneField.text length]==7 || [m_PhoneField.text length]==8))
    {
        [AlertView showAlertView:nil alertMsg:@"电话号码格式不正确" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
    }
    
    else if(m_FromTag==FROM_CHECK_ORDER && [m_SelectedProvince.addressId intValue] != [[GlobalValue getGlobalValueInstance].provinceId intValue]
            )
    {
        
        DebugLog(@"地址 %@,%@",m_SelectedProvince.addressId,[GlobalValue getGlobalValueInstance].provinceId);

        NSString *title=@"无法下订单";
        NSString *message=[NSString stringWithFormat:@"订单地址与收货省份%@不一致，无法下单。\n切换省份，会使您购物车中的部分商品价格变化或者不能购买",m_CurrentProvince];
        UIAlertView *alertView=[[OTSAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"修改地址" otherButtonTitles:@"更换省份", nil];
        [alertView setTag:ALERTVIEW_TAG_CANNOT_ORDER_WHEN_SAVE];
        [alertView show];
        [alertView release];
    }
    else
    {
        if([[m_PhoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] < 1)
        {//如果电话号码全是空格，清空电话号码
            [m_PhoneField setText:@""];
        }
        
        Trader *trader=[GlobalValue getGlobalValueInstance].trader;
        NSString *appVersion=trader.clientVersion;
        NSArray *array=[appVersion componentsSeparatedByString:@"."];
        NSString *firstStr=[array objectAtIndex:0];
        int firstNumber=[firstStr intValue];
        
        if (([[m_ProvinceBtn titleForState:UIControlStateNormal] isEqualToString:@"  上海"]
             || [[m_ProvinceBtn titleForState:UIControlStateNormal] isEqualToString:@"  北京"])
            && firstNumber>=5)
        {
            [self getUserLocation];
        }
        else
        {
            self.m_Lngs = [NSMutableArray array];
            self.m_Lats = [NSMutableArray array];
        }
        
        m_ThreadState=THREAD_STATUS_SAVE_RECEIVER;
        [self setUpThread];
    }
}

-(IBAction)deleteBtnClicked:(id)sender
{
    
    UIAlertView *alertView=[[OTSAlertView alloc] initWithTitle:@"确定删除收货地址?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setTag:ALERTVIEW_TAG_DELETE_RECEIVER];
    [alertView show];
    [alertView release];
}


-(void)getUserLocation
{
    self.m_Lngs = [NSMutableArray array];
    self.m_Lats = [NSMutableArray array];
}

#pragma mark 页面上移
-(void)changeScrollOffsetY:(int)aPosY
{
    [m_ContentView setContentOffset:CGPointMake(0, aPosY) animated:YES];
}

-(void)viewMoveUpAddress
{
    [self changeScrollOffsetY:45];
}
#pragma mark 页面上移
-(void)viewMoveUpMobile
{
    [self changeScrollOffsetY:110];
}
#pragma mark 页面上移
-(void)viewMoveUpPhone
{
    [self changeScrollOffsetY:160];
}
#pragma mark 页面下移
-(void)viewMoveDown
{
    [self changeScrollOffsetY:0];
}
#pragma mark 关闭键盘
-(void)closeKeyBorad {
	[UIView setAnimationsEnabled:YES];
	[m_NameField resignFirstResponder];
	[m_AddressField resignFirstResponder];
	[m_MobileField resignFirstResponder];
	[m_PhoneField resignFirstResponder];
	[UIView setAnimationsEnabled:NO];
}

#pragma mark 建立线程
-(void)setUpThread
{
	if (!m_ThreadRunning)
    {
        [self showLoading:YES];
		m_ThreadRunning=YES;
		[self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
	}
}

#pragma mark 开启线程
-(void)startThread
{
	while (m_ThreadRunning)
    {
		@synchronized(self)
        {
            switch (m_ThreadState)
            {
                case THREAD_STATUS_GET_PROVINCE: {//获取省份信息
                    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
                    
                    YWAddressService * aServ = [[YWAddressService alloc] init];
                    @try
                    {
						NSArray * tempArray=[aServ getAllProvince];
                        if (m_ProvinceArray!=nil)
                        {
                            [m_ProvinceArray release];
                        }
						if(tempArray!=nil&& tempArray.count > 0 && ![tempArray isKindOfClass:[NSNull class]])
                        {
							m_ProvinceArray = [tempArray retain];
						}
						else
                        {
							m_ProvinceArray=nil;
						}
						
						[self performSelectorOnMainThread:@selector(showPrvoince) withObject:self waitUntilDone:NO];
                    
                    
                    
					/*AddressService * aServ = [[AddressService alloc] init];
                    @try
                    {
						NSArray * tempArray=[aServ getAllProvince:[GlobalValue getGlobalValueInstance].trader];
                        if (m_ProvinceArray!=nil)
                        {
                            [m_ProvinceArray release];
                        }
						if(tempArray!=nil && ![tempArray isKindOfClass:[NSNull class]])
                        {
							m_ProvinceArray=[tempArray retain];
						}
						else
                        {
							m_ProvinceArray=nil;
						}
						
						[self performSelectorOnMainThread:@selector(showPrvoince) withObject:self waitUntilDone:NO];*/
                    }
                    @catch (NSException * e)
                    {
                    }
                    @finally
                    {
						[aServ release];
                        [self stopThread];
                    }
                    [pool drain];
                    break;
                }
                case THREAD_STATUS_GET_CITY:
                {  // 获取市区信息
                    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
					YWAddressService * aServ = [[YWAddressService alloc] init];
                    @try
                    {
                        NSArray * tempArray=[aServ  getCitiesByProvinceId:m_SelectedProvince.addressId];
						if (m_CityArray!=nil)
                        {
                            [m_CityArray release];
                        }
                        if(tempArray!=nil && tempArray.count > 0 &&![tempArray isKindOfClass:[NSNull class]]){
							m_CityArray=[tempArray retain];
						}
						else
                        {
							m_CityArray=nil;
						}
						[self performSelectorOnMainThread:@selector(showCity) withObject:self waitUntilDone:NO];
                        
                        /*
						NSArray * tempArray=[aServ getCityByProvinceId:[GlobalValue getGlobalValueInstance].trader provinceId:m_SelectedProvince.nid];
						if (m_CityArray!=nil)
                        {
                            [m_CityArray release];
                        }
                        if(tempArray!=nil && ![tempArray isKindOfClass:[NSNull class]]){
							m_CityArray=[tempArray retain];
						}
						else
                        {
							m_CityArray=nil;
						}
						[self performSelectorOnMainThread:@selector(showCity) withObject:self waitUntilDone:NO];*/
                    } @catch (NSException * e) {
                    } @finally {
						[aServ release];
                        [self stopThread];
                    }
                    [pool drain];
                    break;
                }
                case THREAD_STATUS_GET_DISTRICT:
                {  // 获取区域信息
                    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
					YWAddressService * aServ = [[YWAddressService alloc] init];
                    @try
                    {
                        NSArray * tempArray=[aServ getCountiesByCityId:m_SelectedCity.addressId];
                        if (m_DistrictArray!=nil)
                        {
                            [m_DistrictArray release];
                        }
						if(tempArray!=nil &&tempArray.count > 0&& ![tempArray isKindOfClass:[NSNull class]])
                        {
							m_DistrictArray=[tempArray retain];
						}
						else{
							m_DistrictArray=nil;
						}
                        [self performSelectorOnMainThread:@selector(showDistrict) withObject:self waitUntilDone:NO];

                        /*
						NSArray * tempArray=[aServ getCountyByCityId:[GlobalValue getGlobalValueInstance].trader cityId:m_SelectedCity.addressId];
                        if (m_DistrictArray!=nil) {
                            [m_DistrictArray release];
                        }
						if(tempArray!=nil && ![tempArray isKindOfClass:[NSNull class]]){
							m_DistrictArray=[tempArray retain];
						}
						else{
							m_DistrictArray=nil;
						}
                        [self performSelectorOnMainThread:@selector(showDistrict) withObject:self waitUntilDone:NO];*/
                    }
                    @catch (NSException * e)
                    {
                    }
                    @finally
                    {
						[aServ release];
                        [self stopThread];
                    }
                    [pool drain];
                    break;
                }
                case THREAD_STATUS_SAVE_RECEIVER:
                {
                    // 保存送货地址
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
					YWAddressService *aServ=[[YWAddressService alloc] init];
                    GoodReceiverVO *goodReceiverVO;
                    if (m_GoodsReceiverVO==nil)
                    {
                        //新建收货地址
                        goodReceiverVO=[[[GoodReceiverVO alloc] init] autorelease];
                    }
                    else
                    {
                        //编辑收货地址
                        goodReceiverVO=m_GoodsReceiverVO;
                    }
                    [goodReceiverVO setAddress1:[m_AddressField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    [goodReceiverVO setRecordName:[m_AddressField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    [goodReceiverVO setCityId:[[[NSNumber alloc]initWithInt:[m_SelectedCity.addressId intValue]] autorelease]];
                    [goodReceiverVO setCityName:[NSString stringWithString:m_SelectedCity.addresssName]];
                    [goodReceiverVO setCountryId:[[[NSNumber alloc]initWithInt:0]autorelease]];
                    [goodReceiverVO setCountryName:@"中国"];
                    [goodReceiverVO setCountyId:[NSNumber numberWithInt:[m_SelectedDistrict.addressId intValue]]];
                    [goodReceiverVO setCountyName:m_SelectedDistrict.addresssName];
                    [goodReceiverVO setProvinceId:[[[NSNumber alloc]initWithInt:[m_SelectedProvince.addressId intValue]] autorelease]];
                    [goodReceiverVO setProvinceName:[NSString stringWithString:m_SelectedProvince.addresssName]];
                    [goodReceiverVO setReceiveName:[NSString stringWithString:[m_NameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]];
                    if(!([m_MobileField.text isEqualToString:@"手机"]))
                    {
                        [goodReceiverVO setReceiverMobile:m_MobileField.text];
                    }
                    if(!([m_PhoneField.text isEqualToString:@"电话"]))
                    {
                        [goodReceiverVO setReceiverPhone:m_PhoneField.text];
                    }
                    [goodReceiverVO setDefaultAddressId:[NSNumber numberWithInt:1]];
//                    int result=99;
                    ResultInfo* result;
                    @try
                    {
						if(m_GoodsReceiverVO == nil)
                        {
                            //如果不是编辑状态
//							[goodReceiverVO setNid:[[[NSNumber alloc]initWithInt:0]autorelease]];
//							if ([[m_ProvinceBtn titleForState:UIControlStateNormal] isEqualToString:@"  上海"] || [[m_ProvinceBtn titleForState:UIControlStateNormal] isEqualToString:@"  北京"])
//                            {
//                                result = [aServ insertGoodReceiverByToken:[GlobalValue getGlobalValueInstance].token goodReceiverVO:goodReceiverVO lngs:m_Lngs lats:m_Lats];
                                
                                result = [aServ addNewGoodReceiver:goodReceiverVO];
                            
                            
                            
//                            }
//                            else
//                            {
//                                result = [aServ insertGoodReceiverByToken:[GlobalValue getGlobalValueInstance].token goodReceiverVO:goodReceiverVO];
//                            }
						}
                        else
                        {	//如果是编辑状态
//							[goodReceiverVO setNid:[[[NSNumber alloc]initWithInt:[m_GoodsReceiverVO.nid intValue]]autorelease]];
//							if ([[m_ProvinceBtn titleForState:UIControlStateNormal] isEqualToString:@"  上海"] || [[m_ProvinceBtn titleForState:UIControlStateNormal] isEqualToString:@"  北京"]) {
//                                result = [aServ updateGoodReceiverByToken:[GlobalValue getGlobalValueInstance].token goodReceiverVO:goodReceiverVO lngs:m_Lngs lats:m_Lats];
//                            }
//                            else
//                            {
                                result = [aServ updateGoodReceiver:goodReceiverVO];
//                            }
						}
                    } @catch (NSException * e)
                    {
                    }
                    @finally
                    {
                        [self stopThread];
                        
						[self performSelectorOnMainThread:@selector(showSaveGoodReceiverAlertView:)
											   withObject:result waitUntilDone:NO];
                    }
                    [aServ release];
                    [pool drain];
                    break;
                }
                case THREAD_STATUS_DELETE_RECEIVER:
                {  // 删除送货地址
                    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
                    YWAddressService * aServ = [[YWAddressService alloc] init];
                    @try
                    {
                        GoodReceiverVO *receiverVO=m_GoodsReceiverVO;
						NSNumber *receiverId=[NSNumber numberWithInt:[receiverVO.nid intValue]];
                        BOOL result=[aServ deleteGoodRecevicer:[receiverId stringValue]];
						[self performSelectorOnMainThread:@selector(showDeleteGoodReciverByTokenAlertView:) withObject:[NSString stringWithFormat:@"%d", result? 1 : 0] waitUntilDone:NO];
    
                        
                        /*
						GoodReceiverVO *receiverVO=m_GoodsReceiverVO;
						NSNumber *receiverId=[NSNumber numberWithInt:[receiverVO.nid intValue]];
						int result=[aServ deleteGoodReceiverByToken:[GlobalValue getGlobalValueInstance].token goodReceiverId:receiverId];
						[self performSelectorOnMainThread:@selector(showDeleteGoodReciverByTokenAlertView:) withObject:[NSString stringWithFormat:@"%d", result] waitUntilDone:NO];*/
                    }
                    @catch (NSException * e)
                    {
                    }
                    @finally
                    {
                        [self stopThread];
                    }
                    [aServ release];
                    [pool drain];
                    break;
                }
                case THREAD_STATUS_GET_RECEIVERLIST:
                {
                    // 获取送货地址列表信息
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
					AddressService *aServ=[[AddressService alloc] init];
                    OrderService *oServ=[[OrderService alloc] init];
                    @try {
                        if (m_GoodsReceiverVO==nil)
                        {
                            //新建收货地址，获取收货地址第一条，然后保存到订单
                            NSArray *tempArray=[aServ getGoodReceiverListByToken:[GlobalValue getGlobalValueInstance].token];
                            if (m_GoodsReceiverVO!=nil)
                            {
                                [m_GoodsReceiverVO release];
                            }
                            if(tempArray!=nil && ![tempArray isKindOfClass:[NSNull class]] && [tempArray count]>0)
                            {
                                m_GoodsReceiverVO=[[tempArray objectAtIndex:0] retain];
                                SaveGoodReceiverResult *tempResult =  [oServ saveGoodReceiverToSessionOrderV2:[GlobalValue getGlobalValueInstance].token goodReceiverId:[m_GoodsReceiverVO nid]];
                                [self performSelectorOnMainThread:@selector(showSaveGoodReceiverToOrderAlertView:) withObject:tempResult waitUntilDone:NO];
                            }
                            else
                            {
                                m_GoodsReceiverVO=nil;
                            }
                        }
                        else
                        {
                            //编辑收货地址，直接保存到订单
                            SaveGoodReceiverResult *tempResult =  [oServ saveGoodReceiverToSessionOrderV2:[GlobalValue getGlobalValueInstance].token goodReceiverId:[m_GoodsReceiverVO nid]];
                            [self performSelectorOnMainThread:@selector(showSaveGoodReceiverToOrderAlertView:) withObject:tempResult waitUntilDone:NO];
                        }
                    }
                    @catch (NSException * e)
                    {
                    }
                    @finally
                    {
						[aServ release];
                        [self stopThread];
                    }
                    [pool drain];
                    break;
                }
                default:
                    break;
            }
		}
	}
}

#pragma mark 停止线程
-(void)stopThread
{
	m_ThreadRunning=NO;
	m_ThreadState=-1;
    [self hideLoading];
}

#pragma mark -
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self closeKeyBorad];
}

#pragma mark 显示保存地址提示框
-(void)showSaveGoodReceiverAlertView:(ResultInfo *)resultInfo
{
    int result =  resultInfo.resultCode;
    
	switch (result)
    {
		case 1:
            if (m_FromTag==FROM_CHECK_ORDER)
            {
//                m_ThreadState=THREAD_STATUS_GET_RECEIVERLIST;
//                [self setUpThread];
                [self saveGoodReceiverToOrder:[resultInfo.resultObject stringValue]];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateReceiverList" object:nil];
//                [[OTSUserLoginHelper sharedInstance] autoLogin];
                [self returnBtnClicked:nil];
            }
			break;
//		case 0:
//			if (m_GoodsReceiverVO == nil)
//            {
//                [AlertView showAlertView:nil alertMsg:@"添加收货地址失败!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
//				return;
//			}
//            else
//            {
//                [AlertView showAlertView:nil alertMsg:@"更新收货地址失败!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
//				return;
//			}
//			break;
		default:
        {
            
            [AlertView showAlertView:nil alertMsg:resultInfo.errorStr buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
//            if ([GlobalValue getGlobalValueInstance].token==nil)
//            {
//                [AlertView showAlertView:nil alertMsg:@"网络异常，请检查网络配置..." buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
//            }
//            else
//            {
//                return;
//                [AlertView showAlertView:nil alertMsg:@"您的输入有误,可能存在无效的字符!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
//            }
            break;
        }
	}
}

// yaowang
- (void)saveGoodReceiverToOrder:(NSString *)addressId
{
    self.backToCart =  NO;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeDistributionArray" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseReceiverList" object:nil];
    [NSThread sleepForTimeInterval:0.5];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveGoodReceiveToOrder" object:addressId];
    [self returnBtnClicked:nil];
}

#pragma mark 显示保存地址到订单提示框
-(void)showSaveGoodReceiverToOrderAlertView:(SaveGoodReceiverResult *)result {
    int intresult=[[result resultCode] intValue];
	switch (intresult) {
        case 1:
            self.backToCart =  NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"removeDistributionArray" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseReceiverList" object:nil];
            [NSThread sleepForTimeInterval:0.5];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveGoodReceiveToOrder" object:m_GoodsReceiverVO];
            [self returnBtnClicked:nil];
			break;
		case 0:
            [AlertView showAlertView:nil alertMsg:@"保存失败!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
			break;
		case -1:
            [AlertView showAlertView:nil alertMsg:@"地址不属于本人!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
			break;
		case -2:
            [AlertView showAlertView:nil alertMsg:@"地址和登录的地区不同!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
			break;
		case -4:
            [AlertView showAlertView:nil alertMsg:@"不支持货到付款!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
			break;
		case -19:
            [AlertView showAlertView:nil alertMsg:@"订单不存在!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
			break;
        case -270:
        {
            UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:nil message:result.errorInfo delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert setTag:ALERTVIEW_TAG_ORDER_DISTRIBUTIONV2];
            [alert show];
            [alert release];
        }
            break;
        case -271:
        {
            //-271 时 添加标记返回购物车
            self.backToCart =  YES;
            [self showErrorOfDistribution:result];
        }
            break;
		default:
            [AlertView showAlertView:nil alertMsg:@"网络异常，请检查网络配置..." buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
			break;
	}
}

-(void)showErrorOfDistribution:(SaveGoodReceiverResult *)result
{
    self.distributionArray = result.productList;
    [self.loadingView hide];
    NSString *disMessage = result.errorInfo;
    NSArray *listItems = [disMessage componentsSeparatedByString:@"收货地址"];
    NSString * mTitle = [[listItems objectAtIndex:0] stringByAppendingString:@"收货地址"];
    //返回的以逗号隔开
    NSArray * mProducts = [[listItems objectAtIndex:1] componentsSeparatedByString:@","];
    NSString * StringProduct = [mProducts objectAtIndex:0];
    for (int i = 1; i< [mProducts count]; i++) {
        NSString * temps = [NSString stringWithFormat:@"\r%@",[mProducts objectAtIndex:i]];
        StringProduct = [StringProduct stringByAppendingString:temps];
    }
    UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:mTitle message:StringProduct delegate:self cancelButtonTitle:@"修改地址" otherButtonTitles:@"删除商品", nil];
    [alert setTag:ALERTVIEW_TAG_ORDER_DISTRIBUTION];
	[alert show];
	[alert release];
}


-(void)showDeleteGoodReciverByTokenAlertView:(NSString *)result {
	[self stopThread];
	switch ([result intValue]) {
		case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateReceiverList" object:nil];
            [self returnBtnClicked:nil];
			break;
		case 0:
			[AlertView showAlertView:nil alertMsg:@"删除失败!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
			break;
		default:
			[AlertView showAlertView:nil alertMsg:@"网络异常，请检查网络配置..." buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
			break;
	}
}

#pragma mark 设置滚轴列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
#pragma mark 设置滚轴行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	// 省份
	if(pickerView.tag==PROVINCE_SELECT_PICKER_TAG_VALUE)
    {
		return [m_ProvinceArray count];
	}
	// 城市
	else if(pickerView.tag==CITY_SELECT_PICKER_TAG_VALUE)
    {
		return [m_CityArray count];
	}
	// 区域
	else if(pickerView.tag==DISTRICT_SELECT_PICKER_TAG_VALUE)
    {
		return [m_DistrictArray count];
	}
	return 1;
}
#pragma mark 设置滚轴内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	// 省份
	if(pickerView.tag==PROVINCE_SELECT_PICKER_TAG_VALUE)
    {
		return [NSString stringWithString:((AddressInfo *)[m_ProvinceArray objectAtIndex:row]).addresssName];
	}
	// 城市
	else if(pickerView.tag==CITY_SELECT_PICKER_TAG_VALUE)
    {
		return [NSString stringWithString:((AddressInfo *)[m_CityArray objectAtIndex:row]).addresssName];
	}
	// 区域
	else if(pickerView.tag==DISTRICT_SELECT_PICKER_TAG_VALUE)
    {
		return [NSString stringWithFormat:@"  %@",((AddressInfo *)[m_DistrictArray objectAtIndex:row]).addresssName];
	}
	return @"";
}
#pragma mark 设置滚轴滚动操作
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	// 省份
	if(pickerView.tag==PROVINCE_SELECT_PICKER_TAG_VALUE){
        provinceSelectedRow=row;
	}
	// 城市
	else if(pickerView.tag==CITY_SELECT_PICKER_TAG_VALUE){
        citySelectedRow=row;
	}
	// 区域
	else if(pickerView.tag==DISTRICT_SELECT_PICKER_TAG_VALUE){
        districtSelectedRow=row;
	}
}
#pragma mark 设置滚轴宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
	// 省份
	if(pickerView.tag==PROVINCE_SELECT_PICKER_TAG_VALUE){
		return 290;
	}
	// 城市
	else if(pickerView.tag==CITY_SELECT_PICKER_TAG_VALUE){
		return 290;
	}
	// 区域
	else if(pickerView.tag==DISTRICT_SELECT_PICKER_TAG_VALUE){
		return 280;
	}
	return 1;
}
#pragma mark 设置输入框开始编辑时的状态
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	[UIView setAnimationsEnabled:NO];
	if (textField == m_NameField) {
		[self viewMoveDown];
	}
	if (textField == m_AddressField) {
		[self viewMoveUpAddress];
	}
	if (textField == m_MobileField) {
		[self viewMoveUpMobile];
	}
    if (textField == m_PhoneField) {
		[self viewMoveUpPhone];
	}
	return YES;
}
#pragma mark 设置输入框返回键操作
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	if (textField == m_NameField) {
		[m_AddressField becomeFirstResponder];
	}
	if (textField == m_AddressField) {
		[m_MobileField becomeFirstResponder];
	}
    if (textField == m_MobileField) {
		[m_PhoneField becomeFirstResponder];
	}
    if (textField == m_PhoneField) {
        [self doSubmitEdit:nil];
    }
	return YES;
}
#pragma mark 设置alert点击操作
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERTVIEW_TAG_CANNOT_ORDER: {
            if (buttonIndex==1) {
                [self changeProvince];
            }
            break;
        }
        case ALERTVIEW_TAG_CANNOT_ORDER_WHEN_SAVE: {
            if (buttonIndex==1) {
                [self changeProvinceWhenSave];
            }
            break;
        }
        case ALERTVIEW_TAG_DELETE_RECEIVER: {
            if (buttonIndex==1) {
                m_ThreadState = THREAD_STATUS_DELETE_RECEIVER;
                [self setUpThread];
            }
            break;
        }
        case ALERTVIEW_TAG_ORDER_DISTRIBUTIONV2:{
            [(PhoneCartViewController *)[SharedDelegate.tabBarController.viewControllers objectAtIndex:2] refreshCart];
            [(PhoneCartViewController *)[SharedDelegate.tabBarController.viewControllers objectAtIndex:2] showMainViewFromTabbarMaskAnimated:NO];
            break;
        }
        case ALERTVIEW_TAG_ORDER_DISTRIBUTION:{
            if (buttonIndex==1) {
                __block int result;
                [self performInThreadBlock:^()
                 {
                     @autoreleasepool {
                         CartService *cService=[[[CartService alloc] init] autorelease];
                         if ([distributionArray count]>0) {
                             NSMutableArray * productids = [[[NSMutableArray alloc] init] autorelease];
                             NSMutableArray * merchantids = [[[NSMutableArray alloc] init] autorelease];
                             NSMutableArray * promotionlist = [[[NSMutableArray alloc] init] autorelease];
                             for (int i= 0; i< [distributionArray count]; i++) {
                                 ProductVO *vo = [distributionArray objectAtIndex:i];
                                 if (vo.productId == nil) {
                                     vo.productId = 0;
                                 }
                                 if (vo.merchantId == nil) {
                                     vo.merchantId = 0;
                                 }
                                 if (vo.promotionId == nil) {
                                     vo.promotionId = @"";
                                 }
                                 [productids addObject:vo.productId];
                                 [merchantids addObject:vo.merchantId];
                                 [promotionlist addObject:vo.promotionId];
                             }
                             result = [cService delProducts:[GlobalValue getGlobalValueInstance].token productIds:productids merchantIds:merchantids promotionList:promotionlist];
                         }
                     }
                 }
                     completionInMainBlock:^(){
                         if (result==1) {
                             [SharedDelegate enterCartWithUpdate:YES];
                         } else {
                             [self toastShowString:@"删除失败"];
                         }
                         
                     }];
                
            } else if (buttonIndex==0) {
                DebugLog(@"修改地址");
                //                [self returnBtnClicked:nil];
                [self performInMainBlock:^(){
                    [self enterGoodsReceiverList];
                }];
                
            }
            break;
        }
        default:
            break;
    }
    [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:NO];
}

//跳转到地址列表页
-(void)enterGoodsReceiverList
{
	GoodReceiver* goodRecieverVC = [[[GoodReceiver alloc]initWithNibName:@"GoodReceiver" bundle:nil] autorelease];
    [goodRecieverVC setM_FromTag:FROM_CHECK_ORDER];
    [goodRecieverVC setIsFromCart:YES];
    [goodRecieverVC setM_SelectedGift:m_SelectedGift];
    [goodRecieverVC setM_DefaultReceiverId:nil];
    [self pushVC:goodRecieverVC animated:YES fullScreen:YES];
}

#pragma mark 设置界面touch事件
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//	[self viewMoveDown];
//	[self closeKeyBorad];
//}
//
//#pragma mark scrollview相关
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self viewMoveDown];
//	[self closeKeyBorad];
//}

#pragma mark error
-(void)toastShowString:(NSString *)string
{
    [self.loadingView showTipInView:self.view title:string];
    
	[UIView setAnimationsEnabled:NO];
}

#pragma mark -
-(void)releaseMyResoures
{
    OTS_SAFE_RELEASE(m_GoodsReceiverVO);
    OTS_SAFE_RELEASE(m_SelectedProvince);
    OTS_SAFE_RELEASE(m_SelectedCity);
    
    OTS_SAFE_RELEASE(m_SelectedDistrict);
    OTS_SAFE_RELEASE(m_ProvinceArray);
    OTS_SAFE_RELEASE(m_CityArray);
    OTS_SAFE_RELEASE(m_DistrictArray);
    
    //  OTS_SAFE_RELEASE(m_Geocoder);
    OTS_SAFE_RELEASE(m_Lngs);
    OTS_SAFE_RELEASE(m_Lats);
    OTS_SAFE_RELEASE(m_CurrentProvince);
    
    // release outlet
    OTS_SAFE_RELEASE(m_ContentView);
    OTS_SAFE_RELEASE(m_ProvinceBtn);
    OTS_SAFE_RELEASE(m_CityBtn);
    OTS_SAFE_RELEASE(m_DistrictBtn);
    OTS_SAFE_RELEASE(m_NameField);
    OTS_SAFE_RELEASE(m_AddressField);
    OTS_SAFE_RELEASE(m_MobileField);
    OTS_SAFE_RELEASE(m_PhoneField);
    OTS_SAFE_RELEASE(m_DeleteBtn);
    OTS_SAFE_RELEASE(m_ProvincePickerView);
    OTS_SAFE_RELEASE(m_CityPickerView);
    OTS_SAFE_RELEASE(m_DistrictPickerView);
    OTS_SAFE_RELEASE(m_TitleLabel);
    OTS_SAFE_RELEASE(escapeView);
    OTS_SAFE_RELEASE(m_Lats);
    OTS_SAFE_RELEASE(m_Lngs);
    OTS_SAFE_RELEASE(distributionArray);
    OTS_SAFE_RELEASE(m_SelectedGift);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseMyResoures];
}

-(void)dealloc
{
    [self releaseMyResoures];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
