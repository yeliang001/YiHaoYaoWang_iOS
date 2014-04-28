//
//  RecommendView.h
//  TheStoreApp
//
//  Created by 林盼 on 14-4-6.
//
//

#import <UIKit/UIKit.h>
@class ProductInfo;
@protocol recommendViewDelegate <NSObject>

- (void)selectedRecommendProduct:(ProductInfo *)product;

@end


@interface RecommendView : UIView<UIScrollViewDelegate>
{
    BOOL _dotShowTitle; //两种显示效果，一种是有标题和 横线的。 另一种是没有标题和横线   这个字段做标示
    
    UIActivityIndicatorView *_lodingView;
}

@property (assign, nonatomic) id delegate;
@property (retain, nonatomic) UILabel *titleLbl;
@property (retain, nonatomic) UIPageControl *pageControl;

- (void)updateRecommendProducts:(NSArray *)productList;

- (id)initWithFrame:(CGRect)frame dontShowTitle:(BOOL)show;

@end
