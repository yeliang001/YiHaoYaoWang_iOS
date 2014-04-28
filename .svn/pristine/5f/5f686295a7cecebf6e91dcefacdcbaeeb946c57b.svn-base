//
//  PADCartBuyRecordDetailView.m
//  TheStoreApp
//
//  Created by huang jiming on 12-11-26.
//
//

#import "PADCartBuyRecordDetailView.h"
#import "OrderV2.h"
#import "OrderItemVO.h"
#import "PADCartProductColumnCell.h"

@implementation PADCartBuyRecordDetailView

-(id)initWithFrame:(CGRect)frame originPoint:(CGPoint)point orderV2:(OrderV2 *)orderV2 delegate:(id<PADCartBuyRecordDetailViewDelegate>)delegate
{
    self=[super initWithFrame:frame];
    if (self) {
        // Initialization code
        m_OriginPoint=point;
        m_OrderV2=[orderV2 retain];
        m_Delegate=delegate;
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //content size
        int rows=[orderV2.orderItemList count]/4;
        if ([orderV2.orderItemList count]%4>0) {
            rows=[orderV2.orderItemList count]/4+1;
        } else {
            rows=[orderV2.orderItemList count]/4;
        }
        if (rows*271>frame.size.height) {
            [self setContentSize:CGSizeMake(1024, rows*271)];
        }
        
        //content offset
        if (rows*271>frame.size.height) {
            [self setContentOffset:CGPointMake(0.0, rows*271-frame.size.height) animated:NO];
        }
        
        NSMutableArray *productArray=[[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        int i;
        for (i=0; i<[orderV2.orderItemList count]; i++) {
            OrderItemVO *orderItemVO=[OTSUtility safeObjectAtIndex:i inArray:orderV2.orderItemList];
            ProductVO *productVO=orderItemVO.product;
            [productArray addObject:productVO];
        }
        
        m_AllView=[[NSMutableArray alloc] initWithCapacity:0];
        for (i=0; i<[orderV2.orderItemList count]; i++) {
//            CGFloat xValue=m_OriginPoint.x+self.contentOffset.x;
//            CGFloat yValue=m_OriginPoint.y+self.contentOffset.y;
            CGFloat xValue=0.0;
            CGFloat yValue=0.0;
            PADCartProductColumnCell *columnCell=[[PADCartProductColumnCell alloc] initWithFrame:CGRectMake(xValue, yValue, 256, 271) delegate:self type:CELL_OTHER];
            [columnCell updateWithArray:productArray index:i];
            [self addSubview:columnCell];
            [columnCell release];
            [m_AllView addObject:columnCell];
        }
        
        //动画
        [UIView animateWithDuration:0.3f animations:^{
            int j;
            for (j=0; j<[m_AllView count]; j++) {
                PADCartProductColumnCell *columnCell=[m_AllView objectAtIndex:j];
                [columnCell setFrame:CGRectMake(j%4*256, j/4*271, 256, 271)];
            }
        } completion:^(BOOL finished){
            
        }];
        
        //返回
        UIButton *returnBtn=[[UIButton alloc] initWithFrame:CGRectMake(6, 6, 60, 60)];
        [returnBtn setBackgroundImage:[UIImage imageNamed:@"cart_product_return.png"] forState:UIControlStateNormal];
        [returnBtn addTarget:self action:@selector(returnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if ([m_Delegate respondsToSelector:@selector(addSubview:)]) {
            [m_Delegate addSubview:returnBtn];
        }
        [returnBtn release];
    }
    return self;
}

-(void)returnBtnClicked:(id)sender
{
    [sender removeFromSuperview];
    
    CGFloat xValue=m_OriginPoint.x+self.contentOffset.x;
    CGFloat yValue=m_OriginPoint.y+self.contentOffset.y;
    //动画
    [UIView animateWithDuration:0.3f animations:^{
        int j;
        for (j=0; j<[m_AllView count]; j++) {
            PADCartProductColumnCell *columnCell=[m_AllView objectAtIndex:j];
            [columnCell setFrame:CGRectMake(xValue, yValue, 256, 271)];
        }
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

#pragma mark - PADTableViewColumnCellDelegate
-(void)tableViewColumnCell:(PADTableViewColumnCell *)cell didSelectAtIndex:(NSInteger)index
{
    OrderItemVO *orderItemVO=[OTSUtility safeObjectAtIndex:index inArray:m_OrderV2.orderItemList];
    ProductVO *productVO=orderItemVO.product;
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
    OrderItemVO *orderItemVO=[OTSUtility safeObjectAtIndex:index inArray:m_OrderV2.orderItemList];
    ProductVO *productVO=orderItemVO.product;
    if ([m_Delegate respondsToSelector:@selector(addProduct:)]) {
        [m_Delegate addProduct:productVO];
    }
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(m_OrderV2);
    m_Delegate=nil;
    OTS_SAFE_RELEASE(m_AllView);
    [super dealloc];
}

@end
