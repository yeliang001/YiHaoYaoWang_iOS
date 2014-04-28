//
//  PADCartBuyRecordView.m
//  TheStoreApp
//
//  Created by huang jiming on 12-11-23.
//
//

#import "PADCartBuyRecordView.h"
#import "OrderService.h"
#import "GlobalValue.h"
#import "PADTableViewCell.h"
#import "PADCartBuyRecordColumnCell.h"
#import "UITableView+LoadingMore.h"
#import "OtsPadLoadingView.h"

@implementation PADCartBuyRecordView

-(id)initWithFrame:(CGRect)frame delegate:(id<PADCartBuyRecordViewDelegate>)delegate
{
    self=[self initWithFrame:frame];
    if (self!=nil) {
        m_Delegate=delegate;
        m_LoadingView=[[OtsPadLoadingView alloc] init];
        [self initBuyRecordView];
        if ([GlobalValue getGlobalValueInstance].token!=nil) {
            [self newThreadGetOrder];
        } else {
            [self updateBuyRecordView];
        }
    }
    return self;
}

-(void)newThreadGetOrder
{
    [m_LoadingView showInView:m_Delegate];
    [self performInThreadBlock:^{
        NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
        OrderService *oServ=[[[OrderService alloc] init] autorelease];
        __block Page *tempPage;
        [self tryCatch:^{
            //所有订单类型，所有订单，1号店订单
            tempPage=[oServ getMyOrderListByToken:[GlobalValue getGlobalValueInstance].token type:[NSNumber numberWithInt:KOtsOrderTypeCompleted] orderRange:[NSNumber numberWithInt:0] siteType:[NSNumber numberWithInt:1] currentPage:[NSNumber numberWithInt:m_PageIndex] pageSize:[NSNumber numberWithInt:8]];
        } finally:^{
            if (tempPage==nil || [tempPage isKindOfClass:[NSNull class]] || [tempPage.objList count]==0) {
                
            } else {
                m_PageIndex++;
                m_TotalCount=[tempPage.totalSize intValue];
                m_RealCount+=[tempPage.objList count];
                int i;
                for (i=0; i<[tempPage.objList count]; i++) {
                    OrderV2 *orderV2=[tempPage.objList objectAtIndex:i];
                    if ([orderV2.orderType intValue]==1) {//普通订单
                        [m_AllOrder addObject:orderV2];
                    }
                }
            }
        }];
        [pool drain];
    } completionInMainBlock:^{
        [m_LoadingView hide];
        [self updateBuyRecordView];
    }];
}

-(void)initBuyRecordView
{
    m_PageIndex=1;
    m_AllOrder=[[NSMutableArray alloc] initWithCapacity:0];
}

-(void)updateBuyRecordView
{
    if ([m_AllOrder count]>0) {
        [m_NilView setHidden:YES];
        
        if (m_TableView==nil) {
            m_TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 1024, BUYRECORD_HEIGHT) style:UITableViewStylePlain];
            [m_TableView setDataSource:self];
            [m_TableView setDelegate:self];
            [m_TableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [self addSubview:m_TableView];
        } else {
            [m_TableView setHidden:NO];
            [m_TableView reloadData];
        }
    } else {
        [m_TableView setHidden:YES];
        
        //空态页面
        if (m_NilView==nil) {
            m_NilView=[[UIView alloc] initWithFrame:CGRectMake(407, 120, 210, 240)];
            [self addSubview:m_NilView];
            
            UIImageView *nilImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 210, 210)];
            [nilImage setImage:[UIImage imageNamed:@"cart_buyrecord_nil.png"]];
            [m_NilView addSubview:nilImage];
            [nilImage release];
            
            UILabel *nilLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 210, 210, 30)];
            [nilLabel setText:@"您还没有购买记录"];
            [nilLabel setTextColor:[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0]];
            [nilLabel setFont:[nilLabel.font fontWithSize:20.0]];
            [nilLabel setTextAlignment:NSTextAlignmentCenter];
            [m_NilView addSubview:nilLabel];
            [nilLabel release];
        } else {
            [m_NilView setHidden:NO];
        }
    }
    
    [m_TableView setTableFooterView:nil];
}

