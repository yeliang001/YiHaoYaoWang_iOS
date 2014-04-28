//
//  OTSProductView.h
//  TheStoreApp
//
//  Created by jiming huang on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartAnimation.h"
typedef enum {
    PD_FROME_MODEL_B=1,//从广告模块B进入
    PD_FROM_SCAN=2,//从扫描进入
    PD_FROM_FAVORITE=3,//从收藏进入
    PD_FROM_BROWSE=4,//从最近浏览进入
    PD_FROM_CATEGORY=5,//从分类列表进入
    PD_FROM_SEARCH=6,//从搜索进入
    PD_FROM_OTHER//从其他进入
} OTSProductDetailFromTag;

//@class ProductVO;
@class AddProductResult;
@class OTSActionSheet;
@class ColorNStringView;
@class ProductInfo;
@protocol ProductTopViewDelegate;
@interface OTSProductView : UIView<UIPickerViewDelegate,UIPickerViewDataSource, CartAnimationDelegate> {
    UIButton *m_MinusBtn;
    UIButton *m_AddBtn;
    UIButton *m_CountBtn;
    UIButton *m_AddCartBtn;
    int m_MinCount;
    int m_MaxCount;  //最多购买
    BOOL m_AddingCart;
    BOOL m_Animating;
    ProductInfo *m_ProductVO;
    AddProductResult *m_AddProductResult;
    OTSActionSheet *m_ActionSheet;
    int m_PickerViewSelectedIndex;
    OTSProductDetailFromTag m_FromTag;
    int  pointProduct;
    id<ProductTopViewDelegate>delegate;
    
    ColorNStringView * colorstringView; //显示倒计时的
    NSTimer *m_timer;                    //计时器
//    BOOL testttt;
}
@property(nonatomic,assign)int  pointProduct;
@property(nonatomic,retain) ColorNStringView * colorstringView; //显示倒计时的
@property(nonatomic,retain) NSTimer *m_timer;                    //计时器
@property(nonatomic,assign)id<ProductTopViewDelegate>delegate;
-(id)initWithFrame:(CGRect)frame productVO:(ProductInfo *)productVO fromTag:(OTSProductDetailFromTag)fromTag;
-(void)refreshView;
@end
@protocol ProductTopViewDelegate
@required
-(void)cashBuyClick;
-(void)callPhone; //处方药 要咨询药师
- (void)showSeriesView;
@end

