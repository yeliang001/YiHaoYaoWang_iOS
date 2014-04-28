//
//  ColorStringView.m
//  TheStoreApp
//
//  Created by towne on 13-5-2.
//
//

#import "ColorNStringView.h"

@implementation ColorNStringView
@synthesize AttriString;

- (id)initWithFrame:(CGRect)frame withNSString:(NSString *) string
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self ChangeNumbersColorFromString:string];
    }
    return self;
}

//字串格式：23天24小时23分23秒
-(void)ChangeNumbersColorFromString:(NSString*)string{
    
    self.attriString = [[[NSMutableAttributedString alloc] initWithString:string] autorelease];
    NSRange range1 = [string rangeOfString:@"天"];
    int location1 = range1.location;
    if (location1) {
//        NSLog(@"location1 %d",location1);
        [self change:[UIColor redColor] range:NSMakeRange(0, location1)];
    }
    
    NSRange range2 = [string rangeOfString:@"小时"];
    int location2 = range2.location;
//    NSLog(@"location2 %d",location2);
    if (location2) {
        [self change:[UIColor redColor] range:NSMakeRange(location1+1, 2)];
    }
    
    NSRange range3 = [string rangeOfString:@"分"];
    int location3 = range3.location;
//    NSLog(@"location3 %d",location3);
    if (location3) {
        [self change:[UIColor redColor] range:NSMakeRange(location2+2, 2)];
    }
    
    NSRange range4 = [string rangeOfString:@"秒"];
    int location4 = range4.location;
//    NSLog(@"location4 %d",location4);
    
    if (location4) {
        [self change:[UIColor redColor] range:NSMakeRange(location3+1, 2)];
    }
    
}

//改变姿态颜色
-(void)change:(UIColor *) color range:(NSRange)range
{
    [AttriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)color.CGColor
                        range:range];
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.f, -1.f));
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)AttriString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    CFRelease(framesetter);
    
    CTFrameDraw(frame, ctx);
    CFRelease(frame);
}

-(void)reflush:(NSString *) mString
{
    [self ChangeNumbersColorFromString:mString];
    [self setNeedsDisplay];
}

+(CGPoint) getLableBackPosition:(UILabel *)label
{
    CGPoint lastPoint ;
    CGSize sz = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
    
    CGSize linesSz = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    if(sz.width <= linesSz.width) //判断是否折行
    {
        lastPoint = CGPointMake(label.frame.origin.x + sz.width, label.frame.origin.y);
    }
    else
    {
        lastPoint = CGPointMake(label.frame.origin.x + (int)sz.width % (int)linesSz.width,linesSz.height - sz.height);
    }
    return lastPoint;
}

-(void)dealloc
{
    [AttriString release];
    [super dealloc];
}

@end
