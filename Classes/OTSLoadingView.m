//
//  OTSLoadingView.m
//  TheStoreApp
//
//  Created by yiming dong on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSLoadingView.h"
#import "OTSUtility.h"
#import <QuartzCore/QuartzCore.h>

@interface OTSLoadingView ()
@property(retain)UIButton* transparentButton;
-(void)doShowInView:(UIView*)aView 
              title:(NSString*)aTitle 
        autoDismiss:(BOOL)aAutoDismiss 
   indicateActivity:(BOOL)aShowIndicator
            offsetY:(int)aOffsetY 
         titleColor:(UIColor*)aTitleColor 
          maskColor:(UIColor*)aMaskColor;

-(void)installTransBlockButtonToView:(UIView*)aView bgColor:(UIColor*)aBgColor;
@end

@implementation OTSLoadingView
@synthesize transparentButton;

#define OTS_LOADING_VIEW_OPACITY        .8f
#define OTS_LOADING_VIEW_DEFAULT_TEXT   @"正在加载";
#define OTS_LOADING_VIEW_DEFAULT_SIZE   90

-(void)adjustTextViewContentVirticalAlignCenter
{
    float textViewHeight = textView.bounds.size.height;
    float textContentHeight = textView.contentSize.height;
    //BOOL needAdjustSize = NO;
    
    if (actIndicatorView.layer.opacity == 0)
    {
        CGFloat topCorrect = textViewHeight - textContentHeight;
        textView.contentOffset = CGPointMake(textView.contentOffset.x, - topCorrect / 2);
        
        if (topCorrect <= 0)
        {
            textView.frame = CGRectMake(textView.frame.origin.x
                                        , 5
                                        , textView.frame.size.width
                                        , textContentHeight);
            
            self.frame = [OTSUtility modifyRect:self.frame 
                                          value:CGRectGetMaxY(textView.frame) + 5 
                                     modifyType:KOtsRectModifyHeight];
            
            textView.contentOffset = CGPointZero;
        }
    }
    else
    {
        textView.frame = CGRectMake(textView.frame.origin.x
                                    , textView.frame.origin.y - (textContentHeight - textViewHeight)
                                    , textView.frame.size.width
                                    , textContentHeight);
        
        if (textView.frame.origin.y < CGRectGetMaxY(actIndicatorView.frame) + 5)
        {
            textView.frame = CGRectOffset(textView.frame, 0, CGRectGetMaxY(actIndicatorView.frame) + 5 - textView.frame.origin.y);
            
            self.frame = [OTSUtility modifyRect:self.frame 
                                          value:CGRectGetMaxY(textView.frame) + 5 
                                     modifyType:KOtsRectModifyHeight];
            
            textView.contentOffset = CGPointZero;
        }
    }
}

-(void)autoLayout
{
    CGRect newRect = self.bounds;
    newRect.origin.y = 0;
    
    int messageLenght = [textView.text length];
    
    if (messageLenght > 30)
    {
        newRect.size = CGSizeMake(OTS_LOADING_VIEW_DEFAULT_SIZE * 1.5
                                  , OTS_LOADING_VIEW_DEFAULT_SIZE * 1.5);
    }
    
    else if (messageLenght > 10)
    {
        newRect.size = CGSizeMake(OTS_LOADING_VIEW_DEFAULT_SIZE * 1.2
                                      , OTS_LOADING_VIEW_DEFAULT_SIZE * 1.2);
    }
        
    else
    {
        newRect.size = CGSizeMake(OTS_LOADING_VIEW_DEFAULT_SIZE
                                      , OTS_LOADING_VIEW_DEFAULT_SIZE);
    }
    
    self.frame = newRect;
    
    // layout indicator view
    actIndicatorView.center = self.center;
    CGRect actRect = actIndicatorView.frame;
    actRect.origin.y = 20;
    //为了适配iOS7
//    if (ISIOS7)
//    {
//        actRect.origin.y += 10;
//    }
    
    actIndicatorView.frame = actRect;
    
    // layout text view
    int textY =  5;
    int textHeight = CGRectGetMaxY(self.frame) - 5;
    if (actIndicatorView.layer.opacity != 0) 
    {
        textY += CGRectGetMaxY(actIndicatorView.frame) + 5;
        textHeight -= textY;
    }
    textViewDefaultRect = CGRectMake(0
                                     , textY
                                     , self.frame.size.width
                                     , textHeight);
    
    if (ISIOS7 && actIndicatorView.layer.opacity == 0)
    {
        textViewDefaultRect = CGRectMake(0
                                         , textY+20
                                         , self.frame.size.width
                                         , textHeight);

    }
    
    
    
    CGRect textViewRect = textViewDefaultRect;
    
    
    textView.frame = textViewRect;
    
    //为了适配iOS7  否则在7下面不显示文字
    if (!ISIOS7)
    {
        [self adjustTextViewContentVirticalAlignCenter];
    }
}

