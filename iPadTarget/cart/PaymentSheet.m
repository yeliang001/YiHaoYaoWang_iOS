//
//  PaymentSheet.m
//  yhd
//
//  Created by jun yuan on 12-8-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PaymentSheet.h"
#import "PayInWebViewCell.h"
#import "DataHandler.h"
@interface PaymentSheet ()
@property(nonatomic,retain) NSArray *mpaymethodImageArray;
@property(nonatomic,retain) NSArray *mpaymethodTextArray;
@end

@implementation PaymentSheet
@synthesize delegate;
@synthesize mBankArray;
@synthesize mpaymethodTextArray;
@synthesize mpaymethodImageArray;
-(void)dealloc{
    [mpaymethodTextArray release];
    [mpaymethodImageArray release];
    [mBankArray release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* barCloseButton=[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeModal:)];
    self.navigationItem.rightBarButtonItem=barCloseButton;
    [barCloseButton release];
    
    payTable=[[UITableView alloc] initWithFrame:self.view.bounds];
    payTable.delegate=self;
    payTable.dataSource=self;
    payTable.backgroundColor=[UIColor clearColor];
    [self.view addSubview:payTable];
    [payTable release];
    mBankArray=[[NSMutableArray alloc] init];
    [self otsDetatchMemorySafeNewThreadSelector:@selector(updatePayList) toTarget:self withObject:nil];
}
- (void)updatePayList{
    NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
    NSArray* tempBanklist= [[DataHandler sharedDataHandler] paymentBankList] ;
    if (mBankArray==nil) {
        mBankArray=[[NSMutableArray alloc] init];
    }
    NSLog(@"%@",tempBanklist);
    [mBankArray addObjectsFromArray:tempBanklist];
    NSLog(@"%@",mBankArray);
    [payTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:[NSThread isMainThread]];
    [pool release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
}
-(void)closeModal:(id)sender{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma mark tableViewDelegate&&tableViewDataSource
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
    BankVO* bankVO=[mBankArray objectAtIndex:indexPath.row];
    cell.mUrl=bankVO.logo;
    cell.mpaymethodLabel.text=bankVO.bankname;
    [cell loadimage];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"popPayInWebView" object:[NSNumber numberWithInt:indexPath.row] userInfo:nil];
    PayInWebViewCell*cell=(PayInWebViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gouinpayinwebviewcell"]] autorelease];
    BankVO* bankvo=[mBankArray objectAtIndex:indexPath.row];
    [delegate selectedPayment:bankvo];
    [self closeModal:nil];
}

@end
