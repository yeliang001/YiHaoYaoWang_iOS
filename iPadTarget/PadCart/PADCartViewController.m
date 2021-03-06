//
//  PADCartViewController.m
//  TheStoreApp
//
//  Created by huang jiming on 12-11-16.
//
//

#define DEFAULT_COLOR   [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0]
#define MALLENTRANCEHEIGHT 53
#import "PADCartViewController.h"
#import "CartService.h"
#import "PADCartTableView.h"
#import "PADCartTableViewCell.h"
#import "FavoriteService.h"
#import "ProductService.h"
#import "OrderService.h"
#import "OTSPadProductDetailVC.h"
#import "PADCartBuyRecordColumnCell.h"
#import "PADCartProductColumnCell.h"
#import "LoginViewController.h"
#import "OtspOrderConfirmVC.h"
#import "WebViewController.h"
#import "GTMBase64.h"
@implementation PADCartViewController
@synthesize needShowTips;
@synthesize isExiteGiftToBeUse;
@synthesize m_Login;

-(BOOL)threadRunning
{
    return m_ThreadRunning;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCartUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeLoginView:) name:@"kcloseloginview" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelf:) name:@"UpdateCartNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleProVinceChange:)name:kNotifyProvinceChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isexitegifttobeuse:) name:@"ExiteGiftToBeUseNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCartCache:) name:kNotifyCartCacheChange object:nil];
    
}

-(void)initCartUI
{
    m_LoadingView=[[OtsPadLoadingView alloc] init];
    [m_LoadingView showInView:self.view withFrame:CGRectMake(0, 0, 1024, 748)];
    [[NSRunLoop mainRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    m_CartVO=[[DataHandler sharedDataHandler].cart retain];
    //标题栏
    UIImageView *titleBg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 53)];
    [titleBg setImage:[UIImage imageNamed:@"pad_title_bg.png"]];
    [self.view addSubview:titleBg];
    [titleBg release];
    
    UIButton *closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(20, 8, 73, 38)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"pad_red_short.png"] forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"pad_red_short_h.png"] forState:UIControlStateHighlighted];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [[closeBtn titleLabel] setTextColor:[UIColor whiteColor]];
    [[closeBtn titleLabel] setFont:[UIFont systemFontOfSize:20.0]];
    [[closeBtn titleLabel] setShadowColor:[UIColor darkTextColor]];
    [[closeBtn titleLabel] setShadowOffset:CGSizeMake(0, -1)];
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn release];
    
//    UIButton* mallCartBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    mallCartBtn.frame=CGRectMake(1024-, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    UILabel *titleText=[[UILabel alloc] initWithFrame:CGRectMake(412, 0, 200, 53)];
    [titleText setBackgroundColor:[UIColor clearColor]];
    [titleText setText:@"我的购物车"];
    [titleText setTextColor:[UIColor whiteColor]];
    [titleText setFont:[UIFont systemFontOfSize:23.0]];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setShadowColor:[UIColor darkTextColor]];
    [titleText setShadowOffset:CGSizeMake(0, -1)];
    [self.view addSubview:titleText];
    [titleText release];
    
    m_ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 53, 1024, 695)];
    [m_ScrollView setDelegate:self];
    [m_ScrollView setContentSize:CGSizeMake(1024, TABVIEW_Y+TABVIEW_HEIGHT)];
    [self.view insertSubview:m_ScrollView belowSubview:titleBg];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateCartUI];
    });
           
    //    [self newThreadGetCart];
}

-(void)initMallEntrance{
    if (MallCartEntrance==nil) {
        MallCartEntrance=[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width, FLOATVIEW_HEIGHT/2)];
        MallCartEntrance.backgroundColor=[UIColor clearColor];
        UIButton* but=[UIButton buttonWithType:UIButtonTypeCustom];
        [but setBackgroundImage:[UIImage imageNamed:@"toMallCart_unsel"] forState:UIControlStateNormal];
        [but setBackgroundImage:[UIImage imageNamed:@"toMallCart_sel"] forState:UIControlStateHighlighted];
        but.frame=CGRectMake(20, 15, 168, 42);
        [but addTarget:self action:@selector(toMallView) forControlEvents:UIControlEventTouchUpInside];
        [MallCartEntrance addSubview:but];
        
        MallCartEntranceLab=[[UILabel alloc] initWithFrame:CGRectMake(200, 25, 150, 42)];
        MallCartEntranceLab.font=[UIFont systemFontOfSize:18];
        MallCartEntranceLab.adjustsFontSizeToFitWidth=YES;
        [MallCartEntrance addSubview:MallCartEntranceLab];
        [MallCartEntranceLab release];
        
        UILabel* des=[[UILabel alloc] initWithFrame:CGRectMake(350, 25, 300, 42)];
        des.font=[UIFont systemFontOfSize:14];
        des.textColor=[UIColor grayColor];
        des.text=@"1号商城和1号药店的商品需要分开结算。";
        [MallCartEntrance addSubview: des];
        [des release];
        [m_ScrollView addSubview:MallCartEntrance];
        [MallCartEntrance release];
    }
    MallCartEntranceLab.text=[NSString stringWithFormat:@"共%@件,¥ %.2f",m_CartVO.totalquantityMall,m_CartVO.totalpriceMall.floatValue];
}

