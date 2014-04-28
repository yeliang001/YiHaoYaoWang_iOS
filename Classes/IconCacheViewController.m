//
//  IconCacheViewController.m
//  TheStoreApp
//
//  Created by yuan jun on 12-12-20.
//
//

#import "IconCacheViewController.h"
#import "GlobalValue.h"
#import "IconDownloadSetting.h"
#import "OTSLoadingView.h"
#import "TheStoreAppAppDelegate.h"
#import "SDDataCache.h"
@interface IconCacheViewController ()

@end

@implementation IconCacheViewController

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
    UIImageView* topNav=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    topNav.userInteractionEnabled=YES;
    topNav.image=[UIImage imageNamed:@"title_bg.png"];
    [self.view addSubview:topNav];
    [topNav release];
    //标题
    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 44)];
    titleLabel.font=[UIFont boldSystemFontOfSize:20];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.shadowColor=[UIColor darkGrayColor];
    titleLabel.shadowOffset=CGSizeMake(1, -1);
    titleLabel.text=@"设置";
    titleLabel.backgroundColor=[UIColor clearColor];
    [topNav addSubview:titleLabel];
    [titleLabel release];

    UIButton* backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(0,0,61,44);
    backBtn.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn.png"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn_sel.png"] forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [topNav addSubview:backBtn];
    
    UITableView* tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44-49) style:UITableViewStyleGrouped];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.backgroundView=nil;
    tableview.backgroundColor=[UIColor colorWithRed:(240.0/255.0) green:(240.0/255.0) blue:(240.0/255.0) alpha:1];
    tableview.scrollEnabled=NO;
    [self.view addSubview:tableview];
    [tableview release];
}
-(void)backClick:(UIButton*)btn{
    [self popSelfAnimated:YES];
}
-(void)swithAction:(UISwitch*)swith{
    if (swith.on) {
        [IconDownloadSetting setIcondownloadSwithStatus:YES];
    }else{
        [IconDownloadSetting setIcondownloadSwithStatus:NO];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReachAbilityNetStatusChanged" object:nil];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self.loadingView showInView:self.view title:@"正在清除"];
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        [NSThread detachNewThreadSelector:@selector(clearthread) toTarget:self withObject:nil];
        //假的清除成功，2s后提示清除成功
        [self performSelector:@selector(clearOK) withObject:nil afterDelay:2.0f];

    }
}

-(void)clearthread{
    @autoreleasepool {
        [[SDDataCache sharedDataCache] clearMemory];
        [[SDDataCache sharedDataCache] clearDisk];
    }
}
-(void)clearOK{
    [self.loadingView showTipInView:self.view title:@"清除成功"];
}
#pragma mark table

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ident=@"cell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident] autorelease];
    }
    if (indexPath.section==0) {
        cell.textLabel.text=@"2G/3G下显示图片";
        UISwitch* swith=[[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        swith.on=[IconDownloadSetting getIcondownloadSwitchStatus];
        [swith addTarget:self action:@selector(swithAction:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView=swith;
        [swith release];
    }
    if (indexPath.section==1) {
        cell.textLabel.text=@"清除缓存图片";
    }
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"图片显示设置";
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        UIActionSheet*sheet=[[UIActionSheet alloc] initWithTitle:@"清空缓存" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
        TheStoreAppAppDelegate *delegate = (TheStoreAppAppDelegate *)([UIApplication sharedApplication].delegate);
        [sheet showFromTabBar:delegate.tabBarController.tabBar];
        [sheet release];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
