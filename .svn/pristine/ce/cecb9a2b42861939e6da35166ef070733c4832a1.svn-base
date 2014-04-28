//
//  OTSPhoneWeRockMainView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-10-26.
//
//

#import "OTSPhoneWeRockMainView.h"

@implementation OTSPhoneWeRockMainView
@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize product1Btn;



- (void)dealloc {
    [titleLabel release];
    [descriptionLabel release];
    [product1Btn release];

    [_backGroundBg release];
    [super dealloc];
}
-(void)suitIPhone5{
    CGRect rect = self.frame;
    rect.size.height = 455;
    self.frame = rect;
    self.backGroundBg.frame = rect;
    self.backGroundBg.image = [[UIImage imageNamed:@"weRockMainBg_normal"]stretchableImageWithLeftCapWidth:0 topCapHeight:110];
}
+(OTSPhoneWeRockMainView*)viewFromXibWithOwner:(id)aOwner{
    OTSPhoneWeRockMainView* instance = [OTSPhoneWeRockMainView viewFromNibWithOwner:aOwner];
    if (instance) {
        if (iPhone5) {
            [instance suitIPhone5];
        }
    }
    return instance;
}

-(IBAction)productBtnClicked:(id)sender
{
    LOG_THE_METHORD;
}

@end
