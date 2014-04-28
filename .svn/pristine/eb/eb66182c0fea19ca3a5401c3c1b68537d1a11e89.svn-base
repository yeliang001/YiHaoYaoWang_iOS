//
//  OTSPadProductDetailVC.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-16.
//
//
// 描述：新的商品详情vc

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OTSPadProductDetailView.h"

@class OTSPadImageSliderView;
@class OTSPadProductDetailInfoView;
@class CategoryVO;

@interface OTSCateInfo : NSObject
@property (retain) NSNumber     *cateid;
@property (retain) CategoryVO   * cate1;
@property (retain) CategoryVO   * cate2;
@property (retain) CategoryVO   * cate3;
@property (retain) NSArray      *listData;

-(CategoryVO*)selectedCate;
-(NSNumber*)selectedCatID;
@end

@interface OTSPadProductDetailVC : BaseViewController
<OTSPadProductDetailViewDelegate>

@property (retain)              ProductVO                   *product;       // productVO，实例化时传入
@property (nonatomic, retain)   OTSPadImageSliderView       *sliderView;    // 左侧大图及小图滚动视图
@property (nonatomic, retain)   OTSPadProductDetailInfoView *infoView;      // 右侧商品信息视图
@property                       BOOL                        isPopped;       //  是否作为浮层弹出
@property   (retain)            OTSCateInfo                 *cateInfo;      // 分类信息
@end
