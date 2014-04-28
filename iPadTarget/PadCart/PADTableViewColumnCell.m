//
//  PADTableViewColumnCell.m
//  TheStoreApp
//
//  Created by huang jiming on 12-11-26.
//
//

#import "PADTableViewColumnCell.h"

@implementation PADTableViewColumnCell
@synthesize backgroundImage=m_BackgroundImage;

-(id)initWithFrame:(CGRect)frame delegate:(id<PADTableViewColumnCellDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        m_Delegate=delegate;
        m_BackgroundImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [m_BackgroundImage setUserInteractionEnabled:YES];
        [self addSubview:m_BackgroundImage];
        
        //手势处理
        UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [m_BackgroundImage addGestureRecognizer:tapGes];
        [tapGes release];
        
        UILongPressGestureRecognizer *longPressGesture=[[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handelLongPress:)] autorelease];
        longPressGesture.minimumPressDuration=kLongPressTime;
        [m_BackgroundImage addGestureRecognizer:longPressGesture];
    }
    return self;
}

//手势处理
-(void)handleTap:(UIPanGestureRecognizer*)gestureRecognizer
{
    if ([m_Delegate respondsToSelector:@selector(tableViewColumnCell:didSelectAtIndex:)]) {
        [m_Delegate tableViewColumnCell:self didSelectAtIndex:m_Index];
    }
}

//长按处理
-(void)handelLongPress:(UILongPressGestureRecognizer*)aGesture
{
    if ([m_Delegate respondsToSelector:@selector(tableViewColumnCell:handelLongPress:)]) {
        [m_Delegate tableViewColumnCell:self handelLongPress:aGesture];
    }
}

-(void)updateWithArray:(NSArray *)array index:(NSInteger)index
{
    m_Array=[array retain];
    m_Index=index;
}

-(void)dealloc
{
    m_Delegate=nil;
    OTS_SAFE_RELEASE(m_Array);
    OTS_SAFE_RELEASE(m_BackgroundImage);
    [super dealloc];
}
@end
