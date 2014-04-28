//
//  ImageScroll.h
//  yhd
//
//  Created by  on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HotPointNewVO;
@protocol ImageScrollDelegate
-(void)enterCMSPage:(HotPointNewVO *)hotPointNewVO;

@end
@interface ImageScroll : UIView<UIScrollViewDelegate>{
    UIImageView *bgView;
    UIScrollView *scrollView;
    int imageWidth;
    int imageHeight;
    id<ImageScrollDelegate>imageScrollDelegate;
    
}
@property(nonatomic,assign)id<ImageScrollDelegate>imageScrollDelegate;
@property(nonatomic,assign)UIScrollView *scrollView;
- (id)initWithFrame:(CGRect)frame width:(NSInteger)width height:(NSInteger)height;
-(void)setImages:(NSArray *)images imageSize:(CGSize)imageSize;
-(void)setBgImage:(UIImage *)image;
-(void)setImagePoints:(NSArray *)imagePoints imageSize:(CGSize)imageSize;
-(void)removeAllImage;
@end
