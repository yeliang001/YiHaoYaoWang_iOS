//
//  TopView.m
//  yhd
//
//  Created by  on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TopView.h"
#import "DataHandler.h"
#import <QuartzCore/QuartzCore.h>
#import "ProvinceVO.h"
#import "ProvinceViewController.h"
#import "CartVO.h"
#import "MyListViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "OTSGpsHelper.h"
#import "OTSPopViewController.h"
#import "OTSGrouponDetail.h"
#import "UIDeviceHardware.h"
#import "SearchKeywordVO.h"
#import "NSObject+OTS.h"
#import "SearchService.h"
#import "FacetValue.h"
#import "OtspOrderConfirmVC.h"

#define SEARCH_TEXT_COLOR [UIColor colorWithRed:76.0/255 green:76.0/255 blue:76.0/255 alpha:1.0]
static NSMutableArray* searchHistoryArr = nil;
static NSArray* searchHotKeyArr = nil;


@interface TopView ()
@property(nonatomic, retain)UIButton *backBut;
@property(nonatomic, retain)UIView *searchView;
@property(nonatomic, retain)NSString* m_KeyWord;
@property(nonatomic, retain)UITableView* searchKeyTable;        // 搜索关键字
@property(nonatomic, retain)UITableView* searchHistoryTable;    // 搜索历史
@property(nonatomic, retain)UITableView* searchHotTable;        // 热门搜索
@property(nonatomic, retain)UIView* searchLeftView;             // 加载以上三个table的容器view
@property(nonatomic, retain)UIImageView* gradientLayer;         // 渐变色
@property(nonatomic, retain)UIImageView* gradientLayer1;
@property(nonatomic, retain)UIImageView* clearSureBtnView;             // 确认删除按钮

@end

//

@implementation TopView
@synthesize addressLabel,popoverController;
@synthesize backBut,delegate=m_Delegate,searchView;
@synthesize m_KeyWord;
@synthesize searchHistoryTable,searchKeyTable,searchHotTable,gradientLayer,gradientLayer1,clearSureBtnView,searchLeftView;

//-(void)setRootViewController:(UIViewController *)aRootViewController
//{
//    rootViewController = aRootViewController;
//}

-(id)initWithDefault
{
    if ([[DataHandler sharedDataHandler] screenWidth]==768) {//竖屏
        [self initWithFrame:CGRectMake(0, 0, 768, TOP_HEIGHT)];
    } else {//横屏
        [self initWithFrame:CGRectMake(0, 0, 1024, TOP_HEIGHT)];
    }
    
    return self;
}

- (id)initWithDefaultFrameWithFlag:(int)flag
{
    m_Flag=flag;
    return [self initWithDefault];
}

