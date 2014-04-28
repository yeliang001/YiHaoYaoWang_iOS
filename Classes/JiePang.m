//
//  JiePang.m
//  街旁
//  TheStoreApp
//
//  Created by yangxd on 11-08-01	创建
//  Updated by yangxd on 11-08-04   修正从同步界面返回签到地点列表的动画
//  Copyright 2011 vsc. All rights reserved.
//

#import "JiePang.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "ProductVO.h"
#import "Page.h"
#import "OrderVO.h"
#import "OrderItemVO.h"
#import "OrderService.h"
#import "GlobalValue.h"
#import "NSData+Base64.h"
#import "ShareToMicroBlog.h"
#import "Trader.h"
#import "LocationEntity.h"
#import "LocationVO.h"
#import "SyncVO.h"
#import "SyncEntity.h"
#import "StatusVO.h"
#import "BadgesEntity.h"
#import "TheStoreAppAppDelegate.h"
#import "HomePage.h"
#import "MyOrder.h"
#import "MicroBlogService.h"
#import "OTSAlertView.h"

// 界面绘制
#define JIEPANG_CELL_SINGLE_HEIGHT 64					// 签到地点TableViewCell单行高度
#define JIEPANG_CELL_DOUBLE_HEIGHT 70					// 签到地点TableViewCell双行高度
#define LOCATION_TABLEVIEW_HEIGHT 416					// 签到地点TableView高度
#define TABLEVIEW_TAG_LOCATIONLIST 0					// 签到地点TableView标记
#define LOADMORE_CELL_MARGINLEFT 0						// 加载更多Cell的marginLeft
#define LOADMORE_CELL_MARGINTOP 0						// 加载更多Cell的marginTop
#define LOADMORE_CELL_WIDTH 320							// 加载更多Cell的宽度
#define LOADMORE_CELL_HEIGHT 40							// 加载更多Cell的高度
#define INDICATORY_BGALERT_MARGINLEFT 0					// 加载背景marginLeft
#define INDICATORY_BGALERT_MARGINTOP 0					// 加载背景marginTop
#define INDICATORY_BGALERT_WIDTH 320					// 加载背景宽度
#define INDICATORY_BGALERT_HEIGHT 413					// 加载背景高度
#define INDICATORY_MARGINLEFT 0							// 转圈控件marginLeft
#define INDICATORY_MARGINTOP 0							// 转圈控件matginTop
#define INDICATORY_WIDTH 320							// 转圈控件宽度
#define INDICATORY_HEIGHT 413							// 转圈控件高度
#define SYNC_ITEM_HEIGHT 30								// 同步项高度
#define SYNC_SCROLLVIEW_INIT_CONTENT_HEIGHT 400			// 同步滚动视图高度
// 线程标记
#define THREAD_STATUS_LOADMORE 200						// 加载更多标记
#define THREAD_STATUS_LOADSYN 201						// 获取同步项标记
#define THREAD_STATUS_CHECKINSYN 202					// 签到标记
#define THREAD_STATUS_GET_LOCATIONS 203					// 获取签到地点标记
// 公用参数
#define JIEPANG_PAGE_SIZE 10							// 签到地点列表每页显示条数
#define SYNC_TEXT_VIEW_TAG -1012						// 同步项标记
#define MICRO_BLOG_CHECK_BUTTON_BASE_TAG 1900			// 同步勾选按钮标记
// 提示框标记
#define ALERTVIEW_TAG_OTHERS 900						// 其他情况
#define ALERTVIEW_TAG_CHECK_IN_SUCCESS 921				// 签到成功标记
// 界面返回类型
#define TO_JIEPANG_FROM_PRODUCTDETAIL 0					// 从商品详情界面
#define TO_JIEPANG_FROM_SHAREORDER 1					// 从晒单界面
// 分享标记
#define SHARE_TO_WEIBO 1								// 分享到新浪微博
#define SHARE_TO_JIEPANG 3								// 分享到街旁

// 转换16进制颜色方法
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation JiePang

