//
//  More.m
//  TheStoreApp
//
//  Created by jiming huang on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "More.h"
#import "AlertView.h"
#import "FeedbackService.h"
#import "TheStoreAppAppDelegate.h"
#import "OTSSecurityValidationVC.h"
#import "OTSNaviAnimation.h"
#import "NeedCheckResult.h"
#import "OTSAlertView.h"
#import "OTSActionSheet.h"
#import "SystemService.h"
#import "Page.h"
#import "QualityAppVO.h"
#import "DataController.h"
#import "OTSUtility.h"
#import "OTSOrderSubmitOKVC.h"
#import "OTSServiceHelper.h"
#import "CmsPageVO.h"
#import "UIScrollView+OTS.h"
#import "MyBrowse.h"
#import "IconCacheViewController.h"
#import "VersionInfo.h"
#import "YWSystemService.h"
#import "ResultInfo.h"
#import "GlobalValue.h"
#define ALERTVIEW_TAG_FEEDBACK  1
#define ALERTVIEW_TAG_UPDATE  2
#define ALERTVIEW_TAG_NO_UPDATE  3

@implementation More
static NSString* startTime=@"09:00";
static NSString* endTime=@"23:00";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (sTimeArray==nil) {
        sTimeArray=[[NSArray alloc] initWithObjects:@"00:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00", nil];
    }
    if (eTimeArray==nil) {
        eTimeArray=[[NSArray alloc] initWithObjects:@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"24:00", nil];

    }
    NSString*start=[[NSUserDefaults standardUserDefaults] valueForKey:@"push_start_time"];
    NSString*end=[[NSUserDefaults standardUserDefaults] valueForKey:@"push_end_time"];
    swit=[[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    if (start==nil) {
        [[NSUserDefaults standardUserDefaults] setValue:startTime forKey:@"push_start_time"];
        [[NSUserDefaults standardUserDefaults] setValue:endTime forKey:@"push_end_time"];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"pushSwith"];
    }
    BOOL needPushSet=NO;
    if (start==nil||end==nil) {
        if (![start isEqualToString:startTime]||![end isEqualToString:endTime]) {
            needPushSet=YES;
        }
    }

    if (start) {
        startTime=start;
    }
    
    if (end) {
        endTime=end;
    }
    
    [self initMore];
    UITableView*table=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
    table.delegate=self;
    table.dataSource=self;
    table.backgroundColor=[UIColor colorWithRed:(240.0/255.0) green:(240.0/255.0) blue:(240.0/255.0) alpha:1];
    table.backgroundView=nil;
    //为了适配iOS7
    if (ISIOS7)
    {
        table.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, table.bounds.size.width, 1.f)] autorelease];
    }
    
    [self.view addSubview:table];
    [table release];
//    屏蔽推送
    NSString* pushOff=[[NSUserDefaults standardUserDefaults] valueForKey:@"pushSwith"];

    if (pushOff ==nil) {
        [self showLoading:YES];
        [self enableDeviceForPushMsg:YES sHour:9 eHour:23];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFeedback:) name:@"FeedbackMsg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(provinceChanged:) name:@"ProvinceChanged" object:nil];
    
#ifdef DEBUG
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"生产服务器",@"测试服务器",@"开发服务器",@"预生产"]];
    segment.frame = CGRectMake(10, 280, 300, 40);
    [segment addTarget:self action:@selector(selectHost:) forControlEvents:UIControlEventValueChanged];
    segment.tintColor = [UIColor redColor];
    
    [self.view addSubview:segment];
    [segment release];
#endif
    
}

- (void)selectHost:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    NSInteger index = segment.selectedSegmentIndex;
    [GlobalValue getGlobalValueInstance].hostIndex = index;
}


-(void)enterFeedback:(NSNotification *)notification
{
    m_FeedBackView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
    [self.view addSubview:m_FeedBackView];
    [m_FeedBackTextView setText:@"留下您宝贵的意见："];
}

-(void)provinceChanged:(NSNotification *)notification
{
    NSString *string=[notification object];
    [m_ProvinceLabel setText:string];
}