//加载更多
-(void)getMoreOrder
{
    [self newThreadGetOrder];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([m_AllOrder count]%4>0) {
        return [m_AllOrder count]/4+1;
    } else {
        return [m_AllOrder count]/4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PADTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BuyRecordTableViewCell"];
    if (cell==nil) {
        cell=[[[PADTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BuyRecordTableViewCell" delegate:self] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell updateWithArray:m_AllOrder index:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BUYRECORD_HEIGHT/2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rows;
    if ([m_AllOrder count]%4>0) {
        rows=[m_AllOrder count]/4+1;
    } else {
        rows=[m_AllOrder count]/4;
    }
    if (indexPath.row==rows-1 && m_RealCount<m_TotalCount) {
        [tableView loadingMoreWithFrame:CGRectMake(0, 0, 1024, 40) target:self selector:@selector(getMoreOrder) type:UITableViewLoadingMoreForeIpad];
    }
}

#pragma mark - PADTableViewCellDelegate
-(NSInteger)tableViewCellNumberOfColumns:(PADTableViewCell *)cell
{
    return 4;
}

-(PADTableViewColumnCell *)tableViewCell:(PADTableViewCell *)cell columnCellAtIndex:(NSInteger)index
{
    PADCartBuyRecordColumnCell *columnCell=[[[PADCartBuyRecordColumnCell alloc] initWithFrame:CGRectMake(0, 0, 256, 271) delegate:self] autorelease];
    return columnCell;
}

#pragma mark - PADTableViewColumnCellDelegate
-(void)tableViewColumnCell:(PADTableViewColumnCell *)cell didSelectAtIndex:(NSInteger)index
{
    CGFloat xValue=index%4*256-m_TableView.contentOffset.x;
    CGFloat yValue=index/4*271-m_TableView.contentOffset.y;
    OrderV2 *orderV2=[OTSUtility safeObjectAtIndex:index inArray:m_AllOrder];
    PADCartBuyRecordDetailView *detailView=[[PADCartBuyRecordDetailView alloc] initWithFrame:CGRectMake(0, 0, 1024, BUYRECORD_HEIGHT) originPoint:CGPointMake(xValue, yValue) orderV2:orderV2 delegate:self];
    [self insertSubview:detailView aboveSubview:m_TableView];
    [detailView release];
}

//long press
-(void)tableViewColumnCell:(PADTableViewColumnCell *)cell handelLongPress:(UILongPressGestureRecognizer*)aGesture
{
    if ([m_Delegate respondsToSelector:@selector(handelLongPressForRebuyOrder:)]) {
        [m_Delegate handelLongPressForRebuyOrder:aGesture];
    }
}

-(void)addProduct:(ProductVO *)productVO
{
    if ([m_Delegate respondsToSelector:@selector(addProduct:)]) {
        [m_Delegate addProduct:productVO];
    }
}

#pragma mark - PADCartBuyRecordDetailViewDelegate
-(void)handelLongPressForAddProduct:(UILongPressGestureRecognizer*)aGesture
{
    if ([m_Delegate respondsToSelector:@selector(handelLongPressForAddProduct:)]) {
        [m_Delegate handelLongPressForAddProduct:aGesture];
    }
}

-(void)enterProductDetail:(ProductVO *)productVO
{
    if ([m_Delegate respondsToSelector:@selector(enterProductDetail:)]) {
        [m_Delegate enterProductDetail:productVO];
    }
}

-(void)dealloc
{
    m_Delegate=nil;
    OTS_SAFE_RELEASE(m_AllOrder);
    OTS_SAFE_RELEASE(m_TableView);
    OTS_SAFE_RELEASE(m_NilView);
    OTS_SAFE_RELEASE(m_LoadingView);
    [super dealloc];
}

@end
