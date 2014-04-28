//
//  MyBrowse.m
//  TheStoreApp
//
//  Created by towne on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyBrowse.h"
#import "BrowseService.h"
#import "GlobalValue.h"
#import "ProductVO.h"
#import "ASIHTTPRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "StringUtil.h"
#import "DataController.h"
#import "OTSActionSheet.h"
#import "CartService.h"
#import "LocalCartItemVO.h"
#import "ErrorStrings.h"
#import "OTSAlertView.h"
#import "HomePage.h"
#import "TheStoreAppAppDelegate.h"
#import "SDImageView+SDWebCache.h"
#import "OTSProductDetail.h"
#import "CategoryProductCell.h"
#import "ProductService.h"
#import "GTMBase64.h"
#import "DoTracking.h"
#import "SDImageView+SDWebCache.h"
#import "CartAnimation.h"

#import "YWBrowseService.h"
#import "ProductInfo.h"
#import "LocalCarInfo.h"
#import "YWLocalCatService.h"
#import "UserInfo.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define TITLE_BACK_BUTTON_TAG 100 //标题按钮tag
#define TITLE_LOGOUT_BUTTON_TAG 101 //标题注销tag
#define TITLE_LABEL_TAG 102 //标题文字

#define BR_NORMAL_STATE 1//浏览
#define BR_DEL_STATE 2//删除
#define BR_BUY_STATE 3//购买


#define BR_PRODUCT_NAME_TAG 100 //商品名称tag
#define BR_PRODUCT_MARKET_PRICE_TAG 104//商品市场价格tag
#define BR_PRODUCT_PRICE_TAG 101//商品价格tag
#define BR_BUTTON_TAG 102//购买button的tag
#define BR_PRODUCT_IMAGE_TAG 103//商品图片
#define BR_FIRSTSCROE_TAG 1000 //星级第一个图片
#define BR_CANBUY_TAG   105 //是否有货tag
#define BR_EXPERENCE_TAG 106 //多少人评论
#define BR_HAVEGIFT	  110 //赠品label

#define ALERTVIEW_TAG_OTHERS 0

#define URL_BASE_MALL_GROUPON      @"http://m.1mall.com/mw/groupdetail/"
#define URL_BASE_MALL_NO_ONE       @"http://m.1mall.com/mw/product/"

@interface MyBrowse ()
@property (nonatomic, retain)   UINib  *_cellNib;
@property(nonatomic, retain)CartAnimation* cartAnimation;

@end

@implementation MyBrowse

@synthesize _currentState;
@synthesize _delProductId,_delGrouponId,_cellNib;
@synthesize browseArray = _browseArray;
@synthesize grouponAreaId = _grouponAreaId;
@synthesize cartAnimation;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self._cellNib = [UINib nibWithNibName:@"GroupBuyHomePageCell" bundle:nil];
    [UIView setAnimationsEnabled:NO];
    
    cartAnimation = [[CartAnimation alloc]init:self.view];
    
    //标题栏
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [imageView setImage:[UIImage imageNamed:@"title_bg.png"]];
    [self.view addSubview:imageView];
    [imageView release];
    
    UIButton *returnBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 61, 44)];
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn.png"] forState:UIControlStateNormal];
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn_sel.png"] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    [returnBtn release];
    
    _mEditBtn=[[UIButton alloc] initWithFrame:CGRectMake(259, 0, 61, 44)];
    [_mEditBtn setBackgroundImage:[UIImage imageNamed:@"title_delete.png"] forState:UIControlStateNormal];
    [_mEditBtn setBackgroundImage:[UIImage imageNamed:@"title_delete_sel.png"] forState:UIControlStateHighlighted];
    [_mEditBtn addTarget:self action:@selector(showSheetView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mEditBtn];
    
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 44)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setText:@"最近浏览"];
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont boldSystemFontOfSize:20.0]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setShadowColor:[UIColor darkGrayColor]];
    [title setShadowOffset:CGSizeMake(1, -1)];
    [self.view addSubview:title];
    [title release];
    
    _isAnimStop = YES;
    
    //没有最近浏览时显示的界面
	_noProductView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    _noProductView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"myFavorite_nil.png"]];
    UIImageView *nullImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"browse_null.png"]];
    [nullImage setFrame:CGRectMake(0, 0, 320, 368)];
    [_noProductView addSubview:nullImage];
    [nullImage release];
    
    UIButton *_brSelect = [[UIButton alloc] init];
    [_brSelect setFrame:CGRectMake(113, 245, 90, 30)];
    if (iPhone5) {
        [_brSelect setFrame:CGRectMake(113, 270, 90, 30)];
    }
    [_brSelect setImage:[UIImage imageNamed:@"browse_select@2x.png"] forState:UIControlStateNormal];
    [_brSelect addTarget:self action:@selector(gotoSelectProduct) forControlEvents:UIControlEventTouchUpInside];
    [_noProductView addSubview:_brSelect];
    [_brSelect release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refleshImmediately) name:@"RefleshImmediately" object:nil];
    
    [self performSelector:@selector(initTableView) withObject:nil];
    
    _currentState = BR_NORMAL_STATE;
    _running = NO;
    [self setUpThread:YES];
}