-(void)initMore
{
//    CGFloat yValue=0.0;
//    UITableView *firstTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, 100) style:UITableViewStyleGrouped];
//    [firstTableView setTag:1];
//    [firstTableView setBackgroundColor:[UIColor clearColor]];
//    [firstTableView setBackgroundView:nil];
//    [firstTableView setScrollEnabled:NO];
//    [firstTableView setDelegate:self];
//    [firstTableView setDataSource:self];
//    [m_ScrollView addSubview:firstTableView];
//    [firstTableView release];
//    
//    yValue+=100;
//    UITableView *secondTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, 189) style:UITableViewStyleGrouped];
//    [secondTableView setTag:2];
//    [secondTableView setBackgroundColor:[UIColor clearColor]];
//    [secondTableView setBackgroundView:nil];
//    [secondTableView setScrollEnabled:NO];
//    [secondTableView setDelegate:self];
//    [secondTableView setDataSource:self];
//    [m_ScrollView addSubview:secondTableView];
//    [secondTableView release];
//    
//    yValue+=189.0;
//    UITableView *thirdTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, 101) style:UITableViewStyleGrouped];
//    [thirdTableView setTag:3];
//    [thirdTableView setBackgroundColor:[UIColor clearColor]];
//    [thirdTableView setBackgroundView:nil];
//    [thirdTableView setScrollEnabled:NO];
//    [thirdTableView setDelegate:self];
//    [thirdTableView setDataSource:self];
//    [m_ScrollView addSubview:thirdTableView];
//    [thirdTableView release];
//    
//    yValue+=111.0;
//    //让scrollview可以滑动
//    if (yValue<=[m_ScrollView frame].size.height) {
//        [m_ScrollView setContentSize:CGSizeMake(320, [m_ScrollView frame].size.height+1)];
//    } else {
//        [m_ScrollView setContentSize:CGSizeMake(320, yValue)];
//    }
    
    //初始化服务协议wap页面
    m_WebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
	[m_WebView setOpaque:NO];
	[m_WebView setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.7f]];
	//[self performSelectorOnMainThread:@selector(loadWap) withObject:self waitUntilDone:YES];
	[m_ServiceAgreeView addSubview:m_WebView];
    
    //版本号
    NSMutableString* buildVersionStr = [NSMutableString stringWithFormat:@"V%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
#if defined (DEBUG)
//    [buildVersionStr appendFormat:@"_%@", OTS_BUILD_TIME];
#endif
    
    m_VersionLabel.frame = CGRectMake(m_VersionLabel.frame.origin.x
                                      , m_VersionLabel.frame.origin.y
                                      , self.view.frame.size.width
                                      , m_VersionLabel.frame.size.height);
    [m_VersionLabel setText:buildVersionStr];
    [m_VersionLabel sizeToFit];
    
    [OTSUtility horizontalCenterViews:[NSArray arrayWithObjects:[m_VersionLabel.superview viewWithTag:999], m_VersionLabel, nil] 
                               inView:m_VersionLabel.superview 
                               margin:0];
}



//显示主view
-(void)showMainView
{
    [self removeSubControllerClass:[IconCacheViewController class]];
    [m_ServiceAgreeView removeFromSuperview];
    [m_FeedBackView removeFromSuperview];
    [m_AboutView removeFromSuperview];
	[m_recommendApplicationView removeFromSuperview];
    [self removeSubControllerClass:[UseHelp class]];
    [self removeSubControllerClass:[MyBrowse class]];
}