- (id)initWithDefaultFrameWithFlag:(int)flag delegate:(id)delegate
{
    m_Delegate=delegate;
    return [self initWithDefaultFrameWithFlag:flag];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleProVinceChange:)name:kNotifyProvinceChange object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDissmissPopOver:)name:kNotifyDismissPopOverProvince object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCartChange:)name:kNotifyCartChange object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleProvincePop:)name:kNotifyProvincePop object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleSearchTextViewChanged:) name:kNotifySearchTextViewChange object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleTopViewShowUser:) name:kNotifyTopViewShowUser object:nil];
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"top_bg.png"]];
        self.backBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBut setImage:[UIImage imageNamed:@"top_back1.png"] forState:UIControlStateNormal];
        [backBut setImage:[UIImage imageNamed:@"top_back2.png"] forState:UIControlStateHighlighted];
        [backBut addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [backBut setFrame:CGRectMake(16, 6, 50,43)];
        [self addSubview:backBut];
        
        UIButton *mainBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [mainBut setImage:[UIImage imageNamed:@"top_main1.png"] forState:UIControlStateNormal];
        [mainBut setImage:[UIImage imageNamed:@"top_main2.png"] forState:UIControlStateHighlighted];
        [mainBut addTarget:self action:@selector(main:) forControlEvents:UIControlEventTouchUpInside];
        [mainBut setFrame:CGRectMake(80,6, 50,43)];
        [self addSubview:mainBut];
        
        UIButton *userBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [userBut setImage:[UIImage imageNamed:@"top_user1.png"] forState:UIControlStateNormal];
        [userBut setImage:[UIImage imageNamed:@"top_user2.png"] forState:UIControlStateHighlighted];
        [userBut addTarget:self action:@selector(user:) forControlEvents:UIControlEventTouchUpInside];
        [userBut setFrame:CGRectMake(144, 6, 50,43)];
        [self addSubview:userBut];
        
        
        
        logo=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_logo.png"]];
        [logo setFrame:CGRectMake(frame.size.width/2-24, 3, 49, 47)];
        [self addSubview:logo];
        [logo release];
        
        address=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_address.png"]];
        address.userInteractionEnabled=YES;
        [address setFrame:CGRectMake(frame.size.width/2+45,0, 150, 55)];
        [self addSubview:address];
        [address release];
        
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2+75, 30, 70.0, 20) ];
        addressLabel.userInteractionEnabled=YES;
        addressLabel.textColor = [UIColor whiteColor];  
        addressLabel.backgroundColor=[UIColor clearColor];
        //addressLabel.textAlignment=NSTextAlignmentCenter;
        addressLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];
        addressLabel.text=[OTSGpsHelper sharedInstance].provinceVO.provinceName;
        [self addSubview:addressLabel];
        [addressLabel release];
        UITapGestureRecognizer *tapGes2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openProVince:)];
        [addressLabel addGestureRecognizer:tapGes2];
        [tapGes2 release];
        
        //搜索
        [self initSearchHistory];
        textBg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_textbg.png"]];
        textBg.userInteractionEnabled=YES;
        [textBg setFrame:CGRectMake(frame.size.width-236, 10, 210, 33)];
        
        [self addSubview:textBg];
        [textBg release];
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(33, 5, 170, 23)];
        //textField.delegate = self;
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        textField.borderStyle=UITextBorderStyleNone;
        textField.placeholder = @"请输入关键词搜索";
        textField.returnKeyType=UIReturnKeySearch;
        textField.enablesReturnKeyAutomatically=YES;
        textField.delegate = self;
        if ([DataHandler sharedDataHandler].keyWord) {
            textField.text=[DataHandler sharedDataHandler].keyWord;
        }
        
        //textField.textAlignment = NSTextAlignmentCenter;
        [textField addTarget:self action:@selector(search:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [textField addTarget:self action:@selector(searchBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [textField addTarget:self action:@selector(searchChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [textBg addSubview: textField];
        [textField release];
        
        UIButton *searchBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [searchBut setImage:[UIImage imageNamed:@"top_search.png"] forState:UIControlStateNormal];
        [searchBut setImage:[UIImage imageNamed:@"top_search.png"] forState:UIControlStateHighlighted];
        [searchBut setFrame:CGRectMake(10, 8, 18,18)];
        [textBg addSubview:searchBut];
        
        if (m_Flag==FROM_GROUPON_HOMEPAGE) {
            [textBg setHidden:YES];
        } else if (m_Flag==FROM_GROUPON_DETAIL) {
            [textBg setHidden:YES];
        } else {
        }
        UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(198, 6, 48, 45)];
        tabBar.backgroundColor = [UIColor clearColor];
        tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:nil tag:0];
        
        NSArray *frameTabBarItemArray = [NSArray arrayWithObjects:tabBarItem,nil];
        [tabBar setItems:frameTabBarItemArray];
        
        UIView *v=[tabBar.subviews objectAtIndex:0];
        if (v.frame.size.width==48) {
            v.alpha=0.0;
        }
        
        tabBar.userInteractionEnabled=YES;
        UIView *tabBarBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0,48, 44)];
        UIImage *img = [UIImage imageNamed:@"6"];
        
        if ([tabBar respondsToSelector:@selector(setBackgroundImage:)]) {
            tabBar.backgroundImage = img;
        }
        
        
        UIColor *color = [UIColor colorWithPatternImage:img];
        tabBarBg.backgroundColor = color;
        [tabBar insertSubview:tabBarBg atIndex:0];
        
        tabBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,50, 43)];
        tabBarImageView.image=[UIImage imageNamed:@"top_cart1.png"];
        tabBarImageView.userInteractionEnabled=YES;
        [tabBarBg insertSubview:tabBarImageView atIndex:1];
        tabBarBg.opaque = YES;
        [tabBarBg release];
        [tabBarImageView release];
        //tabBarImageView.hidden = YES;
        
        [self addSubview:tabBar];
        [tabBar release];
        
        UIButton *cartBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [cartBut addTarget:self action:@selector(cart:) forControlEvents:UIControlEventTouchUpInside];
        [cartBut addTarget:self action:@selector(cart2:) forControlEvents:UIControlEventTouchDown];
        [cartBut addTarget:self action:@selector(cart3:) forControlEvents:UIControlEventTouchUpOutside];
        [cartBut setTag:10015];
        [cartBut setFrame:CGRectMake(198, 7, 48,45)];
        [self addSubview:cartBut];
    }
    return self;
}

-(void)setSearchHidden:(BOOL)hidden
{
    [textBg setHidden:hidden];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [textBg setFrame:CGRectMake(frame.size.width-236, 10, 210, 33)];
    [logo setFrame:CGRectMake(frame.size.width/2-24, 3, 49, 47)];
    [address setFrame:CGRectMake(frame.size.width/2+45,0, 150, 55)];
    [addressLabel setFrame:CGRectMake(frame.size.width/2+75, 30, 70.0, 20) ];
}

