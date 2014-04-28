//
//  SwitchProvince.m
//  TheStoreApp
//
//  Created by jiming huang on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SwitchProvince.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalValue.h"
#import "TheStoreAppAppDelegate.h"

@implementation SwitchProvince

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    NSNumber *provinceId=[[GlobalValue getGlobalValueInstance] provinceId];
    if (provinceId==nil) {
        [m_TitleLabel setText:@"收货省份-上海"];
    } else {
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths objectAtIndex:0];
        NSString *filename=[path stringByAppendingPathComponent:@"SaveProvinceId.plist"];
        NSMutableArray *array=[[NSMutableArray alloc] initWithContentsOfFile:filename];
        NSString *provinceName=[array objectAtIndex:0];
        [m_TitleLabel setText:[NSString stringWithFormat:@"收货省份-%@",provinceName]];
        [array release];
    }
    m_TitleArray=[[NSMutableArray alloc] init];
    m_AllProvinceArray=[[NSMutableArray alloc] init];
    NSMutableArray *mArray=nil;
    if ([GlobalValue getGlobalValueInstance].gpsProvinceStr!=nil) {
        [m_TitleArray addObject:@"定位省份"];
        mArray=[[NSMutableArray alloc] init];
        [mArray addObject:[GlobalValue getGlobalValueInstance].gpsProvinceStr];
        [m_AllProvinceArray addObject:mArray];
        [mArray release];
    }
    [m_TitleArray addObject:@"热门省份"];
    [m_TitleArray addObject:@"华东地区"];
    [m_TitleArray addObject:@"华北地区"];
    [m_TitleArray addObject:@"华南地区"];
    [m_TitleArray addObject:@"华中地区"];
    
    //热门省份
    mArray=[[NSMutableArray alloc] init];
    [mArray addObject:@"上海"];
    [mArray addObject:@"北京"];
    [mArray addObject:@"广东"];
    [mArray addObject:@"江苏"];
    [mArray addObject:@"浙江"];
    [m_AllProvinceArray addObject:mArray];
    [mArray release];
    //华东地区
    mArray=[[NSMutableArray alloc] init];
    [mArray addObject:@"上海"];
    [mArray addObject:@"江苏"];
    [mArray addObject:@"浙江"];
    [mArray addObject:@"安徽"];
    [mArray addObject:@"山东"];
    [m_AllProvinceArray addObject:mArray];
    [mArray release];
    //华北地区
    mArray=[[NSMutableArray alloc] init];
    [mArray addObject:@"北京"];
    [mArray addObject:@"天津"];
    [mArray addObject:@"河北"];
    [mArray addObject:@"山西"];
    [mArray addObject:@"吉林"];
    [mArray addObject:@"黑龙江"];
    [mArray addObject:@"辽宁"];
    [mArray addObject:@"内蒙古"];
    [m_AllProvinceArray addObject:mArray];
    [mArray release];
    //华南地区
    mArray=[[NSMutableArray alloc] init];
    [mArray addObject:@"广东"];
    [mArray addObject:@"海南"];
    [mArray addObject:@"广西"];
    [mArray addObject:@"福建"];
    [mArray addObject:@"四川"];
    [mArray addObject:@"重庆"];
    [mArray addObject:@"贵州"];
    [mArray addObject:@"云南"];
    [mArray addObject:@"西藏"];
    [m_AllProvinceArray addObject:mArray];
    [mArray release];
    //华中地区
    mArray=[[NSMutableArray alloc] init];
    [mArray addObject:@"湖北"];
    [mArray addObject:@"湖南"];
    [mArray addObject:@"河南"];
    [mArray addObject:@"江西"];
    [mArray addObject:@"陕西"];
    [mArray addObject:@"甘肃"];
    [mArray addObject:@"青海"];
    [mArray addObject:@"宁夏"];
    [mArray addObject:@"新疆"];
    [m_AllProvinceArray addObject:mArray];
    [mArray release];
    
    [self showSwitchProvince];
}

-(void)showSwitchProvince
{
    CGFloat yValue=8.0+44;
    UIView *commentView=[[[UIView alloc] initWithFrame:CGRectMake(7, yValue, 306, 50)] autorelease];
    [commentView.layer setBorderWidth:1.0];
    [commentView.layer setBorderColor:[[UIColor colorWithRed:255.0/255.0 green:219.0/255.0 blue:167.0/255.0 alpha:1.0] CGColor]];
    [commentView setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:254.0/254.0 blue:238.0/255.0 alpha:1.0]];
    [self.view addSubview:commentView];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 16, 16)];
    [imageView setImage:[UIImage imageNamed:@"switchProvince_warn.png"]];
    [commentView addSubview:imageView];
    [imageView release];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(30, 0, 275, 50)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"因各省份所售商品不同，请根据您的收货地址选择相应的省份"];
    [label setFont:[UIFont boldSystemFontOfSize:15.0]];
    [label setNumberOfLines:2];
    [commentView addSubview:label];
    [label release];
    
    yValue+=58.0;
    UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, self.view.frame.size.height-yValue+49)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
}

- (IBAction)cancelBtnClicked:(id)sender
{
    CATransition *animation=[CATransition animation]; 
	[animation setDuration:0.3f];
	[animation setTimingFunction:UIViewAnimationCurveEaseInOut];
	[animation setType:kCATransitionReveal];
	[animation setSubtype: kCATransitionFromBottom];
	[self.view.superview.layer addAnimation:animation forKey:@"Reveal"];
    
    [self removeSelf];
    [SharedDelegate setM_GpsAlertDisAble:NO];
}

- (NSString *)currentProvinceName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *path=[paths objectAtIndex:0];
	NSString *filename=[path stringByAppendingPathComponent:@"SaveProvinceId.plist"]; 
	NSArray *userArray=[NSArray arrayWithContentsOfFile:filename];
    NSString *curProvince=[userArray objectAtIndex:0];
    return curProvince;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [m_TitleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    NSArray *array=[m_AllProvinceArray objectAtIndex:section];
    return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    NSString *string=[m_TitleArray objectAtIndex:section];
    return string;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier=@"MyIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    if ([GlobalValue getGlobalValueInstance].gpsProvinceStr!=nil && [indexPath section]==0) {
        NSString *string=[[m_AllProvinceArray objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
        cell.textLabel.text=[NSString stringWithFormat:@"%@",string];
    } else {
        cell.textLabel.text=[[m_AllProvinceArray objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *string=[[m_AllProvinceArray objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    [self cancelBtnClicked:nil];
    NSString *curProvinceStr=[self currentProvinceName];
    if (![string isEqualToString:curProvinceStr])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ProvinceChanged" object:string];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark -
-(void)releaseMyResoures
{
    OTS_SAFE_RELEASE(m_TitleArray);
    OTS_SAFE_RELEASE(m_AllProvinceArray);
    
    // release outlet
    OTS_SAFE_RELEASE(m_TitleLabel);
    OTS_SAFE_RELEASE(m_ContentView);
	// remove vc
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseMyResoures];
}

-(void)dealloc
{
    [self releaseMyResoures];
    [super dealloc];
}

@end
