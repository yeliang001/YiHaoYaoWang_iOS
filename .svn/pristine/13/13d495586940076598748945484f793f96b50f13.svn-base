//
//  PayInWebView.m
//  yhd
//
//  Created by dev dev on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PayInWebView.h"
#import "PayInWebViewCell.h"
#import "BankVO.h"
@implementation PayInWebView
@synthesize mpaymethodTextArray;
@synthesize mpaymethodImageArray;
@synthesize mBankArray;
@synthesize hasSelectOnlinePay = _hasSelectOnlinePay;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        mselectedindex = -1;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mselectedindex = -1;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    
//    
//}
-(void)dealloc
{
    [mpaymethodImageArray release];
    [mpaymethodTextArray release];
    [super dealloc];
}
-(IBAction)CloseClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"popPayInWebView" object:[NSNumber numberWithInt:mselectedindex] userInfo:nil];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 4;
    return [mBankArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"PayInWebViewCell";
    
    PayInWebViewCell *cell = (PayInWebViewCell*)[tableView dequeueReusableCellWithIdentifier:
                                                           SimpleTableIdentifier];
    if (cell == nil) { 
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"PayInWebViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (!mpaymethodImageArray) {
        self.mpaymethodImageArray = [NSArray arrayWithObjects:@"zhifubao@2x.png",@"zaixianzhifu@2x.png",@"caifutong@2x.png",@"zhaoshangyinhang@2x.png",nil];
    }
    if (!mpaymethodTextArray) {
        //self.mpaymethodTextArray = [NSArray arrayWithObjects:@"支付宝",@"银联支付",@"财付通",@"招商银行",nil];
        NSMutableArray* temp = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<[mBankArray count]; i++)
        {
            [temp addObject:((BankVO*)[mBankArray objectAtIndex:i]).bankname];
        }
        self.mpaymethodTextArray = temp;
    }
    NSLog(@"%i,indexPath.row is %i,text is %@",[mpaymethodTextArray count],indexPath.row,((BankVO*)[mBankArray objectAtIndex:indexPath.row]).bankname);
//    UIImage * image = [UIImage imageNamed:[mpaymethodImageArray objectAtIndex:indexPath.row]];
//    //cell.mpaymethodImageView.image = [UIImage imageNamed:[mpaymethodImageArray objectAtIndex:indexPath.row]];
//    cell.mpaymethodImageView.image = image;
    cell.mUrl = ((BankVO*)[mBankArray objectAtIndex:indexPath.row]).logo;
    cell.mpaymethodLabel.text = [mpaymethodTextArray objectAtIndex:indexPath.row];
    [cell loadimage];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _hasSelectOnlinePay = YES;
    mselectedindex = indexPath.row;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"popPayInWebView" object:[NSNumber numberWithInt:mselectedindex] userInfo:nil];
}
@end