@synthesize selectedProduct;
@synthesize isExclusive;

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initLocationView];
}
#pragma mark 初始化签到地点界面
-(void)initLocationView {
	// 加载Label为空时创建
	if(loadLabel == nil){
		loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(LOADMORE_CELL_MARGINLEFT, LOADMORE_CELL_MARGINTOP, 
															  LOADMORE_CELL_WIDTH, LOADMORE_CELL_HEIGHT)];	// 位置
	}
	// 标题图片
	UIImageView * titleBGImg=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,44)];	// 位置
	titleBGImg.image=[UIImage imageNamed:@"title_bg.png"];	// 图片
	titleBGImg.userInteractionEnabled=YES;	// 是否可以点击
	// 标题文字：“签到地点”
	UILabel * titleTextLable=[[UILabel alloc]initWithFrame:CGRectMake(121,0,126,44)];	// 位置		
	titleTextLable.text=@"签到地点";		// 标题栏文字
	[titleTextLable setBackgroundColor:[UIColor clearColor]];	// 背景颜色
	titleTextLable.textColor=[UIColor whiteColor];	// 字体颜色
	titleTextLable.font=[UIFont boldSystemFontOfSize:20.0];	// 字体大小
	titleTextLable.shadowColor = [UIColor darkGrayColor];
	titleTextLable.shadowOffset = CGSizeMake(1.0, -1.0);
	[titleBGImg addSubview:titleTextLable];		// 标题文字添加到标题图片上
	[titleTextLable release];	// 标题文字销毁
	// 返回按钮
	UIButton * returnBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,61,44)];	// 位置
	[returnBtn setBackgroundImage:[UIImage imageNamed:@"title_cancel.png"] forState:0];		// 背景图片
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"title_cancel_sel.png"] forState:UIControlStateHighlighted];		// 背景图片
//	[returnBtn setTitle:@"取消" forState:0];	// 按钮文字
//	[returnBtn setTitleColor:[UIColor whiteColor] forState:0];	// 文字颜色
//	returnBtn.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];	// 文字大小
//	returnBtn.titleLabel.shadowColor = [UIColor darkGrayColor];
//	returnBtn.titleLabel.shadowOffset = CGSizeMake(1.0, -1.0);
	[returnBtn addTarget:self action:@selector(toPreviousPage)  forControlEvents:UIControlEventTouchUpInside];	//设置点击按钮调用的方法
	[titleBGImg addSubview:returnBtn];	// 按钮添加到标题图片上
	[returnBtn release];	// 按钮销毁
	[self.view addSubview:titleBGImg];	// 标题图片添加到当前视图
	[titleBGImg release];	// 标题图片销毁
		
	// 当前签到地点不为空时
	if (currentLocation != nil && ![currentLocation isKindOfClass:[NSNull class]] && [currentLocation.list count] > 0) {
		// 绘制界面
		[self showLocationTableView];
	} 
	// 当前签到地点为空时
	else {
		// 绘制数据加载Label
        if (loadingMsgLabel != nil) {
            [loadingMsgLabel removeFromSuperview];
            [loadingMsgLabel release];
        }
		loadingMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 55, 310, 40)];	// 位置
		loadingMsgLabel.text = @"数据加载中,请稍候...";	// 提示文字
		[loadingMsgLabel setBackgroundColor:[UIColor clearColor]];	// 背景颜色
		[loadingMsgLabel setTextAlignment:NSTextAlignmentCenter];	// 文字居中
		loadingMsgLabel.textColor = UIColorFromRGB(0x333333);		// 文字颜色
		loadingMsgLabel.font=[UIFont boldSystemFontOfSize:16.0];	// 文字大小
		[self.view addSubview:loadingMsgLabel];						// 提示信息添加到当前视图
		// 开线程，获取签到地点信息
		currentState = THREAD_STATUS_GET_LOCATIONS;
		currentPage = 1;
		[self setUpThread];
	}
}
#pragma mark 显示签到地点列表
-(void)showLocationTableView {
	// 当前签到地点不为空时
	if (currentLocation != nil && ![currentLocation isKindOfClass:[NSNull class]] && [currentLocation.list count] > 0) {	//currentLocation.list!=nil) {
		// 签到地点集合为空时，创建签到地点集合
		if(locationList==nil){
			locationList=[[NSMutableArray alloc] initWithCapacity:0];
		}
		// 遍历签到地点，添加到签到地点集合中
		for(LocationEntity * lEVO in currentLocation.list){
			[locationList addObject:lEVO];
		}
		// 签到地点TableView不为空时销毁
		if(locationTable!=nil){
			[locationTable release];
		}
		// 创建签到地点TableView
		locationTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, LOCATION_TABLEVIEW_HEIGHT)];	// 位置
		[locationTable setTag:TABLEVIEW_TAG_LOCATIONLIST   ];	// 标记
		[locationTable setDelegate:self];		// 设置数据源
		[locationTable setDataSource:self];		// 设置数据源
		[locationTable setBackgroundColor:[UIColor whiteColor]];	// 背景颜色
		[locationTable setShowsVerticalScrollIndicator:NO];
		[self.view addSubview:locationTable];		// 添加签到地点TableView到当前视图
	} 
	// 当前签到地点为空时
	else {
		// 创建用户提示信息Label
        if (loadingMsgLabel != nil) {
            [loadingMsgLabel removeFromSuperview];
            [loadingMsgLabel release];
        }
		loadingMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 55, 310, 40)];	// 位置
		loadingMsgLabel.text = @"很抱歉,暂无可签到的信息,请稍后再试!";	// 提示信息
		[loadingMsgLabel setBackgroundColor:[UIColor clearColor]];	// 背景颜色
		loadingMsgLabel.textColor = UIColorFromRGB(0x333333);		// 字体颜色
		loadingMsgLabel.font=[UIFont boldSystemFontOfSize:16.0];	// 字体大小
		[self.view addSubview:loadingMsgLabel];						// 提示信息添加到当前视图
	}
}
#pragma mark 显示街旁的签到&晒单
-(void)showJiePangSyncView:(NSString *)guid{
	CATransition * animation = [CATransition animation];		//设置跳转动画
    animation.duration = 0.3f;									//设置动画持续时间
    animation.timingFunction = UIViewAnimationCurveEaseInOut;	//设置动画抽出方式
	[animation setType:kCATransitionPush];
	[animation setSubtype: kCATransitionFromRight];				//设置动画抽出方向
	[self.view.layer addAnimation:animation forKey:@"Reveal"];
	[self initSyncView:guid];
}
#pragma mark 初始化签到&晒单界面
-(void)initSyncView:(NSString *)guid {
	// 获取同步项
	currentState = THREAD_STATUS_LOADSYN;
	[self setUpThread];
	m_guid = [NSString stringWithString:guid];
	[syncView setBackgroundColor:UIColorFromRGB(0xf8eeda)];
	// 标题栏
	UIImageView * titleBGImg=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,44)];	// 位置
	titleBGImg.image=[UIImage imageNamed:@"title_bg.png"];	// 标题背景图片
	titleBGImg.userInteractionEnabled=YES;	// 设置标题栏是否可选择
	// 标题文字：“签到&晒单”
	UILabel * titleTextLable=[[UILabel alloc]initWithFrame:CGRectMake(121,0,126,44)];	// 位置
	titleTextLable.text=@"签到&晒单";	// 标题文字
	[titleTextLable setBackgroundColor:[UIColor clearColor]];	// 标题文字背景颜色
	titleTextLable.textColor=[UIColor whiteColor];	// 文字颜色
	titleTextLable.font=[UIFont boldSystemFontOfSize:20.0];	// 文字大小
	titleTextLable.shadowColor = [UIColor darkGrayColor];
	titleTextLable.shadowOffset = CGSizeMake(1.0, -1.0);
	[titleBGImg addSubview:titleTextLable];	//	标题文字添加到标题背景图片上
	[titleTextLable release];	// 销毁标题文字
	// 返回按钮
	UIButton * returnBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,61,44)];	// 位置
	[returnBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn.png"] forState:0];		// 按钮图片
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn_sel.png"] forState:UIControlStateHighlighted];		// 按钮图片
	//[returnBtn setTitle:@" 返回" forState:0];	// 按钮文字
	[returnBtn setTitleColor:[UIColor whiteColor] forState:0];	// 文字颜色
	returnBtn.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];	// 文字大小
	returnBtn.titleLabel.shadowColor = [UIColor darkGrayColor];
	returnBtn.titleLabel.shadowOffset = CGSizeMake(1.0, -1.0);
	[returnBtn addTarget:self action:@selector(backToLocationListView) forControlEvents:UIControlEventTouchUpInside];		//设置点击按钮调用的方法
	[titleBGImg addSubview:returnBtn];	// 返回按钮添加到标题图片上
	[returnBtn release];	// 销毁返回按钮
	[syncView addSubview:titleBGImg];	// 标题图片添加到同步视图
	[titleBGImg release];	// 销毁标题图片
	// 滚动视图
	if(syncScrollView!=nil){	// 不为空时销毁
		[syncScrollView removeFromSuperview];
		[syncScrollView release];
	}
	// 创建同步滚动视图
	syncScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];	// 位置
	[syncScrollView setBackgroundColor:[UIColor clearColor]];	// 设置背景颜色
	[syncScrollView setContentSize:CGSizeMake(0, SYNC_SCROLLVIEW_INIT_CONTENT_HEIGHT)];	// 设置可显示区域
	[syncScrollView setShowsVerticalScrollIndicator:NO];
	// 签到文字输入框背景
	UIImageView * syncFrameView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 299, 145)];	// 位置
	[syncFrameView setImage:[UIImage imageNamed:@"sync_input_border.png"]];		// 输入框背景图片
	[syncFrameView setUserInteractionEnabled:YES];	// 设置可点击
	
	// 签到文字
    NSString * tempContent=nil;
    NSNumber *locationId=[GlobalValue getGlobalValueInstance].provinceId;
    tempContent=[NSString stringWithFormat:@"我在%@发现了%@，只要￥%@元，快来抢购哦！http://m.yihaodian.com/p/%@_%@_1051392535 手机拍,随手买,用1号药网,随时随地购物!", 
                 currentLocationName,	// 签到地点
                 selectedProduct.cnName,		// 商品名称
                 selectedProduct.price,		// 商品价格
                 selectedProduct.productId,	// 商品id
                 locationId];	// 省份id
	// 签到输入框不为空时销毁
	if(syncContentView!=nil){
		[syncContentView removeFromSuperview];
		[syncContentView release];
	}
	// 创建签到输入框
	syncContentView=[[UITextView alloc] initWithFrame:CGRectMake(2, 2, 295, 123)];	// 位置
	[syncContentView setText:tempContent];	// 输入框中显示文字
	[syncContentView setDelegate:self];		// 绑定数据源
	[syncContentView setTag:SYNC_TEXT_VIEW_TAG];	// 设置标记
	[syncContentView setUserInteractionEnabled:YES];	// 是否可点击
	[syncContentView setTextColor:UIColorFromRGB(0x666666)];	// 字体颜色
	[syncContentView setFont:[UIFont systemFontOfSize:14.0f]];	// 字体大小
	[syncFrameView addSubview:syncContentView];			// 输入框添加到输入框背景上
	// 字数提示
	// 字数Label不为空时销毁
	if(contentLenghtLabel!=nil){
		[contentLenghtLabel removeFromSuperview];
		[contentLenghtLabel release];
	}
	// 签到文字长度Label
	contentLenghtLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 125, 200, 16)];	// 位置
	[contentLenghtLabel setBackgroundColor:[UIColor clearColor]];	// 背景颜色
	[contentLenghtLabel setFont:[UIFont systemFontOfSize:14.0f]];	// 文字大小
	[contentLenghtLabel setTextColor:UIColorFromRGB(0x666666)];		// 文字颜色
	[contentLenghtLabel setText:[NSString stringWithFormat:@"共%d个字",[tempContent length]]];	// 设置Label文字
	[syncFrameView addSubview:contentLenghtLabel];		// 字数Label添加到输入框背景上
	[syncScrollView addSubview:syncFrameView];		// 输入框背景添加到同步滚动视图上
	[syncFrameView release];	// 销毁输入框背景
	// 签到按钮
	UIButton * submitSync=[[UIButton alloc] initWithFrame:CGRectMake((320 - 132) / 2, 165, 132, 41)];	// 位置
	[submitSync setBackgroundImage:[UIImage imageNamed:@"orange_btn.png"] forState:0];	// 按钮背景图片
	[submitSync setTitle:@"签到&晒单" forState:0];	// 按钮显示文字
	[submitSync addTarget:self action:@selector(syncToMicroBlog) forControlEvents:UIControlEventTouchUpInside];	// 按钮触发事件
	[syncScrollView addSubview:submitSync];		// 签到按钮添加到同步滚动视图上
	[submitSync release];	// 销毁按钮
	// 分割线
	UILabel * dottedLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 216, 320, 1)];	// 位置
	[dottedLineLabel setBackgroundColor:UIColorFromRGB(0xcccccc)];	// 文字颜色
	[syncScrollView addSubview:dottedLineLabel];	// 分割线添加到同步滚动视图上
	[dottedLineLabel release];	// 销毁分割线

	[syncView addSubview:syncScrollView];	// 同步滚动视图添加到同步视图上
	[self.view addSubview:syncView];		// 将同步视图设置为当前视图
}
#pragma mark 显示同步对象
-(void)showSyncItem {
	// 当同步VO不为空时
	if (currentSyncVO != nil && ![currentSyncVO isKindOfClass:[NSNull class]] && [currentSyncVO.numItems intValue] > 0) {
		// 同步提示Label
		UILabel * label01 = [[UILabel alloc] initWithFrame:CGRectMake(30, 227, 200, 20)];	// 位置
		[label01 setText:@"同时分享到"];	// 提示文字
		[label01 setTextColor:UIColorFromRGB(0x666666)];		// 文字颜色
		[label01 setBackgroundColor:[UIColor clearColor]];		// 文字背景颜色
		[label01 setFont:[UIFont boldSystemFontOfSize:18.0f]];	// 文字大小
		[syncScrollView addSubview:label01];	// 提示Label添加到同步滚动视图上
		[label01 release];	// 销毁提示Label
		
		// 设置同步滚动视图可显示区域
		int syncItemHeight = ([currentSyncVO.numItems intValue] / 2 + 1) * SYNC_ITEM_HEIGHT;
		[syncScrollView setContentSize:CGSizeMake(0, (SYNC_SCROLLVIEW_INIT_CONTENT_HEIGHT + syncItemHeight))];
        
		if (microBlogButtonArray!=nil) {
            [microBlogButtonArray release];
        }
        microBlogButtonArray=[[NSMutableArray alloc] initWithCapacity:0];	// 创建同步按钮集合
		
		for(int i=0; i < [currentSyncVO.list count]; i++){
			UIButton * checkBtn=nil;	// 初始化可同步项勾选按钮
			UILabel * microBlogNameLabel=nil;	// 初始化可同步项Label
			SyncEntity * sEVO=[currentSyncVO.list objectAtIndex:i];	// 获取同步对象
			if(i%2 == 0){	// 第一列
				checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, (257 + SYNC_ITEM_HEIGHT * (i / 2)), 130, 30)];			// 勾选按钮位置
				microBlogNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, (261 + SYNC_ITEM_HEIGHT * (i / 2)), 100, 18)];	// 可同步项位置
			} else {	// 第二列
				checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, (257 + SYNC_ITEM_HEIGHT * (i / 2)), 130, 30)];			// 勾选按钮位置
				microBlogNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, (261 + SYNC_ITEM_HEIGHT * (i/2)), 100, 18)];	// 可同步项位置
			}
			[microBlogNameLabel setText:sEVO.name];		// 可同步项名称
			[microBlogNameLabel setBackgroundColor:[UIColor clearColor]];	// 可同步项背景颜色
			[microBlogNameLabel setTextColor:UIColorFromRGB(0x666666)];		// 可同步项文字颜色
			[microBlogNameLabel setFont:[UIFont systemFontOfSize:16.0f]];	// 可同步项文字大小
			[syncScrollView addSubview:microBlogNameLabel];		// 可同步项添加到同步滚动视图上
			[microBlogNameLabel release];	// 销毁可同步项
			[checkBtn setTag:(MICRO_BLOG_CHECK_BUTTON_BASE_TAG + i)];	// 设置勾选按钮标签
			[checkBtn addTarget:self action:@selector(checkSelectAction:) forControlEvents:UIControlEventTouchUpInside];	// 勾选按钮触发事件
			// 设置checkbox是否可以选择
			if([sEVO.canSet isEqualToString:@"false"]){
				[checkBtn setUserInteractionEnabled:NO];
			}
			// 设置checkbox默认是否已选择
			if([sEVO.isSet isEqualToString:@"true"]) {
				[checkBtn setImage:[UIImage imageNamed:@"sync_selected_icon.png"] forState:0];		// 勾选
			} else if ([sEVO.isSet isEqualToString:@"false"]) {
				[checkBtn setImage:[UIImage imageNamed:@"sync_unselected_icon.png"] forState:0];	// 未勾选
				int currentTag = checkBtn.tag;
				[checkBtn setTag:currentTag * (-1)];
			}
			// 将勾选按钮添加至按钮集合中
			[microBlogButtonArray addObject:checkBtn];
			[checkBtn release];
		}
		// 遍历同步按钮集合，并添加到同步滚动视图上
		for(UIButton * checkSelectBtn in microBlogButtonArray){
			[syncScrollView addSubview:checkSelectBtn];
		}
	}
}
#pragma mark 同步到微博，点击签到按钮后触发
-(void)syncToMicroBlog{
	BOOL haveAppend=NO;
	int i=0;
	int appendCount=0;
	NSString * appendStr;
	// 遍历同步项
	for(UIButton * aBtn in microBlogButtonArray){
		if(aBtn.tag>0){
			haveAppend=YES;
			if(appendCount==0){
				appendStr=[NSString stringWithFormat:@"%@",((SyncEntity *)[currentSyncVO.list objectAtIndex:i]).target];
			}
			else{
				appendStr=[NSString stringWithFormat:@"%@,%@",appendStr,((SyncEntity *)[currentSyncVO.list objectAtIndex:i]).target];
			}
			appendCount++;
		}
		i++;
	}
	// 无同步项
	if(!haveAppend){
		appendStr=@"";
	}
	// 输入框中无文字时提示
	if([syncContentView.text isEqualToString:@""] || [[syncContentView.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]<1){
		[self showAlertView:nil alertMsg:@"内容不能为空!" alertTag:ALERTVIEW_TAG_OTHERS];
		return;
	}
    /*
	// 输入框中文字超过140字时提示
	if([syncContentView.text length]>140){
		[self showAlertView:nil alertMsg:@"您的输入的文字过长,请确认不超过140个字符!" alertTag:ALERTVIEW_TAG_OTHERS];
		return;
	}*/
	// 创建提交签到线程
    if (m_syncs!=nil) {
        [m_syncs release];
    }
	m_syncs=[appendStr retain];
	currentState=THREAD_STATUS_CHECKINSYN;
	[self setUpThread];
}
-(void)showSyncToMicroBlogResult{
	if(resultStatusVO!=nil){
		if(resultStatusVO.list!=nil){
			[self showAlertView:nil 
					   alertMsg:[NSString stringWithFormat:@"晒单成功\r\n%@",((BadgesEntity *)[resultStatusVO.list lastObject]).message] 
					   alertTag:ALERTVIEW_TAG_CHECK_IN_SUCCESS];
		} else {
			[self showAlertView:nil alertMsg:@"晒单成功\r\n" alertTag:ALERTVIEW_TAG_CHECK_IN_SUCCESS];
		}
	} else {
		[self showAlertView:nil alertMsg:@"晒单失败" alertTag:ALERTVIEW_TAG_OTHERS];
	}
}
#pragma mark 微博点选事件
-(IBAction)checkSelectAction:(id)sender{
	UIButton * button=(UIButton *)sender;
	int currentTag=button.tag;
	int indexOfBtn=0;
	if(currentTag>0){
		indexOfBtn=currentTag-MICRO_BLOG_CHECK_BUTTON_BASE_TAG;
		[((UIButton *)[microBlogButtonArray objectAtIndex:indexOfBtn]) setTag:currentTag*(-1)];
		[((UIButton *)[microBlogButtonArray objectAtIndex:indexOfBtn]) setImage:[UIImage imageNamed:@"sync_unselected_icon.png"] 
																	   forState:0];
	}
	else{
		indexOfBtn=-MICRO_BLOG_CHECK_BUTTON_BASE_TAG-currentTag;
		[((UIButton *)[microBlogButtonArray objectAtIndex:indexOfBtn]) setTag:currentTag*(-1)];
		[((UIButton *)[microBlogButtonArray objectAtIndex:indexOfBtn]) setImage:[UIImage imageNamed:@"sync_selected_icon.png"] 
																	   forState:0];
	}
}
#pragma mark 返回签到地点列表页面
-(void)backToLocationListView {
	[syncView removeFromSuperview];
	CATransition * animation = [CATransition animation];								//设置跳转动画
    animation.duration = 0.3f;															//设置动画持续时间
    animation.timingFunction = UIViewAnimationCurveEaseInOut;							//设置动画抽出方式
	[animation setType:kCATransitionPush];
	[animation setSubtype: kCATransitionFromLeft];										//设置动画抽出方向
	[self.view.layer addAnimation:animation forKey:@"Reveal"];
	
}
#pragma mark 返回上一页
-(void)toPreviousPage {
	CATransition *animation=[CATransition animation]; 
	[animation setDuration:0.3f];
	[animation setTimingFunction:UIViewAnimationCurveEaseInOut];
	[animation setType:kCATransitionReveal];
	[animation setSubtype: kCATransitionFromBottom];
	[self.view.superview.layer addAnimation:animation forKey:@"Reveal"];
	[self removeSelf];
	if(locationList!=nil){
		[locationList removeAllObjects];
	}
}
#pragma mark 签到完成后的页面跳转操作
-(void)doFinishCheckin {
	switch ([[GlobalValue getGlobalValueInstance].toJiePangFromPage intValue]) {
		case TO_JIEPANG_FROM_SHAREORDER: {	// 从下订单进入,返回订单列表页面
            if (myOrderView!=nil) {
                [myOrderView release];
            }
			myOrderView = [[MyOrder alloc]initWithNibName:@"MyOrder" bundle:nil];			
			NSNumber * number = [[NSNumber alloc] initWithInt:0];
			[[GlobalValue getGlobalValueInstance] setToOrderFromPage:number];
			[number release];
			
			CATransition *animation = [CATransition animation]; 
			animation.duration = 0.3f;
			animation.timingFunction = UIViewAnimationCurveEaseInOut;
			[animation setType:kCATransitionPush];
			[animation setSubtype: kCATransitionFromRight];
			[self.view.layer addAnimation:animation forKey:@"Reveal"];
			[self.view addSubview:myOrderView.view];
			break;
		}
		case TO_JIEPANG_FROM_PRODUCTDETAIL:{	// 从商品详情进入,返回商品详情页面
			CATransition *animation = [CATransition animation]; 
			animation.duration = 0.3f;
			animation.timingFunction = UIViewAnimationCurveEaseInOut;
			[animation setType:kCATransitionPush];
			[animation setSubtype: kCATransitionFromRight];
			[self.view.superview.layer addAnimation:animation forKey:@"Reveal"];
			[self removeSelf];
			break;
		}
		default:
			break;
	}
}
#pragma mark 获得当前身份字符串
-(NSString *)getCurrentDistrictStr {
	TheStoreAppAppDelegate * delegate = (TheStoreAppAppDelegate*)([UIApplication sharedApplication].delegate);
	NSString *str=[NSString stringWithString:((HomePage*)[delegate.tabBarController.viewControllers objectAtIndex:0]).m_CurrentProvinceStr];
    return str;
}
#pragma mark 显示提示框
-(void)showAlertView:(NSString *) alertTitle alertMsg:(NSString *)alertMsg alertTag:(int)tag {
	[[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
    UIAlertView * alert = [[OTSAlertView alloc]initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    alert.tag = tag;
	[alert show];
	[alert release];
	alert = nil;
}
#pragma mark -
#pragma mark 设置列表行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// 签到地点列表
	if(tableView.tag == TABLEVIEW_TAG_LOCATIONLIST){
		if ([locationList count] > 0) {
			return [locationList count] + 1;
		}
	}
	return 1;
}
#pragma mark 设置列表的行点击事件
-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	switch (tableView.tag) {
		case TABLEVIEW_TAG_LOCATIONLIST:	// 签到地点
			// 加载更多列
			if([indexPath row]==[locationList count]) {	
				if ([currentLocation.hasMore isEqualToString:@"true"]) {
					[loadLabel setText:@"加载中,请稍候..."];
					currentPage++;
					currentState = THREAD_STATUS_LOADMORE;
					[self setUpThread];
				}
			} 
			// 签到地点信息列
			else {
				// 跳转至街旁签到界面
				LocationEntity * lEntity = [locationList objectAtIndex:[indexPath row]];
                if (currentLocationName!=nil) {
                    [currentLocationName release];
                }
				currentLocationName = [[NSString alloc] initWithFormat:@"%@", lEntity.name];
				[self showJiePangSyncView:lEntity.guid];
			}
			break;
		default:
			break;
	}
}
#pragma mark 设置列表行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// 创建列表cell
	//UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShareOrderTableViewCell"];
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShareOrderTableViewCell"] autorelease];
    [cell setBackgroundColor:[UIColor whiteColor]];
    switch (tableView.tag) {
		case TABLEVIEW_TAG_LOCATIONLIST:	// 签到地点列表
			// 加载更多列
			if([indexPath row] == [locationList count]){
				// 加载文字Label
				UIView * loadView = [[UIView alloc] initWithFrame:CGRectMake(LOADMORE_CELL_MARGINLEFT, LOADMORE_CELL_MARGINTOP, 
																			 LOADMORE_CELL_WIDTH, LOADMORE_CELL_HEIGHT)];
				loadView.backgroundColor = [UIColor clearColor];
				// 判断是否有更多
				// 有时，文字显示“加载更多...”
				if([currentLocation.hasMore isEqualToString:@"true"]){
					[loadLabel setText:@"加载更多..."];
				} 
				// 没有时，文字显示"加载完毕"
				else {
					[loadLabel setText:@"加载完毕"];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;	// 设置不能点击
				}
				loadLabel.font = [UIFont systemFontOfSize:17.0];	// 文字大小
                loadLabel.textAlignment = NSTextAlignmentCenter;	// 文字居中显示
                [loadView addSubview:loadLabel];
                [cell setAccessoryType:UITableViewCellAccessoryNone];// 列显示样式为无
                [cell addSubview:loadView];
                [loadView release];
			} 
			// 签到地点信息列
			else {	
				// 获取签到地点对象
				LocationEntity * lEntity = [locationList objectAtIndex:[indexPath row]];
				// 大头针图标
				UIImageView * pinIconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 19, 15, 32)];	// 位置
				[pinIconView setImage:[UIImage imageNamed:@"pin_icon.png"]];	// 图标
				[cell addSubview:pinIconView];	// 大头针图标添加到cell
				[pinIconView release];	// 销毁大头针图标
				// 签到地点名
				UILabel * locationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 260, 18)];	// 位置
				[locationNameLabel setText:lEntity.name];	// 签到地点名称
				[locationNameLabel setTextColor:UIColorFromRGB(0x333333)];	// 文字颜色
				[locationNameLabel setFont:[UIFont boldSystemFontOfSize:16.0]];	// 文字大小
				[cell addSubview:locationNameLabel];	// 签到地点名Label添加到cell
				[locationNameLabel release];	// 销毁签到地点名Label
				// 签到地址
				UILabel * locationAddrLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 33, 260, 32)];	// 位置
				[locationAddrLabel setText:[NSString stringWithFormat:@"地址: %@", lEntity.addr]];	// 签到地点地址
				[locationAddrLabel setTextColor:UIColorFromRGB(0x666666)];	// 字体颜色
				[locationAddrLabel setFont:[UIFont boldSystemFontOfSize:14.0]];	// 字体大小
				[locationAddrLabel setNumberOfLines:2];	// 设置文字分2行显示
				[cell addSubview:locationAddrLabel];	// 签到地址Label添加到cell
				[locationAddrLabel release];	// 销毁签到地址Label
			}
			break;
		default:
			break;
	}
	
	return cell;
}
#pragma mark 设置列表行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (tableView.tag) {
		case TABLEVIEW_TAG_LOCATIONLIST:	// 签到地点列表
			// 加载更多列
			if ([indexPath row] == [locationList count]) {
				return LOADMORE_CELL_HEIGHT;
			}
			// 签到地点列
			return JIEPANG_CELL_DOUBLE_HEIGHT;
			break;
		default:
			break;
	}
	// 其他回返0
    return 0;
}

