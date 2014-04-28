//
//  ImagePageControl.m
//  yhd
//
//  Created by  on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImagePageControl.h"

@implementation ImagePageControl
@synthesize total;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
           }
    return self;
}
- (id)initWithFrame:(CGRect)frame total:(NSInteger)atotal
{
    self = [super initWithFrame:frame];
    if (self) {
        total=atotal;
        for (int i=0; i<total; i++) {
            UIImageView *bg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imagepage1.png"]];
            bg.tag=i+1;
            [bg setFrame:CGRectMake(i*40, 0, 15, 15)];
            [self insertSubview:bg atIndex:1];
            [bg release];
            
            
        }
    }
    return self;
}
-(void)setSelectedNum:(NSInteger)selectedNum{
    if (selectedNum<=total) {
        for (UIView *v in self.subviews) {
            if (v.tag>0) {
                UIImageView *bg=(UIImageView *)v;
                if (bg.tag==selectedNum) {
                     bg.image=[UIImage imageNamed:@"imagepage2.png"];
                }else {
                     bg.image=[UIImage imageNamed:@"imagepage1.png"];
                }
                
            }
        }
    }
   
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [self setSelectedNum:offset.x / bounds.size.width+1];
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
