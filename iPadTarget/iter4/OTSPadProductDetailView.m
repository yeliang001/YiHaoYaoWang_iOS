//
//  OTSPadProductDetailView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-16.
//
//

#import "OTSPadProductDetailView.h"
#import "OTSProductDtTab2View.h"
#import "UIView+LoadFromNib.h"
#import "OTSPadProductDtMovingHeadView.h"

#import "OTSPadProductCommentView.h"
#import "OTSPadProductPromotionView.h"
#import "OTSPadProductSameCateView.h"

#define MOVING_OFFSET_Y         50

@interface OTSPadProductDetailView ()
{
    CGRect      _movingRectHide;
    CGRect      _movingRectShow;
    BOOL        _isMoving;
}
@end

@implementation OTSPadProductDetailView
@synthesize productNameLabel;
@synthesize baseScrollView;
@synthesize webView = _webView;
@synthesize commentView = _commentView;
@synthesize promotionView = _promotionView;
@synthesize sameCateView = _sameCateView;
@synthesize delegate = _delegate;

-(void)setDelegate:(id)delegate
{
    _delegate = delegate;
    self.promotionView.delegate = _delegate;
    self.sameCateView.delegate = _delegate;
    
    if ([_delegate isPopped])
    {
        [self.movingHeadView switchToShortMode];
        
        
    }
}

-(id)delegate
{
    return _delegate;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [productNameLabel release];
    [baseScrollView release];
    [_tabView release];
    [_movingHeadView release];
    [_webView release];
    [_commentView release];
    [_promotionView release];
    [_sameCateView release];
    
    [_closeBtn release];
    [_naviBgIV release];
    [super dealloc];
}

-(void)awakeFromNib
{
    //
    self.baseScrollView.alwaysBounceVertical = YES;
    self.baseScrollView.delegate = self;
    
    //
    CGRect tabRc = self.tabView.frame;
    [self.tabView removeFromSuperview];
    self.tabView = [OTSProductDtTab2View viewFromNibWithOwner:self];
    self.tabView.frame = tabRc;
    self.tabView.delegate = self;
    [self.baseScrollView addSubview:self.tabView];
    
    //
    CGRect webRc = CGRectMake(0, CGRectGetMaxY(self.tabView.frame), self.baseScrollView.frame.size.width, 500);
    self.webView = [[[UIWebView alloc] initWithFrame:webRc] autorelease];
    [self.baseScrollView addSubview:self.webView];
    
    //[self.webView loadHTMLString:@"<body>hahaha</body>" baseURL:nil];
    
    //
    self.commentView = [OTSPadProductCommentView viewFromNibWithOwner:self];
    CGRect commentRc = self.commentView.frame;
    commentRc.origin.y = CGRectGetMaxY(self.tabView.frame);
    self.commentView.frame = commentRc;
    [self.baseScrollView addSubview:self.commentView];
    
    //
    self.promotionView = [OTSPadProductPromotionView viewFromNibWithOwner:self];
    
    CGRect promotionRc = self.promotionView.frame;
    promotionRc.origin.y = CGRectGetMaxY(self.tabView.frame);
    self.promotionView.frame = promotionRc;
    [self.baseScrollView addSubview:self.promotionView];
    
    //
    self.sameCateView = [OTSPadProductSameCateView viewFromNibWithOwner:self];
    
    CGRect sameCateRc = self.sameCateView.frame;
    sameCateRc.origin.y = CGRectGetMaxY(self.tabView.frame);
    self.sameCateView.frame = sameCateRc;
    [self.baseScrollView addSubview:self.sameCateView];
    
    [self.baseScrollView bringSubviewToFront:self.webView];
    
    
    //
    //[self adjustContentSizeIfPopped];
    self.baseScrollView.contentSize = CGSizeMake(self.baseScrollView.contentSize.width, CGRectGetMaxY(self.tabView.frame) + 500);
    
    //
    _movingRectHide = self.movingHeadView.frame;
    _movingRectShow = CGRectOffset(_movingRectHide, 0, _movingRectHide.size.height + 90);
    [self.movingHeadView removeFromSuperview];
    self.movingHeadView = [OTSPadProductDtMovingHeadView viewFromNibWithOwner:self];
    self.movingHeadView.frame = _movingRectHide;
    [self addSubview:self.movingHeadView];
}

//-(void)adjustContentSizeIfPopped
//{
//    //if ([_delegate isPopped])
//    {
//        CGSize contentSize = self.baseScrollView.contentSize;
//        contentSize.width += kCartViewWidth;
//        self.baseScrollView.contentSize = contentSize;
//    }
//}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    _isMoving = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isMoving)
    {
        return;
    }
    
    CGPoint offset = scrollView.contentOffset;
    SEL animFinishSelecotor = @selector(animationDidStop:finished:context:);
    //NSLog(@"offset: %f", offset.y);
    float redLine = self.tabView.frame.origin.y - kTopHeight - _movingRectHide.size.height - 60;
    
//    BOOL isPopped = [_delegate isPopped];
//    
//    if (isPopped)
//    {
//        redLine = self.tabView.frame.origin.y - _movingRectHide.size.height - 60;
//    }
    
    [self.movingHeadView.layer removeAllAnimations];
    
    if (offset.y > redLine)
    {
        if (self.movingHeadView.frame.origin.y < _movingRectShow.origin.y)
        {
            [UIView beginAnimations:@"show" context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:animFinishSelecotor];
            
            CGRect movingRc = _movingRectShow;
            if ([_delegate isPopped])
            {
                movingRc = CGRectOffset(movingRc, 0, -95);
            }
            
            self.movingHeadView.frame = movingRc;
            [UIView commitAnimations];
            _isMoving = YES;
        }
    }
    else
    {
        if (self.movingHeadView.frame.origin.y > _movingRectHide.origin.y)
        {
            [UIView beginAnimations:@"show" context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:animFinishSelecotor];
            self.movingHeadView.frame = _movingRectHide;
            [UIView commitAnimations];
            _isMoving = YES;
        }
        
    }
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    _isMoving = NO;
}

#pragma mark - 
-(void)tabTappedWithIndex:(OTSPadProdDetailTabType)anIndex
{
    switch (anIndex)
    {
        case kPadProdDetailTabDescription:
        {
            [self.baseScrollView bringSubviewToFront:self.webView];
        }
            break;
            
        case kPadProdDetailTabComment:
        {
            [self.baseScrollView bringSubviewToFront:self.commentView];
        }
            break;
            
        case kPadProdDetailTabPromotion:
        {
            [self.baseScrollView bringSubviewToFront:self.promotionView];
        }
            break;
            
        case kPadProdDetailTabSameCate:
        {
            [self.baseScrollView bringSubviewToFront:self.sameCateView];
        }
            break;
            
        default:
            break;
    }

    // 滚动到tab位置
    [_delegate scrollToTabIndex];
//    SEL sel = @selector(scrollToTabIndex);
//    if ([_delegate respondsToSelector:sel])
//    {
//        [_delegate performSelector:sel];
//    }
}

#pragma mark - actions
-(IBAction)closeMe:(id)sender
{
    LOG_THE_METHORD;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PAD_NOTIFY_CLOSE_DETAIL_IN_DETAIL object:nil];
    
}

@end
