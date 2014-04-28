//
//  CityChooseAddressViewController.m
//  yhd
//
//  Created by dev dev on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CityChooseAddressViewController.h"
#import "ProvinceChooseAddressCell.h"
#import "CityVO.h"
@interface CityChooseAddressViewController ()

@end

@implementation CityChooseAddressViewController
@synthesize mProvinceId;
@synthesize mcity;
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
    [self getcity:mProvinceId];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mcity count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"CityChooseAddressCell";
    
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
    cell.textLabel.text = ((CityVO*)[mcity objectAtIndex:indexPath.row]).cityName;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"System" size:17];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(CityChooseAtIndex::)])
    {
        [self.delegate CityChooseAtIndex:indexPath.row:mcity];
    }
}
#pragma mark - Address Service
-(void)getcity:(NSNumber*)provinceid
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(getcityfromserver:) toTarget:self withObject:mProvinceId];
}
-(void)getcityfromserver:(NSNumber*)provinceid
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    NSLog(@"%@",provinceid);
    self.mcity = [service getCityByProvinceId:[GlobalValue getGlobalValueInstance].trader provinceId:provinceid];
    [mTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [pool drain];
}
@end
