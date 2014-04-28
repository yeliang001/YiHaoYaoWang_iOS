//
//  OTSProdPromHeadView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-20.
//
//

#import "OTSProdPromHeadView.h"

@implementation OTSProdPromHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [_nameLabel release];
    [_timeLabel release];
    [_symbolIV release];
    [_markIV release];
    [super dealloc];
}

-(void)swtichToExchangeBuy
{
    self.markIV.image = [UIImage imageNamed:@"pdLeftTopYellowCornerMark"];
    self.symbolIV.image = [UIImage imageNamed:@"pdExchangeBuySymbol"];
}

+(float)height
{
    return 45;
}

-(void)switchToPoppedMode
{
    CGRect newRc = CGRectOffset(self.timeLabel.frame, -100, 0);
    self.timeLabel.frame = newRc;
}

@end
