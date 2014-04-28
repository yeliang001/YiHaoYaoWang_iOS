//
//  More.h
//  TheStoreApp
//
//  Created by jiming huang on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UseHelp.h"
#import "UserManage.h"
#import "IconCacheViewController.h"
@interface More : OTSBaseViewController<UITextFieldDelegate,UITextViewDelegate, UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    IBOutlet UIScrollView *m_ScrollView;//
    IBOutlet UIView *m_ServiceAgreeView;//
    IBOutlet UIView *m_FeedBackView;//
    IBOutlet UIView *m_AboutView;//
    IBOutlet UILabel *m_VersionLabel;//
    IBOutlet UITextView *m_FeedBackTextView;//
	IBOutlet UIView *m_recommendApplicationView;
	IBOutlet UITableView *recommendTableView;
    IBOutlet UITextField *contactTf;
    IconCacheViewController*cacheView;
    UILabel *m_ProvinceLabel;
    UIWebView *m_WebView;
	NSMutableArray *m_recommendAppList; //精品应用数组
	int m_PageIndex;
	int appTotalCount;
	int appListCount;
    UIActionSheet* timeSheet;
    NSArray*sTimeArray,*eTimeArray;
    UILabel*pushTime;
    UISwitch*swit;
}

-(IBAction)closeRecommendApplicationView:(id)sender;
-(void)initMore;
-(void)showMainView;
- (IBAction) textFieldDoneEditing:(id)sender;
@end
