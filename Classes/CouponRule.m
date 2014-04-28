//
//  CouponRule.m
//  TheStoreApp
//
//  Created by towne on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CouponRule.h"
#import "SearchResult.h"
#import "TheStoreAppAppDelegate.h"

@implementation CouponRule
@synthesize mCoupon;
@synthesize mTextView;
@synthesize RegulationArr;
@synthesize mLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoupon:(CouponVO *)aCoupon
{
    self = [self initWithNibName:@"CouponRule" bundle:nil];
    if (self)
    {
        self.mCoupon = aCoupon;
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
    
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [mScrollView setBackgroundColor:[UIColor clearColor]];
    [mScrollView setDelegate:self];
    [mScrollView setAlwaysBounceVertical:YES];
    
    CGRect rc = mScrollView.frame;
    rc.size.height = self.view.frame.size.height;
    rc.origin.y = OTS_IPHONE_NAVI_BAR_HEIGHT;
    mScrollView.frame = rc;
    
    NSString *str = mCoupon.description;
    
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(310.0f,10000.0f)lineBreakMode:UILineBreakModeWordWrap];
    
    [mLabel setFrame:CGRectMake(12, 7, size.width, size.height)];
    mLabel.numberOfLines = 0; // 最关键的一句
    mLabel.text = str;
    mLabel.font = [UIFont systemFontOfSize:14];

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[mCoupon.detailDescription componentsSeparatedByString:@"\r\n"]];
    for (int i = 0; i < [tempArray count]; i++) {
        if([[tempArray objectAtIndex:i] isEqual:@""]||[tempArray objectAtIndex:i] == nil)
           [tempArray removeObject:[tempArray objectAtIndex:i]];
    }

    self.RegulationArr = tempArray;
    
    _regulationTableView.layer.borderColor = [UIColor colorWithRed:201.0/255 green:201.0/255 blue:201.0/255 alpha:1.0].CGColor;
    _regulationTableView.layer.borderWidth =1;
    _regulationTableView.layer.cornerRadius = 7.0;
    _regulationTableView.layer.masksToBounds = YES;
    [_regulationTableView setShowsVerticalScrollIndicator:NO];
    
    CGRect tc = _regulationTableView.frame;
    tc.size.height = self.view.frame.size.height -OTS_IPHONE_NAVI_BAR_HEIGHT - 25 - size.height;
    tc.origin.y =  22 + size.height;
    _regulationTableView.frame = tc;
    
    
    //回滚
//    [mLabel removeFromSuperview];
//    [_regulationTableView removeFromSuperview];
    
//    if ([mCoupon.defineType intValue] == 5) {
//        [_regulationTableView removeFromSuperview];
//         mLabel.text  = @"购买除以下商品可以使用抵用券";
//        UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 50, 320, 368)];
//        webview.backgroundColor = [UIColor clearColor];
//        webview.opaque = NO;
//        webview.dataDetectorTypes = UIDataDetectorTypeNone;
//        NSString *webviewText = @"<style>body{margin:10;background-color:transparent;font:16px/18px Custom-Font-Name}</style>";
//        NSString * currentRegulation = @"";
//            for (int i=0 ; i<[self.RegulationArr count]; i++) {
//                currentRegulation = [currentRegulation stringByAppendingFormat:@"%@<br/>",
//                                     [RegulationArr objectAtIndex:i]];
//            }
//        NSString *htmlString = [webviewText stringByAppendingFormat:@"%@<br/><br/>%@",[mCoupon description],currentRegulation];
//        [webview loadHTMLString:htmlString baseURL:nil]; //在 WebView 中显示本地的字符串
//        [mScrollView addSubview:webview];
//        [webview release];
//    }
//    else
//    {
//        _regulationTableView.hidden = NO;
//        [mScrollView addSubview:_regulationTableView];
//    }

    /*
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, 368)];
    webview.backgroundColor = [UIColor clearColor]; 
    webview.opaque = NO;
    webview.dataDetectorTypes = UIDataDetectorTypeNone;
    NSString *webviewText = @"<style>body{margin:10;background-color:transparent;font:16px/18px Custom-Font-Name}</style>";
    NSString * currentRegulation = @"";
    for (int i=0 ; i<[self.RegulationArr count]; i++) {
        currentRegulation = [currentRegulation stringByAppendingFormat:@"%@<br/>",
                             [RegulationArr objectAtIndex:i]];
    }
    NSString *htmlString = [webviewText stringByAppendingFormat:@"%@<br/><br/>%@",[mCoupon description],currentRegulation];
    [webview loadHTMLString:htmlString baseURL:nil]; //在 WebView 中显示本地的字符串
    [mScrollView addSubview:webview];
    [webview release];
     */
}

//返回
-(IBAction)returnBtnClicked:(id)sender
{
    [self popSelfAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.RegulationArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell;
    cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell.textLabel.text = [self.RegulationArr objectAtIndex:[indexPath row]];
    if (tableView.tag == 0) {
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [cell.textLabel setTextColor:[UIColor colorWithRed:84.0/255 green:102.0/255 blue:142.0/255 alpha:1.0]];
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* keyWord = [[self.RegulationArr objectAtIndex:[indexPath row]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([mCoupon.defineType intValue]!=5) {
        if (keyWord!=nil) {
            SearchResult *searchResult=[[[SearchResult alloc] initWithKeyword:keyWord fromTag:FROM_HOMEPAGE] autorelease];
            [self removeSelf];
            [SharedDelegate.tabBarController removeViewControllerWithAnimation:[OTSNaviAnimation animationPushFromLeft]];
            [SharedDelegate enterHomePageRoot];
            [[SharedDelegate homePage] pushVC:searchResult animated:NO];
        }
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    self.mCoupon = nil;
    self.mTextView = nil;
    self.RegulationArr = nil;
    self.regulationTableView = nil;
    self.mLabel = nil;
    [super dealloc];
}

@end