-(void)toMallView{
    NSString *urlStr = @"http://m.1mall.com/mw/cart";
    if ([GlobalValue getGlobalValueInstance].token == nil) {
        urlStr = [urlStr stringByAppendingFormat:@"?osType=%d&provinceId=%@",40,[GlobalValue getGlobalValueInstance].provinceId];
    } else {
        // 对 token 进行base64加密
        NSData *b64Data = [GTMBase64 encodeData:[[GlobalValue getGlobalValueInstance].token dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *b64Str = [[[NSString alloc] initWithData:b64Data encoding:NSUTF8StringEncoding] autorelease];
        urlStr = [urlStr stringByAppendingFormat:@"?osType=%d&token=%@&provinceId=%@",40,b64Str,[GlobalValue getGlobalValueInstance].provinceId];
    }
        WebViewController* web=[[WebViewController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) WapType:5 URL:urlStr];
        web.isFirstToMallWeb=YES;
        [web customSizeWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:web.view];
}

//刷新购物车UI
-(void)updateCartUI
{
    //购物车数字修改
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartChange object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartReload object:nil];
    BOOL hasMallCart=NO;
    if (m_CartVO.totalquantityMall.intValue) {
        hasMallCart=YES;
        if ([GlobalValue getGlobalValueInstance].token) {
        [self initMallEntrance];
        }
    }else{
        if (MallCartEntrance!=nil) {
            [MallCartEntrance removeFromSuperview];
        }
    }
    if (m_CartVO!=nil && m_CartVO.buyItemList!=nil && [m_CartVO.buyItemList count]>0) {
        //显示table view
        CGRect rect=TABLEVIEW_FRAME;
        if (hasMallCart) {
            rect=CGRectMake(TABLEVIEW_FRAME.origin.x, TABLEVIEW_FRAME.origin.y+MALLENTRANCEHEIGHT, TABLEVIEW_FRAME.size.width, TABLEVIEW_FRAME.size.height-MALLENTRANCEHEIGHT);
        }
        if (m_CartTableView==nil) {
            m_CartTableView=[[PADCartTableView alloc] initWithFrame:rect promotions:needShowTips cartVO:m_CartVO delegate:self];
            [m_ScrollView addSubview:m_CartTableView];
        }
        else {
            if (m_UpdateTableView) {
                m_CartTableView.frame=rect;
                m_UpdateTableView=NO;
                [m_CartTableView updateWithCartVO:m_CartVO promotions:needShowTips delegate:self];
            }
            [m_CartTableView setHidden:NO];
        }
        //隐藏空态页面
        [m_NilView setHidden:YES];
    } else {
        //隐藏table view
        [m_CartTableView setHidden:YES];
        CGRect rect=CGRectMake(212, 150, 600, 350);
        if (hasMallCart) {
            rect=CGRectMake(212, 150+MALLENTRANCEHEIGHT, 600, 350);
        }
        //显示空态页面
        if (m_NilView==nil) {
            m_NilView=[[UIView alloc] initWithFrame:rect];
            [m_ScrollView addSubview:m_NilView];
            
            UIImageView *nilImage=[[UIImageView alloc] initWithFrame:CGRectMake(195, 0, 210, 210)];
            [nilImage setImage:[UIImage imageNamed:@"cart_buyrecord_nil.png"]];
            [m_NilView addSubview:nilImage];
            [nilImage release];
            
            UILabel *nilLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 210, 600, 30)];
            [nilLabel setText:@"您还没选中商品呢？"];
            [nilLabel setTextColor:[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0]];
            [nilLabel setFont:[nilLabel.font fontWithSize:20.0]];
            [nilLabel setTextAlignment:NSTextAlignmentCenter];
            [m_NilView addSubview:nilLabel];
            [nilLabel release];
            
            nilLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 240, 600, 30)];
            [nilLabel setText:@"马上去挑选中意的商品，加入购物车吧！"];
            [nilLabel setTextColor:[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0]];
            [nilLabel setFont:[nilLabel.font fontWithSize:20.0]];
            [nilLabel setTextAlignment:NSTextAlignmentCenter];
            [m_NilView addSubview:nilLabel];
            [nilLabel release];
            
            UIButton *shopBtn=[[UIButton alloc] initWithFrame:CGRectMake(212, 300, 177, 46)];
            [shopBtn setBackgroundImage:[UIImage imageNamed:@"red_mid.png"] forState:UIControlStateNormal];
            [shopBtn setTitle:@"去购物" forState:UIControlStateNormal];
            [shopBtn.titleLabel setShadowColor:[UIColor darkTextColor]];
            [shopBtn.titleLabel setShadowOffset:CGSizeMake(0, -1)];
            [shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [shopBtn.titleLabel setFont:[shopBtn.titleLabel.font fontWithSize:20.0]];
            [shopBtn addTarget:self action:@selector(goShopBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [m_NilView addSubview:shopBtn];
            [shopBtn release];
        }
        else {
            m_NilView.frame=rect;
            [m_NilView setHidden:NO];
        }
    }
    
    //tab
    CGRect rect=TABVIEW_FRAME;
    if (hasMallCart) {
        rect=CGRectMake(TABVIEW_FRAME.origin.x, TABVIEW_FRAME.origin.y, TABVIEW_FRAME.size.width, TABVIEW_FRAME.size.height);
    }

        if (m_CartTabView==nil) {
            m_CartTabView=[[PADCartTabView alloc] initWithFrame:rect cartVO:m_CartVO delegate:self];
            [m_LoadingView hide];
            //这里影响购物车速度，空转一个消息刷新ui避免白屏等待
            [[NSRunLoop mainRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            [m_ScrollView addSubview:m_CartTabView];
        } else {
            if (m_UpdateTabView) {
                m_UpdateTabView=NO;
                m_CartTabView.frame=rect;
                [m_CartTabView updateWithCartVO:m_CartVO];
            }
        }
        //浮层
        if (m_FloatView==nil) {
            m_FloatView=[[PADCartFloatView alloc] initWithFrame:FLOATVIEW_FRAME cartVO:m_CartVO delegate:self];
            [self.view insertSubview:m_FloatView aboveSubview:m_ScrollView];
        } else {
            if (m_UpdateFloatView) {
                m_UpdateFloatView=NO;
                [m_FloatView updateWithCartVO:m_CartVO];
            }
        }
        //登录、注册入口
    CGRect rect1=CGRectMake(600, TABVIEW_Y, 424, 41);
    if (hasMallCart) {
        rect1=CGRectMake(600, TABVIEW_Y, 424, 41);
    }

        if ([GlobalValue getGlobalValueInstance].token!=nil) {
            [m_LoginView setHidden:YES];
        } else {
            if (m_LoginView==nil) {
                m_LoginView=[[UIView alloc] initWithFrame:rect1];
                [m_ScrollView addSubview:m_LoginView];
                
                UILabel *loginLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 424, 41)];
                [loginLabel setBackgroundColor:[UIColor clearColor]];
                [loginLabel setText:@"请登录来同步您的购物车           还没有账户？"];
                [loginLabel setFont:[loginLabel.font fontWithSize:17.0]];
                [m_LoginView addSubview:loginLabel];
                [loginLabel release];
                
                UIButton *loginBtn=[[UIButton alloc] initWithFrame:CGRectMake(170, 0, 80, 41)];
                [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
                [loginBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [loginBtn.titleLabel setFont:[loginBtn.titleLabel.font fontWithSize:17.0]];
                [loginBtn addTarget:self action:@selector(showLoginView) forControlEvents:UIControlEventTouchUpInside];
                [m_LoginView addSubview:loginBtn];
                [loginBtn release];
                
                UIButton *registBtn=[[UIButton alloc] initWithFrame:CGRectMake(325, 0, 80, 41)];
                [registBtn setTitle:@"注册" forState:UIControlStateNormal];
                [registBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [registBtn.titleLabel setFont:[registBtn.titleLabel.font fontWithSize:17.0]];
                [registBtn addTarget:self action:@selector(showLoginView) forControlEvents:UIControlEventTouchUpInside];
                [m_LoginView addSubview:registBtn];
                [registBtn release];
            } else {
                m_LoginView.frame=rect1;
                [m_LoginView setHidden:NO];
            }
        }
}

#pragma mark - 新线程
//新线程获取购物车
-(void)newThreadGetCart
{
    if ([GlobalValue getGlobalValueInstance].token!=nil) {
        if (!m_ThreadRunning) {
            m_ThreadRunning=YES;
            [m_LoadingView showInView:self.view withFrame:CGRectMake(0, 0, 1024, 748)];
            [self performInThreadBlock:^{
                NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                CartService *cServ=[[[CartService alloc] init] autorelease];
                CartVO *tempCartVO;
                @try {
                    tempCartVO=[cServ getSessionCart:[GlobalValue getGlobalValueInstance].token];
                }
                @catch (NSException *exception) {
                }
                @finally {
                    if (m_CartVO!=nil) {
                        [m_CartVO release];
                    }
                    if (tempCartVO!=nil && ![tempCartVO isKindOfClass:[NSNull class]]) {
                        m_CartVO=[tempCartVO retain];
                    } else {
                        m_CartVO=nil;
                    }
                    //缓存购物车数据
                    [[DataHandler sharedDataHandler] setCart:m_CartVO];
                }
                [pool drain];
            }completionInMainBlock:^{
                m_ThreadRunning=NO;
                [m_LoadingView hide];
                [self updateCartUI];
            }];
        }
    } else {
        if (m_CartVO!=nil) {
            [m_CartVO release];
        }
        m_CartVO=[[DataHandler sharedDataHandler].cart retain];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateCartUI];
        });
    }
}

