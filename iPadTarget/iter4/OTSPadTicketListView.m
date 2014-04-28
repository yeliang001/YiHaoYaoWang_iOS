//
//  OTSPadTicketListView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-28.
//
//

#import "OTSPadTicketListView.h"
#import "UIView+LayerEffect.h"

@implementation OTSPadTicketListView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [_btnUnused release];
    [_btnUsed release];
    [_btnExpired release];
    [_tableView release];
    [_emptyView release];
    [_emptyLabel release];
    [super dealloc];
}

-(void)awakeFromNib
{
    UIColor *red = [UIView colorFromRGB:0xCC0000];
    UIColor *black = [UIColor blackColor];
    UIColor *veryLightGray = [UIView colorFromRGB:0xE4E4E4];
    
    [self.btnUnused setTitleColor:black forState:UIControlStateNormal];
    [self.btnUsed setTitleColor:black forState:UIControlStateNormal];
    [self.btnExpired setTitleColor:black forState:UIControlStateNormal];
    
    [self.btnUnused setTitleColor:red forState:UIControlStateSelected];
    [self.btnUsed setTitleColor:red forState:UIControlStateSelected];
    [self.btnExpired setTitleColor:red forState:UIControlStateSelected];
    
    [self.btnUnused applyBorderWithWidth:2 color:veryLightGray];
    [self.btnUsed applyBorderWithWidth:2 color:veryLightGray];
    [self.btnExpired applyBorderWithWidth:2 color:veryLightGray];
    
    self.emptyLabel.text = @"";
}

-(IBAction)btnSelected:(id)sender
{
    self.btnUnused.selected = NO;
    self.btnUsed.selected = NO;
    self.btnExpired.selected = NO;
    
    UIColor *gray = [UIView colorFromRGB:0xF4F4F4];
    UIColor *white = [UIColor whiteColor];
    
    [self.btnUnused setBackgroundColor:gray];
    [self.btnUsed setBackgroundColor:gray];
    [self.btnExpired setBackgroundColor:gray];
    
    UIButton *theBtn = (UIButton*)sender;
    theBtn.selected = YES;
    [theBtn setBackgroundColor:white];
    self.emptyView.hidden = YES;
    
    if (sender == self.btnUnused)
    {
        self.emptyLabel.text = @"暂无未使用抵用券";
        [_delegate ticketTabSelected:kTicketTabUnused];
    }
    
    else if (sender == self.btnUsed)
    {
        self.emptyLabel.text = @"暂无已使用抵用券";
        [_delegate ticketTabSelected:kTicketTabUsed];
    }
    
    else if (sender == self.btnExpired)
    {
        self.emptyLabel.text = @"暂无已过期抵用券";
        [_delegate ticketTabSelected:kTicketTabExpired];
    }
}

@end