//联系客服
-(IBAction)telephone:(id)sender {
    UIActionSheet *actionSheet=[[OTSActionSheet alloc] initWithTitle:@"客服工作时间 : 每日 9:00-21:00" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"400-007-0958", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
}

-(IBAction)closeServiceAgree:(id)sender
{
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [m_ServiceAgreeView removeFromSuperview];
}

-(IBAction)closeRecommendApplicationView:(id)sender{
    [m_recommendAppList removeAllObjects];
	[self.view.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [m_recommendApplicationView removeFromSuperview];
}

-(IBAction)closeFeedBack:(id)sender
{
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [m_FeedBackView removeFromSuperview];
}

-(IBAction)closeAbout:(id)sender
{
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [m_AboutView removeFromSuperview];
}

//提交意见反馈
-(IBAction)submitFeedBack:(id)sender
{
    NSString *alertMsg;
	//当输入文字超过800字
	if ([[m_FeedBackTextView text] length]>800)
    {
		alertMsg=@"提交字数不能大于800!";
        [AlertView showAlertView:nil alertMsg:alertMsg buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
    }
    else
    {
		if ([[m_FeedBackTextView text] length]==0 || [[m_FeedBackTextView text] isEqualToString:@"留下您宝贵的意见："] || [[[m_FeedBackTextView text] stringByReplacingOccurrencesOfString:@" " withString:@""] length]<1)
        {
			alertMsg=@"提交内容不能为空!";
            [AlertView showAlertView:nil alertMsg:alertMsg buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
			[m_FeedBackTextView setText:@""];
	    }
        else if (contactTf.text.length == 0)
        {
            [AlertView showAlertView:nil alertMsg:@"联系方式不能为空！" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
        }
        
        else
        {
			NSString *message=[m_FeedBackTextView text];
			[NSThread otsDetatchMemorySafeNewThreadSelector:@selector(newThreadSubmitFeedBack:) toTarget:self withObject:message];
		}
	}
	[m_FeedBackTextView resignFirstResponder];
}

//新线程提交反馈
-(void)newThreadSubmitFeedBack:(NSString *)message
{
    
    YWSystemService *ser = [[YWSystemService alloc] init];
    ResultInfo *result = [ser feedBack:@{@"content": m_FeedBackTextView.text, @"contact":contactTf.text}];
    
    
    
    
//    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
//    FeedbackService *fServ=[[FeedbackService alloc]init];
//	int result=[fServ addFeedback:[GlobalValue getGlobalValueInstance].token feedbackcontext:message];
    [self performSelectorOnMainThread:@selector(feedBackShowResult:) withObject:[NSNumber numberWithInt:result.resultCode] waitUntilDone:NO];
//    [fServ release];
//    [pool release];
}

//提交反馈结果显示
-(void)feedBackShowResult:(NSNumber *)resultNum
{
    int result=[resultNum intValue];
    NSString *alertMsg;
    if (result==1)
    {
        alertMsg=@"提交成功!";
        
        [self showShortTip:alertMsg];
        [self closeFeedBack:nil];
    }
    else
    {
        [self showLongTip:@"提交失败!"];
    }
//    UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:nil message:alertMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert setTag:ALERTVIEW_TAG_FEEDBACK];
//    [alert show];
//    [alert release];
}


//加载wap页面
-(void)loadWap
{
    NSString *urlStr=@"http://m.yihaodian.com/helpmore/10";
    NSURL *url=[[NSURL alloc] initWithString:urlStr];
	[m_WebView loadRequest:[NSURLRequest requestWithURL:url]];
	[url release];
}
#pragma mark 消息推送部分
-(void)showTimePicker{
    timeSheet=[[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    timeSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    UIPickerView* picker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 320, 200)];
    picker.delegate=self;
    picker.showsSelectionIndicator=YES;
    picker.backgroundColor=[UIColor clearColor];
    [timeSheet addSubview:picker];
    [picker release];
    UISegmentedControl*doneBtn=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"完成"]];
    [doneBtn addTarget:self action:@selector(timeDone) forControlEvents:UIControlEventValueChanged];
    doneBtn.segmentedControlStyle=UISegmentedControlStyleBar;
    doneBtn.tintColor=[UIColor blackColor];
    doneBtn.frame=CGRectMake(260, 6, 50, 30);
    [timeSheet addSubview:doneBtn];
    [doneBtn release];
    
    UISegmentedControl*cancelBtn=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"取消"]];
    [cancelBtn addTarget:self action:@selector(timeCancel) forControlEvents:UIControlEventValueChanged];
    cancelBtn.segmentedControlStyle=UISegmentedControlStyleBar;
    cancelBtn.frame=CGRectMake(10, 6, 50, 30);
    cancelBtn.tintColor=[UIColor blackColor];
    [timeSheet addSubview:cancelBtn];
    [cancelBtn release];
    TheStoreAppAppDelegate*delegate=(TheStoreAppAppDelegate*)[[UIApplication sharedApplication] delegate];
    [timeSheet showFromTabBar:delegate.tabBarController.tabBar];
    [timeSheet release];
    int startIndex = [self indexOfStartTime:startTime];
    int endIndex = [self indexOfEndTime:endTime];
    if (startIndex>=0 && startIndex<24) {
        [picker selectRow:startIndex inComponent:0 animated:NO];
    }
    if (endIndex>=0 && endIndex<24) {
        [picker selectRow:endIndex inComponent:1 animated:NO];
    }
}
//消息开关
-(void)pushSwith:(UISwitch*)sender{
    [self showLoading:YES];
    if (!sender.on) {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"pushSwith"];
        pushTime.textColor=[UIColor lightGrayColor];
        [self otsDetatchMemorySafeNewThreadSelector:@selector(opreationOnSwith:) toTarget:self withObject:[NSNumber numberWithInt:0]];

    } else{
        pushTime.textColor=[UIColor blackColor];
        [self otsDetatchMemorySafeNewThreadSelector:@selector(opreationOnSwith:) toTarget:self withObject:[NSNumber numberWithInt:1]];
    }
}