-(void)back:(id)sender
{
    if ([SharedPadDelegate.navigationController.topViewController isKindOfClass:[MyListViewController class]]) {

        [SharedPadDelegate.navigationController.view.layer addAnimation:[OTSNaviAnimation transactionFade] forKey:nil];
        [SharedPadDelegate.navigationController popToRootViewControllerAnimated:NO];
    }else {
    
        CATransition *transition = [CATransition animation];
        transition.duration = OTSP_TRANS_DURATION;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type =kCATransitionFade; //@"cube";
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [SharedPadDelegate.navigationController.view.layer addAnimation:transition forKey:nil];
        
        [SharedPadDelegate.navigationController popViewControllerAnimated:NO];
        //rootViewController = nil;
    }
}


-(void)main:(id)sender{
    CATransition *transition = [CATransition animation];
    transition.duration = OTSP_TRANS_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type =kCATransitionFade; //@"cube";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [SharedPadDelegate.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [SharedPadDelegate.navigationController popToRootViewControllerAnimated:NO];
}
-(void)user:(id)sender{
    if ([SharedPadDelegate.navigationController.topViewController isKindOfClass:[MyListViewController class]]) {
        return;
    } else {
        //删除其他MyListViewController实例
        for (UIViewController *viewController in [SharedPadDelegate.navigationController viewControllers]) {
            if ([viewController isKindOfClass:[MyListViewController class]]) {
                [viewController.navigationController popViewControllerAnimated:NO];
            }
        }
        
        [MobClick event:@"account"];
        if ([GlobalValue getGlobalValueInstance].token) {
            CATransition *transition = [CATransition animation];
            transition.duration = OTSP_TRANS_DURATION;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type =kCATransitionFade; //@"cube";
            transition.subtype = kCATransitionFromRight;
            transition.delegate = self;
            [SharedPadDelegate.navigationController.view.layer addAnimation:transition forKey:nil];
            
             MyListViewController *myStoreVC = [[[MyListViewController alloc] initWithNibName:@"MyListViewController" bundle:nil] autorelease];
            [SharedPadDelegate.navigationController pushViewController:myStoreVC animated:NO];

        } else {
            mloginViewController = [[LoginViewController alloc]init];
            mloginViewController.delegate = self;
            DataHandler * datehandle = [DataHandler sharedDataHandler];
            [mloginViewController setMcart:datehandle.cart];
            if (datehandle.cart.totalquantity!=0)
            {
                [mloginViewController setMneedToAddInCart:YES];
            }
            UIView * newview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
            [SharedPadDelegate.navigationController.topViewController.view addSubview:newview];
            [newview setBackgroundColor:[UIColor grayColor]];
            [newview setAlpha:0.5];
            [newview setTag:kLoginViewTag];
            
            mloginViewController.view.tag = kRealLoginViewTag;
            [SharedPadDelegate.navigationController.topViewController.view addSubview:mloginViewController.view];
            [mloginViewController.view setFrame:CGRectMake(1024, 0, 1024, 768)];
            [self moveToLeftSide:mloginViewController.view];
            [newview release];
            //UISwipeGestureRecognizer
            UISwipeGestureRecognizer * swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
            swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
            [mloginViewController.view addGestureRecognizer:swipeGes];
            [swipeGes release];
        }
    }
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)gestureRecognizer {
    
    [self loginclosed]; 
    
}

