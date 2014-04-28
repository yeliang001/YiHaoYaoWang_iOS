//
//  CountyChooseAddressViewController.m
//  yhd
//
//  Created by dev dev on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CountyChooseAddressViewController.h"
#import "ProvinceChooseAddressCell.h"
#import "CountyVO.h"
#import "CountyChooseAddressCell.h"
@interface CountyChooseAddressViewController ()

@end

@implementation CountyChooseAddressViewController
@synthesize mCityId;
@synthesize mcounty;
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
    [self getcounty:mCityId];
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
    return [mcounty count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"CountyChooseAddressCell";
    
    CountyChooseAddressCell *cell = (CountyChooseAddressCell*)[tableView dequeueReusableCellWithIdentifier:
                                                                   SimpleTableIdentifier];
    if (cell == nil) { 
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"CountyChooseAddressCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CountyLineInAddress@2x.png"]];
        [cell addSubview:image];
        [image setFrame:CGRectMake(0, cell.frame.size.height, 245, 1)];
        [image release];
    }
    cell.textLabel.text = ((CountyVO*)[mcounty objectAtIndex:indexPath.row]).countyName;
    cell.textLabel.font = [UIFont fontWithName:@"System" size:17];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(CountyChooseAtIndex::)])
    {
        [self.delegate CountyChooseAtIndex:indexPath.row:mcounty];
    }
}
#pragma mark - Address Service
-(void)getcounty:(NSNumber *)cityid
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(getcountyfromserver:) toTarget:self withObject:cityid];
}
-(void)getcountyfromserver:(NSNumber*)cityid
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    
    self.mcounty = [service getCountyByCityId:[GlobalValue getGlobalValueInstance].trader cityId:cityid];
    [mtableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [pool drain];
}
@end
