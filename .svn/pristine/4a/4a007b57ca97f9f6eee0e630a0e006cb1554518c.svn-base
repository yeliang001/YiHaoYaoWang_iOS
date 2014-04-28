//
//  NewAddressView.m
//  yhd
//
//  Created by dev dev on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewAddressView.h"
#import "NSObject+OTS.h"
#import "OTSServiceHelper.h"
#import "ProvinceVO.h"
#import "CityVO.h"
#import "CountyVO.h"
#import "GoodReceiverVO.h"
#import <CoreLocation/CoreLocation.h>
#import "ProvinceChooseAddressViewController.h"
#import "CityChooseAddressViewController.h"
#import "CountyChooseAddressViewController.h"
#import "OTSGpsHelper.h"

@implementation NewAddressView
@synthesize mprovince;
@synthesize mcity;
@synthesize mcounty;
@synthesize mnewgoodreceive;
@synthesize isnewAddress;
@synthesize mPopOverController;
@synthesize mCityPopOverController;
@synthesize mCountyPopOverController;
@synthesize isShowingBack;
@synthesize isNotLimited;
@synthesize mcloseButton,isFromeMyStore;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UpdateProvince:) name:@"kProvinceSelected" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UpdateCity:) name:@"kCitySelected" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UpdateCounty:) name:@"kCountySelected" object:nil];
    NSLog(@"pr1,gr1 %@%@",mprovince,mnewgoodreceive);
    if (mprovince ==nil && mnewgoodreceive ==nil) {
        mtextField1.text = [OTSGpsHelper sharedInstance].provinceVO.provinceName;
    }
  //  mbackButton.hidden = !isShowingBack;
  //  mcloseButton.hidden = isShowingBack;
//    msubMitButton.hidden = isShowingBack;
}

