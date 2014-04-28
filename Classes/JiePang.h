//
//  JiePang.h
//  街旁
//  TheStoreApp
//
//  Created by yangxd on 11-08-01  创建
//  Copyright 2011 vsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaUtil.h"
@class LocationVO;
@class SyncVO;
@class StatusVO;
@class MyOrder;
@class ProductVO;

@interface JiePang : OTSBaseViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UITextViewDelegate> {
	
	NSMutableArray * locationList;			// 签到地点列表
	NSMutableArray * microBlogButtonArray;	// 同步按钮集合
	ProductVO * selectedProduct;			// 传入参数，要被分享的商品
    BOOL isExclusive;                       // 传入参数，是否是掌上专享
	NSString * m_guid;						// 街旁网点Id
	NSString * m_syncs;						// 同步网站
	NSString * currentLocationName;			// 当前签到地点名
	
	IBOutlet UIView * syncView;//				// 签到&晒单视图
	UITableView * locationTable;			// 地点视图
	UIScrollView * syncScrollView;			// 同步滚动视图
	UITextView * syncContentView;			// 签到输入框
	UILabel * contentLenghtLabel;			// 签到文字长度Label
	UILabel * loadLabel;					// 加载时Label
	UILabel * loadingMsgLabel;				// 加载文字Label
	
	BOOL hasMoreLocation;				// 判断是否有更多签到地点
	BOOL running;						// 控制线程
	BOOL isSelected;					// 晒单项目是否选择
    BOOL isStop;						// 判断线程是否停止
	int currentPage;					// 当前页数
	int currentState;					// 当前线程状态
	int fromPageType;					// 从哪里界面进入街旁签到
	
	LocationVO * currentLocation;		// 当前LocationVO
	SyncVO * currentSyncVO;				// 当前SyncVO
	StatusVO * resultStatusVO;			// 返回的状态VO
	MyOrder * myOrderView;				// 我的订单ViewConroller对象
}
@property(nonatomic,retain)ProductVO * selectedProduct;
@property(nonatomic)BOOL isExclusive;
@end

@interface JiePang(private)

#pragma mark 初始化签到地点界面
-(void)initLocationView;
#pragma mark 显示签到地点列表
-(void)showLocationTableView;
#pragma mark 初始化签到&晒单界面
-(void)initSyncView:(NSString *)guid;
#pragma mark 登录到街旁并获取签到地点
-(void)loginJiePangAndGetLocations;
#pragma mark 获得当前省份字符串
-(NSString *)getCurrentDistrictStr;

#pragma mark 建立线程
-(void)setUpThread;
#pragma mark 开启线程
-(void) startThread;
#pragma mark 停止线程
-(void)stopThread;

#pragma mark 签到完成后的页面跳转操作
-(void)doFinishCheckin;
#pragma mark 返回上一页
-(void)toPreviousPage;
#pragma mark 返回签到地点列表页面
-(void)backToLocationListView;

#pragma mark 显示签到&晒单底部视图
-(void)showSyncBottomView;
#pragma mark 显示街旁的签到地点
-(void)showJiePangLocations:(NSNotification *)notification;
#pragma mark 显示街旁的签到&晒单
-(void)showJiePangSyncView:(NSString *)guid;
#pragma mark 返回到晒单界面
-(void)returnToShareOrderView;
#pragma mark 返回到街旁的签到地点界面
-(void)returnToJiePangLocations;
#pragma mark 获得当前身份字符串
-(NSString *)getCurrentDistrictStr;
#pragma mark 同步到微博，点击签到按钮后触发
-(void)syncToMicroBlog;
#pragma mark 同步到微博成功以后显示结果
-(void)showSyncToMicroBlogResult;
#pragma mark 微博点选事件
-(IBAction)checkSelectAction:(id)sender;
#pragma mark 显示同步对象
-(void)showSyncItem;
#pragma mark 显示提示框
-(void)showAlertView:(NSString *) alertTitle alertMsg:(NSString *)alertMsg alertTag:(int)tag;
@end