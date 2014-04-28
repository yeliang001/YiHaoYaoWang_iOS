//
//  ProvinceViewController.m
//  yhd
//
//  Created by  on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProvinceViewController.h"
#import "ProvinceVO.h"
#import "DataHandler.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "OTSGpsHelper.h"


@interface ProvinceViewController ()

@end

@implementation ProvinceViewController
@synthesize listData,provinceDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [listData release];
    [super dealloc];
}

-(NSArray*)arrayOfGpsProvinceName
{
    if ([OTSGpsHelper sharedInstance].gpsProvinceVO==nil) {
        
        ProvinceVO *localProvinceVO = [[[ProvinceVO alloc] init] autorelease];
        localProvinceVO.provinceName = @"上海";
        localProvinceVO.nid = [NSNumber numberWithInt:1];
        
        [OTSGpsHelper sharedInstance].gpsProvinceVO = localProvinceVO;
    }
    
    return [NSMutableArray arrayWithObject:[OTSGpsHelper sharedInstance].gpsProvinceVO.provinceName];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [provinceDic setObject:[self arrayOfGpsProvinceName] forKey:@"定位省份"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //华东地区
    NSMutableArray *mArray2=[NSMutableArray arrayWithCapacity:5];
    [mArray2 addObject:@"上海"];
    [mArray2 addObject:@"江苏"];
    [mArray2 addObject:@"浙江"];
    [mArray2 addObject:@"安徽"];
    [mArray2 addObject:@"山东"];
    
    NSMutableArray *mArray3=[NSMutableArray arrayWithCapacity:5];
    [mArray3 addObject:@"北京"];
    [mArray3 addObject:@"天津"];
    [mArray3 addObject:@"河北"];
    [mArray3 addObject:@"山西"];
    [mArray3 addObject:@"内蒙古"];
    [mArray3 addObject:@"辽宁"];
    [mArray3 addObject:@"吉林"];
    [mArray3 addObject:@"黑龙江"];
    
    
    NSMutableArray *mArray4=[NSMutableArray arrayWithCapacity:5];
    [mArray4 addObject:@"广东"];
    [mArray4 addObject:@"广西"];
    [mArray4 addObject:@"海南"];
    [mArray4 addObject:@"福建"];
    [mArray4 addObject:@"四川"];
    [mArray4 addObject:@"重庆"];
    [mArray4 addObject:@"贵州"];
    [mArray4 addObject:@"云南"];
    [mArray4 addObject:@"西藏"];
    NSMutableArray *mArray5=[NSMutableArray arrayWithCapacity:5];
    
    [mArray5 addObject:@"湖北"];
    [mArray5 addObject:@"湖南"];
    [mArray5 addObject:@"河南"];
    [mArray5 addObject:@"江西"];
    [mArray5 addObject:@"陕西"];
    [mArray5 addObject:@"甘肃"];
    [mArray5 addObject:@"青海"];
    [mArray5 addObject:@"宁夏"];
    [mArray5 addObject:@"新疆"];
    
    provinceDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:[self arrayOfGpsProvinceName], @"定位省份",
                 mArray2,@"华东地区",
                 mArray3,@"华北东北",
                 mArray4,@"华南西南",
                 mArray5,@"华中西北",
                 nil];
    
    [provinceDic retain];
    self.listData=[NSArray arrayWithObjects:@"定位省份", @"华东地区",@"华北东北",@"华南西南",@"华中西北", nil];
    
    //self.listData=[provinceDic allKeys];
}
#pragma mark -
#pragma mark Table Data Source Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
        return [self.listData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CustomCellIdentifier = @"CateCellIdentifier ";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];

    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier] autorelease];
    }
    NSUInteger row = [indexPath row];
    
    NSString *area = [self.listData objectAtIndex:row];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UIImageView *bg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"province_bg.png"]];
     bg.frame=CGRectMake(0, 0, 459, 80);
    if (row==listData.count-1) {
        bg.image=[UIImage imageNamed:@"province_bg1.png"];
       
    }
    
    //bg.userInteractionEnabled=YES;
    [cell addSubview:bg];
    [bg release];
   
   
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, 270.0, 30.0) ];
    addressLabel.text=area;
    //addressLabel.textColor = [UIColor whiteColor];  
    addressLabel.backgroundColor=[UIColor clearColor];
    //addressLabel.textAlignment=NSTextAlignmentCenter;
    addressLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:17];
    //  addressLabel.font= [addressLabel.font fontWithSize:19];
    [bg insertSubview:addressLabel atIndex:1];
    [addressLabel release];
    
    NSArray *array=[provinceDic objectForKey:area];
    int x=15;
    
    for (NSString *province in array) {
        
        UIButton *provinceBut=[UIButton buttonWithType:UIButtonTypeCustom];
        provinceBut.layer.cornerRadius = 8;
        provinceBut.layer.masksToBounds = YES;
        [provinceBut setTitleColor:kBlackColor forState:UIControlStateNormal];
        [provinceBut setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [provinceBut setBackgroundImage:[UIImage imageNamed:@"cate_butbg.png"] forState:UIControlStateHighlighted];
        [provinceBut setTitle:province forState:UIControlStateNormal];
        //provinceBut.titleLabel.font=[UIFont fontWithName:kCellButFontname size:15];
        provinceBut.titleLabel.font=[provinceBut.titleLabel.font fontWithSize:16];
        [provinceBut addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        int width=47;
        if (province.length>2) {
            width=60;
        }
        [provinceBut setFrame:CGRectMake(x, 42, width, 30.0)];//
        [cell addSubview:provinceBut];
//        if ([province isEqualToString:dataHandler.province.provinceName]) {
//            provinceBut.selected=YES;
//        }
        x+=width;
        
    }
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSUInteger row = [indexPath row];
//    ProvinceVO *province = [self.listData objectAtIndex:row];
//    [OTSGpsHelper sharedInstance].provinceVO=province;
//    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:province,@"province", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyProvinceChange object:nil userInfo:dic];
//    
    
}

-(void)butClick:(UIButton *)but{
    NSString* rootPath = [[NSBundle mainBundle]resourcePath];
    NSString* path = [rootPath stringByAppendingPathComponent:@"ProvinceID.plist"];
    
    NSDictionary *provinceid=[NSDictionary dictionaryWithContentsOfFile:path];
    
    
    ProvinceVO *province = [[ProvinceVO alloc]init];
    province.provinceName=but.titleLabel.text;
    province.nid=[NSNumber numberWithInt:[[provinceid objectForKey:province.provinceName] intValue]];
    [OTSGpsHelper sharedInstance].provinceVO = province;
    
    BOOL provinceChanged = NO;
    if ([GlobalValue getGlobalValueInstance].provinceId == nil
        || [[GlobalValue getGlobalValueInstance].provinceId intValue] != [province.nid intValue])
    {
        [GlobalValue getGlobalValueInstance].provinceId = province.nid;
        provinceChanged = YES;
    }
    
    
    [dataHandler saveProvice];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:province,@"province", nil];
    NSLog(@"province.nid==%@",province.nid);
    
    if (provinceChanged)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyProvinceChange object:nil userInfo:dic];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyDismissPopOverProvince object:nil userInfo:nil];
    }
    
    [province release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
     provinceTableView = nil;
}

@end