//--------安全获取当前省份,ProvinceVO 无数据是取全局省份------------------------------
-(NSNumber *)safeGetmprovince:(NSNumber *)nid
{
    NSNumber *_proviceId =  ((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid;
    
    if (!_proviceId&&mnewgoodreceive) {
        
        _proviceId = mnewgoodreceive.provinceId;
    }
    
    if (!_proviceId) {
        _proviceId = [GlobalValue getGlobalValueInstance].provinceId;
    }
    
    return _proviceId;
}

-(IBAction)downpickerviewClicked:(id)sender
{
    [self dismisskeyboard];
    if (((UIButton*)sender).tag ==1) 
    {
        ProvinceChooseAddressViewController *contentViewController = [[[ProvinceChooseAddressViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        contentViewController.delegate = self;
        self.mPopOverController = [[[WEPopoverController alloc] initWithContentViewController:contentViewController] autorelease];
        self.mPopOverController.popoverContentSize=CGSizeMake(193.0, 234.0);
        if ([self.mPopOverController respondsToSelector:@selector(setContainerViewProperties:)]) 
        {
            [self.mPopOverController setContainerViewProperties:[self improvedContainerViewProperties]];
        }

        [self.mPopOverController presentPopoverFromRect:CGRectMake(0, 0, 400, 150) inView:self  permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) animated:YES];
    }
    else if(((UIButton*)sender).tag==2)
    {
        if (((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid||mnewgoodreceive.provinceId||[OTSGpsHelper sharedInstance].provinceVO)
        {
            CityChooseAddressViewController *contentViewController = [[[CityChooseAddressViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            contentViewController.delegate = self;
            self.mCityPopOverController = [[[WEPopoverController alloc] initWithContentViewController:contentViewController] autorelease];
            
            contentViewController.mProvinceId = [self safeGetmprovince:((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid];
            
            self.mCityPopOverController.popoverContentSize=CGSizeMake(193.0, 234.0);
            if ([self.mCityPopOverController respondsToSelector:@selector(setContainerViewProperties:)]) 
            {
                [self.mCityPopOverController setContainerViewProperties:[self improvedContainerViewProperties]];
            }
            [self.mCityPopOverController presentPopoverFromRect:CGRectMake(0, 0, 800, 150) inView:self  permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) animated:YES];
        }
            
    }
    else if (((UIButton*)sender).tag==3)
    {
        if (((CityVO*)[mcity objectAtIndex:mcityselectedindex]).nid||mnewgoodreceive.cityId)
        {
            CountyChooseAddressViewController *contentViewController = [[[CountyChooseAddressViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            contentViewController.delegate = self;
            self.mCountyPopOverController = [[[WEPopoverController alloc] initWithContentViewController:contentViewController] autorelease];
            NSNumber *_cityId =  ((CityVO*)[mcity objectAtIndex:mcityselectedindex]).nid;
            if (!_cityId) {
                _cityId = mnewgoodreceive.cityId;
            }
            contentViewController.mCityId = _cityId;

            self.mCountyPopOverController.popoverContentSize=CGSizeMake(252.0, 234.0);
            if ([self.mCountyPopOverController respondsToSelector:@selector(setContainerViewProperties:)]) 
            {
                [self.mCountyPopOverController setContainerViewProperties:[self improvedContainerViewProperties]];
            }
            
            //        }
            [self.mCountyPopOverController presentPopoverFromRect:CGRectMake(0, 0, 800, 200) inView:self  permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) animated:YES];
        }
    }
}
-(void)dismisskeyboard
{
    [mreceiveNameTextField resignFirstResponder];
    [mreceiveMobile resignFirstResponder];
    [mreceivePhone resignFirstResponder];
    [maddressTextField resignFirstResponder];
}
-(IBAction)okClicked:(id)sender
{
    if (isnewAddress) {
        [MobClick event:@"new_address"];
    }
    if ([mreceiveNameTextField.text isEqualToString:@""]&&[mreceiveMobile.text isEqualToString:@""]&&[mreceivePhone.text isEqualToString:@""]) 
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"输入内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else {
    if ([self checkTelephone]==1)
    {
        if ([self checkDetailAddress])
        {
            if (isnewAddress)
            {
                self.mnewgoodreceive = [[GoodReceiverVO alloc]init];
                [mnewgoodreceive setReceiveName:mreceiveNameTextField.text];
                [mnewgoodreceive setAddress1:maddressTextField.text];
                [mnewgoodreceive setReceiverPhone:mreceivePhone.text];
                [mnewgoodreceive setReceiverMobile:mreceiveMobile.text];
                [mnewgoodreceive setCountryId:[NSNumber numberWithInt:1]];
                [mnewgoodreceive setProvinceId:[self safeGetmprovince:((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid]];
                [mnewgoodreceive setCityId:((CityVO*)[mcity objectAtIndex:mcityselectedindex]).nid];
                [mnewgoodreceive setCountyId:((CountyVO*)[mcounty objectAtIndex:mcountyselectedindex]).nid];
                [mnewgoodreceive setRecordName:maddressTextField.text];
                [mnewgoodreceive setDefaultAddressId:[NSNumber numberWithInt:1]];
            }
            else
            {
                [mnewgoodreceive setReceiveName:mreceiveNameTextField.text];
                [mnewgoodreceive setAddress1:maddressTextField.text];
                [mnewgoodreceive setReceiverPhone:mreceivePhone.text];
                [mnewgoodreceive setReceiverMobile:mreceiveMobile.text];
                [mnewgoodreceive setRecordName:maddressTextField.text];
                [mnewgoodreceive setDefaultAddressId:[NSNumber numberWithInt:1]];
                [mnewgoodreceive setProvinceId:[self safeGetmprovince:((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid]];
                if (((CityVO*)[mcity objectAtIndex:mcityselectedindex]).nid) 
                {
                    [mnewgoodreceive setCityId:((CityVO*)[mcity objectAtIndex:mcityselectedindex]).nid];
                }
                if (((CountyVO*)[mcounty objectAtIndex:mcountyselectedindex]).nid) 
                {
                    [mnewgoodreceive setCountyId:((CountyVO*)[mcounty objectAtIndex:mcountyselectedindex]).nid];
                    [mnewgoodreceive setCountyName:mtextField3.text];
                }
            }
            if (isnewAddress)
            {
                if ([[self safeGetmprovince:((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid] longValue] ==1 ) 
                {
                    [self transaddresstolatandlongWithSelector:@selector(SaveAddressSH)];
                }
                else 
                {
                    [self otsDetatchMemorySafeNewThreadSelector:@selector(addnewaddresstoserver) toTarget:self withObject:nil];
                }
            }
            else
            {
                if ([[self safeGetmprovince:((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid] longValue] ==1 ) 
                {
                    [self transaddresstolatandlongWithSelector:@selector(EditAddressSH)];
                }
                else
                {
                    [self otsDetatchMemorySafeNewThreadSelector:@selector(editaddresstoserver) toTarget:self withObject:nil];
                }
            }
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"地址错误" message:@"请检查详细地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
    }
    else
    {
        NSString * message;
        switch ([self checkTelephone]) {
            case -1:
                message = @"手机号格式不正确，请重新输入";
                break;
            case -2:
                message = @"电话格式不正确，请重新输入";
            default:
                break;
        }
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    }
}
-(int)checkTelephone
{
    NSLog(@"receivephone %@ receivemobile %@",mreceivePhone.text ,mreceiveMobile.text);
    if([mreceivePhone.text isEqualToString:@""]&&[mreceiveMobile.text isEqualToString:@""])
    {
        return -1;
    }
    else if([mreceivePhone.text isEqualToString:@""]&&mreceiveMobile.text.length !=11)
    {
        return -1;
    }
    else if([mreceiveMobile.text isEqualToString:@""]&&mreceivePhone.text.length < 8)
    {
        return -2;
    }
    return 1;
}
-(BOOL) checkDetailAddress
{
    if (maddressTextField.text.length>100) {
        return NO;
    }
    else {
        return YES;
    }
}
-(void)UpdateProvince:(NSNotification*)notification
{
    mtextField1.text = notification.object;
    mprovince = [notification.userInfo objectForKey:@"provinces"];
    mproviceselectedindex = [[notification.userInfo objectForKey:@"row"] intValue];
    if ([[self safeGetmprovince:((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid] longValue] ==1 ) 
    {
        [self refreshlocation];
    }
    else {
        [self resetlocation];
    }
}
-(void)refreshlocation
{
    CGRect temprect = mChangeLocationView.frame;
    mChangeLocationView.frame = CGRectMake(temprect.origin.x, 175, temprect.size.width, temprect.size.height);
    mHiddenView.hidden = YES;
}
-(void)resetlocation
{
    CGRect temprect = mChangeLocationView.frame;
    mChangeLocationView.frame = CGRectMake(temprect.origin.x, 226, temprect.size.width, temprect.size.height);
    mHiddenView.hidden = NO;
}
-(void)UpdateCity:(NSNotification*)notification
{
    mtextField2.text = notification.object;
    mcity = [notification.userInfo objectForKey:@"citys"];
    mcityselectedindex= [[notification.userInfo objectForKey:@"row"] intValue];
}
-(void)UpdateCounty:(NSNotification*)notification
{
    mtextField3.text = notification.object;
    mcounty = [notification.userInfo objectForKey:@"countys"];
    mcountyselectedindex = [[notification.userInfo objectForKey:@"row"] intValue];
}
-(IBAction)closeClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"popthnewaddressview" object:nil userInfo:nil];
}
-(IBAction)backClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"poptheDetailView" object:nil];
}
-(void)addnewaddresstoserver
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    
    int result = [service insertGoodReceiverByToken:[GlobalValue getGlobalValueInstance].token goodReceiverVO:mnewgoodreceive];
    if (result ==1)
    {
        [self performSelectorOnMainThread:@selector(newaddresssucceed) withObject:nil waitUntilDone:YES];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(addressSaveFailed) withObject:nil waitUntilDone:YES];
    }
    [pool drain];
}
-(void)editaddresstoserver
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    NSLog(@"%@",mnewgoodreceive.nid);
    int result = [service updateGoodReceiverByToken:[GlobalValue getGlobalValueInstance].token goodReceiverVO:mnewgoodreceive];
    if (result ==1)
    {
        [self performSelectorOnMainThread:@selector(editaddresssucceed) withObject:nil waitUntilDone:YES];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(addressSaveFailed) withObject:nil waitUntilDone:YES];
    }
    [pool drain];
}
-(void)newaddresssucceed
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"newaddresssucceed" object:mnewgoodreceive userInfo:nil];
}
-(void)editaddresssucceed
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"editaddresssucceed" object:mnewgoodreceive userInfo:nil];
}
-(void)showgoodreceive
{
    mreceiveNameTextField.text = mnewgoodreceive.receiveName;
    mreceiveMobile.text = mnewgoodreceive.receiverMobile;
    mreceivePhone.text = mnewgoodreceive.receiverPhone;
    maddressTextField.text = mnewgoodreceive.address1;
    mtextField1.text = mnewgoodreceive.provinceName;
    mtextField2.text = mnewgoodreceive.cityName;
    mtextField3.text = mnewgoodreceive.countyName;
    if([mnewgoodreceive.provinceId intValue] ==1)
    {
        [self refreshlocation];
    }
    mTitleLabel.text = @"编辑地址";
}
#pragma mark - UITextFieldDelegate
-(void)keyboardWillShow:(NSNotification*)notification
{
    float height = 434.0;
    CGRect frame = self.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height-height);
    [UIView beginAnimations:@"Curl" context:nil];
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self setFrame:frame];
    [UIView commitAnimations];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(self.frame.origin.x, 80, self.frame.size.width,self.frame.size.height);
    self.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(self.frame.origin.x, 80, self.frame.size.width,self.frame.size.height);
    self.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //CGRect frame = textField.frame;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    CGRect rect = CGRectMake(self.frame.origin.x, -10, width, height);
    self.frame = rect;
    [UIView commitAnimations];
}
-(void)transaddresstolatandlongWithSelector:(SEL)aSelector
{
    CLGeocoder *m_Geocoder;
    m_Geocoder=[[CLGeocoder alloc] init];
    __block CLGeocodeCompletionHandler handler=  ^(NSArray *placemarks, NSError *error)
    {
        for (CLPlacemark *placemark in placemarks)
        {
            double lng=[[placemark region] center].longitude;
            double lat=[[placemark region] center].latitude;
            [m_Lngs addObject:[NSNumber numberWithDouble:lng]];
            [m_Lats addObject:[NSNumber numberWithDouble:lat]];
        }
        
    [m_Geocoder geocodeAddressString:[NSString stringWithFormat:@"%@ %@ %@",((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).provinceName,((CityVO*)[mcity objectAtIndex:mcityselectedindex]).cityName,mtextField3.text]  completionHandler:handler];
    };
    [NSThread detachNewThreadSelector:aSelector toTarget:self withObject:nil];
}


-(void)SaveAddressSH
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    int result = [service insertGoodReceiverByToken:[GlobalValue getGlobalValueInstance].token goodReceiverVO:mnewgoodreceive lngs:m_Lngs lats:m_Lats];
    if (result ==1)
    {
        [self performSelectorOnMainThread:@selector(newaddresssucceed) withObject:nil waitUntilDone:YES];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(addressSaveFailed) withObject:nil waitUntilDone:YES];
    }
    [pool drain];
}

-(void)EditAddressSH
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    int result = [service updateGoodReceiverByToken:[GlobalValue getGlobalValueInstance].token goodReceiverVO:mnewgoodreceive lngs:m_Lngs lats:m_Lats];
    if (result ==1)
    {
        [self performSelectorOnMainThread:@selector(editaddresssucceed) withObject:nil waitUntilDone:YES];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(addressSaveFailed) withObject:nil waitUntilDone:YES];
    }
    [pool drain];
}

-(void)addressSaveFailed
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"失败" message:@"地址保存失败，请检查地址格式和电话格式并重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
#pragma mark -
#pragma mark WEPopover set
- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
	
	WEPopoverContainerViewProperties *props = [[WEPopoverContainerViewProperties alloc] autorelease];
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 4.0;
	
	bgImageName = @"ProvinceInAddress@2x.png";
	
	// These constants are determined by the popoverBg.png image file and are image dependent
	bgMargin = 4; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13 
	bgCapSize = 0; // ImageSize/2  == 62 / 2 == 31 pixels
	
	props.leftBgMargin = bgMargin;
	props.rightBgMargin = bgMargin;
	props.topBgMargin =8;// bgMargin;
	props.bottomBgMargin = bgMargin;
	props.leftBgCapSize = bgCapSize;
	props.topBgCapSize = bgCapSize;
	props.bgImageName = bgImageName;
	props.leftContentMargin = contentMargin;
	props.rightContentMargin =0;// contentMargin - 1; // Need to shift one pixel for border to look correct
	props.topContentMargin = 2;//contentMargin; 
	props.bottomContentMargin = contentMargin;
	
	props.arrowMargin = 4.0;
	
	props.upArrowImageName = @"popoverArrowUp.png";
	props.downArrowImageName = @"popoverArrowDown.png";
	props.leftArrowImageName = @"popoverArrowLeft.png";
	props.rightArrowImageName = @"popoverArrowRight.png";
	return props;	
}

#pragma mark - ProvinceChooseAddressDelegate
-(void)ProvinceChooseAtIndex:(int)index:(NSArray*)provinceArray
{
    [mPopOverController dismissPopoverAnimated:YES];
    tempProvice = provinceArray;
    tempProvinceSelectedIndex = index;
    
    //DataHandler * tempdata = [DataHandler sharedDataHandler];
    if (![[OTSGpsHelper sharedInstance].provinceVO.provinceName isEqualToString:((ProvinceVO*)[provinceArray objectAtIndex:index]).provinceName] && !isFromeMyStore) 
    {
        UIAlertView * tempalert = [[UIAlertView alloc]initWithTitle:@"无法下订单" message:[NSString stringWithFormat:@"订单地址与收货省份%@不一致，无法下单。\n切换省份，会使您购物车中的部分商品价格变化或者不能购买",[OTSGpsHelper sharedInstance].provinceVO.provinceName] delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"更换省份",nil];
        [tempalert setTag:2];
        [tempalert show];
        [tempalert release];
    }else {
        mprovince = provinceArray;
        mproviceselectedindex = index;
        mtextField1.text = ((ProvinceVO*)[mprovince objectAtIndex:index]).provinceName;
        
        
        //--------------更新省份的时候重置城市,地区-----------------------
        mtextField2.text = @"";
        mtextField3.text = @"";
        if ([[self safeGetmprovince:((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid] longValue] ==1 ) 
        {
            [self refreshlocation];
        }
        else 
        {
            [self resetlocation];
        }
    }
}

-(void)CityChooseAtIndex:(int)index :(NSArray *)CityArray
{
    [mCityPopOverController dismissPopoverAnimated:YES];
    mcity = CityArray;
    mtextField2.text = ((CityVO*)[mcity objectAtIndex:index]).cityName;
    mcityselectedindex = index;
    //--------------更新市时重置地区-----------------------
    mtextField3.text = @"";
    if ([[self safeGetmprovince:((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid] longValue] ==1 ) 
    {
        [self refreshlocation];
    }
    else 
    {
        [self resetlocation];
    }
}
-(void)CountyChooseAtIndex:(int)index :(NSArray *)countyArray
{
    [mCountyPopOverController dismissPopoverAnimated:YES];
    mcounty = countyArray;
    mtextField3.text = ((CountyVO*)[mcounty objectAtIndex:index]).countyName;
    mcountyselectedindex = index;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 2:
            if(buttonIndex == 1)
            {
             
                mprovince = tempProvice;
                mproviceselectedindex = tempProvinceSelectedIndex;
                ProvinceVO *province = [[ProvinceVO alloc]init];
                province.provinceName=((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).provinceName;
                
                NSString* rootPath = [[NSBundle mainBundle]resourcePath];
                NSString* path = [rootPath stringByAppendingPathComponent:@"ProvinceID.plist"];
                NSDictionary *provinceid=[NSDictionary dictionaryWithContentsOfFile:path];
                
                province.provinceName= province.provinceName;
                province.nid=[NSNumber numberWithInt:[[provinceid objectForKey:province.provinceName] intValue]];
                
                //DataHandler * tempdata = [DataHandler sharedDataHandler];
                [OTSGpsHelper sharedInstance].provinceVO=province;
                [GlobalValue getGlobalValueInstance].provinceId=province.nid;
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:province,@"province", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyProvinceChange object:nil userInfo:dic];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"popotheraddress" object:nil userInfo:nil];
                [province release];
            }
            break;
            
        default:
            if (buttonIndex ==1)
            {
                datahandler = [DataHandler sharedDataHandler];
                [OTSGpsHelper sharedInstance].provinceVO = mchangedProvinceVO;
                [GlobalValue getGlobalValueInstance].provinceId=mchangedProvinceVO.nid;
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:mchangedProvinceVO,@"province", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyProvinceChange object:nil userInfo:dic];
            }
            break;
    }
}
@end
