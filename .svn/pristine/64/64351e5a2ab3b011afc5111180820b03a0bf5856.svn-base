//
//  TopView.h
//  yhd
//
//  Created by  on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#define FROM_GROUPON_HOMEPAGE   1
#define FROM_GROUPON_DETAIL 2

#define TOP_HEIGHT     55

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"
#import "LoginViewController.h"
#import "OTSPopViewController.h"
@interface TopView : UIView<LoginDelegate,OTSPopViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>{
    //UIViewController *rootViewController;
    UIImageView *textBg;
    UIImageView *logo;
    UIImageView *address;
    UILabel *addressLabel;
    UITextField *textField;
    
    UIImageView *tabBarImageView;
    UITabBarItem *tabBarItem;
    WEPopoverController *popoverController;
    LoginViewController *mloginViewController;
    
    int m_Flag;
    id m_Delegate;
    
    BOOL getKeyWordRuning;                      // 是否正在获取关键字
    NSMutableArray* searchRelationArray;        // 关联子VO的数组                 
    
}
//@property(nonatomic,assign)UIViewController *rootViewController;
@property(nonatomic,assign)UILabel *addressLabel;
@property(nonatomic, retain) WEPopoverController *popoverController;
@property(nonatomic,assign)id delegate;
//@property (nonatomic, copy) NSString *keyWord;
-(void)setCartCount:(NSInteger)count;
//- (void)setKeyWord:(NSString *)keyWord;
-(id)initWithDefault;
- (id)initWithDefaultFrameWithFlag:(int)flag;
- (id)initWithDefaultFrameWithFlag:(int)flag delegate:(id)delegate;
-(void)setSearchHidden:(BOOL)hidden;

- (void)handleCartChange:(NSNotification *)note;
@end
