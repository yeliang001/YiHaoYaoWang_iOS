//
//  OTSPadProductSameCateView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-20.
//
//

#import "OTSPadProductSameCateView.h"
#import "UIView+LoadFromNib.h"
#import "OTSPromoteProductItemView.h"
#import "Page.h"
#import "SDImageView+SDWebCache.h"

#define NUM_IN_COL  4

@interface OTSPadProductSameCateView ()
@property (retain)  NSMutableArray      *products;
@end

@implementation OTSPadProductSameCateView
@synthesize products = _products;
@synthesize delegate = _delegate;

-(void)extraInit
{
    _products = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleProductDetailDestroyed:) name:PAD_NOTIFY_PRODUCT_DETAIL_VC_DEALLOC object:nil];
}

-(void)handleProductDetailDestroyed:(NSNotification*)aNote
{
    id productdetailObj = aNote.object;
    if ([productdetailObj longLongValue] == (long long)_delegate)
    {
        _delegate = nil;
    }
}

    

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self extraInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self extraInit];
    }
    return self;
}


#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num = self.products.count / NUM_IN_COL + 1;
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    
    for (UIView *sub in cell.contentView.subviews)
    {
        [sub removeFromSuperview];
    }
    
    int itemCount = self.products.count;
    int itemCol = NUM_IN_COL;
    int startIndex = indexPath.row * itemCol;
    int endIndex = (indexPath.row + 1) * itemCol;
    if (endIndex >= itemCount)
    {
        endIndex = itemCount;
    }
    
    for (int i = startIndex; i < endIndex; i++)
    {
        ProductVO *product = [self.products objectAtIndex:i];
        OTSPromoteProductItemView *itemView = [OTSPromoteProductItemView viewFromNibWithOwner:self];
        itemView.delegate = self.delegate;
        [itemView updateWithProduct:product];
        
        
        
        int itemX = (i % itemCol) * itemView.width;
        int itemY = 0;
        itemView.frame = CGRectMake(itemX
                                    , itemY
                                    , itemView.width
                                    , OTSPromoteProductItemView.height);
        [cell.contentView addSubview:itemView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return OTSPromoteProductItemView.height;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_tableView release];
    [_products release];
    
    [super dealloc];
}

#pragma mark - 
-(void)updateWithPage:(Page*)aPage
{
    if (aPage)
    {
        [self.products addObjectsFromArray:aPage.objList];
        [self.tableView reloadData];
    }
}

@end