//新线程设置商品数量
-(void)newThreadSetCount:(int)count forCartItem:(CartItemVO *)cartItemVO;
{
    if ([GlobalValue getGlobalValueInstance].token!=nil) {
        if (!m_ThreadRunning) {
            m_ThreadRunning=YES;
            [m_LoadingView showInView:self.view withFrame:CGRectMake(0, 0, 1024, 748)];
            
            __block UpdateCartResult *result;
            [self performInThreadBlock:^{
                NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                CartService *cartSer=[[[CartService alloc] init] autorelease];
                ProductVO *productVO=cartItemVO.product;
                @try {
                    //result=[[cartSer updateCartItemQuantityV2:[GlobalValue getGlobalValueInstance].token productId:[productVO productId] merchantId:[productVO merchantId] quantity:[NSNumber numberWithInt:count] updateType:cartItemVO.updateType promotionId:[productVO promotionId]] retain];
                    if (productVO.promotionId && [productVO.promotionId rangeOfString:@"landingpage"].location!=NSNotFound) {
                        result = [[cartSer updateLandingpageProductQuantity:[GlobalValue getGlobalValueInstance].token productId:[productVO productId] merchantId:[productVO merchantId] quantity:[NSNumber numberWithInt:count] promotionId:productVO.promotionId]retain];
                    }else if(productVO.promotionId==nil||[productVO.promotionId isEqualToString:@""]){
                        result = [[cartSer updateNormalProductQuantity:[GlobalValue getGlobalValueInstance].token productId:[productVO productId] merchantId:[productVO merchantId] quantity:[NSNumber numberWithInt:count]]retain];
                    }
                }
                @catch (NSException *exception) {
                }
                @finally {
                }
                [pool drain];
            } completionInMainBlock:^{
                m_ThreadRunning=NO;
                [m_LoadingView hide];
                
                if (result!=nil && ![result isKindOfClass:[NSNull class]]) {
                    if ([[result resultCode] intValue]==1) {//成功
                        m_UpdateTableView=YES;
                        m_UpdateTabView=YES;
                        m_UpdateFloatView=YES;
                        [self newThreadGetCart];
                    } else {
                        [self showError:result.errorInfo];
                    }
                } else {
                    [self showError:@"修改商品数量失败"];
                }
                [result release];
            }];
        }
    } else {
        [[DataHandler sharedDataHandler] localCartProduct:cartItemVO.product setCount:count];
        
        m_UpdateTableView=YES;
        m_UpdateTabView=YES;
        m_UpdateFloatView=YES;
        [self newThreadGetCart];
    }
}

//新线程删除商品
-(void)newThreadDeleteCartItem:(CartItemVO *)cartItemVO
{
    if ([GlobalValue getGlobalValueInstance].token!=nil) {
        if (!m_ThreadRunning) {
            m_ThreadRunning=YES;
            [m_LoadingView showInView:self.view withFrame:CGRectMake(0, 0, 1024, 748)];
            
            __block int result;
            [self performInThreadBlock:^{
                NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                CartService *cartSer=[[[CartService alloc] init] autorelease];
                ProductVO *productVO=cartItemVO.product;
                @try {
                    //result=[cartSer delProduct:[GlobalValue getGlobalValueInstance].token productId:productVO.productId merchantId:productVO.merchantId updateType:cartItemVO.updateType promotionid:productVO.promotionId];
                    result = [cartSer deleteSingleProduct:[GlobalValue getGlobalValueInstance].token productId:productVO.productId merchantId:productVO.merchantId promotionid:productVO.promotionId];
                }
                @catch (NSException *exception) {
                }
                @finally {
                }
                [pool drain];
            } completionInMainBlock:^{
                m_ThreadRunning=NO;
                [m_LoadingView hide];
                
                if (result==1) {
                    m_UpdateTableView=YES;
                    m_UpdateTabView=YES;
                    m_UpdateFloatView=YES;
                    //删除含赠品的购物车item时，重置赠品提示信息
                    if (cartItemVO.product.hasGift) {
                        isExiteGiftToBeUse = NO;
                    }
                    [self newThreadGetCart];
                } else {
                    [self showError:@"删除失败"];
                }
            }];
        }
    } else {
        [[DataHandler sharedDataHandler] deleteLocalCartItem:cartItemVO];
        
        m_UpdateTableView=YES;
        m_UpdateTabView=YES;
        m_UpdateFloatView=YES;
        [self newThreadGetCart];
    }
}

