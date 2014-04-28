//
//  OTSMfStackLabel.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSMfStackLabel.h"

#define LBL_HEIGHT  15

@implementation OTSMfStackLabel
@synthesize statusMessages, bigTransparentBtn, delegate;

-(UILabel*)labelWithFrame:(CGRect)aFrame text:(NSString*)aText
{
    UILabel* lbl = [[[UILabel alloc] initWithFrame:aFrame] autorelease];
    lbl.text = aText;
    lbl.font = [UIFont systemFontOfSize:14.f];
    lbl.numberOfLines = 0;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor blackColor];
    lbl.textAlignment = NSTextAlignmentLeft;
    
    return lbl;
}

-(void)setStatusMessages:(NSArray *)aStatusMessages
{
    if (aStatusMessages != statusMessages)
    {
        //test code...
//        NSMutableArray* testArr = [NSMutableArray arrayWithArray:aStatusMessages];
//        [testArr addObject:@"sadasdasdasdasdadas"];
//        [testArr addObject:@"sadasdasdasdasdadassadasdasdasdasdadassadasdasdasdasdadas"];
        //test code...
        
        [statusMessages release];
        statusMessages = [aStatusMessages retain];
        
        //
        for (UIView* sub in self.subviews)
        {
            [sub removeFromSuperview];
        }
        
        //
        int count = [statusMessages count];
        //NSLog(@"count:%d", count);
        float offsetY = 28;
        
        if (count <= 0)
        {
            // NOTICE: dont know why count = 0, here regurad as "已发货"
            UILabel* lbl = [self labelWithFrame:CGRectMake(10, offsetY, self.frame.size.width - 50, LBL_HEIGHT) text:@"不能得到包裹状态"];
            [lbl sizeToFit];
            [self addSubview:lbl];
            offsetY += lbl.frame.size.height;
        }
        else
        {
            for (int i = 0; i < count; i++)
            {
                UILabel* lbl = [self labelWithFrame:CGRectMake(10, offsetY, self.frame.size.width - 50, LBL_HEIGHT) text:[statusMessages objectAtIndex:i]];
                [lbl sizeToFit];
                [self addSubview:lbl];
                offsetY += lbl.frame.size.height;
            } 
        }
        
        
        //NSLog(@"new frame:%f, %f, %f, %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, offsetY);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, offsetY + 28);
        
        //
        [bigTransparentBtn removeFromSuperview];
        self.bigTransparentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bigTransparentBtn.frame = self.bounds;
        bigTransparentBtn.backgroundColor = [UIColor clearColor];
        [bigTransparentBtn addTarget:self action:@selector(buttonUpInsideAction) forControlEvents:UIControlEventTouchUpInside];
        [bigTransparentBtn addTarget:self action:@selector(buttonDownAction) forControlEvents:UIControlEventTouchDown];
        [bigTransparentBtn addTarget:self action:@selector(buttonUpAction) forControlEvents:UIControlEventTouchUpOutside];
        [bigTransparentBtn addTarget:self action:@selector(buttonUpAction) forControlEvents:UIControlEventTouchDragOutside];
        
        [bigTransparentBtn setBackgroundImage:[UIImage imageNamed:@"white1x1.png"] forState:UIControlStateNormal];
        [bigTransparentBtn setBackgroundImage:[UIImage imageNamed:@"skyblue1x1.png"] forState:UIControlStateHighlighted];
        [self addSubview:bigTransparentBtn];
        
        UIImage* arrowImg = [UIImage imageNamed:@"mf_title_arrow.png"];
        //float scale =[[UIScreen mainScreen] scale];
        UIImageView* arrowImgView = [[[UIImageView alloc] initWithImage:arrowImg] autorelease];
        arrowImgView.tag = OTS_MAGIC_TAG_NUMBER;
        
        CGSize arrowSize = arrowImg.size;
        arrowSize.width /= 2;
        arrowSize.height /= 2;
        arrowImgView.frame = CGRectMake(bigTransparentBtn.frame.size.width - arrowSize.width - 20
                                        , (bigTransparentBtn.frame.size.height - arrowSize.width) / 2
                                        , arrowSize.width, arrowSize.height);
        [bigTransparentBtn addSubview:arrowImgView];
        
        [self sendSubviewToBack:bigTransparentBtn];
    }
}

-(void)changeLabelColor:(UIColor*)aColor
{
    if (aColor)
    {
        for (UIView* sub in self.subviews)
        {
            if ([sub isKindOfClass:[UILabel class]])
            {
                ((UILabel*)sub).textColor = aColor;
            }
        }
    }
}

-(void)buttonDownAction
{
    [self changeLabelColor:[UIColor whiteColor]];
}

-(void)buttonUpAction
{
    [self changeLabelColor:[UIColor blackColor]];
}

-(void)buttonUpInsideAction
{
    [self buttonUpAction];
    
    SEL handlerSel = @selector(handleInfoBtnClicked);
    if ([delegate respondsToSelector:handlerSel])
    {
        [delegate performSelector:handlerSel];
    }
}

-(void)extraInit
{

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor whiteColor];
        [self extraInit];
    }
    return self;
}

-(void)dealloc
{
    [statusMessages release];
    [bigTransparentBtn release];
    
    [super dealloc];
}

@end
