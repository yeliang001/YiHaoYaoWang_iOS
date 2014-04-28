//
//  OTSPhoneWeRockResultNormalView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-10-26.
//
//

#import "OTSPhoneWeRockResultNormalView.h"
#import "RockResultV2.h"
#import "RockProductV2.h"
#import "OTSUtility.h"

@interface OTSPhoneWeRockResultNormalView ()
@property OTSWeRockResultType   resultType;
@property(nonatomic,strong)NSTimer* progressTimer;
@property(nonatomic)NSInteger waitTime;
@end

@implementation OTSPhoneWeRockResultNormalView
@synthesize bgGrayIV;
@synthesize bgYellowIV;
@synthesize bgSunIV;
@synthesize productInfoView;
@synthesize productTitleLabel;
@synthesize productPictureIV;
@synthesize productCountDownLabel;
@synthesize productPriceLabel;
@synthesize productMarketPriceLabel;
@synthesize productCornerMarkIV;
@synthesize productRobTimeLabel;
@synthesize ticketInfoView;
@synthesize ticketPriceLabel;
@synthesize ticketTimeLabel;
@synthesize gamePicIV;
@synthesize cornerIV;
@synthesize cornerYellowIV;
@synthesize resultNameLabel;
@synthesize resultCountLabel;
@synthesize starIV;
@synthesize vanishBtn;
@synthesize addToCartBtn;
@synthesize addFavBtn;
@synthesize getTicketBtn;
@synthesize gameActiveBtn;
@synthesize cornerMarkSuperIV;
@synthesize cornerMarkHalfIV;
@synthesize cornerMarkGuessIV;
@synthesize delegate = _delegate;
@synthesize resultType = _resultType;
@synthesize rockResult = _rockResult;
@synthesize progressTimer;
@synthesize waitTime = _waitTime;

#pragma mark - antions -

-(IBAction)vanishAction:(id)sender
{
    LOG_THE_METHORD;
    
    [self.delegate handleRockResultAction:kRockReultActionVanish resultObject:nil];
}

-(IBAction)addToCartAction:(id)sender
{
    LOG_THE_METHORD;
    
    [self.delegate handleRockResultAction:kRockReultActionAddToCart resultObject:nil];
}

-(IBAction)addToFavAction:(id)sender
{
    LOG_THE_METHORD;
    
    [self.delegate handleRockResultAction:kRockReultActionAddToFav resultObject:nil];
}

-(IBAction)getTicketAction:(id)sender
{
    LOG_THE_METHORD;
    
    [self.delegate handleRockResultAction:kRockReultActionGetTicket resultObject:nil];
}

-(IBAction)activateGameAction:(id)sender
{
    LOG_THE_METHORD;
    
    [self.delegate handleRockResultAction:kRockReultActionActivateGame resultObject:nil];
}
-(IBAction)goToDetail:(id)sender{
    LOG_THE_METHORD;
    [self.delegate handleRockResultAction:kRockReultActionToDetail resultObject:nil];
}
-(IBAction)rockNow:(id)sender{
    LOG_THE_METHORD;
    [self.delegate handleRockResultAction:kRockReultActionRockNow resultObject:nil];
}
#pragma mark - life cycle -
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [bgGrayIV release];
    [bgYellowIV release];
    [bgSunIV release];
    [productInfoView release];
    [ticketInfoView release];
    [productTitleLabel release];
    [productPictureIV release];
    [productCountDownLabel release];
    [productPriceLabel release];
    [productMarketPriceLabel release];
    [productCornerMarkIV release];
    [ticketPriceLabel release];
    [resultNameLabel release];
    [resultCountLabel release];
    [starIV release];
    [productRobTimeLabel release];
    [ticketTimeLabel release];
    [cornerIV release];
    [cornerYellowIV release];
    [vanishBtn release];
    [addToCartBtn release];
    [addFavBtn release];
    [getTicketBtn release];
    [gameActiveBtn release];
    [cornerMarkSuperIV release];
    [cornerMarkHalfIV release];
    [cornerMarkGuessIV release];
    [_rockResult release];
    
    [gamePicIV release];
    [_goToDetailBtn release];
    [_mallLogo release];
    [_groupLogo release];
    [_groupProductIV release];
    [_groupPriceLabel release];
    [_groupCountLabel release];
    [_bootLine release];
    [_weRockMainPrizeOK release];
    [_productInfoMainView release];
    [_prizeProgressBg release];
    [_prizeProgress release];
    [_prizeTimeLabel release];
    [_prizeAgainBtn release];
    [_prizeSuccessIV release];
    [_prizeFaildIV release];
    [super dealloc];
}