-(void)assemleSubViews
{
    actIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    [self addSubview:actIndicatorView];
    [actIndicatorView startAnimating];
    

    textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.text = OTS_LOADING_VIEW_DEFAULT_TEXT;
    textView.textColor = [UIColor whiteColor];
    textView.backgroundColor = [UIColor clearColor];
    textView.textAlignment = NSTextAlignmentCenter;
    textView.font = [UIFont boldSystemFontOfSize:14.f];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    [self addSubview:textView];
    [textView release];
    
    [self autoLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self assemleSubViews];
    }
    return self;
}

-(id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, OTS_LOADING_VIEW_DEFAULT_SIZE, OTS_LOADING_VIEW_DEFAULT_SIZE)]; 
    
    if (self)
    {
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor blackColor];
        self.layer.opacity = 0;
    }
    
    return self;
}

-(void)anmateToOpacity:(float)aOpacity
{
    [self.layer removeAllAnimations];
    
    [UIView setAnimationsEnabled:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    self.layer.opacity = aOpacity;
    [UIView commitAnimations];
}


#pragma mark - show method
-(void)showInView:(UIView*)aView
{
    [self showInView:aView offsetY:0];
}

-(void)showInView:(UIView*)aView maskColor:(UIColor*)aMaskColor
{
    [self showInView:aView title:nil autoDismiss:NO indicateActivity:YES offsetY:0 titleColor:nil maskColor:aMaskColor];
}

-(void)showInView:(UIView*)aView offsetY:(int)aOffsetY
{
    [self showInView:aView title:nil autoDismiss:NO indicateActivity:YES offsetY:aOffsetY];
}

-(void)showInView:(UIView*)aView title:(NSString*)aTitle
{
    [self showInView:aView title:aTitle autoDismiss:NO indicateActivity:YES offsetY:0];
}

-(void)showTipInView:(UIView*)aView title:(NSString*)aTitle
{
    [self showInView:aView title:aTitle autoDismiss:YES indicateActivity:NO offsetY:0];
}

-(void)showTipInView:(UIView*)aView title:(NSString*)aTitle titleColor:(UIColor*)aTitleColor
{
    [self showInView:aView title:aTitle autoDismiss:YES indicateActivity:NO offsetY:0 titleColor:aTitleColor maskColor:nil];
}

-(void)showInView:(UIView*)aView 
            title:(NSString*)aTitle 
      autoDismiss:(BOOL)aAutoDismiss 
 indicateActivity:(BOOL)aShowIndicator
          offsetY:(int)aOffsetY 
{
    [self showInView:aView title:aTitle autoDismiss:aAutoDismiss indicateActivity:aShowIndicator offsetY:aOffsetY titleColor:nil maskColor:nil];
}

-(void)showInView:(UIView*)aView 
            title:(NSString*)aTitle 
      autoDismiss:(BOOL)aAutoDismiss 
 indicateActivity:(BOOL)aShowIndicator
          offsetY:(int)aOffsetY 
       titleColor:(UIColor*)aTitleColor 
        maskColor:(UIColor*)aMaskColor
{
    if (aView)
    {
        NSMutableArray* objects = [NSMutableArray arrayWithCapacity:7];
        [objects addObject:aView];
        [objects addObject:aTitle ? aTitle : [NSNull null]];
        [objects addObject:[NSNumber numberWithBool:aAutoDismiss]];
        [objects addObject:[NSNumber numberWithBool:aShowIndicator]];
        [objects addObject:[NSNumber numberWithInt:aOffsetY]];
        [objects addObject:aTitleColor ? aTitleColor : [NSNull null]];
        [objects addObject:aTitleColor ? aTitleColor : [NSNull null]];
        
        [self performSelectorOnMainThread:@selector(showWithObject:) withObject:objects waitUntilDone:YES];
    }
}

-(void)showWithObject:(NSArray*)aObjArr
{
    if (aObjArr && [aObjArr count] == 7)
    {
        UIView* parentView = [aObjArr objectAtIndex:0];
        NSString* title = [aObjArr objectAtIndex:1];
        BOOL autoDismiss = [[aObjArr objectAtIndex:2] boolValue];
        BOOL showIndicator = [[aObjArr objectAtIndex:3] boolValue];
        int  offsetY = [[aObjArr objectAtIndex:4] intValue];
        UIColor* titleColor  = [aObjArr objectAtIndex:5];
        UIColor* maskColor = [aObjArr objectAtIndex:6];
        
        title = [title isKindOfClass:[NSNull class]] ? nil : title;
        titleColor = [titleColor isKindOfClass:[NSNull class]] ? nil : titleColor;
        maskColor = [maskColor isKindOfClass:[NSNull class]] ? nil : maskColor;
        
        [self doShowInView:parentView
                     title:title
               autoDismiss:autoDismiss 
          indicateActivity:showIndicator 
                   offsetY:offsetY 
                titleColor:titleColor 
                 maskColor:maskColor];
    }
}

-(void)doShowInView:(UIView*)aView
            title:(NSString*)aTitle 
      autoDismiss:(BOOL)aAutoDismiss 
 indicateActivity:(BOOL)aShowIndicator
          offsetY:(int)aOffsetY 
       titleColor:(UIColor*)aTitleColor 
        maskColor:(UIColor*)aMaskColor
{
    if (aView == nil)
    {
        return;
    }
    
    if (aTitle && [aTitle length] > 0) 
    {
        textView.text = aTitle;
    }
    else
    {
        textView.text = OTS_LOADING_VIEW_DEFAULT_TEXT;
    }
    
    textView.textColor = aTitleColor ? aTitleColor : [UIColor whiteColor];
    
    //actIndicatorView.hidden = !aShowIndicator; 
    // problem with hidden property when 1st time set it to yes...
    // so changed to use layer'opacity instead...dym
    
    if (aShowIndicator)
    {
        actIndicatorView.layer.opacity = 1.f;
    }
    else
    {
        actIndicatorView.layer.opacity = 0.f;
    }
       
    [self autoLayout];
    
    // 在super view中定位
    [aView addSubview:self];

    //self.center = aView.center;
    
    
    float x = (aView.frame.size.width - self.frame.size.width) / 2;
    float y = (aView.frame.size.height - self.frame.size.height) / 2;
    
    CGRect thisRect = self.frame;
    thisRect.origin.x = x;
    thisRect.origin.y = y;
    self.frame = thisRect;
    
    
    
    self.frame = CGRectOffset(self.frame, 0, aOffsetY);
    
    [self anmateToOpacity:OTS_LOADING_VIEW_OPACITY];
    
    
    // 透明大按钮, 用来模拟模态
    blockViewRect=aView.bounds;//全部遮挡
    [self installTransBlockButtonToView:aView bgColor:aMaskColor];
    
    
    if (aAutoDismiss) 
    {
        [self performSelector:@selector(hide) withObject:nil afterDelay:2.5];
    }
}

-(void)installTransBlockButtonToView:(UIView*)aView bgColor:(UIColor*)aBgColor
{
    if (aView)
    {
        // 透明大按钮, 用来模拟模态
        if (self.transparentButton == nil)
        {
            self.transparentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.transparentButton addTarget:self action:@selector(doNothing) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //ISSUE #4813  BUS_ADRALN at 0x0
        //[error]-[__NSCFString backgroundColor]: unrecognized selector sent to instance
        if (self.transparentButton && [self.transparentButton isKindOfClass:[UIButton class]]){
            self.transparentButton.backgroundColor = aBgColor ? aBgColor : [UIColor clearColor];
            
            CGRect transRect = blockViewRect;
            transRect.origin.y += 44;
            self.transparentButton.frame = transRect;
            [aView addSubview:self.transparentButton];
        }

    }
}

-(void)blockView:(UIView*)aView
{
    if (aView)
    {
        blockViewRect=aView.bounds;//全部遮挡
        [self otsDetatchMemorySafeNewThreadSelector:@selector(doBlockView:) toTarget:self withObject:aView];
    }
}

-(void)blockView:(UIView*)aView rect:(CGRect)rect
{
    if (aView)
    {
        blockViewRect=rect;//部分遮挡
        [self otsDetatchMemorySafeNewThreadSelector:@selector(doBlockView:) toTarget:self withObject:aView];
    }
}

-(void)doBlockView:(UIView*)aView
{
    [self installTransBlockButtonToView:aView bgColor:nil];
}

#pragma mark -
-(void)doNothing
{
    
}

-(void)doHideFunction
{
    if (transparentButton && transparentButton.superview)
    {
        [transparentButton removeFromSuperview];
    }
    
    [self anmateToOpacity:0];
}

-(void)hide
{
    [self performSelectorOnMainThread:@selector(doHideFunction) withObject:nil waitUntilDone:YES];
}

-(void)dealloc
{
    //ISSUE #4027 EXC_BAD_ACCESS
    //-[OTSLoadingView dealloc]
    OTS_SAFE_RELEASE(transparentButton);
    [super dealloc];
}

@end


@implementation OTSGlobalLoadingView

#pragma mark - singleton methods
static OTSGlobalLoadingView *sharedInstance = nil;

+ (OTSGlobalLoadingView *)sharedInstance
{ 
    @synchronized(self) 
    { 
        if (sharedInstance == nil) 
        { 
            sharedInstance = [[self alloc] init]; 
        } 
    } 
    
    return sharedInstance; 
} 

+ (id)allocWithZone:(NSZone *)zone 
{ 
    @synchronized(self) 
    { 
        if (sharedInstance == nil) 
        { 
            sharedInstance = [super allocWithZone:zone]; 
            return sharedInstance; 
        } 
    } 
    
    return nil; 
} 

- (id)copyWithZone:(NSZone *)zone 
{ 
    return self; 
} 

- (id)retain 
{ 
    return self; 
} 

- (NSUInteger)retainCount 
{ 
    return NSUIntegerMax; 
} 

- (oneway void)release
{ 
} 

- (id)autorelease 
{ 
    return self; 
}

@end