- (void)moveToLeftSide:(UIView *)view{
    [UIView animateWithDuration:OTSP_TRANS_DURATION animations:^{
        view.frame = CGRectMake(104, 0, 1024, 768);
    }
                     completion:^(BOOL finished)
     {
         
     }];
}
-(void)setCartCount:(NSInteger)count{
    if (count>0) {
        [tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",count]];
    }else {
        [tabBarItem setBadgeValue:nil];
    }
}
-(void)cart:(id)sender
{
    [SharedPadDelegate enterCart];
    tabBarImageView.image=[UIImage imageNamed:@"top_cart1.png"];
}
-(void)cart2:(id)sender{
    tabBarImageView.image=[UIImage imageNamed:@"top_cart2.png"];
}
-(void)cart3:(id)sender{
    
    tabBarImageView.image=[UIImage imageNamed:@"top_cart1.png"];
}
#pragma mark -
#pragma mark 搜索相关
-(void)initSearchHistory
{
    if (searchHistoryArr==nil) {
        //初始化搜索历史
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *filename=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"SearchHistory.plist"];
        NSMutableArray *mArray=[[NSMutableArray alloc] initWithContentsOfFile:filename];
        if (mArray!=nil && [mArray count]!=0) {
            searchHistoryArr=[[NSMutableArray alloc] initWithArray:mArray];
        } else {
            searchHistoryArr=[[NSMutableArray alloc] init];
        }
        [mArray release];
    }
}
-(void)initSearchingView{
    if (searchView.superview) {
        return;
    }
    [self otsDetatchMemorySafeNewThreadSelector:@selector(getHotKeyWord) toTarget:self withObject:nil];
    UIView* tpview = SharedPadDelegate.navigationController.topViewController.view; // 获取将要加载的VIEW
    self.searchView = [[[UIView alloc]initWithFrame:CGRectMake(0, 55, 1024,713)]autorelease];
    searchView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    // 透明的底层BTN
    UIButton* closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 1024, 713)];
    [closeBtn addTarget:self action:@selector(closeSearchView) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:closeBtn];
    [closeBtn release];
    [tpview addSubview:searchView];
    
    // 热门搜索 table
    self.searchHotTable = [[[UITableView alloc]initWithFrame:CGRectMake(160, 0, 160, 713) style:UITableViewStylePlain]autorelease];
    searchHotTable.dataSource = self;
    searchHotTable.delegate = self;
    
    // 关键字搜索 table
    self.searchKeyTable = [[[UITableView alloc]initWithFrame:CGRectMake(320, 0, 240, 713) style:UITableViewStylePlain]autorelease];
    searchKeyTable.dataSource = self;
    searchKeyTable.delegate = self;
    
    
    // 搜索历史 table
    self.searchHistoryTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 160, 713) style:UITableViewStylePlain]autorelease];
    searchHistoryTable.dataSource = self;
    searchHistoryTable.delegate = self;
    
    // 加载上面三个table的容器VIEW
    self.searchLeftView = [[[UIView alloc]initWithFrame:CGRectMake(464, 0, 560,713)]autorelease];
    searchLeftView.backgroundColor=[UIColor whiteColor];
    
    [searchLeftView addSubview:searchHistoryTable];
    [searchLeftView addSubview:searchHotTable];
    [searchLeftView addSubview:searchKeyTable];
    
    if ([self isEmptyString:textField.text]) {
        [searchKeyTable setHidden:YES];
    }else{
        self.m_KeyWord = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [self getAndUpdateTheRelationKey];
    }
    // 渐变色
    UIImage* gradImage = [[UIImage imageNamed:@"search_gradientLine_short.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:5];
    self.gradientLayer=[[[UIImageView alloc] init]autorelease];
    [gradientLayer setFrame:CGRectMake(searchHotTable.frame.size.width-10, 0, 10, 713)];
    [gradientLayer setImage:gradImage];
    [searchLeftView addSubview:gradientLayer];
    
    self.gradientLayer1=[[[UIImageView alloc] init]autorelease];
    [gradientLayer1 setFrame:CGRectMake(searchHistoryTable.frame.size.width-10, 0, 10, 713)];
    [gradientLayer1 setImage:gradImage];
    [searchLeftView addSubview:gradientLayer1];
    
    // 确认删除按钮
    self.clearSureBtnView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"confirm_black_up.png"]]autorelease];
    [clearSureBtnView setUserInteractionEnabled:YES];
    [clearSureBtnView setHidden:YES];
    [searchLeftView addSubview:clearSureBtnView];
    
    UIButton* clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn setFrame:CGRectMake(7.5, 23, 275, 46)];
    [clearBtn setTitle:@"清空搜索历史" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [clearBtn setBackgroundImage:[UIImage imageNamed:@"confirm_red.png"] forState:UIControlStateNormal];
    [clearBtn setBackgroundImage:[UIImage imageNamed:@"confirm_red_h.png"] forState:UIControlStateHighlighted];
    [clearBtn addTarget:self action:@selector(doClearSearchHistory) forControlEvents:UIControlEventTouchUpInside];
    [clearSureBtnView addSubview:clearBtn];
    
    [self showSearchingViewCorrectlyWithAnimated:NO];
    // 滑动关闭
    UISwipeGestureRecognizer* recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeSearchView)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [searchLeftView addGestureRecognizer:recognizer];
    [recognizer release];
    
    CATransition *animation = [CATransition animation];
	animation.duration = 0.3f;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	[animation setType:kCATransitionPush];
	[animation setSubtype: kCATransitionFromRight];
    [searchLeftView.layer addAnimation:animation forKey:@"left"];
    
    [searchView addSubview:searchLeftView];
}
// 获取热门搜索
-(void)getHotKeyWord{
    if (searchHotKeyArr == nil) {
        SearchService* serv = [[SearchService alloc]init];
        NSArray* tempArray;
        @try {
            tempArray = [serv getHomeHotElement:[GlobalValue getGlobalValueInstance].trader type:[NSNumber numberWithInt:2]];
        } @catch (NSException * e) {
        } @finally {
            if (tempArray) {
                searchHotKeyArr = [tempArray retain];
                [searchHotTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        }
        [serv release];
    }
    //    searchHotKeyArr = [[NSArray alloc]initWithObjects:@"假数据",@"接口ERD都木有",@"接口好了再来调",@"接口据说周三才给ERD",@"做面包屑了先",@"有问题我再来改",nil];
}
//获取相关关键字
-(void)getRelationKeyWord:(NSString *)word
{
    
    YWSearchService *searchSer = [[YWSearchService alloc] init];
    
    NSDictionary *paramDic = @{@"word" : word,@"minScore":@"1",@"count":@"10"};
    
    NSArray *tempArray = [searchSer getSearchKeyword:paramDic];


//    NSArray *tempArray=[[OTSServiceHelper sharedInstance] getSearchKeyword:[GlobalValue getGlobalValueInstance].trader mcsiteId:[NSNumber numberWithInt:1] keyword:self.m_KeyWord provinceId:[GlobalValue getGlobalValueInstance].provinceId];
    getKeyWordRuning=NO;
    if (searchRelationArray!=nil) {
        [searchRelationArray release];
    }
    if (tempArray==nil || [tempArray isKindOfClass:[NSNull class]]) {
		searchRelationArray = nil;
    } else {
        searchRelationArray=[[NSMutableArray alloc]initWithArray:tempArray];
    }
    [self performSelectorOnMainThread:@selector(updateKeyTableView) withObject:nil waitUntilDone:NO];
}
// 判断字符串是否为空，用于搜索框
- (BOOL) isEmptyString:(NSString *) string {
    if([string length] == 0) { //string is empty or nil
        return YES;
    } else if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        //string is all whitespace
        return YES;
    }
    return NO;
}
// 根据不同的情况显示正确的UI。包括是否有输入，是否有搜索历史。
-(void)showSearchingViewCorrectlyWithAnimated:(BOOL)isAnimation{
    // 分为 4 种情况：1.无搜索历史，无输入. 2.有搜索历史，无输入. 3.无搜素历史，有输. 4.有搜索历史，有输入
    
    // 动画
    if (isAnimation) {
        [UIView setAnimationsEnabled:YES];
        [UIView beginAnimations:@"hidden" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
    }
    if (searchHistoryArr.count == 0 && [self isEmptyString:textField.text]) {
        [searchHotTable setFrame:CGRectMake(18, 0, 204, 713)];
        [searchLeftView setFrame:CGRectMake(784, 0, 240, 713)];
        [searchHistoryTable setHidden:YES];
    }else if(searchHistoryArr.count > 0 && [self isEmptyString:textField.text]){
        [searchHotTable setFrame:CGRectMake(18, 0, 124, 713)];
        [searchHistoryTable setFrame:CGRectMake(178, 0, 204, 713)];
        [searchLeftView setFrame:CGRectMake(624, 0, 400, 713)];
    }else if(searchHistoryArr.count == 0 && ![self isEmptyString:textField.text]){
        [searchHotTable setFrame:CGRectMake(18, 0, 124, 713)];
        [searchKeyTable setFrame:CGRectMake(178, 0, 204, 713)];
        [searchLeftView setFrame:CGRectMake(624, 0, 400, 713)];
        [searchHistoryTable setHidden:YES];
        [searchKeyTable setHidden:NO];
    }else if(searchHistoryArr.count > 0 && ![self isEmptyString:textField.text]){
        [searchHotTable setFrame:CGRectMake(18, 0, 124, 713)];
        [searchHistoryTable setFrame:CGRectMake(178, 0, 124, 713)];
        [searchKeyTable setFrame:CGRectMake(338, 0, 204, 713)];
        [searchLeftView setFrame:CGRectMake(464, 0, 560, 713)];
        [searchKeyTable setHidden:NO];
    }
    [gradientLayer setFrame:CGRectMake(searchHotTable.frame.origin.x+searchHotTable.frame.size.width+18-10, 0, 10, 713)];
    if (!searchHistoryTable.hidden) {
        [gradientLayer1 setFrame:CGRectMake(searchHistoryTable.frame.origin.x+searchHistoryTable.frame.size.width+18-10, 0, 10, 713)];
    }else{
        [gradientLayer1 setHidden:YES];
    }
    if (isAnimation) {
        [UIView commitAnimations];
        [UIView setAnimationsEnabled:NO];
    }
}
-(void)getAndUpdateTheRelationKey{

    if (![[m_KeyWord substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "] && !getKeyWordRuning) {
        getKeyWordRuning=YES;
    [self otsDetatchMemorySafeNewThreadSelector:@selector(getRelationKeyWord:) toTarget:self withObject:m_KeyWord];
    }
}


-(void)updateKeyTableView{
    if (searchKeyTable.hidden) {
        [self showSearchingViewCorrectlyWithAnimated:YES];
    }
    if (![self isEmptyString:textField.text]) {  // 用于判断用户删除过快，输入框无内容后获取线程才结束导致的输入框为空，关联却有内容的情况
        [searchKeyTable reloadData];
    }

}

-(void)doClearSearchHistory{
    [searchHistoryArr removeAllObjects];
    [searchHistoryTable reloadData];
    [self showSearchingViewCorrectlyWithAnimated:YES];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *filename=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"SearchHistory.plist"];
    [searchHistoryArr writeToFile:filename atomically:NO];
    [clearSureBtnView setHidden:YES];
}
-(void)showClearSearchHistoryBtn{
    if (searchHistoryArr.count == 0 || searchHistoryArr == nil) {
        return;
    }
    if (clearSureBtnView.hidden) {
        // 获得清空按钮的frame
        CGRect rect = [searchHistoryTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].accessoryView.frame;
        [clearSureBtnView setFrame:CGRectMake(rect.origin.x+160+54-260, 32, 290, 86)];  // 210为微调值
        [clearSureBtnView setHidden:NO];
    }else{
        [clearSureBtnView setHidden:YES];
    }
   
    
}
// 保存搜索历史
-(void)saveSearchKeyword
{
    NSString *keyWord=[[NSString alloc] initWithString:m_KeyWord];
    
    for (int i=0;i<[searchHistoryArr count];i++) {    // 如果在搜索框里面进行的搜索已存在所搜记录中，将该记录移到最前面
        NSString *text=[searchHistoryArr objectAtIndex:i];
        if ([text isEqualToString:keyWord]) {
            [searchHistoryArr removeObject:text];
        }
    }
    if ([searchHistoryArr count] >= 50) {  // 搜索历史保存最多50个记录
        [searchHistoryArr removeLastObject];
    }
    [searchHistoryArr insertObject:keyWord atIndex:0];
    [keyWord release];
    // 保存到本地
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *filename=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"SearchHistory.plist"];
    [searchHistoryArr writeToFile:filename atomically:NO];
}

-(void)hiddenTheLeftViewWithAnimation{
    [UIView setAnimationsEnabled:YES];
    [UIView beginAnimations:@"hidden" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [searchLeftView  setFrame:CGRectMake(1024, 0, 560,713)];
    [UIView  commitAnimations];
    [UIView setAnimationsEnabled:NO];
}
-(void)closeSearchView{
    if (searchView.superview.superview) {
        [textField resignFirstResponder];
        
        [self hiddenTheLeftViewWithAnimation];
        [searchView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4];
        self.searchView = nil;
    }
}

-(void)searchBegin:(id)sender
{
    [self initSearchingView];
}
-(void)searchChanged:(id)sender{
    NSString *text=[[NSString stringWithString:textField.text]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [DataHandler sharedDataHandler].keyWord=text;
    NSMutableDictionary *mDictionary=[[NSMutableDictionary alloc] init];
    [mDictionary setObject:text forKey:@"TextFieldText"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifySearchTextViewChange object:self userInfo:mDictionary];
    [mDictionary release];
    
    if ([self isEmptyString:text]) {
        [searchRelationArray removeAllObjects];
        [searchKeyTable reloadData];
    }else{
        self.m_KeyWord = text;
        [self getAndUpdateTheRelationKey];
    }
    [self showSearchingViewCorrectlyWithAnimated:YES];
}
// 进行搜索
-(void)search:(id)sender{
    if ([self isEmptyString:textField.text]) {
        return;
    }
    self.m_KeyWord = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [DataHandler sharedDataHandler].keyWord = m_KeyWord;
    [[DataHandler sharedDataHandler] saveSearchHistory:m_KeyWord];
    [SharedPadDelegate goSearch:sender];
    
    [self saveSearchKeyword];
    [self closeSearchView];
    [MobClick event:@"search"];
}
-(void)keyboardWillHide:(NSNotification *)note{
    
}
-(void)handleSearchTextViewChanged:(NSNotification *)notification
{
    TopView *topView=[notification object];
    if (topView==self) {
        return;
    }
    NSString *text=[[notification userInfo] objectForKey:@"TextFieldText"];
    [textField setText:text];
}
- (BOOL)textFieldShouldReturn:(UITextField *)aTextField{
    if ([self isEmptyString:textField.text]) {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)atextField{
    textField.text = @"";
    [self showSearchingViewCorrectlyWithAnimated:YES];
    return YES;
}
#pragma mark -
#pragma mark 省份切换
-(void)openProVince:(UIPanGestureRecognizer*)gestureRecognizer{

    if (!popoverController) {
        ProvinceViewController *contentViewController = [[[ProvinceViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        //contentViewController.listData=[DataHandler sharedDataHandler] .provinceArray;
        self.popoverController = [[[WEPopoverController alloc] initWithContentViewController:contentViewController] autorelease];
        //self.popoverController.delegate = self;
        self.popoverController.popoverContentSize=CGSizeMake(462.0, 410.0);
        if ([self.popoverController respondsToSelector:@selector(setContainerViewProperties:)]) {
            [self.popoverController setContainerViewProperties:[self improvedContainerViewProperties]];
        }
    }
    [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, 1224, 45) inView:self  permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) animated:YES];
    
//    [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, 1224, 45)
//                                            inView:self
//                          permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown)
//                                        parentView:self
//                                          animated:YES];
    
}

-(void)saveProvinceToLocal:(ProvinceVO *)provinceVO
{
    NSBundle *bundle=[NSBundle mainBundle];
	NSString *listPath=[bundle pathForResource:@"ProvinceID" ofType:@"plist"];//获得资源文件路径
	NSDictionary *provinceDic=[[NSDictionary alloc] initWithContentsOfFile:listPath];//获得内容
	
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *path=[paths objectAtIndex:0];
	NSString *filename=[path stringByAppendingPathComponent:@"SaveProvinceId.plist"]; 
	NSMutableArray *array=[[NSMutableArray alloc] init];
    [array addObject:[NSString stringWithString:[provinceVO provinceName]]];
    [array writeToFile:filename atomically:NO];
    [array release];
    [provinceDic release];
	
	[[GlobalValue getGlobalValueInstance] setProvinceId:[provinceVO nid]];
}

-(void)handleTopViewShowUser:(NSNotification *)notification
{
    [self user:nil];
}

#pragma mark -
#pragma mark NOTIFICATION
-(void)handleProVinceChange:(NSNotification *)note{
    ProvinceVO *province=[note.userInfo objectForKey:@"province"];
    if(province){
        addressLabel.text=province.provinceName;
        [OTSGpsHelper sharedInstance].provinceVO = province;
        [[OTSGpsHelper sharedInstance] saveProvince];
        
        [[GlobalValue getGlobalValueInstance] setProvinceId:[province nid]];
        [self saveProvinceToLocal:province];
        
        if ([popoverController respondsToSelector:@selector(dismissPopoverAnimated:)]) {
            [popoverController dismissPopoverAnimated:NO];
        }
    }
}

-(void)handleDissmissPopOver:(NSNotification *)note
{
    if ([popoverController respondsToSelector:@selector(dismissPopoverAnimated:)]) {
        [popoverController dismissPopoverAnimated:NO];
    }
}

- (void)handleCartChange:(NSNotification *)note{

    [self setCartCount:[DataHandler sharedDataHandler].cart.totalquantity.intValue];
}
-(void)handleProvincePop:(NSNotification *)note{
    [self performSelector:@selector(openProVince:) withObject:nil afterDelay:0.5];
}
//- (void)setKeyWord:(NSString *)keyWord{
//    textField.text=keyWord;
//}
#pragma mark -
#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == searchHistoryTable) {
        return [searchHistoryArr count]+1;
    }
    if (tableView == searchKeyTable) {
        if (searchRelationArray.count > 0) {
            return searchRelationArray.count;
        }
    }
    if (tableView == searchHotTable) {
        return [searchHotKeyArr count]+1;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
    int row = [indexPath row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    [titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:SEARCH_TEXT_COLOR];
    [cell addSubview:titleLabel];
    [titleLabel release];
    
    if (tableView == searchHistoryTable) {
        
        if (row == 0) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [titleLabel setText:@"搜索历史"];
            [titleLabel setTextColor:[UIColor colorWithRed:213.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]];
            
            // 清空按钮的实现
            UIView* accView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
            [accView setBackgroundColor:[UIColor clearColor]];
            cell.accessoryView = accView;
            [accView release];
            
            UIButton* clearHistoryBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, 0, 40, 30)];
            [clearHistoryBtn addTarget:self action:@selector(showClearSearchHistoryBtn) forControlEvents:UIControlEventTouchUpInside];
            [clearHistoryBtn setTitle:@"清空" forState:UIControlStateNormal];
            if (searchHistoryArr.count == 0 || searchHistoryArr == nil) {
                [clearHistoryBtn setTitleColor:[UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1.0] forState:UIControlStateNormal];
            }else{
                [clearHistoryBtn setTitleColor:SEARCH_TEXT_COLOR forState:UIControlStateNormal];
            }
            [clearHistoryBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            [cell.accessoryView addSubview:clearHistoryBtn];
            [clearHistoryBtn release];
            
            UIView* botLine = [[UIView alloc]initWithFrame:CGRectMake(14, 23, 38, 1)];
            if (searchHistoryArr.count == 0 || searchHistoryArr == nil) {
                [botLine setBackgroundColor:[UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1.0]];
            }else{
                [botLine setBackgroundColor:SEARCH_TEXT_COLOR];
            }
            [botLine setBackgroundColor:SEARCH_TEXT_COLOR];
            [cell.accessoryView addSubview:botLine];
            [botLine release];
        }else{
            titleLabel.text = [searchHistoryArr objectAtIndex:row-1];
            [titleLabel setTag:101];
        }
    }else if(tableView == searchHotTable){
        if (row == 0) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [titleLabel setTextColor:[UIColor colorWithRed:213.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]];
            [titleLabel setText:@"热门搜索"];
            
        }else{
            FacetValue* facetValue = [searchHotKeyArr objectAtIndex:row-1];
            titleLabel.text = facetValue.name;
            [titleLabel setTag:101];
        }
    }else if(tableView == searchKeyTable){
        [titleLabel setTag:101];
        if ([searchRelationArray count] == 0) {
			if ([indexPath row] == 0) {
                [titleLabel setText:@"无结果"];
				[[cell detailTextLabel] setText:@""];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			}
		} else {
            // 相关搜索的名称和数量
			SearchKeywordVO *keyWordVO=[OTSUtility safeObjectAtIndex:[indexPath row] inArray:searchRelationArray];
			[titleLabel setText:[keyWordVO keyword]];
            [titleLabel setFrame:CGRectMake(0, 0, 100, 40)];
            
            UILabel* countLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 110, 40)];
            [countLabel setFont:[UIFont systemFontOfSize:15.0]];
            [countLabel setBackgroundColor:[UIColor clearColor]];
            [countLabel setTextAlignment:NSTextAlignmentRight];
            [countLabel setTextColor:[UIColor colorWithRed:99.0/255 green:116.0/255 blue:159.0/255 alpha:1]];
            [countLabel setText:[NSString stringWithFormat:@"约%@条商品",[keyWordVO resultCount]]];
            [cell addSubview:countLabel];
            [countLabel release];
        }
    }
    [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((tableView == searchHotTable || tableView == searchHistoryTable) && [indexPath row] == 0) {
        return;
    }
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel* titleLabel = (UILabel*)[cell viewWithTag:101];
    if (![titleLabel.text isEqualToString:@"无结果"]) {
        self.m_KeyWord = titleLabel.text;
        textField.text = m_KeyWord;
        [DataHandler sharedDataHandler].keyWord=m_KeyWord;
        [[DataHandler sharedDataHandler] saveSearchHistory:m_KeyWord];
        [SharedPadDelegate goSearch:textField];
        
        [self saveSearchKeyword];
        [self closeSearchView];
        [MobClick event:@"search"];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ((scrollView == searchHotTable || scrollView == searchHistoryTable) || scrollView == searchKeyTable) {
        [textField resignFirstResponder];
    }
}
#pragma mark -
#pragma mark WEPopover set
- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
	
	WEPopoverContainerViewProperties *props = [[WEPopoverContainerViewProperties alloc] autorelease];
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 4.0;
	
	bgImageName = @"province_kuangbg.png";
	
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

#pragma mark - logindelegate
-(void)loginclosed
{
    [UIView animateWithDuration:OTSP_TRANS_DURATION animations:^{
        mloginViewController.view.frame = CGRectMake(1024, 0, 1024, 768);
    }
                     completion:^(BOOL finished)
     {
         [[SharedPadDelegate.navigationController.topViewController.view viewWithTag:kLoginViewTag] removeFromSuperview];
         [mloginViewController.view removeFromSuperview];
     }];
}
-(void)loginsucceed
{
    [MobClick event:@"account"];
    mloginViewController.view.frame = CGRectMake(1024, 0, 1024, 768);
    [[SharedPadDelegate.navigationController.topViewController.view viewWithTag:kLoginViewTag] removeFromSuperview];
    [mloginViewController.view removeFromSuperview];
    
     MyListViewController *myStoreVC = [[[MyListViewController alloc] initWithNibName:@"MyListViewController" bundle:nil] autorelease];
    [SharedPadDelegate.navigationController pushViewController:myStoreVC animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    OTS_SAFE_RELEASE(popoverController);
    OTS_SAFE_RELEASE(searchRelationArray);
    
    OTS_SAFE_RELEASE(backBut);
    OTS_SAFE_RELEASE(searchView);
    OTS_SAFE_RELEASE(m_KeyWord);
    OTS_SAFE_RELEASE(searchKeyTable);
    OTS_SAFE_RELEASE(searchHistoryTable);
    OTS_SAFE_RELEASE(searchHotTable);
    OTS_SAFE_RELEASE(searchLeftView);
    OTS_SAFE_RELEASE(gradientLayer);
    OTS_SAFE_RELEASE(gradientLayer1);
    OTS_SAFE_RELEASE(clearSureBtnView);
    
    //[keyWord release];
    //rootViewController=nil;
    
    [super dealloc];
}
@end