-(void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateExpiredTime) name:kNotifyWRInventoryCellUpdateTime object:nil];
}

-(void)updateExpiredTime
{
    if (self.resultType == kWeRockResultFree || self.resultType == kWeRockResultDisCount)
    {
        if (self.rockResult.rockProductV2List.count > 0)
        {
            RockProductV2 *rockProduct = [self.rockResult.rockProductV2List objectAtIndex:0];
            NSDate *expireDate = rockProduct.expireDate;
            NSDate *now = [NSDate date];
            if (expireDate && [expireDate compare:now] != NSOrderedAscending)
            {
                //未过期
                int interval = [expireDate timeIntervalSinceNow];
                NSString *timeStr = [OTSUtility timeStringFromInterval:interval];
                self.productCountDownLabel.text = timeStr;
            }
        }
    }
}
-(void)suitIPhone5{
    CGRect rect = self.frame;
    rect.size.height = 455;
    self.frame = rect;
    self.bgGrayIV.frame = rect;
    self.bgGrayIV.image = [[UIImage imageNamed:@"weRockMainBg_normal"]stretchableImageWithLeftCapWidth:0 topCapHeight:110];
    self.bgSunIV.frame = rect;
    self.bgSunIV.image = [[UIImage imageNamed:@"rockbuy_sunBg"]stretchableImageWithLeftCapWidth:0 topCapHeight:110];
    self.bgYellowIV.frame = rect;
    self.bgYellowIV.image = [[UIImage imageNamed:@"rockbuy_sunBg"]stretchableImageWithLeftCapWidth:0 topCapHeight:110];
}