//新线程添加收藏
-(void)newThreadAddFavoriteForCartItem:(CartItemVO *)cartItemVO cell:(PADCartTableViewCell *)cell
{
    if ([GlobalValue getGlobalValueInstance].token!=nil) {
        if (!m_ThreadRunning) {
            m_ThreadRunning=YES;
            [m_LoadingView showInView:self.view withFrame:CGRectMake(0, 0, 1024, 748)];
            
            __block int result;
            [self performInThreadBlock:^{
                NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                FavoriteService *fServ=[[[FavoriteService alloc] init] autorelease];
                result=[fServ addFavorite:[GlobalValue getGlobalValueInstance].token tag:nil productId:cartItemVO.product.productId];
                [pool drain];
            }completionInMainBlock:^{
                m_ThreadRunning=NO;
                [m_LoadingView hide];
                
                if (result==1) {
                    [cell showFavoriteTip:CARTITEM_FAVORITE_SUCCESS];
                    //收藏夹刷新
                    [m_CartTabView.favoritesView updateSelf];
                } else if (result==-1) {
                    [cell showFavoriteTip:CARTITEM_HAVE_FAVORITED];
                } else {
                    //do nothing
                }
            }];
        }
    } else {
        //登录
        [self showLoginView];
    }
}

//新线程清空购物车
-(void)newThreadClearCart
{
    if ([GlobalValue getGlobalValueInstance].token!=nil) {
        if (!m_ThreadRunning) {
            m_ThreadRunning=YES;
            [m_LoadingView showInView:self.view withFrame:CGRectMake(0, 0, 1024, 748)];
            
            __block int result;
            [self performInThreadBlock:^{
                NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                CartService *cartSer=[[[CartService alloc] init] autorelease];
                @try {
                    result=[cartSer delAllProduct:[GlobalValue getGlobalValueInstance].token];
                }
                @catch (NSException *exception) {
                }
                @finally {
                }
                [pool drain];
            } completionInMainBlock:^{
                m_ThreadRunning=NO;
                [m_LoadingView hide];
                
                if (result==1) {
                    m_UpdateTableView=YES;
                    m_UpdateTabView=YES;
                    m_UpdateFloatView=YES;
                    //清空购物车
                    [dataHandler resetCart];
                    [self newThreadGetCart];
                } else {
                    [self showError:@"清空购物车失败"];
                }
            }];
        }
    } else {
        [[DataHandler sharedDataHandler] clearLocalCart];
        
        m_UpdateTableView=YES;
        m_UpdateTabView=YES;
        m_UpdateFloatView=YES;
        [self newThreadGetCart];
    }
}

//新线程领取赠品和换购
-(void)newThreadReceivePromotion:(ProductVO *)product withTarget:(id)target selector:(SEL)selector object:(id)object
{
    if ([GlobalValue getGlobalValueInstance].token!=nil) {
        if (!m_ThreadRunning) {
            m_ThreadRunning=YES;
            [m_LoadingView showInView:self.view withFrame:CGRectMake(0, 0, 1024, 748)];
            
//            __block int result;
//            __block NSArray *tempArray=[theArray retain];
            __block AddProductResult* reuslt=nil;
            [self performInThreadBlock:^{
                NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
//                ProductService *pServ=[[ProductService alloc] init];
//                NSMutableArray *productIdArray=[[NSMutableArray alloc] init];
//                NSMutableArray *promotionIdArray=[[NSMutableArray alloc] init];
//                NSMutableArray *merchantIdArray=[[NSMutableArray alloc] init];
//                NSMutableArray *quantityArray=[[NSMutableArray alloc] init];
                if ([GlobalValue getGlobalValueInstance].token!=nil) {
                    //int i;
                    //使用新的轻量级接口
                    CartService*ser=[[CartService alloc] init];
                    reuslt=[[ser addPromotionProduct:[GlobalValue getGlobalValueInstance].token productId:product.productId merchantId:product.merchantId quantity:product.quantity promotionid:product.promotionId] retain];
//                    for (i=0; i<[tempArray count]; i++) {
//                        CartItemVO *cartItemVO=[tempArray objectAtIndex:i];
//                        ProductVO *productVO=cartItemVO.product;
//                        if (productVO!=nil) {
//                            [productIdArray addObject:[NSNumber numberWithInt:[productVO.productId intValue]]];
//                            if (productVO.promotionId!=nil) {
//                                [promotionIdArray addObject:[NSString stringWithString:productVO.promotionId]];
//                            } else {
//                                [promotionIdArray addObject:@""];
//                            }
//                            [merchantIdArray addObject:[NSNumber numberWithInt:[productVO.merchantId intValue]]];
//                            [quantityArray addObject:[NSNumber numberWithInt:[productVO.quantity intValue]]];
//                        }
//                    }
//                    result=[pServ updateCartPromotion:[GlobalValue getGlobalValueInstance].token giftProductIdList:productIdArray promotionIdList:promotionIdArray merchantIdList:merchantIdArray quantityList:quantityArray Type:1];
                }
//                [productIdArray release];
//                [promotionIdArray release];
//                [merchantIdArray release];
//                [quantityArray release];
//                [pServ release];
                [pool drain];
            } completionInMainBlock:^{
                m_ThreadRunning=NO;
                [m_LoadingView hide];
                
                //[tempArray release];
                if (reuslt.resultCode.intValue==1) {
                    //领取、换购成功显示tip
                    if ([target respondsToSelector:selector]) {
                        [target performSelector:selector withObject:object];
                    }
                    [self newThreadGetCart];
                } else {
                    [m_LoadingView hide];
                    [m_CartTabView updateWithCartVO:m_CartVO];
                    [self showError:@"领取失败"];
                }
            }];
        }
    } else {
        //登录
        [self showLoginView];
    }
}

