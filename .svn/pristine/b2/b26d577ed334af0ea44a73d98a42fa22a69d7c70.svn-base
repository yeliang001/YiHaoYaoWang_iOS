//
//  NewAddressSheet.m
//  yhd
//
//  Created by jun yuan on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewAddressSheet.h"
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



@interface NewAddressSheet ()

@end

@implementation NewAddressSheet
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem* barCloseButton=[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeModal:)];
    self.navigationItem.rightBarButtonItem=barCloseButton;
    [barCloseButton release];
    //init
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UpdateProvince:) name:@"kProvinceSelected" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UpdateCity:) name:@"kCitySelected" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UpdateCounty:) name:@"kCountySelected" object:nil];
    
    mbackButton.hidden = !isShowingBack;
    mcloseButton.hidden = isShowingBack;
    if (!isnewAddress) {
        [self showgoodreceive];
    }
}

-(void)closeModal:(id)sender{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark --
-(IBAction)downpickerviewClicked:(id)sender
{
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"kPopUpUIpickerview" object:[NSNumber numberWithInt:((UIButton*)sender).tag] userInfo:nil];//1 province 2city 3county
    [self dismisskeyboard];
    if (((UIButton*)sender).tag ==1) 
    {
        //        if (!mPopOverController)
        //        {
        ProvinceChooseAddressViewController *contentViewController = [[[ProvinceChooseAddressViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        contentViewController.delegate = self;
        self.mPopOverController = [[[WEPopoverController alloc] initWithContentViewController:contentViewController] autorelease];
        //self.popoverController.delegate = self;
        self.mPopOverController.popoverContentSize=CGSizeMake(193.0, 234.0);
        if ([self.mPopOverController respondsToSelector:@selector(setContainerViewProperties:)]) 
        {
            [self.mPopOverController setContainerViewProperties:[self improvedContainerViewProperties]];
        }
        
        //}
        
        mPopOverController.view.backgroundColor=[UIColor redColor];
        [self.mPopOverController presentPopoverFromRect:CGRectMake(0, 0, 400, 100) inView:self.view  permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) animated:YES];
    }
    else if(((UIButton*)sender).tag==2)
    {
        NSLog(@"%d",mproviceselectedindex);
        if (((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid||mnewgoodreceive.provinceId)
        {
            CityChooseAddressViewController *contentViewController = [[[CityChooseAddressViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            contentViewController.delegate = self;
            self.mCityPopOverController = [[[WEPopoverController alloc] initWithContentViewController:contentViewController] autorelease];
            if (isnewAddress) {
                contentViewController.mProvinceId = ((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid;
            }
            else
            {
                contentViewController.mProvinceId = mnewgoodreceive.provinceId;
            }
            //self.popoverController.delegate = self;
            self.mCityPopOverController.popoverContentSize=CGSizeMake(193.0, 234.0);
            if ([self.mCityPopOverController respondsToSelector:@selector(setContainerViewProperties:)]) 
            {
                [self.mCityPopOverController setContainerViewProperties:[self improvedContainerViewProperties]];
            }
            [self.mCityPopOverController presentPopoverFromRect:CGRectMake(0, 0, 800, 100) inView:self.view  permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) animated:YES];
        }
        
    }
    else if (((UIButton*)sender).tag==3)
    {
        if (((CityVO*)[mcity objectAtIndex:mcityselectedindex]).nid||mnewgoodreceive.cityId)
        {
            CountyChooseAddressViewController *contentViewController = [[[CountyChooseAddressViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            contentViewController.delegate = self;
            self.mCountyPopOverController = [[[WEPopoverController alloc] initWithContentViewController:contentViewController] autorelease];
            if (isnewAddress) {
                contentViewController.mCityId = ((CityVO*)[mcity objectAtIndex:mcityselectedindex]).nid;
            }
            else {
                if (((CityVO*)[mcity objectAtIndex:mcityselectedindex]).nid) {
                    contentViewController.mCityId = ((CityVO*)[mcity objectAtIndex:mcityselectedindex]).nid ;
                }
                else {
                    contentViewController.mCityId = mnewgoodreceive.cityId;
                }
                
            }
            //self.popoverController.delegate = self;
            self.mCountyPopOverController.popoverContentSize=CGSizeMake(252.0, 234.0);
            if ([self.mCountyPopOverController respondsToSelector:@selector(setContainerViewProperties:)]) 
            {
                [self.mCountyPopOverController setContainerViewProperties:[self improvedContainerViewProperties]];
            }
            
            //        }
            [self.mCountyPopOverController presentPopoverFromRect:CGRectMake(0, 0, 800, 150) inView:self.view  permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) animated:YES];
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
                    [mnewgoodreceive setProvinceId:((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid];
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
                    if (((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid) 
                    {
                        [mnewgoodreceive setProvinceId:((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid];
                    }
                    if (((CityVO*)[mcity objectAtIndex:mcityselectedindex]).nid) 
                    {
                        [mnewgoodreceive setCityId:((CityVO*)[mcity objectAtIndex:mcityselectedindex]).nid];
                    }
                    if (((CountyVO*)[mcounty objectAtIndex:mcountyselectedindex]).nid) 
                    {
                        [mnewgoodreceive setCountyId:((CountyVO*)[mcounty objectAtIndex:mcountyselectedindex]).nid];
                    }
                }
                if (isnewAddress)
                {
                    if ([((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid longValue] ==1 ) 
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
                    if ([((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid longValue] ==1 ) 
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
    else if([mreceiveMobile.text isEqualToString:@""] && mreceivePhone.text.length < 8)
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
    if ([((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid longValue] ==1 ) 
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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"newaddresssucceed" object:nil userInfo:nil];
}
-(void)editaddresssucceed
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"editaddresssucceed" object:nil userInfo:nil];
}
-(void)showgoodreceive
{
    mreceiveNameTextField.text = mnewgoodreceive.receiveName;
    NSLog(@"%@",mnewgoodreceive.receiveName);
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
//-(void)keyboardWillShow:(NSNotification*)notification
//{
//    float height = 434.0;
//    CGRect frame = self.frame;
//    frame.size = CGSizeMake(frame.size.width, frame.size.height-height);
//    [UIView beginAnimations:@"Curl" context:nil];
//    [UIView setAnimationDuration:0.30];
//    [UIView setAnimationDelegate:self];
//    [self setFrame:frame];
//    [UIView commitAnimations];
//}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //    NSTimeInterval animationDuration = 0.30f;
    //    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    //    [UIView setAnimationDuration:animationDuration];
    //    CGRect rect = CGRectMake(self.frame.origin.x, 80, self.frame.size.width,self.frame.size.height);
    //    self.frame = rect;
    //    [UIView commitAnimations];
    //    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    NSTimeInterval animationDuration = 0.30f;
    //    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    //    [UIView setAnimationDuration:animationDuration];
    //    CGRect rect = CGRectMake(self.frame.origin.x, 80, self.frame.size.width,self.frame.size.height);
    //    self.frame = rect;
    //    [UIView commitAnimations];
    //    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //CGRect frame = textField.frame;
    //    NSTimeInterval animationDuration = 0.30f;
    //    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    //    [UIView setAnimationDuration:animationDuration];
    //    float width = self.frame.size.width;
    //    float height = self.frame.size.height;
    //    CGRect rect = CGRectMake(self.frame.origin.x, -10, width, height);
    //    self.frame = rect;
    //    [UIView commitAnimations];
}

-(void)transaddresstolatandlongWithSelector:(SEL)aSelector
{
    CLGeocoder *m_Geocoder;
    m_Geocoder=[[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handler=  ^(NSArray *placemarks, NSError *error){
        for (CLPlacemark *placemark in placemarks) {
            double lng=[[placemark region] center].longitude;
            double lat=[[placemark region] center].latitude;
            [m_Lngs addObject:[NSNumber numberWithDouble:lng]];
            [m_Lats addObject:[NSNumber numberWithDouble:lat]];
        }
        [m_Geocoder geocodeAddressString:[NSString stringWithFormat:@"%@ %@ %@",((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).provinceName,((CityVO*)[mcity objectAtIndex:mcityselectedindex]).cityName,mtextField3.text]  completionHandler:handler];
    };
    [self otsDetatchMemorySafeNewThreadSelector:@selector(aSelector) toTarget:self withObject:nil];
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
    mprovince = provinceArray;
    datahandler = [DataHandler sharedDataHandler];
    if ([((ProvinceVO*)[mprovince objectAtIndex:index]).nid intValue]!=[[OTSGpsHelper sharedInstance].provinceVO.nid intValue]&&!isNotLimited)
    {
        mchangedProvinceVO = ((ProvinceVO*)[mprovince objectAtIndex:index]);
        [mchangedProvinceVO retain];
        UIAlertView * tempalert = [[UIAlertView alloc]initWithTitle:@"无法下订单" message:[NSString stringWithFormat:@"订单地址与收货省份%@不一致，无法下单。\n切换省份，会使您购物车中的部分商品价格变化或者不能购买",[OTSGpsHelper sharedInstance].provinceVO.provinceName] delegate:self cancelButtonTitle:nil otherButtonTitles:@"修改地址",@"更换省份",nil];
        [tempalert show];
        [tempalert release];
    }
    else {
        mtextField1.text = ((ProvinceVO*)[mprovince objectAtIndex:index]).provinceName;
        //mprovince = [notification.userInfo objectForKey:@"provinces"];
        mproviceselectedindex = index;
        datahandler = [DataHandler sharedDataHandler];
        if ([((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid longValue] ==1 ) 
        {
            [self refreshlocation];
        }
        else {
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
    if (buttonIndex ==1)
    {
        datahandler = [DataHandler sharedDataHandler];
        [OTSGpsHelper sharedInstance].provinceVO = mchangedProvinceVO;
        [GlobalValue getGlobalValueInstance].provinceId=mchangedProvinceVO.nid;
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:mchangedProvinceVO,@"province", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyProvinceChange object:nil userInfo:dic];
    }
}


@end