+(OTSPhoneWeRockResultNormalView *)viewFromNibWithOwner:(id)aOwner type:(OTSWeRockResultType)aType rockResult:(RockResultV2*)rockResult
{
    OTSPhoneWeRockResultNormalView *instance = [OTSPhoneWeRockResultNormalView viewFromNibWithOwner:aOwner];
    if (instance)
    {
        if (iPhone5) {
            [instance suitIPhone5];
        }
        [instance addLineToMarkectPrice];
        
        instance.resultType = aType;
        instance.rockResult = rockResult;
        switch (aType)
        {
            case kWeRockResultTicket:
            {
                instance.bgSunIV.hidden = NO;
                instance.productInfoView.hidden = YES;
                instance.ticketInfoView.hidden = NO;
                instance.resultCountLabel.hidden = NO;
                instance.starIV.hidden = NO;
                
                instance.cornerIV.hidden = YES;
                instance.cornerYellowIV.hidden = NO;
                
                instance.vanishBtn.hidden = YES;
                instance.addToCartBtn.hidden = YES;
                instance.addFavBtn.hidden = YES;
                instance.getTicketBtn.hidden = NO;
            }
                break;
                
            case kWeRockResultFree:
            case kWeRockResultDisCount:
            {
                instance.bgSunIV.hidden = NO;
                instance.productTitleLabel.text = @"限时抢购价";
                
                instance.productRobTimeLabel.hidden = NO;
                instance.productCountDownLabel.hidden = NO;
                instance.resultCountLabel.hidden = NO;
                instance.productMarketPriceLabel.hidden = NO;
                
                instance.cornerIV.hidden = YES;
                instance.cornerYellowIV.hidden = NO;
                
                instance.vanishBtn.hidden = YES;
                instance.addFavBtn.hidden = YES;
                
                CGRect addToCartBtnRc = instance.addToCartBtn.frame;
                addToCartBtnRc.origin.x = (instance.frame.size.width - addToCartBtnRc.size.width) / 2;
                instance.addToCartBtn.frame = addToCartBtnRc;
                
                if (aType == kWeRockResultFree)
                {
                    instance.starIV.hidden = NO;
                    instance.productPriceLabel.text = @"￥0";
                    instance.cornerMarkSuperIV.hidden = NO;
                }
                else if (aType == kWeRockResultDisCount)
                {
                    instance.cornerMarkHalfIV.hidden = NO;
                }
                
                
            }
                break;
                
            case kWeRockResultGame:
            {
                instance.bgSunIV.hidden = NO;
                
                instance.productPictureIV.hidden = YES;
                instance.productTitleLabel.hidden = YES;
                instance.productPriceLabel.hidden = YES;
                instance.productMarketPriceLabel.hidden = YES;
                
                instance.cornerIV.hidden = YES;
                instance.cornerYellowIV.hidden = NO;
                
                instance.vanishBtn.hidden = YES;
                instance.addToCartBtn.hidden = YES;
                instance.addFavBtn.hidden = YES;
                instance.gameActiveBtn.hidden = NO;
                
                instance.cornerMarkGuessIV.hidden = YES;
                instance.gamePicIV.hidden = NO;
                
                instance.resultNameLabel.text = @"你送我猜";
            }
                break;
            
            case kWeRockResultGroupon:{
                instance.groupLogo.hidden = NO;
                instance.groupProductIV.hidden = NO;
                instance.groupPriceLabel.hidden = NO;
                instance.groupCountLabel.hidden = NO;
                
                instance.addToCartBtn.hidden = YES;
                instance.addFavBtn.hidden = YES;
                instance.goToDetailBtn.hidden = NO;
                instance.bootLine.hidden = NO;
            }
                break;
            
            case kWeRockResultPrize:{
                instance.groupProductIV.hidden = NO;
                instance.addToCartBtn.hidden = YES;
                instance.addFavBtn.hidden = YES;
                instance.prizeProgressBg.hidden = NO;
                instance.prizeProgress.hidden = NO;
                instance.prizeTimeLabel.hidden = NO;
                instance.waitTime = 15;
                CGRect rect = instance.prizeProgress.frame;
                rect.size.width = 250;
                instance.prizeProgress.frame = rect;
                instance.prizeProgress.image = [[UIImage imageNamed:@"rockbuy_progress"]stretchableImageWithLeftCapWidth:16 topCapHeight:0];
                [instance.prizeTimeLabel setText:[NSString stringWithFormat:@"%d",instance.waitTime]];
                instance.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:instance selector:@selector(prizeTimer) userInfo:nil repeats:YES];
                
            }
                break;
            case kWeRockResultSale:
            case kWeRockResultNormal:{
                if (instance.rockResult.productVOList.count > 0) {
                    ProductVO* productVO = [instance.rockResult.productVOList objectAtIndex:0];
                    if (productVO.isYihaodian.intValue == 0) {
                        instance.mallLogo.hidden = NO;
                        instance.productTitleLabel.text = @"商城价";
                        instance.addToCartBtn.hidden = YES;
                        instance.addFavBtn.hidden = YES;
                        instance.goToDetailBtn.hidden = NO;
                        instance.bootLine.hidden = NO;
                    }
                }
            }
                break;
            case kWeRockResultPrizeSuccess:{
                instance.bgSunIV.hidden = NO;
                instance.productInfoMainView.hidden = YES;
                instance.resultNameLabel.hidden = YES;
                instance.addFavBtn.hidden = YES;
                instance.addToCartBtn.hidden = YES;
                instance.prizeSuccessIV.hidden = NO;
            }
                break;
            case kWeRockResultPrrzeFaild:{
                instance.productInfoMainView.hidden = YES;
                instance.resultNameLabel.hidden = YES;
                instance.addFavBtn.hidden = YES;
                instance.addToCartBtn.hidden = YES;
                instance.prizeFaildIV.hidden = NO;
                instance.prizeAgainBtn.hidden = NO;
            }
                break;
            default:
                break;
        }
    }
    
    return instance;
}
-(void)prizeTimer{
    self.waitTime = self.waitTime-1;
    [self.prizeTimeLabel setText:[NSString stringWithFormat:@"%d",self.waitTime]];
    if (self.waitTime == 0) {
        DebugLog(@"timer over");
        if (self.progressTimer != nil) {
            [self.progressTimer invalidate];
            self.progressTimer = nil;
            [self.delegate handleRockResultAction:kRockReultActionCheckPrize resultObject:nil];
        }
    }else
        DebugLog(@"timer is %d",self.waitTime);
    CGRect rect = self.prizeProgress.frame;
    rect.size.width = rect.size.width - 16.66;
    self.prizeProgress.frame = rect;
}
-(void)addLineToMarkectPrice
{
    UIView *line = [self.productMarketPriceLabel viewWithTag:2000];
    if (line == nil)
    {
        line = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        line.backgroundColor = [UIColor lightGrayColor];
        line.tag = 2000;
        [self.productMarketPriceLabel addSubview:line];
    }
    
    int textLength = [self.productMarketPriceLabel.text length];
    float fontSize = self.productMarketPriceLabel.font.pointSize * 5 / 8;
    float textWidth = textLength * fontSize;
    CGRect labelRc = self.productMarketPriceLabel.frame;
    line.frame = CGRectMake((labelRc.size.width - textWidth) / 2
                            , labelRc.size.height / 2
                            , textWidth
                            , 1);
}

-(void)setMarketPrice:(NSString*)aMarketPriceString
{
    self.productMarketPriceLabel.text = aMarketPriceString;
    //[self.productMarketPriceLabel sizeToFit];  介个方法会导致 alignment不可用
    
    [self addLineToMarkectPrice];
}

@end