-(void)opreationOnSwith:(NSNumber*)status{
    if (status.intValue==0) {
        [self enableDeviceForPushMsg:NO sHour:[self indexOfStartTime:startTime] eHour:[self indexOfEndTime:endTime]+1];
    }else{
        [self enableDeviceForPushMsg:YES sHour:[self indexOfStartTime:startTime] eHour:[self indexOfEndTime:endTime]+1];
    }

}
-(NSInteger)indexOfStartTime:(NSString*)time{
    return  [sTimeArray indexOfObject:time];
}
-(NSInteger)indexOfEndTime:(NSString*)time{
    return  [eTimeArray indexOfObject:time];
}
-(void)timeCancel{
    [self savePushTimeToDefault];
    [timeSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)savePushTimeToDefault{
    startTime=[[NSUserDefaults standardUserDefaults] valueForKey:@"push_start_time"];
    endTime=[[NSUserDefaults standardUserDefaults] valueForKey:@"push_end_time"];
}
-(void)savePushTime{
    pushTime.text=[NSString stringWithFormat:@"%@-%@",startTime,endTime];
    [[NSUserDefaults standardUserDefaults] setValue:startTime forKey:@"push_start_time"];
    [[NSUserDefaults standardUserDefaults] setValue:endTime forKey:@"push_end_time"];
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",swit.on] forKey:@"pushSwith"];
}
-(void)timeDone{
    [timeSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self showLoading:YES];
    [self enableDeviceForPushMsg:YES sHour:[self indexOfStartTime:startTime] eHour:[self indexOfEndTime:endTime]+1];
}
-(void)pushMsgBack:(PushMappingResult*)result{
    [self hideLoading];
    if ([result.resultCode intValue]) {
        [self savePushTime];
    }else{
        BOOL status=swit.on;
        if (!status) {
            swit.on=YES;
        }else{
            swit.on=NO;
        }
        if (swit.on) {
            pushTime.textColor=[UIColor blackColor];
        }else{
            pushTime.textColor=[UIColor lightGrayColor];
        }
        [self savePushTimeToDefault];
        if ([GlobalValue getGlobalValueInstance].deviceToken==nil) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"设置参数无效" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
}

-(void)enableDeviceForPushMsg:(BOOL)isOpen sHour:(int)shour eHour:(int)ehour{
    @autoreleasepool {
        FeedbackService* fdSer=[[FeedbackService alloc] init];
        [GlobalValue getGlobalValueInstance].trader.provinceId=[[GlobalValue getGlobalValueInstance].provinceId stringValue];
        PushMappingResult* result=[fdSer enableDeviceForPushMsg:[GlobalValue getGlobalValueInstance].trader deviceToken:[GlobalValue getGlobalValueInstance].deviceToken isOpen:isOpen startHour:[NSNumber numberWithInt:shour] endHour:[NSNumber numberWithInt:ehour]];
        if (result.resultCode.intValue) {
            DebugLog(@"OK");
        }else{
            DebugLog(@"Failed");
        }
        [self performSelectorOnMainThread:@selector(pushMsgBack:) withObject:result waitUntilDone:YES];
        [fdSer release];
    }
    
}

#pragma mark picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return [sTimeArray objectAtIndex:row];
    }else{
        return [eTimeArray objectAtIndex:row];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return [sTimeArray count];
    }else{
        return [eTimeArray count];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        DebugLog(@"%@====%@",startTime,endTime);
        startTime=[sTimeArray objectAtIndex:row];
        if ([startTime isEqualToString:endTime]) {
            [pickerView selectRow:row inComponent:1 animated:YES];
            endTime=[eTimeArray objectAtIndex:row];
        }
    }else{
        endTime=[eTimeArray objectAtIndex:row];
            if ([startTime isEqualToString:endTime]) {
                [pickerView selectRow:row inComponent:0 animated:YES];
                startTime=[sTimeArray objectAtIndex:row];
            }
    }
}
#pragma mark 精品应用推荐
-(void)updateRecommendAppTable{
	[recommendTableView reloadData];
}

// 保存应用信息到本地
-(void)saveRecommendAppInfoToLocal
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    for (QualityAppVO *appVO in m_recommendAppList) {
        NSMutableDictionary *mDictionary=[[NSMutableDictionary alloc] init];
        [mDictionary setObject:[NSString stringWithFormat:@"%@",[appVO appName]] forKey:@"appName"];
        [mDictionary setObject:[NSString stringWithFormat:@"%@",[appVO appLinkUrl]] forKey:@"appLinkUrl"];
        [mDictionary setObject:[NSString stringWithFormat:@"%@",[appVO appIconUrl]] forKey:@"appIconUrl"];
        [mDictionary setObject:[NSString stringWithFormat:@"%@",[appVO appExplain]] forKey:@"appExplain"];
        [array addObject:mDictionary];
        [mDictionary release];
    }
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"SaveQualityApp.plist"];    
    [array writeToFile:filename atomically:NO];
    [array release];
}

// 从本地获取应用信息
-(NSMutableArray *)getRecommendAppInfoLocal
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *path=[paths objectAtIndex:0];
	NSString *filename=[path stringByAppendingPathComponent:@"SaveQualityApp.plist"];  
	NSMutableArray *qualityAppInfoArray=[[[NSMutableArray alloc] initWithContentsOfFile:filename] autorelease];
    if (qualityAppInfoArray!=nil && [qualityAppInfoArray count]>0) {
        NSMutableArray *apps=[[[NSMutableArray alloc] init] autorelease];
        for (NSMutableDictionary *mDictionary in qualityAppInfoArray) {
            QualityAppVO *appVO=[[QualityAppVO alloc] init];
            NSString *appName=[NSString stringWithFormat:@"%@",[mDictionary objectForKey:@"appName"]];
            [appVO setAppName:appName];
            NSString *appLinkUrl=[NSString stringWithFormat:@"%@",[mDictionary objectForKey:@"appLinkUrl"]];
            [appVO setAppLinkUrl:appLinkUrl];
            NSString *appIconUrl=[NSString stringWithFormat:@"%@",[mDictionary objectForKey:@"appIconUrl"]];
            [appVO setAppIconUrl:appIconUrl];
            NSString *appExplain=[NSString stringWithFormat:@"%@",[mDictionary objectForKey:@"appExplain"]];
            [appVO setAppExplain:appExplain];
            [apps addObject:appVO];
            [appVO release];
        }
        return apps;
    } else {
        return nil;
    }
    return nil;
}

