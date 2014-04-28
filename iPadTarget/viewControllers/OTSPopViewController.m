//
//  OTSPopViewController.m
//  TheStoreApp
//
//  Created by jiming huang on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define TAG_RED_TICK_VIEW   1

#import "OTSPopViewController.h"
#import "GrouponSortAttributeVO.h"
#import "GrouponCategoryVO.h"

@implementation OTSPopViewController
@synthesize delegate=m_Delegate,dataArray=m_DataArray,currentIndex=m_CurrentSelectedIndex;

-(id)initWithType:(PopViewControllerType)type
{
    m_Type=type;
    return [self initWithNibName:nil bundle:nil];
}

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (m_Type==PopSortType) {
        m_CurrentSelectedIndex=0;
        m_TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 245, 220)];
        [m_TableView setDelegate:self];
        [m_TableView setDataSource:self];
        [self.view addSubview:m_TableView];
        [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetAllSort) toTarget:self withObject:nil];
    } else if (m_Type==PopCategoryType) {
        m_TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 245, 44.0*([m_DataArray count]+1))];
        [m_TableView setDelegate:self];
        [m_TableView setDataSource:self];
        [self.view addSubview:m_TableView];
    } else {
        
    }
}

//刷新tableview
-(void)updateTableView
{
    [m_TableView reloadData];
}

//红色勾号
-(UIView *)redTick
{
    UIImageView *imageView=[[[UIImageView alloc] initWithFrame:CGRectMake(200, 7, 30, 30)] autorelease];
    [imageView setTag:TAG_RED_TICK_VIEW];
    [imageView setImage:[UIImage imageNamed:@"redTick.png"]];
    return imageView;
}

#pragma mark - 排序
-(void)newThreadGetAllSort
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    @try {
        NSNumber *tempNumber=[[OTSServiceHelper sharedInstance] getGrouponAreaIdByProvinceId:[GlobalValue getGlobalValueInstance].trader provinceId:[GlobalValue getGlobalValueInstance].provinceId];
        if (tempNumber!=nil && ![tempNumber isKindOfClass:[NSNull class]]) {
            NSArray *tempArray=[[OTSServiceHelper sharedInstance] getGroupOnSortAttribute:[GlobalValue getGlobalValueInstance].trader AreaId:tempNumber];
            if (m_DataArray!=nil) {
                [m_DataArray release];
            }
            if (tempArray!=nil && ![tempArray isKindOfClass:[NSNull class]]) {
                m_DataArray=[tempArray retain];
            } else {
                m_DataArray=nil;
            }
        }
    } @catch (NSException * e) {
    } @finally {
        [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
    }
    [pool drain];
}

#pragma mark tableView相关delegate和datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PopCell"];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PopCell"] autorelease];
        [cell addSubview:[self redTick]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:18.0]];
    }
    
    if (m_Type==PopSortType) {//排序
        GrouponSortAttributeVO *vo=(GrouponSortAttributeVO*)[m_DataArray objectAtIndex:indexPath.row];
        [cell.textLabel setText:vo.attrName];
    } else if (m_Type==PopCategoryType) {//其他分类
        if (indexPath.row==0) {
            [cell.textLabel setText:@"全部"];
        } else {
            GrouponCategoryVO *categoryVO=[m_DataArray objectAtIndex:indexPath.row-1];
            [cell.textLabel setText:categoryVO.name];
        }
    } else {
    }
    
    //红勾
    UIView *redTick=[cell viewWithTag:TAG_RED_TICK_VIEW];
    if (indexPath.row==m_CurrentSelectedIndex) {
        [redTick setHidden:NO];
    } else {
        [redTick setHidden:YES];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (m_Type==PopSortType) {
        return [m_DataArray count];
    } else if (m_Type==PopCategoryType) {
        return [m_DataArray count]+1;
    } else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}

- (CGRect)rectForHeaderInSection:(NSInteger)section
{
    return CGRectZero;
}

- (CGRect)rectForFooterInSection:(NSInteger)section
{
    return CGRectZero;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中颜色
    //隐藏其他cell的红勾
    int i;
    for (i=0; i<[m_DataArray count]; i++) {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (i!=indexPath.row) {
            UIView *redTick=[cell viewWithTag:TAG_RED_TICK_VIEW];
            [redTick setHidden:YES];
        } else {
        }
    }
    //显示当前cell的红勾
    if (m_CurrentSelectedIndex!=indexPath.row) {
        m_CurrentSelectedIndex=indexPath.row;
        
        if (m_Type==PopSortType) {//排序
            GrouponSortAttributeVO *vo=(GrouponSortAttributeVO*)[m_DataArray objectAtIndex:indexPath.row];
            if ([m_Delegate respondsToSelector:@selector(sortItemSelectedWithVO:)]) {
                [m_Delegate performSelector:@selector(sortItemSelectedWithVO:) withObject:vo];
            }
        } else if (m_Type==PopCategoryType) {//分类
            if (indexPath.row==0) {//全部
                if ([m_Delegate respondsToSelector:@selector(categoryItemSelectedWithCategoryId:)]) {
                    [m_Delegate performSelector:@selector(categoryItemSelectedWithCategoryId:) withObject:[NSNumber numberWithInt:-1]];
                }
            } else {
                GrouponCategoryVO *categoryVO=[m_DataArray objectAtIndex:indexPath.row-1];
                if ([m_Delegate respondsToSelector:@selector(categoryItemSelectedWithCategoryId:)]) {
                    [m_Delegate performSelector:@selector(categoryItemSelectedWithCategoryId:) withObject:[categoryVO nid]];
                }
            }
        } else {
        }
        
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        UIView *redTick=[cell viewWithTag:TAG_RED_TICK_VIEW];
        [redTick setHidden:NO];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
