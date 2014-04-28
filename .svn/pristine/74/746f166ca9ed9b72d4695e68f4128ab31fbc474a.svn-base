//
//  ImageScroll.m
//  yhd
//
//  Created by  on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageScroll.h"
#import "SDImageView+SDWebCache.h"
#import "ImageScrollView.h"
#import "HotPointNewVO.h"
#import "ProductVO.h"
//#define imageWidth 180
//#define imageHeight 154
#define butWidth 31
#define footHeight 2
#define spaceWidth 38
@implementation ImageScroll
@synthesize imageScrollDelegate,scrollView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        bgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:bgView];
        [bgView release];
        imageHeight=154;
        imageWidth=180;
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width-butWidth, frame.size.height-footHeight)];
        scrollView.clipsToBounds = YES;
        scrollView.scrollEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.directionalLockEnabled = YES;
        //scrollView.pagingEnabled = YES;
        scrollView.delegate=self;
        [self addSubview:scrollView];
        [scrollView release];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame width:(NSInteger)width height:(NSInteger)height
{
    self = [super initWithFrame:frame];
    if (self) {
        bgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:bgView];
        [bgView release];
        imageHeight=height;
        imageWidth=width;
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(31, 0, frame.size.width-butWidth-31, frame.size.height-footHeight)];
        scrollView.clipsToBounds = YES;
        scrollView.scrollEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.directionalLockEnabled = YES;
        //scrollView.pagingEnabled = YES;
        scrollView.delegate=self;
        [self addSubview:scrollView];
        [scrollView release];
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [bgView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [scrollView setFrame:CGRectMake(31, 0, frame.size.width-butWidth-31, frame.size.height-footHeight)];    
}
-(void)setBgImage:(UIImage *)image{
    bgView.image=image;
}
-(void)leftClick:(id)sender{
    CGPoint point= scrollView.contentOffset;
    point.x=point.x<=0.0?0:point.x-imageWidth;
    [scrollView setContentOffset:point animated:YES];
}
-(void)rightClick:(id)sender{
    CGPoint point= scrollView.contentOffset;
    NSLog(@"point.x==%f", point.x);
    point.x=point.x>=scrollView.contentSize.width-scrollView.frame.size.width?scrollView.contentSize.width-scrollView.frame.size.width:point.x+imageWidth;
    [scrollView setContentOffset:point animated:YES];
}
-(void)setImages:(NSArray *)images imageSize:(CGSize)imageSize{
    int i=0;
	scrollView.contentSize=CGSizeMake((imageWidth+spaceWidth)*images.count-spaceWidth, 10);
    for (NSString *image in images) {
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed: image]];
        imageView.frame=CGRectMake(i*imageWidth, 0, imageWidth, imageHeight);
        [scrollView addSubview:imageView];
        [imageView release];
        i++;
    }


}
-(void)setImagePoints:(NSArray *)imagePoints imageSize:(CGSize)imageSize{
    int i=0;
    CGRect rect=self.frame;
    //float xSpace=(rect.size.width-imageWidth)/2;
    float ySpace=(rect.size.height-imageHeight)/2;
	scrollView.contentSize=CGSizeMake((imageWidth+spaceWidth)*imagePoints.count-38, 10);
    for (HotPointNewVO *hotPointNew in imagePoints) {
        ImageScrollView *imageView=[[ImageScrollView alloc]initWithFrame:CGRectMake(i*(imageWidth+spaceWidth), ySpace, imageWidth, imageHeight)];
        imageView.userInteractionEnabled=YES;
        [imageView setHotPointNewVO:hotPointNew];
        
        NSURL *url=[NSURL URLWithString: hotPointNew.picUrl];
        if (url) {
            [imageView setImageWithURL:url refreshCache:YES];
        }
        
        [scrollView addSubview:imageView];
        [imageView release];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTap:)];
        [imageView addGestureRecognizer:tapGes];
        [tapGes release];
        i++;
    }
    
    
}
-(void)removeAllImage{
    if (scrollView.subviews) {

        for (UIView *subView in scrollView.subviews) {
            if ([subView isKindOfClass:[ImageScrollView class]]) {
                [subView removeFromSuperview];
                subView=nil;
            }
        }
    }
}
#pragma mark handel UIPanGestureRecognizer 手势处理
-(void)handelTap:(UIPanGestureRecognizer*)gestureRecognizer{
    ImageScrollView *imageView=(ImageScrollView *)gestureRecognizer.view;
    [imageScrollDelegate enterCMSPage:imageView.hotPointNewVO];
}
#pragma mark -
#pragma mark Scroll View Delegate

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)ascrollView{
//     NSLog(@"scrollViewDidEndDecelerating---==");
//
//    int x=scrollView.contentOffset.x;
//    if(x%imageWidth!=0){
//    CGPoint point= scrollView.contentOffset;
//    int mo=x%imageWidth;
//    point.x=mo>imageWidth/2?x-x%imageWidth+imageWidth:x-x%imageWidth;
//    [scrollView setContentOffset:point animated:YES];
//    }
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)ascrollView willDecelerate:(BOOL)decelerate{
//    NSLog(@"scrollViewDidScroll---%@",decelerate?@"y":@"n");
//    if (!decelerate) {
//        int x=scrollView.contentOffset.x;
//        CGPoint point= scrollView.contentOffset;
//        int mo=x%imageWidth;
//        point.x=mo>imageWidth/2?x-x%imageWidth+imageWidth:x-x%imageWidth;
//        [scrollView setContentOffset:point animated:YES];
//    }
//
//}
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//     NSLog(@"scrollViewWillBeginDecelerating===");
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)dealloc
{
    imageScrollDelegate=nil;
    
    [super dealloc];
}
@end
