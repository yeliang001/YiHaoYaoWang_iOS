//
//  RecommendView.m
//  TheStoreApp
//
//  Created by 林盼 on 14-4-6.
//
//

#import "RecommendView.h"
#import "LPPager.h"
#import "RecommendProductView.h"
#import "ProductInfo.h"
@implementation RecommendView

- (id)initWithFrame:(CGRect)frame
{
    frame.size = _dotShowTitle? CGSizeMake(320, 166) : CGSizeMake(320, 215);
    
    
    
    
    
    self = [super initWithFrame:frame];
    if (self)
    {
    
        
        // Initialization code
        if (!_dotShowTitle)
        {
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
            title.text = @"猜您需要";
            title.font = [UIFont boldSystemFontOfSize:17];
            [self addSubview:title];
            [title release];
            _titleLbl = title;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame), 320, 1)];
            line.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:line];
            [line release];
            
            
            
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame)+10 +134 + 7+30, 320, 1)];
            line2.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:line2];
            [line2 release];

        }
     
        
        CGRect pcRect = CGRectMake(0, 30 +10 +134 + 7+5, 320, 20);
        if (_dotShowTitle)
        {
            pcRect = CGRectMake(0, 134 + 7+5, 320, 20);
        }
        
        
        _pageControl = [[UIPageControl alloc] initWithFrame:pcRect];
//        _pageControl.tintColor = [UIColor redColor];
        [self addSubview:_pageControl];
        [_pageControl release];
        
        
        _lodingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _lodingView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview: _lodingView];
        [_lodingView release];
        [_lodingView startAnimating];
    
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame dontShowTitle:(BOOL)show
{
    _dotShowTitle = show;

    return [self initWithFrame:frame];
}






- (void)updateRecommendProducts:(NSArray *)productList
{
    [_lodingView stopAnimating];
    
    for (UIView *v in [self subviews])
    {
        if ([v isKindOfClass:[LPPager class]])
        {
            [v removeFromSuperview];
        }
    }
    
    _pageControl.numberOfPages =  (int)ceil(productList.count/3.0);
    _pageControl.currentPage = 0;
    [self pageChanged:_pageControl];
    NSMutableArray *productViewList = [[NSMutableArray alloc] init];
    for (ProductInfo *product in productList)
    {
        
        RecommendProductView *productView =[[RecommendProductView alloc] initWithFrame:CGRectZero product:product target:self action:@selector(selectedProduct:)];
        [productViewList addObject:productView];
        [productView release];
    }
    
    
    LPPager *pager = [[LPPager alloc] initWithFrame:CGRectMake(5, _dotShowTitle? 0 : 40, 310, 134) viewArr:productViewList gapX:5];
    pager.bounces = YES;
    pager.delegate = self;
    pager.pagingEnabled = YES;
    [self addSubview:pager];
    [pager release];
    [productViewList release];
}


- (void)selectedProduct:(RecommendProductView *)productView
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectedRecommendProduct:)])
    {
        [_delegate selectedRecommendProduct:productView.product];
    }
}

-(void)pageChanged:(UIPageControl*)pc
{
    NSArray *subViews = pc.subviews;
    for (int i = 0; i < [subViews count]; i++)
    {
        UIView* subView = [subViews objectAtIndex:i];
        if ([NSStringFromClass([subView class]) isEqualToString:NSStringFromClass([UIView class])])
        {
            UIImage *image = (pc.currentPage == i ? [UIImage imageNamed:@"RedPoint.png"] : [UIImage imageNamed:@"GrayPoint.png"]);
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [subView addSubview:imageView];
            [imageView release];
            
        }
        
    }
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    int index = (int) (point.x / 310);
    _pageControl.currentPage = index;
    
    [self pageChanged:_pageControl];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
