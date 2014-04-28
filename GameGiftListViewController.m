//
//  GameGiftListViewController.m
//  TheStoreApp
//
//  Created by yuan jun on 12-11-10.
//
//

#import "GameGiftListViewController.h"
#import "RockGameVO.h"
#import "RockGameProductVO.h"
#import "OTSLoadingView.h"

@interface GameGiftListViewController ()

@end

@implementation GameGiftListViewController
@synthesize loadingView = _loadingView;
@synthesize delegate;
-(void)dealloc{
    [_loadingView dealloc];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
        UISwipeGestureRecognizer*sw=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        sw.direction=UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:sw];
        [sw release];
        
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInview:)];
        [self addGestureRecognizer:tap];
        [tap release];
        [self initSubviews];
    }
    return self;
}

-(void)swipe:(UISwipeGestureRecognizer*)gesture{
    if (gesture.direction==UISwipeGestureRecognizerDirectionUp) {
        [delegate gestureHiddenGiftList];
    }
}

-(void)tapInview:(UITapGestureRecognizer*)tap{
   CGPoint p=[tap locationInView:self];
    if (p.y>364) {
        [delegate gestureHiddenGiftList];
    }
}

-(void)initSubviews{
    bgImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 305, 364)];
    bgImg.image=[UIImage imageNamed:@"game_giftListBG.png"];
    bgImg.center=CGPointMake(160, 181);
    //bgImg.userInteractionEnabled = YES;
    [self addSubview:bgImg];
    [bgImg release];
    
    UIImageView*tit=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 165, 22)];
    tit.image=[UIImage imageNamed:@"gameGiftTitle.png"];
    tit.center=CGPointMake(160, 23);
    [bgImg addSubview:tit];

    for (int i=0; i<4; i++) {
        CGRect rect;
        switch (i) {
            case 0:
                rect=CGRectMake(45, 60, 85, 85);
                break;
            case 1:
                rect=CGRectMake(183, 60, 85, 85);
                break;
            case 2:
                rect=CGRectMake(45, 170, 85, 85);
                break;
            case 3:
                rect=CGRectMake(183, 170, 85, 85);
                break;
            default:
                break;
        }
        UIButton* giftbox=[UIButton buttonWithType:UIButtonTypeCustom];
        giftbox.frame=rect;
        [giftbox setBackgroundImage:[UIImage imageNamed:@"game_box_unsel.png"] forState:UIControlStateNormal];
        [giftbox setBackgroundImage:[UIImage imageNamed:@"game_box_sel.png"] forState:UIControlStateSelected];
        giftbox.tag=100+i;
        [giftbox addTarget:self action:@selector(giftBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [bgImg addSubview:giftbox];
        
        UIButton*counponBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        counponBtn.frame=CGRectMake(15+(i*70), 287, 69, 43);
        [counponBtn setBackgroundImage:[UIImage imageNamed:@"game_counpon_sel.png"] forState:UIControlStateSelected];
        [counponBtn setBackgroundImage:[UIImage imageNamed:@"game_counpon_unsel.png"] forState:UIControlStateNormal];
        counponBtn.tag=10+i;
        [bgImg addSubview:counponBtn];
    }

    
}

-(void)giftBtnSelected:(UIButton*)aBtn
{
    for (int i = 0; i < 4; i++)
    {
        UIButton *theBtn = (UIButton *)[bgImg viewWithTag:100 + i];
        theBtn.selected = (theBtn.tag == aBtn.tag);
    }
}



-(void)updateWihtRockGameVO:(RockGameVO*)aGameVO
{
    NSArray *giftList = aGameVO.rockGameProdList;
    __block int loadImgCount = 0;
    int couponNum=[aGameVO.couponNum intValue];
    for (int i = 0; i < giftList.count; i++)
    {
        if (i > 3)
        {
            break;
        }
        
        RockGameProductVO *rockGameProductVO = [giftList objectAtIndex:i];
        UIButton* giftbox = (UIButton*)[bgImg viewWithTag:100 + i];
        UIButton* counponBtn = (UIButton*)[bgImg viewWithTag:10 + i];
        
        BOOL isGiftSent = rockGameProductVO.isGiftSent;
        giftbox.selected = isGiftSent;
        if (couponNum) {
            counponBtn.selected = YES;
            couponNum--;
        }
        
        if (isGiftSent)
        {
            loadImgCount++;
            [self.loadingView showInView:self];
            
            __block UIImage * unselectedImage = nil;
            __block UIImage * selectedImage = nil;
            [self performInThreadBlock:^{
                
                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:rockGameProductVO.pictureUnpicked]];
                unselectedImage = [[UIImage imageWithData:imgData] retain];
                
                imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:rockGameProductVO.picturePicked]];
                selectedImage = [[UIImage imageWithData:imgData] retain];
                
            } completionInMainBlock:^{
                
                if (unselectedImage && selectedImage)
                {
                    [giftbox setImage:unselectedImage forState:UIControlStateNormal];
                    [giftbox setImage:selectedImage forState:UIControlStateSelected];
                    [giftbox setImage:selectedImage forState:UIControlStateHighlighted];
                    
                    [unselectedImage release];
                    [selectedImage release];
                }
                
                loadImgCount--;
                if (loadImgCount <= 0)
                {
                    [self.loadingView hide];
                }
                
            }];
        }
        else
        {
            [giftbox setImage:nil forState:UIControlStateNormal];
            [giftbox setImage:nil forState:UIControlStateSelected];
            [giftbox setImage:nil forState:UIControlStateHighlighted];
        }
    }
}


@end