// 从网络获取应用信息并进行本地缓存
-(void)netThreadGetRecommendApplication {
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    SystemService *service=[[SystemService alloc] init];
    Page *tempPage=[service getQualityAppList:[GlobalValue getGlobalValueInstance].trader currentPage:[NSNumber numberWithInt:m_PageIndex] pageSize:[NSNumber numberWithInt:20]];
    if (tempPage==nil || [tempPage isKindOfClass:[NSNull class]] || [[tempPage objList]count] <= 0) {
    } else {
		if (m_PageIndex==1 && [m_recommendAppList count]>0 ) {//若首次请求数据成功，清除之前的缓存数据
			[m_recommendAppList removeAllObjects];
		}
        int i;
        for (i=0; i<[[tempPage objList]count]; i++) {
			[m_recommendAppList addObject:[[tempPage objList]objectAtIndex:i]];
		}
		m_PageIndex++;
		appTotalCount=[tempPage.totalSize intValue];
		appListCount=[m_recommendAppList count];
		[self saveRecommendAppInfoToLocal];
		[self performSelectorOnMainThread:@selector(updateRecommendAppTable) withObject:nil waitUntilDone:NO];
		[self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetAppImage) toTarget:self withObject:nil];
    }
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"MainWindowHideLoading" object:nil];
    [self hideLoading];
    [service release];
    [pool drain];
}

//新线程获取应用图片
-(void)newThreadGetAppImage
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    int i;
    for (i=0; i<[m_recommendAppList count]; i++) {
        QualityAppVO *appVO=[OTSUtility safeObjectAtIndex:i inArray:m_recommendAppList];
        NSURL *url=[NSURL URLWithString:[appVO appIconUrl]];
        NSData *data=[NSData dataWithContentsOfURL:url];
        if (data!=nil) {
            [DataController writeApplicationData:data name:[NSString stringWithFormat:@"qualityApp_%@",[appVO appName]]];
        }
    }
    [self performSelectorOnMainThread:@selector(updateRecommendAppTable) withObject:nil waitUntilDone:NO];
    [pool drain];
}

#pragma mark alertview相关
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch ([alertView tag]) {
        case ALERTVIEW_TAG_FEEDBACK:
        {//提交反馈
            [self closeFeedBack:nil];
            break;
        }
        case ALERTVIEW_TAG_UPDATE: {//更新
            if (buttonIndex==1)
            {
                
                NSString *tempStr=[[NSString alloc] initWithString:[GlobalValue getGlobalValueInstance].downloadVO.updateUrl];
                if (tempStr==nil) {
//                    tempStr=@"http://itunes.apple.com/cn/app/id427457043?mt=8&ls=1";
                }
                NSString *url=[tempStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				NSURL *iTunesUrl=[NSURL URLWithString:url] ; 
				[[UIApplication	sharedApplication] openURL:iTunesUrl];
                [tempStr release];
                TheStoreAppAppDelegate *delegate=(TheStoreAppAppDelegate*)([UIApplication sharedApplication].delegate);
                [delegate setIsVersionUpdate:YES];
			}
            break;
        }
        case ALERTVIEW_TAG_NO_UPDATE: {//无更新
            break;
        }
        default:
            break;
    }
}

#pragma mark actionsheet相关
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (actionSheet==timeSheet) {
        
    }else{
        switch (buttonIndex) {
            case 0: {
                UIDeviceHardware *hardware=[[UIDeviceHardware alloc] init];
                //判断设备是否iphone
                /* if (!([[hardware platformString] isEqualToString:@"iPhone 1G"] || 
                 [[hardware platformString] isEqualToString:@"iPhone 3G"] || 
                 [[hardware platformString] isEqualToString:@"iPhone 3GS"] || 
                 [[hardware platformString] isEqualToString:@"iPhone 4"] || 
                 [[hardware platformString] isEqualToString:@"Verizon iPhone 4"])) */
                NSRange range = [[hardware platformString] rangeOfString:@"iPhone"];
                if (range.length <= 0) {
                    [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
                    [AlertView showAlertView:nil alertMsg:@"您的设备不支持此项功能,感谢您对1号药店的支持!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000070958"]];
                }
                [hardware release];
                break;
            }
            default:
                break;
        }
    }
}



#pragma mark tableView的datasource和delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
    
    switch (section)
    {
        case 0: {
            return 5;
            break;
        }
        case 1: {
            return 4;
            break;
        }
        case 2: {
            return 3;
            break;
        }
		case 3:{
			return [m_recommendAppList count]+1;
			break;
		}
        default:
            return 0;
            break;
    }
}

