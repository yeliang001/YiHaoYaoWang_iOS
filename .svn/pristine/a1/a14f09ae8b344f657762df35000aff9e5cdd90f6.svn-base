//
//  OTSPhoneWebRockInventoryCell.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-10-30.
//
//

#import "OTSPhoneWebRockInventoryCell.h"
#import "OTSUtility.h"
#import "StorageBoxVO.h"
#import "SDImageView+SDWebCache.h"

@implementation OTSPhoneWebRockInventoryCell
@synthesize productView;
@synthesize productMarkeetPriceLabel;              // 市场价格
@synthesize productPromotionPriceLabel;        // 促销价格
@synthesize productTimeLimitLabel;
@synthesize productTimeDownLabel;
@synthesize productPicIV;
@synthesize ticketView;
@synthesize ticketValidDateLabel;
@synthesize ticketMoneyLabel;
@synthesize ticketRuleBtn;
@synthesize statusLabel;
@synthesize nameLabel;
@synthesize addCartBtn;
@synthesize expiredIV;
@synthesize delegate = _delegate;
@synthesize dataModel = _dataModel;


-(void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateExpiredTime) name:kNotifyWRInventoryCellUpdateTime object:nil];
    
    [self.addCartBtn setImage:[UIImage imageNamed:@"wrAddCartBtnGray"] forState:UIControlStateDisabled];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [productView release];
    [ticketView release];
    [statusLabel release];
    [nameLabel release];
    [addCartBtn release];
    [expiredIV release];
    [productMarkeetPriceLabel release];
    [productPromotionPriceLabel release];
    [productTimeDownLabel release];
    [productPicIV release];
    [ticketValidDateLabel release];
    [ticketMoneyLabel release];
    [ticketRuleBtn release];
    [_dataModel release];
    
    [productTimeLimitLabel release];
    [super dealloc];
}

-(void)updateExpiredTime
{
    NSDate *now = [NSDate date];
    BOOL isExpired = NO;
    
    if ([self.dataModel.type intValue] == kRockBoxItemProduct
        && self.dataModel.rockProductV2.expireDate)
    {
        // update time
        if ([self.dataModel.rockProductV2.expireDate compare:now] == NSOrderedAscending)
        {
            isExpired = YES;
        }
        else
        {
            int interval = [self.dataModel.rockProductV2.expireDate timeIntervalSinceNow];
            NSString *timeStr = [OTSUtility timeStringFromInterval:interval];
            self.productTimeDownLabel.text = timeStr;
        }
        
        // update status
        OTSRockProductStatus status = self.dataModel.rockProductV2.getStatus;
        
        self.addCartBtn.hidden = YES;
        self.statusLabel.hidden = YES;
        
        switch (status)
        {
            case kRockProductNotBuy:
            case kRockProductExpired:
            {
                self.addCartBtn.hidden = NO;
            }
                break;
                
            case kRockProductHasBuy:
            case kRockProductHasAddCart:
                
            {
                if (status == kRockProductHasBuy)
                {
                    self.statusLabel.hidden = NO;
                    self.statusLabel.text = @"已购买";
                }
                else if (status == kRockProductHasAddCart)
                {
                    self.addCartBtn.hidden = NO;
                    self.addCartBtn.enabled = NO;
                }
                
                
                self.productTimeDownLabel.hidden = YES;
                self.productTimeLimitLabel.hidden = YES;
            }
                break;
        
            default:
                break;
        }

    }
    else if ([self.dataModel.type intValue] == kRockBoxItemTicket
             && self.dataModel.rockCouponVO.couponVO.expiredTime)
    {
        // update time
        if ([self.dataModel.rockCouponVO.couponVO.expiredTime compare:now] == NSOrderedAscending)
        {
            isExpired = YES;
        }
        
        // update status
        self.statusLabel.text = @"已领取"; //寄存箱中的抵用券一定是已领取的！
        //self.statusLabel.text = ([self.dataModel.rockCouponVO.isReceived intValue] == kRockTicketAcceptted) ? @"已领取" : @"未领取";
    }
    
    if (isExpired)
    {
        self.expiredIV.hidden = NO;
        self.productTimeDownLabel.hidden = YES;
    }
}

