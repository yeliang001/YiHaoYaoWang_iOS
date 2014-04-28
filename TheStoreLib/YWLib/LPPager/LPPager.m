//
//  LPPager.m
//  WisdomCloud
//
//  Created by Lin Pan on 12-10-16.
//
//

#import "LPPager.h"

@implementation LPPager
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code

    }
    return self;
}
-(id)initWithFrame:(CGRect)frame viewArr:(NSArray *)aViewArr gapX:(NSInteger )aGapx
{
    self = [super initWithFrame:frame];
    if (self)
    {
       
        self.backgroundColor = [UIColor clearColor];
        self.viewArr = aViewArr;
        self.gapX = aGapx;
        
        int viewCount = [self.viewArr count];
        int viewWidth = (viewCount == 0? 0 : ((UIView *)[self.viewArr objectAtIndex:0]).frame.size.width);
        float viewHeight = (viewCount == 0? 0 : ((UIView *)[self.viewArr objectAtIndex:0]).frame.size.height);

        self.contentSize = CGSizeMake( viewWidth * viewCount + self.gapX * (viewCount-1), self.frame.size.height);
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollsToTop = NO;
        self.scrollEnabled = YES;

        for (int i = 0; i < viewCount; ++i)
        {
            UIView *view = [self.viewArr objectAtIndex:i];
            
            CGRect viewRect = CGRectMake(i*self.gapX + i*viewWidth,(self.frame.size.height - viewHeight)/2  , viewWidth, viewHeight);
            view.frame = viewRect;
            
            [self addSubview:view];
            
            if (i != viewCount-1)
            {
                UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_line.png"]];
                line.frame = CGRectMake(viewRect.origin.x + viewRect.size.width + self.gapX/2, (self.frame.size.height - 22)/2, 1, 22);
                [self addSubview:line];
                [line release];
            }
            
        }
        
    }
    return self;
}

-(void)dealloc
{
    [self.viewArr release];
    [super dealloc];
}




@end