//新线程重新购买
-(void)newThreadRebuyOrder:(OrderV2 *)orderV2
{
    if ([GlobalValue getGlobalValueInstance].token!=nil) {
        if (!m_ThreadRunning) {
            m_ThreadRunning=YES;
            [m_LoadingView showInView:self.view withFrame:CGRectMake(0, 0, 1024, 748)];
            
            __block int result;
            [self performInThreadBlock:^{
                NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                OrderService *oServ=[[[OrderService alloc] init] autorelease];
                result=[oServ rebuyOrder:[GlobalValue getGlobalValueInstance].token orderId:orderV2.orderId];
                [pool drain];
            }completionInMainBlock:^{
                m_ThreadRunning=NO;
                [m_LoadingView hide];
                
                if (result==1) {
                    m_UpdateTableView=YES;
                    m_UpdateTabView=YES;
                    m_UpdateFloatView=YES;
                    [self newThreadGetCart];
                } else {
                    [self showError:@"重新购买失败"];
                }
            }];
        }
    } else {
        //登录
        [self showLoginView];
    }
}

//新线程添加商品到购物车
-(void)newThreadAddProduct:(ProductVO *)productVO
{
    if ([GlobalValue getGlobalValueInstance].token!=nil) {
        if (!m_ThreadRunning) {
            m_ThreadRunning=YES;
            [m_LoadingView showInView:self.view withFrame:CGRectMake(0, 0, 1024, 748)];
            
            __block AddProductResult *addProductResult;
            [self performInThreadBlock:^{
                NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                int quantity=1;
                NSString *promotionId=@"";
                if (productVO.promotionId!=nil) {
                    promotionId=productVO.promotionId;
                }
                
                CartService *cServ=[[[CartService alloc] init] autorelease];
                @try {
//                    AddProductResult *result=[cServ addProductV2:[GlobalValue getGlobalValueInstance].token productId:[productVO productId] merchantId:[productVO merchantId] quantity:[NSNumber numberWithInt:quantity] promotionid:promotionId];
                    AddProductResult *result=[cServ addSingleProduct:[GlobalValue getGlobalValueInstance].token productId:[productVO productId] merchantId:[productVO merchantId] quantity:[NSNumber numberWithInt:quantity] promotionid:promotionId];
                    if (result!=nil && ![result isKindOfClass:[NSNull class]]) {
                        addProductResult=[result retain];
                    } else {
                        addProductResult=nil;
                    }
                }
                @catch (NSException *exception) {
                }
                @finally {
                }
                [pool drain];
            }completionInMainBlock:^{
                if (addProductResult!=nil) {
                    m_ThreadRunning=NO;
                    [m_LoadingView hide];
                    
                    if ([[addProductResult resultCode] intValue]==1) {//成功
                        m_UpdateTableView=YES;
                        m_UpdateTabView=YES;
                        m_UpdateFloatView=YES;
                        [self newThreadGetCart];
                    } else {
                        [self showError:[addProductResult errorInfo]];
                    }
                } else {
                    [self showError:@"加入购物车失败"];
                }
            }];
        }
    } else {
        [[DataHandler sharedDataHandler] localCartProduct:productVO addCount:1];
        
        m_UpdateTableView=YES;
        m_UpdateTabView=YES;
        m_UpdateFloatView=YES;
        [self newThreadGetCart];
    }
}

//新线程创建订单
-(void)newThreadCreateOrder
{
    if ([GlobalValue getGlobalValueInstance].token!=nil) {
        if (!m_ThreadRunning) {
            m_ThreadRunning=YES;
            [m_LoadingView showInView:self.view withFrame:CGRectMake(0, 0, 1024, 748)];
            
            __block CreateOrderResult *result;
            [self performInThreadBlock:^{
                NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                OrderService *oServ=[[[OrderService alloc] init] autorelease];
                CreateOrderResult *tempResult=[oServ createSessionOrderV2:[GlobalValue getGlobalValueInstance].token];
                if (tempResult!=nil && ![tempResult isKindOfClass:[NSNull class]]) {
                    result=[tempResult retain];
                } else {
                    result=nil;
                }
                [pool drain];
            }completionInMainBlock:^{
                m_ThreadRunning=NO;
                [m_LoadingView hide];
                
                if (result!=nil) {
                    if ([result.resultCode intValue]==1) {
                        [self.navigationController pushViewController:[[[OtspOrderConfirmVC alloc] init] autorelease] animated:YES];
                    } else {
                        [self showError:result.errorInfo];
                    }
                } else {
                    //do nothing
                }
                [result release];
            }];
        }
    } else {
        //登录
        [self showLoginView];
    }
}

