//
//  OTSPadTicketRuleView.m
//  TheStoreApp
//
//  Created by dong yiming on 12-12-11.
//
//

#import "OTSPadTicketRuleView.h"
#import "CouponVO.h"
#import "UIView+LoadFromNib.h"
#import "OTSPadTicketRuleFloatView.h"

@interface OTSPadTicketRuleView ()
{
    BOOL    _isShowing;
}
@property (retain) OTSPadTicketRuleFloatView        *floatView;
@end


@implementation OTSPadTicketRuleView
@synthesize floatView = _floatView;

-(void)extraInit
{
    self.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:.5f];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self extraInit];
    }
    return self;
}

- (void)dealloc
{
    [_floatView release];
    
    [super dealloc];
}

-(void)showWithVO:(CouponVO*)aCouponVO
{
    if (aCouponVO)
    {
        NSString *trimmedStr = [self stringByTrimmingLeadingWhitespace:aCouponVO.detailDescription];
        NSArray *keywords = [trimmedStr componentsSeparatedByString:@"\r\n"];
        NSMutableArray *keyWordsNoSpace = [NSMutableArray arrayWithCapacity:10];
        
        for (NSString *str in keywords)
        {
            NSLog(@"%@", str);
            if (str.length > 0)
            {
                [keyWordsNoSpace addObject:str];
            }
        }
        
        [self.floatView removeFromSuperview];
        self.floatView = [OTSPadTicketRuleFloatView viewFromNibWithOwner:self];
        self.floatView.datas = keyWordsNoSpace;
        self.floatView.defineType = aCouponVO.defineType;
        [self.floatView showTitle];
        self.floatView.delegate = self;
        
        float offsetX = (self.frame.size.width - self.floatView.frame.size.width) * .5f;
        float offsetY = self.frame.size.height + 100.f;
        float centerY = (self.frame.size.height - self.floatView.frame.size.height) * .5f;
        self.floatView.frame = CGRectOffset(self.floatView.frame, offsetX, offsetY);
        
        [self addSubview:self.floatView];
        
        [UIView animateWithDuration:.3f animations:^{
        
            self.floatView.frame = CGRectMake(offsetX, centerY, self.floatView.frame.size.width, self.floatView.frame.size.height);
        }];
        
        _isShowing = YES;
        
        
    }
    else
    {
        [self removeFromSuperview];
    }
}

-(NSString*)stringByTrimmingLeadingWhitespace:(NSString *)aString
{
    if (aString.length > 0)
    {
        NSInteger i = 0;
        
        while ((i < [aString length])
               && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[aString characterAtIndex:i]]) {
            i++;
        }
        return [aString substringFromIndex:i];
    }
    
    return nil;
}

-(void)hide
{
    if (_isShowing)
    {
        _isShowing = NO;
        
        float offsetX = (self.frame.size.width - self.floatView.frame.size.width) * .5f;
        float offsetY = self.frame.size.height + 100.f;
        //float centerY = (self.frame.size.height - self.floatView.frame.size.height) * .5f;
        
        [UIView animateWithDuration:.3f animations:^{
            
            self.floatView.frame = CGRectMake(offsetX, offsetY, self.floatView.frame.size.width, self.floatView.frame.size.height);
            
        } completion:^(BOOL finished){
            
            [self removeFromSuperview];
            
        }];
    }
}

@end
