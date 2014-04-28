//
//  OTSAddMinusTextField.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-19.
//
//

#import "OTSAddMinusTextField.h"

@implementation OTSAddMinusTextField


-(NSUInteger)count
{
    NSUInteger count = [self.txtFd.text integerValue];
    return count;
}

-(void)setCount:(NSUInteger)count
{
    NSString *txt = [NSString stringWithFormat:@"%d", count];
    self.txtFd.text = txt;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [_txtFd release];
    [_btnAdd release];
    [_btnMinus release];
    [super dealloc];
}

-(void)decideMinusBtnEnable
{
    self.btnMinus.enabled = (self.count > 1);
}

-(void)awakeFromNib
{
    [self decideMinusBtnEnable];
}

#pragma mark - actions
-(IBAction)addAction:(id)sender
{
    LOG_THE_METHORD;
    
    NSUInteger count = self.count;
    count++;
    self.count = count;
    
    [self.delegate textField:self addOrMinus:YES];
    
    [self decideMinusBtnEnable];
}

-(IBAction)minusAction:(id)sender
{
    LOG_THE_METHORD;
    NSUInteger count = self.count;
    count--;
    self.count = count;
    
    [self.delegate textField:self addOrMinus:NO];
    
    [self decideMinusBtnEnable];
}

@end