//关闭
-(void)closeBtnClicked:(id)sender
{
    CATransition *transition=[OTSNaviAnimation transactionFade];
    transition.delegate=self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    if (m_NeedPopToRootWhenQuit)
    {
        m_NeedPopToRootWhenQuit=NO;
        [SharedPadDelegate.navigationController popToRootViewControllerAnimated:NO];
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

//进入商品详情
-(void)enterProductDetail:(ProductVO *)productVO
{
    CATransition *transition = [CATransition animation];
    transition.duration = OTSP_TRANS_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade; //@"cube";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    OTSPadProductDetailVC *vc=[[[OTSPadProductDetailVC alloc] init] autorelease];
    vc.product=productVO;
    [self.navigationController pushViewController:vc animated:NO];
    
    //刷新最近浏览
    [m_CartTabView.browseHistory updateSelf];
}

//拉下float view
-(void)pullDownFloatViewIfNeed
{
    if (m_FloatView.frame.origin.y==-106) {
        [UIView animateWithDuration:0.3f animations:^{[m_FloatView setFrame:CGRectMake(20, 53, FLOATVIEW_WIDTH, FLOATVIEW_HEIGHT)];} completion:^(BOOL finished){
        }];
    }
    [m_FloatView showDragPrompt];
}

//推上float view
-(void)pushUpFloatViewIfNeed
{
    if (m_ScrollView.contentOffset.y<448 && m_FloatView.frame.origin.y==53) {
        [UIView animateWithDuration:0.3f animations:^{[m_FloatView setFrame:CGRectMake(20, -106, FLOATVIEW_WIDTH, FLOATVIEW_HEIGHT)];} completion:^(BOOL finished){
        }];
    }
    [m_FloatView hideDragPrompt];
}

//显示登录
-(void)showLoginView
{
    if (m_LoginRegistView==nil) {
        m_LoginRegistView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        [self.view addSubview:m_LoginRegistView];
        
        //半透背景
        UIView * bg=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        [bg setBackgroundColor:[UIColor grayColor]];
        [bg setAlpha:0.5];
        [m_LoginRegistView addSubview:bg];
        [bg release];
    } else {
        [self.view addSubview:m_LoginRegistView];
    }
    
    self.m_Login=[[LoginViewController alloc] init];
    [m_Login setMcart:m_CartVO];
    if (m_CartVO.totalquantity!=0) {
        [m_Login setMneedToAddInCart:YES];
    }
    [m_LoginRegistView addSubview:m_Login.view];
    
    //动画
    [m_Login.view setFrame:CGRectMake(1024, 0, 1024, 768)];
    [UIView animateWithDuration:0.3 animations:^{
        [m_Login.view setFrame:CGRectMake(104, 0, 1024, 768)];
    } completion:^(BOOL finished){
    }];
}

//去购物
-(void)goShopBtnClicked:(id)sender
{
    CATransition *transition=[CATransition animation];
    transition.duration=OTSP_TRANS_DURATION;
    transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type=kCATransitionFade;
    transition.subtype=kCATransitionFromRight;
    transition.delegate=self;
    [SharedPadDelegate.navigationController.view.layer addAnimation:transition forKey:nil];
    [SharedPadDelegate.navigationController popToRootViewControllerAnimated:NO];
}

-(void)deletePromotion:(ProductVO*)product withTarget:(id)target selector:(SEL)selector object:(id)object{
    __block int result;
    [m_LoadingView showInView:self.view];
    [self performInThreadBlock:^{
        CartService* ser=[[CartService alloc] init];
         result=[ser deletePromotionProduct:[GlobalValue getGlobalValueInstance].token productId:product.productId merchantId:product.merchantId promotionId:product.promotionId];
    } completionInMainBlock:^{
        if (result==1) {
            [self updateSelf:nil];
        }else{
            [m_LoadingView hide];
            [m_CartTabView updateWithCartVO:m_CartVO];
            [self showError:@"删除失败"];
        }
    }];
}

-(void)selectPromotion:(ProductVO*)product withTarget:(id)target selector:(SEL)selector object:(id)object{
    __block AddProductResult* result=nil;
    [m_LoadingView showInView:self.view];
    [self performInThreadBlock:^{
        CartService* ser=[[CartService alloc] init];
        result=[[ser addSingleProduct:[GlobalValue getGlobalValueInstance].token productId:product.productId merchantId:product.merchantId quantity:[NSNumber numberWithInt:1] promotionid:product.promotionId] retain];
    } completionInMainBlock:^{
        if (result.resultCode.intValue==1) {
            //领取、换购成功显示tip
            if ([target respondsToSelector:selector]) {
                [target performSelector:selector withObject:object];
            }
            [self updateSelf:nil];
        } else {
            [m_LoadingView hide];
            [m_CartTabView updateWithCartVO:m_CartVO];
            [self showError:@"领取失败"];
        }
        [result release];
    }];
}

#pragma mark - NSNotification
-(void)closeLoginView:(NSNotification *)notification
{
    [UIView animateWithDuration:0.5 animations:^{
        [m_Login.view setFrame:CGRectMake(1024, 0, 1024, 768)];
    } completion:^(BOOL finished) {
        [m_LoginRegistView removeFromSuperview];
    }];
}

-(void)updateSelf:(NSNotification *)notification
{
    m_UpdateTableView=YES;
    m_UpdateTabView=YES;
    m_UpdateFloatView=YES;
    [self newThreadGetCart];
}

-(void)updateCartCache:(NSNotification *)notification
{
    m_CartVO=[[DataHandler sharedDataHandler].cart retain];
    m_UpdateTabView=YES;
    m_UpdateTableView = YES;
    m_UpdateFloatView = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateCartUI];
    });
}

-(void)isexitegifttobeuse:(NSNotification *)notification
{
    NSString * notifyStr = (NSString *)notification.object;
    if ([notifyStr isEqualToString:@"YES"]) {
        isExiteGiftToBeUse = YES;
    }
    else
        if ([notifyStr isEqualToString:@"NO"]) {
            isExiteGiftToBeUse = NO;
        }
}

-(void)handleProVinceChange:(NSNotification *)note
{
    m_NeedPopToRootWhenQuit=YES;
}

#pragma mark - PADCartTableViewDelegate
-(void)tableView:(PADCartTableView *)tableView cartItem:(CartItemVO *)cartItem setCount:(int)count
{
    [self newThreadSetCount:count forCartItem:cartItem];
}

-(void)tableView:(PADCartTableView *)tableView deleteCartItem:(CartItemVO *)cartItem
{
    [self newThreadDeleteCartItem:cartItem];
}

-(void)tableView:(PADCartTableView *)tableView deleteGift:(CartItemVO *)cartItem
{
    [self deletePromotion:cartItem.product withTarget:nil selector:nil object:nil];
//    NSMutableArray *giftArray=[[NSMutableArray alloc] initWithArray:m_CartVO.redemptionItemList];
//    for (CartItemVO *theCartItemVO in m_CartVO.gifItemtList) {
//        if ([theCartItemVO.product.productId intValue]!=[cartItem.product.productId intValue] || ![theCartItemVO.product.promotionId isEqualToString:cartItem.product.promotionId]) {
//            [giftArray addObject:theCartItemVO];
//        }
//    }
//    
//    m_UpdateTableView=YES;
//    m_UpdateTabView=YES;
//    m_UpdateFloatView=YES;
//    [self newThreadReceivePromotion:giftArray withTarget:nil selector:nil object:nil];
//    [giftArray release];
}

-(void)tableView:(PADCartTableView *)tableView deleteRedemption:(CartItemVO *)cartItem
{
    [self deletePromotion:cartItem.product withTarget:nil selector:nil object:nil];

//    NSMutableArray *redemptionArray=[[NSMutableArray alloc] initWithArray:m_CartVO.gifItemtList];
//    for (CartItemVO *theCartItemVO in m_CartVO.redemptionItemList) {
//        if ([theCartItemVO.product.productId intValue]!=[cartItem.product.productId intValue] || ![theCartItemVO.product.promotionId isEqualToString:cartItem.product.promotionId]) {
//            [redemptionArray addObject:theCartItemVO];
//        }
//    }
//    
//    m_UpdateTableView=YES;
//    m_UpdateTabView=YES;
//    m_UpdateFloatView=YES;
//    [self newThreadReceivePromotion:redemptionArray withTarget:nil selector:nil object:nil];
//    [redemptionArray release];
}

-(void)tableView:(PADCartTableView *)tableView cell:(PADCartTableViewCell *)cell addFavoriteForCartItem:(CartItemVO *)cartItem
{
    [self newThreadAddFavoriteForCartItem:cartItem cell:cell];
}