-(void)updateWithModel:(StorageBoxVO*)aModel
{
    self.dataModel = aModel;
    if ([aModel.type intValue] == kRockBoxItemProduct)
    {
        // product
        RockProductV2 *rockProduct = self.dataModel.rockProductV2;
        [rockProduct updateMyExpTime];
        
        //update UI with data
        self.nameLabel.text = rockProduct.prodcutVO.cnName;
        //self.productPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [rockProduct.prodcutVO.maketPrice floatValue]];
        
        //[self setMarketPrice:[NSString stringWithFormat:@"￥%.2f", [rockProduct.prodcutVO.maketPrice floatValue]]];
        self.productPromotionPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [rockProduct.prodcutVO.promotionPrice floatValue]];
        
        [self.productPicIV setImageWithURL:[NSURL URLWithString:rockProduct.prodcutVO.miniDefaultProductUrl]];
    }
    else
    {
        // ticket
        RockCouponVO *rockTicket = self.dataModel.rockCouponVO;
        
        self.productView.hidden = YES;
        self.ticketView.hidden = NO;
        self.addCartBtn.hidden = YES;
        self.statusLabel.hidden = NO;
        
        //update UI with data
        self.nameLabel.text = rockTicket.couponVO.description;
        
        NSString *startDate = [self stringFromDate:rockTicket.couponVO.beginTime];
        startDate = startDate ? startDate : [NSDate date];
        NSString *endDate = [self stringFromDate:rockTicket.couponVO.expiredTime];
        
        self.ticketValidDateLabel.text = [NSString stringWithFormat:@"有效日期：%@-%@", startDate, endDate];
        
        self.ticketMoneyLabel.text = [NSString stringWithFormat:@"%d元", [rockTicket.couponVO.amount intValue]];
    }
    
    [self updateExpiredTime];
}

-(NSString*)stringFromDate:(NSDate*)aDate
{
    if (aDate)
    {
        NSDateFormatter *formater = [[[NSDateFormatter alloc] init] autorelease];
        [formater setDateFormat:@"yyyy/MM/dd"];
        return [formater stringFromDate:aDate];
    }
    
    return nil;
}

-(IBAction)addCartAction:(id)sender
{
    SEL selector = @selector(addToCartWithProduct:);
    if ([self.delegate respondsToSelector:selector])
    {
        [self.delegate performSelector:selector withObject:self];
    }
}

-(IBAction)showRuleAction:(id)sender
{
    SEL selector = @selector(showRuleWithCell:);
    if ([self.delegate respondsToSelector:selector])
    {
        [self.delegate performSelector:selector withObject:self];
    }
}

-(void)addLineToMarkectPrice
{
    UIView *line = [self.productMarkeetPriceLabel viewWithTag:2000];
    if (line == nil)
    {
        line = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        line.backgroundColor = [UIColor lightGrayColor];
        line.tag = 2000;
        [self.productMarkeetPriceLabel addSubview:line];
    }
    
    int textLength = [self.productMarkeetPriceLabel.text length];
    float fontSize = self.productMarkeetPriceLabel.font.pointSize * 5 / 8;
    float textWidth = textLength * fontSize;
    CGRect labelRc = self.productMarkeetPriceLabel.frame;
    line.frame = CGRectMake((labelRc.size.width - textWidth) / 2
                            , labelRc.size.height / 2
                            , textWidth
                            , 1);
}

-(void)setMarketPrice:(NSString*)aMarketPriceString
{
    self.productMarkeetPriceLabel.text = aMarketPriceString;
    [self.productMarkeetPriceLabel sizeToFit];
    
    [self addLineToMarkectPrice];
}

@end
