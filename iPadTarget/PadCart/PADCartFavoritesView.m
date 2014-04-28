//
//  PADCartFavoritesView.m
//  TheStoreApp
//
//  Created by huang jiming on 12-11-26.
//
//

#import "PADCartFavoritesView.h"
#import "FavoriteService.h"
#import "GlobalValue.h"
#import "PADCartProductColumnCell.h"
#import "FavoriteVO.h"
#import "UITableView+LoadingMore.h"

@implementation PADCartFavoritesView

-(id)initWithFrame:(CGRect)frame delegate:(id<PADCartFavoritesViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        m_Delegate=delegate;
        m_LoadingView=[[OtsPadLoadingView alloc] init];
        m_PageIndex=1;
        m_AllProducts=[[NSMutableArray alloc] initWithCapacity:0];
        
        if ([GlobalValue getGlobalValueInstance].token!=nil) {
            [self newThreadGetFavorites];
        } else {
            [self updateFavoritesView];
        }
    }
    return self;
}

-(void)updateSelf
{
    m_PageIndex=1;
    [m_AllProducts removeAllObjects];
    if ([GlobalValue getGlobalValueInstance].token!=nil) {
        [self newThreadGetFavorites];
    } else {
        [self updateFavoritesView];
    }
}

-(void)newThreadGetFavorites
{
    [m_LoadingView showInView:m_Delegate];
    [self performInThreadBlock:^{
        NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
        FavoriteService *service=[[[FavoriteService alloc] init] autorelease];
        __block Page *tempPage;
        [self tryCatch:^{
            tempPage=[service getMyFavoriteList:[GlobalValue getGlobalValueInstance].token tag:nil currentPage:[NSNumber numberWithInt:m_PageIndex] pageSize:[NSNumber numberWithInt:8]];
        } finally:^{
            if (tempPage==nil || [tempPage isKindOfClass:[NSNull class]] || [tempPage.objList count]==0) {
                
            } else {
                m_PageIndex++;
                m_TotalCount=[tempPage.totalSize integerValue];
                int i;
                for (i=0; i<[tempPage.objList count]; i++) {
                    FavoriteVO *favoriteVO=[tempPage.objList objectAtIndex:i];
                    ProductVO *productVO=favoriteVO.product;
                    [productVO setPromotionId:nil];//收藏中商品都是非促销商品
                    [m_AllProducts addObject:productVO];
                }
            }
        }];
        [pool drain];
    } completionInMainBlock:^{
        [m_LoadingView hide];
        [self updateFavoritesView];
    }];
}

-(void)updateFavoritesView
{
    if ([m_AllProducts count]>0) {
        [m_NilView setHidden:YES];
        
        if (m_TableView==nil) {
            m_TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 1024, FAVORITES_HEIGHT)];
            [m_TableView setDataSource:self];
            [m_TableView setDelegate:self];
            [m_TableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [self addSubview:m_TableView];
        } else {
            [m_TableView setHidden:NO];
            [m_TableView reloadData];
        }
        [m_TableView setTableFooterView:nil];
    } else {
        [m_TableView setHidden:YES];
        
        //空态页面
        if (m_NilView==nil) {
            m_NilView=[[UIView alloc] initWithFrame:CGRectMake(407, 120, 210, 240)];
            [self addSubview:m_NilView];
            
            UIImageView *nilImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 210, 210)];
            [nilImage setImage:[UIImage imageNamed:@"cart_favorites_nil.png"]];
            [m_NilView addSubview:nilImage];
            [nilImage release];
            
            UILabel *nilLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 210, 210, 30)];
            [nilLabel setText:@"您还没有收藏过商品"];
            [nilLabel setTextColor:[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0]];
            [nilLabel setFont:[nilLabel.font fontWithSize:20.0]];
            [nilLabel setTextAlignment:NSTextAlignmentCenter];
            [m_NilView addSubview:nilLabel];
            [nilLabel release];
        } else {
            [m_NilView setHidden:NO];
        }
    }
}

//加载更多
-(void)getMoreProduct
{
    [self newThreadGetFavorites];
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
    PADTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FavoritesTableViewCell"];
    if (cell==nil) {
        cell=[[[PADTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FavoritesTableViewCell" delegate:self] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell updateWithArray:m_AllProducts index:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FAVORITES_HEIGHT/2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rows;
    if ([m_AllProducts count]%4>0) {
        rows=[m_AllProducts count]/4+1;
    } else {
        rows=[m_AllProducts count]/4;
    }
    if (indexPath.row==rows-1 && [m_AllProducts count]<m_TotalCount) {
        [tableView loadingMoreWithFrame:CGRectMake(0, 0, 1024, 40) target:self selector:@selector(getMoreProduct) type:UITableViewLoadingMoreForeIpad];
    }
}

#pragma mark - PADTableViewCellDelegate
-(NSInteger)tableViewCellNumberOfColumns:(PADTableViewCell *)cell
{
    return 4;
}

-(PADTableViewColumnCell *)tableViewCell:(PADTableViewCell *)cell columnCellAtIndex:(NSInteger)index
{
    PADCartProductColumnCell *columnCell=[[[PADCartProductColumnCell alloc] initWithFrame:CGRectMake(0, 0, 256, 271) delegate:self type:CELL_FOR_FAVORITE] autorelease];
    return columnCell;
}

#pragma mark - PADTableViewColumnCellDelegate
-(void)tableViewColumnCell:(PADTableViewColumnCell *)cell didSelectAtIndex:(NSInteger)index
{
    ProductVO *productVO=[OTSUtility safeObjectAtIndex:index inArray:m_AllProducts];
    if (productVO.price == nil || productVO.price.doubleValue == 0) {
        return;
    }
    if ([m_Delegate respondsToSelector:@selector(enterProductDetail:)]) {
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
    OTS_SAFE_RELEASE(m_LoadingView);
    [super dealloc];
}
@end
