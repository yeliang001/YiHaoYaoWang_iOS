//
//  OTSProductDetail.h
//  TheStoreApp
//
//  Created by jiming huang on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "OTSTabView.h"
#import "OTSAnimationTableView.h"
#import "OTSInterestedProducts.h"
#import "OTSEverybodyWantsMe.h"
#import "OTSProductView.h"
#import "PhoneCartViewController.h"
#import "WeiboSDK.h"
#import "mobidea4ec.h"
#import "RecommendView.h"
@class ProductInfo;
@class OTSInterestedProducts;


@interface OTSProductDetail : OTSBaseViewController<UITableViewDelegate,UITableViewDataSource,OTSTabViewDelegate,ProductTopViewDelegate,OTSAnimationTableViewDelegate,OTSInterestedProductsDelegate,UIActionSheetDelegate,WeiboSDKDelegate,recommendViewDelegate,mobideaRecProtocol>
{
    long m_ProductId;
    NSString *m_PromotionId;
    OTSProductDetailFromTag m_FromTag;
    ProductInfo *m_ProductDetailVO;
    int m_ThreadStatus;
    BOOL m_ThreadRunning;
    OTSInterestedProducts *m_InterestedProducts;
    UIScrollView *m_ScrollView;
    BOOL m_AddingFavorite;
    int m_AddFavoriteResult;
    OTSTabView *m_TabView;
    BOOL pointIn;
    UIViewController*  superVC;
    
    //二维码扫瞄时传过来的编码
    NSString *_barcode;
    
    UIButton *favoriteBtn;
    
    //系列品
    NSMutableArray *_seriesButtonArr; //二纬数组， 每种属性，作为一个数组存在这个数组里面
    
    //提示对话框
    UIAlertView *_alertView;
    
    //同类推荐的View
    RecommendView *_sameProductsView;
    RecommendView *_recommendProductsView;
    UIView *_productPicturesView;
}
@property(assign)BOOL pointIn;
@property (retain) NSNumber *promotionPrice;
@property(retain)UIViewController*  superVC;
-(id)initWithProductVO:(ProductInfo *)productVo fromTag:(OTSProductDetailFromTag)fromTag;
-(id)initWithProductId:(long)productId promotionId:(NSString *)promotionId fromTag:(OTSProductDetailFromTag)fromTag;

-(id)initWithBarcode:(NSString *)barcode fromTag:(OTSProductDetailFromTag)fromTag;//二维码扫瞄进来

- (void)showSeriesView:(id)sender;
@end
