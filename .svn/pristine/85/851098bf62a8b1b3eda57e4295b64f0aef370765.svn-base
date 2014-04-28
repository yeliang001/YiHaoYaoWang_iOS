//
//  OTSPadTicketListCell.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-28.
//
//

#import "OTSPadTicketListCell.h"
#import "UIView+LayerEffect.h"
#import "CouponVO.h"

@interface OTSPadTicketListCell ()
@property  (retain)     CouponVO        *couponVO;
@end

@implementation OTSPadTicketListCell
@synthesize couponVO = _couponVO;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib
{
    UIColor *red = [UIView colorFromRGB:0xCC0000];
    self.labelAmount.textColor = red;
    
    self.labelAmount.text = nil;
    self.labelDescription.text = nil;
    self.labelTime.text = nil;
    self.labelRule.text = nil;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)dealloc {
    [_labelAmount release];
    [_labelDescription release];
    [_labelTime release];
    [_labelRule release];
    [_imageViewExpiredMark release];
    [_imageViewUsedMark release];
    [_couponVO release];
    
    [super dealloc];
}

-(void)updateWithCouponVO:(CouponVO*)aCouponVO
{
    self.couponVO = aCouponVO;
    
    if (aCouponVO)
    {
        
        if (aCouponVO.isUsed)
        {
            self.imageViewUsedMark.hidden = NO;
        }
        
        if (aCouponVO.isExpired)
        {
            self.imageViewExpiredMark.hidden = NO;
        }
        
        self.labelAmount.text = [NSString stringWithFormat:@"%d元", [aCouponVO.amount intValue]];
        self.labelDescription.text = [NSString stringWithFormat:@"指定商品满%@元抵%@元", aCouponVO.threshOld, aCouponVO.amount];
        
        NSString *beginDateStr = [self stringFromDate:aCouponVO.beginTime];
        NSString *expiredDateStr = [self stringFromDate:aCouponVO.expiredTime];
        self.labelTime.text = [NSString stringWithFormat:@"有效日期：%@ ~ %@", beginDateStr, expiredDateStr];
        
        //self.labelRule.text = [NSString stringWithFormat:@"规则：%@", aCouponVO.detailDescription];
        
    }
}

-(NSString *)stringFromDate:(NSDate *)anDate
{
    if (anDate)
    {
        NSDateFormatter *formater = [[[NSDateFormatter alloc] init] autorelease];
        //formater.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
        formater.dateFormat = @"yyyy年MM月dd日";
        return [formater stringFromDate:anDate];
    }
    
    return nil;
}

-(IBAction)showRuleAction:(id)sender
{
    if (self.couponVO)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:PAD_NOTIFY_SHOW_TICKET_RULE object:self.couponVO];
    }
}

@end
