//
//  PADCartBrowseHistoryView.m
//  TheStoreApp
//
//  Created by huang jiming on 12-11-26.
//
//

#import "PADCartBrowseHistoryView.h"
#import "DataHandler.h"
#import "PADTableViewCell.h"
#import "PADCartProductColumnCell.h"

@implementation PADCartBrowseHistoryView

-(id)initWithFrame:(CGRect)frame delegate:(id<PADCartBrowseHistoryViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        m_Delegate=delegate;
        m_AllProducts=[[NSArray alloc] initWithArray:[[DataHandler sharedDataHandler] queryProductHistory]];
        if ([m_AllProducts count]==0) {
            [m_TableView setHidden:YES];
            
            //空态页面
            if (m_NilView==nil) {
                m_NilView=[[UIView alloc] initWithFrame:CGRectMake(407, 120, 210, 240)];
                [self addSubview:m_NilView];
                
                UIImageView *nilImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 210, 210)];
                [nilImage setImage:[UIImage imageNamed:@"cart_browse_nil.png"]];
                [m_NilView addSubview:nilImage];
                [nilImage release];
                
                UILabel *nilLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 210, 210, 30)];
                [nilLabel setText:@"您还没有浏览过商品"];
                [nilLabel setTextColor:[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0]];
                [nilLabel setFont:[nilLabel.font fontWithSize:20.0]];
                [nilLabel setTextAlignment:NSTextAlignmentCenter];
                [m_NilView addSubview:nilLabel];
                [nilLabel release];
            } else {
                [m_NilView setHidden:NO];
            }
        } else {
            [m_NilView setHidden:YES];
            
            if (m_TableView==nil) {
                m_TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 1024, BROWSE_HISTORY_HEIGHT)];
                [m_TableView setDataSource:self];
                [m_TableView setDelegate:self];
                [m_TableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                [self addSubview:m_TableView];
            } else {
                [m_TableView setHidden:NO];
                [m_TableView reloadData];
            }
        }
    }
    return self;
}

-(void)updateSelf
{
    if (m_AllProducts!=nil) {
        [m_AllProducts release];
    }
    m_AllProducts=[[NSArray alloc] initWithArray:[[DataHandler sharedDataHandler] queryProductHistory]];
    
    if ([m_AllProducts count]==0) {
        [m_TableView setHidden:YES];
        [m_NilView setHidden:NO];
    } else {
        [m_NilView setHidden:YES];
        [m_TableView setHidden:NO];
        [m_TableView reloadData];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([m_AllProducts count]%4>0) {
        return [m_AllProducts count]/4+1;
    } else {
        return [m_AllProducts count]/4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PADTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BrowseHistoryTableViewCell"];
    if (cell==nil) {
        cell=[[[PADTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BrowseHistoryTableViewCell" delegate:self] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell updateWithArray:m_AllProducts index:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BROWSE_HISTORY_HEIGHT/2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - PADTableViewCellDelegate
-(NSInteger)tableViewCellNumberOfColumns:(PADTableViewCell *)cell
{
    return 4;
}

-(PADTableViewColumnCell *)tableViewCell:(PADTableViewCell *)cell columnCellAtIndex:(NSInteger)index
{
    PADCartProductColumnCell *columnCell=[[[PADCartProductColumnCell alloc] initWithFrame:CGRectMake(0, 0, 256, 271) delegate:self type:CELL_FOR_BROWSE] autorelease];
    return columnCell;
}

#pragma mark - PADTableViewColumnCellDelegate
-(void)tableViewColumnCell:(PADTableViewColumnCell *)cell didSelectAtIndex:(NSInteger)index
{
    ProductVO *productVO=[OTSUtility safeObjectAtIndex:index inArray:m_AllProducts];
    if ([m_Delegate respondsToSelector:@selector(enterProductDetail:)]) {
        //历史浏览中去掉promotionid
        [productVO setPromotionId:nil];
        [m_Delegate enterProductDetail:productVO];
    }
}

//long press
-(void)tableViewColumnCell:(PADTableViewColumnCell *)cell handelLongPress:(UILongPressGestureRecognizer*)aGesture
{
    if ([m_Delegate respondsToSelector:@selector(handelLongPressForAddProduct:)]) {
        [m_Delegate handelLongPressForAddProduct:aGesture];
    }
}

-(void)tableViewColumnCell:(PADTableViewColumnCell *)cell addProductAtIndex:(NSInteger)index
{
    ProductVO *productVO=[OTSUtility safeObjectAtIndex:index inArray:m_AllProducts];
    if ([m_Delegate respondsToSelector:@selector(addProduct:)]) {
        [m_Delegate addProduct:productVO];
    }
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(m_AllProducts);
    OTS_SAFE_RELEASE(m_TableView);
    OTS_SAFE_RELEASE(m_NilView);
    m_Delegate=nil;
    [super dealloc];
}

@end