-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中颜色
    
    switch (indexPath.row)
    {
        case 0:
            //使用省份切换
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddSwitchProvinceForTabBar" object:nil];
            break;
        case 1:
        {
            [m_FeedBackTextView setText:@"留下您宝贵的意见："];
            m_FeedBackView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
            CATransition *animation=[CATransition animation];
            animation.duration=0.3f;
            animation.timingFunction=UIViewAnimationCurveEaseInOut;
            [animation setType:kCATransitionPush];
            [animation setSubtype: kCATransitionFromRight];
            [self.view.layer addAnimation:animation forKey:@"Reveal"];
            [self.view addSubview:m_FeedBackView];
        }
            break;
            
        case 2:
            //联系客服
            [self telephone:nil];
            break;
        case 3:
        {  //版本更新
            UIAlertView *alertView;
            if ([GlobalValue getGlobalValueInstance].downloadVO!=nil)
            {
                alertView=[[OTSAlertView alloc] initWithTitle:@"更新提示" message:[GlobalValue getGlobalValueInstance].downloadVO.versionDesc delegate:self cancelButtonTitle:@"稍后" otherButtonTitles:@"更新", nil];
                [alertView setTag:ALERTVIEW_TAG_UPDATE];
            }
            else
            {
                alertView=[[OTSAlertView alloc] initWithTitle:@"更新提示" message:@"您当前使用的已经是最新版的1号药店,感谢您对1号药店的支持!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView setTag:ALERTVIEW_TAG_NO_UPDATE];
            }
            [alertView show];
            [alertView release];
            break;
        }
        case 4:
        {
            //关于
            m_AboutView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
            UIScrollView* content=nil;
            for (UIView* v in m_AboutView.subviews) {
                if ([v isKindOfClass:[UIScrollView class]]) {
                    content=(UIScrollView*)v;
                    break;
                }
            }
            content.frame=CGRectMake(0,44, 320, self.view.frame.size.height-44);
            CATransition *animation=[CATransition animation];
            animation.duration=0.3f;
            animation.timingFunction=UIViewAnimationCurveEaseInOut;
            [animation setType:kCATransitionPush];
            [animation setSubtype: kCATransitionFromRight];
            [self.view.layer addAnimation:animation forKey:@"Reveal"];
            [self.view addSubview:m_AboutView];
            
            break;
        }
        default:
            break;
    }

    /*
    
    switch ([indexPath section])
    {
        case 0: {
            if ([indexPath row]==0) 
            {//使用省份切换
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AddSwitchProvinceForTabBar" object:nil];
            }
            else if([indexPath row]==1)
            {//最近浏览
                [self removeSubControllerClass:[MyBrowse class]];
                MyBrowse *browse=[[[MyBrowse alloc]initWithNibName:@"MyBrowse" bundle:nil] autorelease];
                
                [self pushVC:browse animated:YES];
            }else if (indexPath.row==2){
                
            }else if (indexPath.row==3){
                if (pushTime.textColor==[UIColor blackColor]) {
                    [self showTimePicker];
                }
            }
            break;
        }
        case 1: {
            if ([indexPath row]==0) {//使用帮助
                [self removeSubControllerClass:[UseHelp class]];
                UseHelp *useHelp=[[[UseHelp alloc]initWithNibName:@"UseHelp" bundle:nil] autorelease];
                
                CATransition *animation=[CATransition animation];
                animation.duration=0.3f;
                animation.timingFunction=UIViewAnimationCurveEaseInOut;
                [animation setType:kCATransitionPush];
                [animation setSubtype: kCATransitionFromRight];
                [self.view.layer addAnimation:animation forKey:@"Reveal"];
                [self.view addSubview:useHelp.view];
            } else if ([indexPath row]==1) {//意见反馈
                if ([GlobalValue getGlobalValueInstance].token!=nil) {
                    [m_FeedBackTextView setText:@"留下您宝贵的意见："];
                    m_FeedBackView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
                    CATransition *animation=[CATransition animation];
                    animation.duration=0.3f;
                    animation.timingFunction=UIViewAnimationCurveEaseInOut;
                    [animation setType:kCATransitionPush];
                    [animation setSubtype: kCATransitionFromRight];
                    [self.view.layer addAnimation:animation forKey:@"Reveal"];
                    [self.view addSubview:m_FeedBackView];
                } else {
                    [SharedDelegate enterUserManageWithTag:6];
                }
            } 
            else if ([indexPath row]==2) 
            {//联系客服
                [self telephone:nil];
            } 
            else if ([indexPath row]==3) 
            {//服务协议
                
                [self performSelectorOnMainThread:@selector(loadWap) withObject:self waitUntilDone:YES];
                
                CATransition *animation=[CATransition animation];
                animation.duration=0.3f;
                animation.timingFunction=UIViewAnimationCurveEaseInOut;
                [animation setType:kCATransitionPush];
                [animation setSubtype: kCATransitionFromRight];
                [self.view.layer addAnimation:animation forKey:@"Reveal"];
                [self.view addSubview:m_ServiceAgreeView];
				for (UIView* tpview in [m_WebView subviews]) {
					if ([tpview isKindOfClass:[UIScrollView class]]) {
						UIScrollView* tpScrollView = (UIScrollView*)tpview;
						[tpScrollView ScrollMeToTopOnly];
						break;
					}
				}
            }
            break;
        }
        case 2: {
            if (indexPath.row==0) {
                cacheView=[[IconCacheViewController alloc] init];                
                [self pushVC:cacheView animated:YES fullScreen:YES];
                [cacheView release];
                
            }else if ([indexPath row]==1) {//版本更新
                UIAlertView *alertView;
                if ([GlobalValue getGlobalValueInstance].downloadVO!=nil)
                {
                    alertView=[[OTSAlertView alloc] initWithTitle:@"更新提示" message:[GlobalValue getGlobalValueInstance].downloadVO.versionDesc delegate:self cancelButtonTitle:@"稍后" otherButtonTitles:@"更新", nil];
                    [alertView setTag:ALERTVIEW_TAG_UPDATE];
                }
                else
                {
                    alertView=[[OTSAlertView alloc] initWithTitle:@"更新提示" message:@"您当前使用的已经是最新版的1号药网,感谢您对1号药网的支持!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView setTag:ALERTVIEW_TAG_NO_UPDATE];
                }
                [alertView show];
                [alertView release];
            } else if ([indexPath row]==2) {//关于
                m_AboutView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
                UIScrollView* content=nil;
                for (UIView* v in m_AboutView.subviews) {
                    if ([v isKindOfClass:[UIScrollView class]]) {
                        content=(UIScrollView*)v;
                        break;
                    }
                }
                content.frame=CGRectMake(0,44, 320, self.view.frame.size.height-44);
                CATransition *animation=[CATransition animation];
                animation.duration=0.3f;
                animation.timingFunction=UIViewAnimationCurveEaseInOut;
                [animation setType:kCATransitionPush];
                [animation setSubtype: kCATransitionFromRight];
                [self.view.layer addAnimation:animation forKey:@"Reveal"];
                [self.view addSubview:m_AboutView];
            } else if ([indexPath row] == 3) { //精品应用
				//功能模块
				if (m_recommendAppList!=nil) {
					[m_recommendAppList release];
					m_recommendAppList = nil;
				}
				NSMutableArray *mArray=[self getRecommendAppInfoLocal];//读取本地缓存数据
				if (mArray!=nil) {
					m_recommendAppList=[mArray retain];
					[self updateRecommendAppTable];
				} else {
					m_recommendAppList = [[NSMutableArray alloc]init];
				}
				m_PageIndex= 1;
				CATransition *animation=[CATransition animation];
                animation.duration=0.3f;
                animation.timingFunction=UIViewAnimationCurveEaseInOut;
                [animation setType:kCATransitionPush];
                [animation setSubtype: kCATransitionFromRight];
                [self.view.layer addAnimation:animation forKey:@"Reveal"];
				[self.view addSubview:m_recommendApplicationView];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"MainWindowShowLoading" object:[NSNumber numberWithBool:YES]];
                [self showLoading:YES];
                
				[self otsDetatchMemorySafeNewThreadSelector:@selector(netThreadGetRecommendApplication) toTarget:self withObject:nil];
			}
            break;
        }
		case 3:{
			if ([indexPath row]!=0) {
				QualityAppVO *appVO=[OTSUtility safeObjectAtIndex:[indexPath row]-1 inArray:m_recommendAppList];
				NSURL *iTunesUrl=[NSURL URLWithString:appVO.appLinkUrl];
				[[UIApplication	sharedApplication] openURL:iTunesUrl];
			}
			break;
		}
        default:
            break;
    }*/
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    switch (indexPath.row)
    {
        case 0:
        {
            [[cell textLabel] setText:@"收货省市切换"];
            //省份
            NSString *listPath=[[NSBundle mainBundle] pathForResource:@"ProvinceID" ofType:@"plist"];
            NSDictionary *provinceDic=[[NSDictionary alloc] initWithContentsOfFile:listPath];
            NSString *provinceStr=[OTSUtility safeObjectAtIndex:0 inArray:[provinceDic allKeysForObject:[[GlobalValue getGlobalValueInstance].provinceId stringValue]]];
            [provinceDic release];
            [[cell detailTextLabel] setText:provinceStr];
            [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:15.0]];
            if (m_ProvinceLabel!=nil) {
                [m_ProvinceLabel release];
            }
            m_ProvinceLabel=[[cell detailTextLabel] retain];
        }
            break;
            
        case 1:
        {
            [[cell textLabel] setText:@"意见反馈"];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
        }
            break;
        
        case 2:
        {
            [[cell textLabel] setText:@"联系客服"];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(80, 0, 160, 44)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:@"（400-007-0958）"];
            [label setFont:[UIFont systemFontOfSize:14.0]];
            [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
            [cell addSubview:label];
            [label release];
        }
            break;
        case 3:
        {
            [[cell textLabel] setText:@"版本更新"];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
        }
            break;
        case 4:
        {
            [[cell textLabel] setText:@"关于"];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
        }
            break;
            
        default:
            break;
    }
    