-(void)initTableView{
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
    [_mTableView setBackgroundColor:[UIColor clearColor]];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    [self.view addSubview:_mTableView];
	_backView = [[BackToTopView alloc] init];
	[self.view addSubview:_backView];
}

#pragma mark 进入／退出编辑模式
-(void)editMode:(id)sender{
	UIButton *_btn = (UIButton*)sender;
	if (_mTableView.isEditing) {
		[_mTableView setEditing:NO];
		[_btn setTitle:@"编辑" forState:0];
		[_mTableView reloadData];
	}else {
		[_mTableView setEditing:YES];
		[_btn setTitle:@"完成" forState:0];
		[_mTableView reloadData];
	}
    
}

#pragma mark 弹出提示框
-(void)showAlertView:(NSString *)alertTitle alertMsg:(NSString *)alertMsg alertTag:(int)tag {
    [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
    UIAlertView * _alert = [[OTSAlertView alloc] initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    _alert.tag = tag;
	[_alert show];
	[_alert release];
	_alert = nil;
}

-(void)showError:(NSString *)errorInfo
{
    [AlertView showAlertView:nil alertMsg:errorInfo buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
}

#pragma mark 开启线程
-(void)setUpThread:(BOOL)showLoading {
    if (!_running) {
		_running=YES;
        [self showLoading:showLoading];
        [self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
	}
}

#pragma mark 开启线程
-(void)startThread{
    
    while (_running) {
		switch (self._currentState)
        {
                
			case BR_NORMAL_STATE://最近浏览
			{
                NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                YWBrowseService *mBrowse = [[YWBrowseService alloc] init];
                @try {
                    //---首先同步数据库---
                    self.browseArray = [mBrowse getHistoryBrowse];
                }
                @catch (NSException * e) {
                    
                }
                @finally {
                    [mBrowse release];
                    mBrowse=nil;
                }
                [self stopThread];

                [self performInMainBlock:^(){
                    [self updateBRView];
                }];
                [pool drain];
			}
				break;
			case BR_DEL_STATE://删除最近浏览数据
			{
                BOOL flag;
                
                NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                YWBrowseService *browseSer = [[YWBrowseService alloc] init];
                
                if(_delProductId)
                    flag = [browseSer cleanHistoryByProductId:_delProductId];
//                else if(_delGrouponId)
//                {
//                    flag = [browseSer deleteGrouponBrowseHistoryById:_delGrouponId];
//                    flag = [browseSer deleteBrowseHistoryByGrouponId:_delGrouponId];
//                }
                else
                {
                    flag = [browseSer cleanHistory];
//                    flag = [browseSer deleteGrouponBrowseHistory];
                }
                
                //reflesh
                [self performInThreadBlock:^(){
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    YWBrowseService *mBrowse = [[YWBrowseService alloc] init];
                    @try {
                        //---首先同步数据库---
                        self.browseArray = [mBrowse getHistoryBrowse];
                    }
                    @catch (NSException * e) {
                        
                    }
                    @finally {
                        [mBrowse release];
                        mBrowse=nil;
                    }
                    [pool drain];
                    
                } completionInMainBlock:^{
                    
                    [_mEditBtn setEnabled:NO];
                    [self updateBRView];
                    
                }];
                
                [self stopThread];
                [pool drain];
			}
				break;
		    case BR_BUY_STATE:
			{
                //浏览记录里面不加入购物车了
                /*
                
                NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
                ProductInfo *productVO = [self.browseArray objectAtIndex:_currentActionIndex];

                // 购物添加到本地
                
                
                YWLocalCatService *localCatService = [[YWLocalCatService alloc] init];
                LocalCarInfo *localCart = [[LocalCarInfo alloc] initWithProductId:productVO.productId
                                                                    shoppingCount:@"1"
                                                                         imageUrl:productVO.productImageUrl
                                                                            price:productVO.price
                                                                       provinceId:[[GlobalValue getGlobalValueInstance].provinceId stringValue]
                                                                              uid:[GlobalValue getGlobalValueInstance].userInfo.ecUserId
                                                                        productNO:<#(NSString *)#>
                                                                           itemId:<#(NSString *)#> ];
                
                BOOL result = [localCatService saveLocalCartToDB:localCart];
                
                if (result)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showBuyProductAnimation];
                    });
                }
                else
                {
                    [self performSelectorOnMainThread:@selector(showError:) withObject:@"加入购物失败" waitUntilDone:NO];
                }
                
                [NSThread sleepForTimeInterval:1.5];
                [self stopThread];
				[pool drain];*/
            }
                break;
			default:
                _running = NO;
				break;
		}
	}
}

#pragma mark 停止线程
-(void)stopThread{
	_running=NO;
	_currentState=-1;
    [self hideLoading];
}

//下载图片后刷新tableview
-(void)refleshTabeView
{
    [_mTableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    //    [self refleshImmediately];
}


-(void)updateBRView{
    if ([self.browseArray count] <= 0)
    {
        if ([_noProductView superview]==nil)
        {
            [self.view addSubview:_noProductView];
        }
    }
    else
    {
        [_noProductView removeFromSuperview];
        [self refleshTabeView];
    }
}

#pragma mark MyBrowse相关notify
-(void)refleshImmediately
{
    _currentState = BR_NORMAL_STATE;
    _running = NO;
    [self setUpThread:NO];
}

#pragma mark scrollView相关delegate

/*****
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
 _backView.scrollScreenHeight = 367;
 [_backView scrollViewDidScroll:scrollView];
 }
 - (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView{
 [_backView scrollViewDidEndDecelerating:theScrollView];
 }
 - (void)scrollViewDidEndDragging:(UIScrollView *)theScrollView willDecelerate:(BOOL)decelerate{
 [_backView scrollViewDidEndDragging:theScrollView willDecelerate:decelerate];
 }
 - (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
 [_backView scrollViewShouldScrollToTop:scrollView];
 return YES;
 }
 **/


#pragma mark tableView相关deleage和datasource
/* 滑动删除代码 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        ProductInfo  *product;
//        GrouponVO  *groupon;
        _currentState=BR_DEL_STATE;
        _currentActionIndex = [indexPath row];
        product =[self.browseArray objectAtIndex:_currentActionIndex];
//        if ([obj isKindOfClass:[ProductVO class]]) {
//            product = obj;
            self._delProductId =product.productId;//获得商品id
            self._delGrouponId = nil; //该条是普通商品的时候 清除团购id
//        }
//        if ([obj isKindOfClass:[GrouponVO class]]) {
//            groupon = obj;
//            self._delGrouponId = groupon.nid;
//            self._delProductId = nil; //该条是团购商品的时候 清除商品id
//        }
        [self setUpThread:YES];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProductInfo *product = [self.browseArray objectAtIndex:indexPath.row];
    CategoryProductCell *cell=(CategoryProductCell*)[tableView dequeueReusableCellWithIdentifier:@"MyBrowseCell"];
    if (cell==nil) {
        cell=[[[CategoryProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyBrowseCell"] autorelease];
    }
    
    //市场价格
    //商品价格
    cell.priceLbl.text=[NSString stringWithFormat:@"￥%.2f",[product.price floatValue]];
    
    
    //不能加入购物车
    cell.operateBtn.hidden = YES;
    /*
    //操作按钮
    if ([product isOTC])
    {
        [cell.operateBtn setFrame:CGRectMake(280, 38, 23, 19)];
        [cell.operateBtn setImage:[UIImage imageNamed:@"1mall_eye.png"] forState:0];
        [cell.operateBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [cell.operateBtn setUserInteractionEnabled:NO];
    }
    else
    {
        [cell.operateBtn setUserInteractionEnabled:YES];
        [cell.operateBtn addTarget:self action:@selector(accessoryButtonTap:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        cell.operateBtn.frame=CGRectMake(270, 8, 50, 85);
        
        [cell.operateBtn setImage:[UIImage imageNamed:@"product_cart.png"] forState:0];
        
    }
     */
    //有赠品
    
    [cell.giftLogo setHidden:YES];
    
    [cell.the1MallLogo setHidden:YES];
    //商品名称
    cell.productNameLbl.text = product.name;
    
    //商品图片
    cell.imageView.image=[UIImage imageNamed:@"defaultimg85.png"];
    [cell downloadImage:product.productImageUrl];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row=[indexPath row];
//    ProductInfo *product  = [self.browseArray objectAtIndex:row];
//    if ([obj isKindOfClass:[ProductVO class]])
//    {
        ProductVO *product=[self.browseArray objectAtIndex:row];
//        if (product.isYihaodian && product.isYihaodian.intValue == 0)
//        {
//            //最近浏览
////            [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadAddBrowse:) toTarget:self withObject:product];
//            // 1MALL的商品
//            NSString *urlStr;
//
//            //这里链接要重新处理
//            NSString* landingPageId;
//            if (product.promotionId)
//            {
//                landingPageId = product.promotionId;
//            }
//            else
//            {
//                landingPageId = @"";
//            }
//            if ([GlobalValue getGlobalValueInstance].token == nil)
//            {
//                urlStr = [URL_BASE_MALL_NO_ONE stringByAppendingFormat:@"%@/%@/%@?osType=30",product.productId,[GlobalValue getGlobalValueInstance].provinceId,landingPageId];
//            }
//            else
//            {
//                // 对 token 进行base64加密
//                NSData *b64Data = [GTMBase64 encodeData:[[GlobalValue getGlobalValueInstance].token dataUsingEncoding:NSUTF8StringEncoding]];
//                NSString* b64Str = [[[NSString alloc] initWithData:b64Data encoding:NSUTF8StringEncoding] autorelease];
//                urlStr = [URL_BASE_MALL_NO_ONE stringByAppendingFormat:@"%@/%@/%@?token=%@&osType=30",product.productId,[GlobalValue getGlobalValueInstance].provinceId,landingPageId,b64Str];
//                
//            }
//            DebugLog(@"enterWap -- url is:\n%@",urlStr);
//            [SharedDelegate enterWap:4 invokeUrl:urlStr isClearCookie:YES];
//        }
//        else
//        {
            OTSProductDetail *productDetail=[[[OTSProductDetail alloc] initWithProductId:[product.productId longLongValue] promotionId:nil fromTag:PD_FROM_BROWSE] autorelease];
            [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
            [self pushVC:productDetail animated:YES];
//        }
//    }
//    else if([obj isKindOfClass:[GrouponVO class]]) {
//        GrouponVO *groupon=[self.browseArray objectAtIndex:row];
//        if (groupon.siteType && groupon.siteType.intValue == 2) {
//            //团购最近浏览
//            [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadAddGrouponBrowse:) toTarget:self withObject:groupon];
//            // 1MALL 的商品
//            __block NSString *urlStr;
//            urlStr = groupon.mallURL;
//            //这里链接要重新处理
//            __block NSNumber *tempNumber;
//            [self performInThreadBlock:^(){
//                NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
//                tempNumber = [[[OTSServiceHelper sharedInstance]
//                               getGrouponAreaIdByProvinceId:[GlobalValue getGlobalValueInstance].trader
//                               provinceId:[GlobalValue getGlobalValueInstance].provinceId] retain];
//                [pool drain];
//            } completionInMainBlock:^(){
//                self.grouponAreaId = tempNumber;
//                NSString *urlStr;
//                if ([GlobalValue getGlobalValueInstance].token == nil) {
//                    urlStr = [URL_BASE_MALL_GROUPON stringByAppendingFormat:@"%@/%@_%d",groupon.nid,self.grouponAreaId,30];
//                }else {
//                    // 对 token 进行base64加密
//                    NSData *b64Data = [GTMBase64 encodeData:[[GlobalValue getGlobalValueInstance].token dataUsingEncoding:NSUTF8StringEncoding]];
//                    NSString* b64Str = [[[NSString alloc] initWithData:b64Data encoding:NSUTF8StringEncoding] autorelease];
//                    
//                    urlStr = [URL_BASE_MALL_GROUPON stringByAppendingFormat:@"%@/%@_%@_%d",groupon.nid,self.grouponAreaId,b64Str,30];
//                    
//                }
//                DebugLog(@"enterWap -- url is:\n%@",urlStr);
//                [SharedDelegate enterWap:1 invokeUrl:urlStr isClearCookie:YES];
//            }];
//        }
//        else
//        {
//            NSMutableArray *currentGrouponArray = [NSMutableArray array];
//            [currentGrouponArray addObject:groupon];
//            
//            __block NSNumber *tempNumber;
//            [self performInThreadBlock:^(){
//                NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
//                tempNumber = [[[OTSServiceHelper sharedInstance]
//                               getGrouponAreaIdByProvinceId:[GlobalValue getGlobalValueInstance].trader
//                               provinceId:[GlobalValue getGlobalValueInstance].provinceId] retain];
//                [pool drain];
//            } completionInMainBlock:^(){
//                self.grouponAreaId = tempNumber;
//                [SharedDelegate enterGrouponDetailWithAreaId:self.grouponAreaId products:currentGrouponArray currentIndex:0 fromTag:FROM_GROUPON_HOMEPAGE_TO_DETAIL isFullScreen:YES];
//                OTS_SAFE_RELEASE(tempNumber);
//            }];
//        }
//    }
    
}

-(void)updateProviceProductStatus:(ProductVO *)productVo
{
    OTSProductDetail *productDetail=[[[OTSProductDetail alloc] initWithProductId:[productVo.productId longValue] promotionId:productVo.promotionId fromTag:PD_FROM_BROWSE] autorelease];
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    [self pushVC:productDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 99;
}

-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    int objCount=[self.browseArray count];//实际的数目
	if (objCount == 0) {
		[_mEditBtn setEnabled:NO];
	}else {
		[_mEditBtn setEnabled:YES];
	}
    return objCount;
}
#pragma mark 返回方法
-(void)back{
	HomePage *homePage = [SharedDelegate.tabBarController.viewControllers objectAtIndex:0];
	[homePage setUniqueScrollToTopFor:homePage->m_ScrollView];
	CATransition * animation = [CATransition animation];
    animation.duration = 0.3f;
    [animation setType:kCATransitionPush];
    [animation setSubtype: kCATransitionFromLeft];
    [self.view.superview.layer addAnimation:animation forKey:@"Reveal"];
    if (_isfromcart) {
        [SharedDelegate enterCartRoot];
    }
    [self removeSelf];
    
}

#pragma mark 响应列表按钮事件
-(void)accessoryButtonTap:(UIControl *)button withEvent:(UIEvent *)event{
	NSIndexPath *indexPath=[_mTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:_mTableView]];//获得NSIndexPath
	if (indexPath==nil) {
		return;
	}
    else
    {
		_currentActionIndex=[indexPath row];//获得选择的第几行
//        id obj = [self.browseArray objectAtIndex:_currentActionIndex];
//        if ([obj isKindOfClass:[ProductVO class]])
//        {
//            ProductVO *productVO= obj;
//            if ([productVO.canBuy isEqualToString:@"true"])
//            {
                _currentState = BR_BUY_STATE;
                [self setUpThread:NO];
//            }
//        }
	}
}

#pragma mark 显示Sheet列表
-(void)showSheetView{
	UIActionSheet *sheet=[[OTSActionSheet alloc] initWithTitle:@"确定清空全部的浏览历史？" delegate:self cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:@"确定"
                                             otherButtonTitles:nil,nil];
	[sheet showInView:[UIApplication sharedApplication].keyWindow];
	[sheet release];
	sheet=nil;
}

#pragma mark 挑选商品
-(void)gotoSelectProduct
{
    [SharedDelegate enterHomePageRoot];
}

#pragma mark UIActionSheet回调函数
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
	switch (buttonIndex) {
        case 0:// 删除全部－清空所有历史浏览
            _currentState = BR_DEL_STATE;
            self._delProductId = nil;
            self._delGrouponId = nil;
            [self setUpThread:YES];
            break;
        default:
            break;
    }
}
#pragma mark    购物车动画
-(void)showBuyProductAnimation {
	[self startAnimation];
    [SharedDelegate setCartNum:1];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
}

-(void)startAnimation {
    ProductInfo *productVO = [self.browseArray objectAtIndex:_currentActionIndex];
    NSString* imageURLStr = [productVO productImageUrl];
    
    // 算出对应的图片坐标
    UITableViewCell* cell = [_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentActionIndex inSection:0]];
    CGPoint point = cell.imageView.center;
    point = [cell.imageView convertPoint:point toView:self.view];
    
    UIImageView* imageV = [[[UIImageView alloc]init]autorelease];
    [imageV setImageWithURL:[NSURL URLWithString:imageURLStr] refreshCache:NO placeholderImage:[UIImage imageNamed:@"defaultimg76"]];
    
    [cartAnimation beginCartAnimationWithProductImageView:imageV point:point];
    
	if (_isAnimStop) {
        [SharedDelegate showAddCartAnimationWithDelegate:self];
		_isAnimStop=NO;
	}
}

-(void)animationFinished
{
    _isAnimStop=YES;
}

-(void)newThreadAddBrowse:(ProductVO *)productVO
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    BrowseService *bServ=[[[BrowseService alloc] init] autorelease];
    int rowcount = [bServ queryBrowseHistoryByIdCount:productVO.productId];
    @try {
        if (rowcount) {
            //productid存在则更新
            [bServ updateBrowseHistory:productVO provice:PROVINCE_ID];
        }
        else {
            [bServ saveBrowseHistory:productVO province:PROVINCE_ID];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefleshImmediately" object:nil];
    [pool drain];
}

-(void)newThreadAddGrouponBrowse:(GrouponVO *)groupon
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    BrowseService *bServ=[[[BrowseService alloc] init] autorelease];
    int rowcount = [bServ queryGrouponBrowseHistoryByIdCount:groupon.nid];
    @try {
        if (rowcount) {
            //存在则更新
            [bServ updateGrouponBrowseHistory:groupon provice:PROVINCE_ID];
            
        }
        else {
            [bServ saveGrouponBrowseHistory:groupon province:PROVINCE_ID];
        }
        [bServ savefkToBrowse:groupon.nid];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefleshImmediately" object:nil];
    [pool drain];
}

- (void)viewDidUnload
{
    if (_browseArray!=nil) {
        [_browseArray release];
        _browseArray=nil;
    }
    if (_noProductView!=nil) {
        [_noProductView release];
        _noProductView=nil;
    }
    if (_mTableView!=nil) {
        [_mTableView release];
        _mTableView=nil;
    }
	if (_backView!=nil) {
        [_backView release];
        _backView=nil;
    }
    OTS_SAFE_RELEASE(_mEditBtn);
    OTS_SAFE_RELEASE(_cellNib);
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc
{
    if (_browseArray!=nil) {
        [_browseArray release];
        _browseArray=nil;
    }
    if (_noProductView!=nil) {
        [_noProductView release];
        _noProductView=nil;
    }
    if (_mTableView!=nil) {
        [_mTableView release];
        _mTableView=nil;
    }
	if (_backView!=nil) {
        [_backView release];
        _backView=nil;
    }
    OTS_SAFE_RELEASE(_mEditBtn);
    OTS_SAFE_RELEASE(_delProductId);
    OTS_SAFE_RELEASE(_cellNib);
    OTS_SAFE_RELEASE(_grouponAreaId);
    OTS_SAFE_RELEASE(cartAnimation);
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
