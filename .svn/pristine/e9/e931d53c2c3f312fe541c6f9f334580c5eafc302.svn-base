//
//  ProvinceChooseAddressViewController.m
//  yhd
//
//  Created by dev dev on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProvinceChooseAddressViewController.h"
#import "NSObject+OTS.h"
#import "OTSServiceHelper.h"
#import "ProvinceVO.h"
#import "ProvinceChooseAddressCell.h"
@interface ProvinceChooseAddressViewController ()

@end

@implementation ProvinceChooseAddressViewController
@synthesize mprovince;
@synthesize delegate;
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
    // Do any additional setup after loading the view from its nib.
    [self getprovince];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mprovince count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"ProvinceChooseAddressCell";
    
    ProvinceChooseAddressCell *cell = (ProvinceChooseAddressCell*)[tableView dequeueReusableCellWithIdentifier:
                                               SimpleTableIdentifier];
    if (cell == nil) { 
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"ProvinceChooseAddressCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LineInAddress@2x.png"]];
        [cell addSubview:image];
        [image setFrame:CGRectMake(0, cell.frame.size.height, 185, 1)];
        [image release];
    }
    cell.textLabel.text = ((ProvinceVO*)[mprovince objectAtIndex:indexPath.row]).provinceName;
    cell.textLabel.font = [UIFont fontWithName:@"System" size:17];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(ProvinceChooseAtIndex::)])
    {
        [self.delegate ProvinceChooseAtIndex:indexPath.row:mprovince];
    }
}
#pragma mark - Address service
-(void)getprovince
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(getprovincefromserver) toTarget:self withObject:nil];
}
-(void)getprovincefromserver
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    
    self.mprovince = [service getAllProvince:[GlobalValue getGlobalValueInstance].trader];
    [mTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [pool drain];
}
@end