/*
    
    switch ([indexPath section])
    {
        case 0:
        {
            if ([indexPath row]==0)
            {
                [[cell textLabel] setText:@"收货省市切换"];
                //省份
                NSString *listPath=[[NSBundle mainBundle] pathForResource:@"ProvinceID" ofType:@"plist"];
                NSDictionary *provinceDic=[[NSDictionary alloc] initWithContentsOfFile:listPath];
                NSString *provinceStr=[OTSUtility safeObjectAtIndex:0 inArray:[provinceDic allKeysForObject:[[GlobalValue getGlobalValueInstance].provinceId stringValue]]];
                [provinceDic release];
                [[cell detailTextLabel] setText:provinceStr];
                [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:15.0]];
                if (m_ProvinceLabel!=nil) {
                    [m_ProvinceLabel release];
                }
                m_ProvinceLabel=[[cell detailTextLabel] retain];
            }
            else if([indexPath row] ==1)
            {
                [[cell textLabel] setText:@"最近浏览"];
            }else if (indexPath.row==2){
                cell.textLabel.text=@"接收通知";
                NSString* b=[[NSUserDefaults standardUserDefaults] valueForKey:@"pushSwith"];
                if ([b intValue]) {
                    swit.on=YES;
                }else{
                    swit.on=NO;
                }
                [swit addTarget:self action:@selector(pushSwith:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView=swit;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==3){
                cell.textLabel.text=@"接受通知时段";
                pushTime=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
                pushTime.text=[NSString stringWithFormat:@"%@-%@",startTime,endTime];
                pushTime.font=[UIFont systemFontOfSize:15];
                pushTime.backgroundColor=[UIColor clearColor];
                cell.accessoryView=pushTime;
                if (swit.on) {
                    pushTime.textColor=[UIColor blackColor];
                }else{
                    pushTime.textColor=[UIColor lightGrayColor];
                }
                [pushTime release];
                
            }
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            break;
        }
        case 1: {
            if ([indexPath row]==0) {
                [[cell textLabel] setText:@"使用帮助"];
                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            } else if ([indexPath row]==1) {
                [[cell textLabel] setText:@"意见反馈"];
                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            } else if ([indexPath row]==2) {
                [[cell textLabel] setText:@"联系客服"];
                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(80, 0, 160, 44)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setText:@"（400-007-0958）"];
                [label setFont:[UIFont systemFontOfSize:14.0]];
                [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
                [cell addSubview:label];
                [label release];
            } else if ([indexPath row]==3) {
                [[cell textLabel] setText:@"服务协议"];
                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            }
            break;
        }
        case 2: {
            if (indexPath.row==0) {
                cell.textLabel.text=@"设置";
                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(60, 0, 160, 44)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setText:@"(节省流量，清空缓存)"];
                [label setFont:[UIFont systemFontOfSize:14.0]];
                [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
                [cell addSubview:label];
                [label release];

            }
            else if ([indexPath row]==1) {
                [[cell textLabel] setText:@"版本更新"];
                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            } else if ([indexPath row]==2) {
                [[cell textLabel] setText:@"关于"];
                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            }else if ([indexPath row] == 3) {
				[[cell textLabel] setText:@"精品应用"];
                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
			}
            break;
        }
		case 3:{//精品应用
			cell.selectionStyle=UITableViewCellSelectionStyleBlue;
			cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
			if ([indexPath row] == 0) {
				[[cell textLabel] setText:@"1号推荐"];
                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
				cell.selectionStyle=UITableViewCellSelectionStyleNone;
				cell.accessoryType=UITableViewCellAccessoryNone;
			}else {
                QualityAppVO *appVO = [OTSUtility safeObjectAtIndex:[indexPath row] - 1 
                                                            inArray:m_recommendAppList];
                
				//应用图片
				UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(18, 5, 45, 45)];
				[iconImage setBackgroundColor:[UIColor redColor]];
				[iconImage setTag:1000];
				NSString *fileName=[NSString stringWithFormat:@"qualityApp_%@",[appVO appName]];
				NSData *data=[DataController applicationDataFromFile:fileName];
				UIImage *image=[UIImage imageWithData:data];
				if (image != nil) {
					[iconImage setImage:image];
				}else {
					[iconImage setImage:[UIImage imageNamed:@"defaultimg85.png"]];
				}

				[cell addSubview:iconImage];
				[iconImage release];
				//应用名称
				UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(68, 5, 200, 22)];
				[nameLabel setFont:[UIFont boldSystemFontOfSize:18]];
				[nameLabel setTextColor:[UIColor blackColor]];
				[nameLabel setText:[appVO appName]];
				[cell addSubview:nameLabel];
				[nameLabel release];
				//应用描述
				UILabel *explainLabel = [[UILabel alloc]initWithFrame:CGRectMake(68, 30, 200, 14)];
				[explainLabel setFont:[UIFont boldSystemFontOfSize:12]];
				[explainLabel setTextColor:[UIColor lightGrayColor]];
				[explainLabel setText:[appVO appExplain]];
				[explainLabel setNumberOfLines:2];
				[explainLabel setLineBreakMode:UILineBreakModeTailTruncation];
				[cell addSubview:explainLabel];
				[explainLabel release];
			}
			return cell;
		}
        default:
            break;
    }*/
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	if (tableView.tag == 4) {
//		if ([indexPath row] == 0) {
//			return 30;
//		}else {
//			return 55;
//		}
//	}
//    return 44.0;
//}

//设置行按钮样式
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
}



#pragma mark -
-(void)releaseMyResoures
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // release outlet
    OTS_SAFE_RELEASE(m_ScrollView);
    OTS_SAFE_RELEASE(m_ServiceAgreeView);
    OTS_SAFE_RELEASE(m_FeedBackView);
    OTS_SAFE_RELEASE(m_AboutView);
    OTS_SAFE_RELEASE(m_VersionLabel);
    OTS_SAFE_RELEASE(m_FeedBackTextView);
    OTS_SAFE_RELEASE(m_ProvinceLabel);
	OTS_SAFE_RELEASE(m_recommendAppList);
    
	// remove vc
}

- (void)viewDidUnload
{
    [contactTf release];
    contactTf = nil;
    [super viewDidUnload];
    [self releaseMyResoures];
}

-(void)dealloc
{
    [self releaseMyResoures];
    OTS_SAFE_RELEASE(swit);
    OTS_SAFE_RELEASE(sTimeArray);
    OTS_SAFE_RELEASE(eTimeArray)
    [contactTf release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	[m_FeedBackTextView resignFirstResponder];
     [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (IBAction) textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}


@end