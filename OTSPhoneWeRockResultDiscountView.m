//
//  OTSPhoneWeRockResultDiscountView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-10-26.
//
//

#import "OTSPhoneWeRockResultDiscountView.h"

@implementation OTSPhoneWeRockResultDiscountView


-(id)initFromNibWithOwner:(id)aOwner
{
    self = [super initFromNibWithOwner:aOwner];
    if (self)
    {
        self.bgSunIV.hidden = NO;
        self.productTitleLabel.text = @"限时抢购价";
        self.productRobTimeLabel.hidden = NO;
        self.productCountDownLabel.hidden = NO;
        self.resultCountLabel.hidden = NO;
    }
    return self;
}


@end
