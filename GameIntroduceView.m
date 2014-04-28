//
//  GameIntroduceView.m
//  TheStoreApp
//
//  Created by yuan jun on 12-11-10.
//
//

#import "GameIntroduceView.h"

@implementation GameIntroduceView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
        UIImageView* img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 296, 358)];
        img.image=[UIImage imageNamed:@"game_intro.png"];
        img.center=CGPointMake(160, 179);
        [self addSubview:img];
        [img release];
        
        UISwipeGestureRecognizer*sw=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        sw.direction=UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:sw];
        [sw release];
        
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInview:)];
        [self addGestureRecognizer:tap];
        [tap release];

    }
    return self;
}
-(void)swipe:(UISwipeGestureRecognizer*)gesture{
    if (gesture.direction==UISwipeGestureRecognizerDirectionUp) {
        [delegate gestureHiddenGameIntroduce];
    }
}

-(void)tapInview:(UITapGestureRecognizer*)tap{
    CGPoint p=[tap locationInView:self];
    if (p.y>358) {
        [delegate gestureHiddenGameIntroduce];
    }
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