-(void)tableView:(PADCartTableView *)tableView didSelectCartItem:(CartItemVO *)cartItem
{
    [self enterProductDetail:cartItem.product];
}

-(void)clearCartForTableView:(PADCartTableView *)tableView
{
    [self newThreadClearCart];
}

-(void)goShopForTableView:(PADCartTableView *)tableView
{
    //去购物
    [self goShopBtnClicked:nil];
}

-(void)enterCheckOrderForTableView:(PADCartTableView *)tableView
{
    if (m_ThreadRunning) {
        return;
    }
    
    //    [self newThreadCreateOrder];
    [self enterCheckOrderForAlertShow];
}

-(void) removePromotTag
{
    //去掉促销标签
    needShowTips = NO;
}

#pragma mark - PADCartTabViewDelegate
-(void)tabView:(PADCartTabView *)tabView receiveGift:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object
{
//    NSMutableArray *giftArray=[[NSMutableArray alloc] initWithArray:m_CartVO.redemptionItemList];
//    for (CartItemVO *cartItemVO in m_CartVO.gifItemtList) {
//        if (![cartItemVO.product.promotionId isEqualToString:productVO.promotionId]) {
//            [giftArray addObject:cartItemVO];
//        }
//    }
//    CartItemVO *theCartItemVO=[[CartItemVO alloc] init];
//    [theCartItemVO setBuyQuantity:[NSNumber numberWithInt:1]];
//    [theCartItemVO setProduct:productVO];
//    [giftArray addObject:theCartItemVO];
//    [theCartItemVO release];
    
    m_UpdateTableView=YES;
    m_UpdateTabView=YES;
    m_UpdateFloatView=YES;
    [self newThreadReceivePromotion:productVO withTarget:target selector:selector object:object];
    //[giftArray release];
    
    
}

-(void)tabView:(PADCartTabView *)tabView receiveRedemption:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object
{
    [self selectPromotion:productVO withTarget:target selector:selector object:object];
//    NSMutableArray *redemptionArray=[[NSMutableArray alloc] initWithArray:m_CartVO.gifItemtList];
//    for (CartItemVO *cartItemVO in m_CartVO.redemptionItemList) {
//        if (![cartItemVO.product.promotionId isEqualToString:productVO.promotionId]) {
//            [redemptionArray addObject:cartItemVO];
//        }
//    }
//    CartItemVO *theCartItemVO=[[CartItemVO alloc] init];
//    [theCartItemVO setBuyQuantity:[NSNumber numberWithInt:1]];
//    [theCartItemVO setProduct:productVO];
//    [redemptionArray addObject:theCartItemVO];
//    [theCartItemVO release];
//    
//    m_UpdateTableView=YES;
//    m_UpdateTabView=YES;
//    m_UpdateFloatView=YES;
//    [self newThreadReceivePromotion:redemptionArray withTarget:target selector:selector object:object];
//    [redemptionArray release];
}

-(void)tabView:(PADCartTabView *)tabView deleteGift:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object
{
//    NSMutableArray *giftArray=[[NSMutableArray alloc] initWithArray:m_CartVO.redemptionItemList];
//    for (CartItemVO *cartItemVO in m_CartVO.gifItemtList) {
//        if (!([cartItemVO.product.productId intValue]==[productVO.productId intValue]&&[cartItemVO.product.promotionId isEqualToString:productVO.promotionId])) {
//            [giftArray addObject:cartItemVO];
//        }
//    }
    
    m_UpdateTableView=YES;
    m_UpdateTabView=YES;
    m_UpdateFloatView=YES;
    [self newThreadReceivePromotion:productVO withTarget:target selector:selector object:object];
    //[giftArray release];
}

-(void)tabView:(PADCartTabView *)tabView deleteRedemption:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object
{
//    NSMutableArray *redemptionArray=[[NSMutableArray alloc] initWithArray:m_CartVO.gifItemtList];
//    for (CartItemVO *cartItemVO in m_CartVO.redemptionItemList) {
//        if (!([cartItemVO.product.productId intValue]==[productVO.productId intValue]&&[cartItemVO.product.promotionId isEqualToString:productVO.promotionId])) {
//            [redemptionArray addObject:cartItemVO];
//        }
//    }
    
    m_UpdateTableView=YES;
    m_UpdateTabView=YES;
    m_UpdateFloatView=YES;
    [self newThreadReceivePromotion:productVO withTarget:target selector:selector object:object];
    //[redemptionArray release];
}

-(void)tabView:(PADCartTabView *)tabView tabClickedAtIndex:(int)index
{
    [m_ScrollView setContentOffset:CGPointMake(0, 542) animated:YES];
}

-(void)tabView:(PADCartTabView *)tabView handelLongPressForRebuyOrder:(UILongPressGestureRecognizer*)aGesture
{
    PADCartBuyRecordColumnCell *cell=(PADCartBuyRecordColumnCell *)aGesture.view.superview;
    if (cell.orderV2!=nil) {
        CGPoint currentPoint=[aGesture locationInView:self.view];
        switch (aGesture.state) {
            case UIGestureRecognizerStateBegan: {
                m_FloatingStartPoint=currentPoint;
                if (m_FloatingView!=nil) {
                    [m_FloatingView release];
                }
                m_FloatingView=[[PADCartBuyRecordColumnCell alloc] initWithFrame:CGRectMake(0, 0, 256, 271) delegate:nil];
                [[(PADCartBuyRecordColumnCell*)m_FloatingView backGroundImage] setImage:[UIImage imageNamed:@"buyRecord_bg_on"]];
                [(PADCartBuyRecordColumnCell*)m_FloatingView updateWithArray:[NSArray arrayWithObject:cell.orderV2] index:0];
                [[(PADCartBuyRecordColumnCell*)m_FloatingView backGroundImage] setCenter:currentPoint];
                [self.view addSubview:[(PADCartBuyRecordColumnCell*)m_FloatingView backGroundImage]];
                [self pullDownFloatViewIfNeed];
                break;
            }
            case UIGestureRecognizerStateEnded: {
                [self pushUpFloatViewIfNeed];
                CGPoint thePoint=currentPoint;
                if (thePoint.y>53 && thePoint.y<53+FLOATVIEW_HEIGHT) {
                    //重新购买
                    [self newThreadRebuyOrder:cell.orderV2];
                    [[(PADCartBuyRecordColumnCell*)m_FloatingView backGroundImage] removeFromSuperview];
                    //友盟统计
                    [MobClick event:@"buy_cartrecord"];
                } else {
                    [UIView animateWithDuration:0.5f animations:^{
                        [[(PADCartBuyRecordColumnCell*)m_FloatingView backGroundImage] setCenter:m_FloatingStartPoint];
                    } completion:^(BOOL completed){
                        [[(PADCartBuyRecordColumnCell*)m_FloatingView backGroundImage] removeFromSuperview];
                    }];
                }
                break;
            }
            default: {
                [[(PADCartBuyRecordColumnCell*)m_FloatingView backGroundImage] setCenter:currentPoint];
            }
                break;
        }
    }
}