#pragma mark 输入框文字变更
- (void)textViewDidChange:(UITextView *)textView{
	switch (textView.tag) {
		case SYNC_TEXT_VIEW_TAG:	// 签到输入框
			// 显示签到输入框文字变动
			[contentLenghtLabel setText:[NSString stringWithFormat:@"共%d个字",[textView.text length]]];
			break;
		default:
			break;
	}
}
#pragma mark 设置输入栏关闭
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	// 签到输入框不为空时关闭键盘
	if(syncContentView!=nil){
		[syncContentView resignFirstResponder];
	}
}
#pragma mark 响应alert操作
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	switch (alertView.tag) {
		case ALERTVIEW_TAG_CHECK_IN_SUCCESS:{	// 签到成功
			// 签到成功后跳转至我的订单界面
			if([[GlobalValue getGlobalValueInstance].toJiePangFromPage intValue]==TO_JIEPANG_FROM_SHAREORDER){
				// 创建我的订单viewController
                if (myOrderView!=nil) {
                    [myOrderView release];
                }
				myOrderView = [[MyOrder alloc]initWithNibName:@"MyOrder" bundle:nil];
				// 设置跳转标签
				NSNumber * number = [[NSNumber alloc] initWithInt:0];
				[[GlobalValue getGlobalValueInstance] setToOrderFromPage:number];
				[number release];
				// 开启界面跳转动画
				CATransition *animation = [CATransition animation]; 
				animation.duration = 0.3f;
				animation.timingFunction = UIViewAnimationCurveEaseInOut;
				[animation setType:kCATransitionPush];
				[animation setSubtype: kCATransitionFromRight];
				[self.view.layer addAnimation:animation forKey:@"Reveal"];
				[self.view addSubview:myOrderView.view];
				break;
			}
			// 签到成功后返回至商品详情界面
			else if([[GlobalValue getGlobalValueInstance].toJiePangFromPage intValue]==TO_JIEPANG_FROM_PRODUCTDETAIL){
				[self toPreviousPage];
			}
		}
		default:
			break;
	}
	// 设置alrtview显示标记为NO
	[[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:NO];
}
#pragma mark 建立线程
-(void)setUpThread {
	if (!running) {
		running=YES;
		// 显示转圈
//		[[NSNotificationCenter defaultCenter] postNotificationName:@"MainWindowShowLoading" object:[NSNumber numberWithBool:YES]];
        [self showLoading:YES];
        
		// 打开线程
		[self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
	}
}
#pragma mark 开启线程
-(void) startThread{
	while (running) {
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		MicroBlogService * blogServ = [[MicroBlogService alloc] init];
		switch (currentState) {
			case THREAD_STATUS_GET_LOCATIONS: {		// 获取签到地点列表
				@try {
					// 当currentLocation不为空时销毁
					if(currentLocation != nil){
						[currentLocation release];
					}
					// 获取currentLocation
					currentLocation = [[blogServ locations:[GlobalValue getGlobalValueInstance].jiePangUserName password:[GlobalValue getGlobalValueInstance].jiePangPassword targetId:(long)SHARE_TO_JIEPANG pageNum:(long)currentPage count:(long)JIEPANG_PAGE_SIZE query:nil city:[self getCurrentDistrictStr] lon:[[GlobalValue getGlobalValueInstance].trader.longitude floatValue] lat:[[GlobalValue getGlobalValueInstance].trader.latitude floatValue]] retain];
					// 返回主线程绘制签到地点列表
					[self performSelectorOnMainThread:@selector(showLocationTableView) withObject:nil waitUntilDone:NO];
				}
				@catch (NSException * e) {
				}
				@finally {
					// 关闭线程
					[self stopThread];
				}
				break;
			}
			case THREAD_STATUS_LOADMORE:	// 获取更多签到地点
				// 当currentLocation不为空时销毁
				if(currentLocation != nil){
					LocationVO * tempGarbage = currentLocation;
					[tempGarbage release];
				}
				// 获取currentLocation
				currentLocation = [blogServ locations:[GlobalValue getGlobalValueInstance].jiePangUserName 
											 password:[GlobalValue getGlobalValueInstance].jiePangPassword 
											 targetId:(long)SHARE_TO_JIEPANG
											  pageNum:(long)currentPage
												count:(long)JIEPANG_PAGE_SIZE 
												query:nil 
												 city:[self getCurrentDistrictStr] 
												  lon:[[GlobalValue getGlobalValueInstance].trader.longitude floatValue] 
												  lat:[[GlobalValue getGlobalValueInstance].trader.latitude floatValue]];
				// 遍历当前签到地点对象，并添加到地点集合中
				for(LocationEntity * lEVO in currentLocation.list){
					[locationList addObject:lEVO];
				}
				// 关闭线程
				[self stopThread];
				break;
			case THREAD_STATUS_LOADSYN:	{	// 获取同步项目
				if(currentSyncVO!=nil){
					[currentSyncVO release];
				}
				@try {
					// 获取临时同步对象
					SyncVO * tempSyncVO = [blogServ syncs:[GlobalValue getGlobalValueInstance].jiePangUserName 
												 password:[GlobalValue getGlobalValueInstance].jiePangPassword 
												 targetId:(long)SHARE_TO_JIEPANG];
					// 当临时同步对象不为空时，赋值给currentSyncVO
					if (![tempSyncVO isKindOfClass:[NSNull class]]) {
						currentSyncVO = [tempSyncVO retain];
					}
					// 返回主线程绘制可同步项
					[self performSelectorOnMainThread:@selector(showSyncItem) withObject:nil waitUntilDone:NO];
				}
				@catch (NSException * e) {
				}
				@finally {
					// 关闭线程
					[self stopThread];
				}
				break;
			}
			case THREAD_STATUS_CHECKINSYN:	// 签到
				// 当resultStatusVO不为空时销毁
				if(resultStatusVO!=nil){
					[resultStatusVO release];
				}
				@try {
					// 获取临时状态对象
					StatusVO * tempStatusVO=[[GlobalValue getGlobalValueInstance].mbService checkin:[GlobalValue getGlobalValueInstance].jiePangUserName 
																						   password:[GlobalValue getGlobalValueInstance].jiePangPassword 
																						   blogType:ShareToJiePang comment:syncContentView.text guid:m_guid 
																							  syncs:m_syncs];
					// 当临时状态对象不为空时，赋值给resultStatusVO
					if (![tempStatusVO isKindOfClass:[NSNull class]]) {
						resultStatusVO = [tempStatusVO retain];
					}
					// 返回主线程，显示提示框
					[self performSelectorOnMainThread:@selector(showSyncToMicroBlogResult) withObject:nil waitUntilDone:NO];
				}
				@catch (NSException * e) {
				}
				@finally {
					// 关闭线程
					[self stopThread];
				}
				break;
			default:
				// 关闭线程
				[self stopThread];
				break;
		}
		[blogServ release];	// 销毁service对象
		[pool drain];		// 销毁自动释放池对象
	}
}
#pragma mark 停止线程
-(void)stopThread {
	running = NO;
	currentState = -1;
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"MainWindowHideLoading" object:nil];
    [self hideLoading];
}
#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark -
-(void)releaseMyResoures
{
    OTS_SAFE_RELEASE(locationList);
    OTS_SAFE_RELEASE(microBlogButtonArray);
    OTS_SAFE_RELEASE(selectedProduct);
    OTS_SAFE_RELEASE(m_syncs);
    OTS_SAFE_RELEASE(currentLocationName);
    OTS_SAFE_RELEASE(locationTable);
    OTS_SAFE_RELEASE(syncScrollView);
    OTS_SAFE_RELEASE(syncContentView);
    OTS_SAFE_RELEASE(contentLenghtLabel);
    OTS_SAFE_RELEASE(loadLabel);
    OTS_SAFE_RELEASE(loadingMsgLabel);
    OTS_SAFE_RELEASE(currentLocation);
    OTS_SAFE_RELEASE(currentSyncVO);
    OTS_SAFE_RELEASE(resultStatusVO);
    OTS_SAFE_RELEASE(myOrderView);
    
    // release outlet
    OTS_SAFE_RELEASE(syncView);
    
	// remove vc
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
@end