-(void)tabView:(PADCartTabView *)tabView handelLongPressForAddProduct:(UILongPressGestureRecognizer*)aGesture
{
    if (m_ThreadRunning) {
        return;
    }
    PADCartProductColumnCell *cell=(PADCartProductColumnCell *)aGesture.view.superview;
    if (cell.productVO!=nil) {
        CGPoint currentPoint=[aGesture locationInView:self.view];
        switch (aGesture.state) {
            case UIGestureRecognizerStateBegan: {
                m_FloatingStartPoint=currentPoint;
                if (m_FloatingView!=nil) {
                    [m_FloatingView release];
                }
                m_FloatingView=[[PADCartProductColumnCell alloc] initWithFrame:CGRectMake(0, 0, 256, 271) delegate:nil type:cell.type];
                [[(PADCartProductColumnCell*)m_FloatingView backgroundImage] setImage:[UIImage imageNamed:@"pdItemDragBg"]];
                [(PADCartProductColumnCell*)m_FloatingView updateWithArray:[NSArray arrayWithObject:cell.productVO] index:0];
                [[(PADCartProductColumnCell*)m_FloatingView backgroundImage] setCenter:currentPoint];
                [self.view addSubview:[(PADCartProductColumnCell*)m_FloatingView backgroundImage]];
                [self pullDownFloatViewIfNeed];
                break;
            }
            case UIGestureRecognizerStateEnded: {
                CGPoint thePoint=currentPoint;
                if (![cell.productVO.canBuy isEqualToString:@"false"] && thePoint.y>53 && thePoint.y<53+FLOATVIEW_HEIGHT) {
                    //添加商品到购物车
                    [self newThreadAddProduct:cell.productVO];
                    [[(PADCartProductColumnCell*)m_FloatingView backgroundImage] removeFromSuperview];
                    //友盟统计
                    if (cell.type==CELL_FOR_BROWSE) {
                        [MobClick event:@"buy_history"];
                    } else if (cell.type==CELL_FOR_FAVORITE) {
                        [MobClick event:@"buy_fav"];
                    } else {
                        [MobClick event:@"buy_cartrecord"];
                    }
                } else {
                    [UIView animateWithDuration:0.5f animations:^{
                        [[(PADCartProductColumnCell*)m_FloatingView backgroundImage] setCenter:m_FloatingStartPoint];
                    } completion:^(BOOL completed){
                        [[(PADCartProductColumnCell*)m_FloatingView backgroundImage] removeFromSuperview];
                    }];
                }
                [self pushUpFloatViewIfNeed];
                break;
            }
            default: {
                [[(PADCartProductColumnCell*)m_FloatingView backgroundImage] setCenter:currentPoint];
            }
                break;
        }
    }
}

-(void)tabView:(PADCartTabView *)tabView enterProductDetail:(ProductVO *)productVO
{
    [self enterProductDetail:productVO];
}

-(void)tabView:(PADCartTabView *)tabView addProduct:(ProductVO *)productVO
{
    [self newThreadAddProduct:productVO];
}

#pragma mark - PADCartFloatViewDelegate
-(void)floatView:(PADCartFloatView *)floatView cartItem:(CartItemVO *)cartItem setCount:(int)count
{
    [self newThreadSetCount:count forCartItem:cartItem];
}

-(void)enterCheckOrderForFloatView:(PADCartFloatView *)floatVie
{
    [self enterCheckOrderForAlertShow];
}

-(void)enterCheckOrderForAlertShow
{
    // 有赠品领取而每领得时候：提示领取赠品
    if (isExiteGiftToBeUse) {
        [self AlertShow];
    }
    else
    {
        [self newThreadCreateOrder];
    }
}

-(void)AlertShow
{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"领取赠品" message:@"您还有赠品没有领取，现在领取吗？" delegate:self cancelButtonTitle:@"去结算" otherButtonTitles:@"领赠品", nil];
    alert.tag=1;
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==1) {
        
        if (buttonIndex==0) {
            [self newThreadCreateOrder];
        }
        if (buttonIndex==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BringToPromotion" object:nil];
        }
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY=scrollView.contentOffset.y;
    if (offsetY>448+53 && m_FloatView.frame.origin.y==-106) {
        [UIView animateWithDuration:0.3f animations:^{[m_FloatView setFrame:CGRectMake(20, 53, FLOATVIEW_WIDTH, FLOATVIEW_HEIGHT)];} completion:^(BOOL finished){
        }];
    } else if (offsetY<448+53 && m_FloatView.frame.origin.y==53) {
        [UIView animateWithDuration:0.3f animations:^{[m_FloatView setFrame:CGRectMake(20, -106, FLOATVIEW_WIDTH, FLOATVIEW_HEIGHT)];} completion:^(BOOL finished){
        }];
    } else {
        //do nothing
    }
    
    //隐藏确认删除按钮
    [m_CartTableView hideConfirmView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)releaseResource
{
    OTS_SAFE_RELEASE(m_ScrollView);
    OTS_SAFE_RELEASE(m_CartVO);
    OTS_SAFE_RELEASE(m_CartTableView);
    OTS_SAFE_RELEASE(m_CartTabView);
    OTS_SAFE_RELEASE(m_FloatView);
    OTS_SAFE_RELEASE(m_LoadingView);
    OTS_SAFE_RELEASE(m_FloatingView);
    OTS_SAFE_RELEASE(m_NilView);
    OTS_SAFE_RELEASE(m_LoginView);
    OTS_SAFE_RELEASE(m_Login);
    OTS_SAFE_RELEASE(m_LoginRegistView);
}

-(void)viewDidUnload
{
    [self releaseResource];
    [super viewDidUnload];
}

-(void)dealloc
{
    [self releaseResource];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
