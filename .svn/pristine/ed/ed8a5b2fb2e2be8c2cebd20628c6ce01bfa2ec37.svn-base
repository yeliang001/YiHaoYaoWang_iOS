//
//  OTSPadProductPromotionView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-20.
//
//

#import "OTSPadProductPromotionView.h"
#import "OTSProdPromHeadView.h"
#import "UIView+LoadFromNib.h"
#import "OTSPromoteProductItemView.h"
#import "MobilePromotionVO.h"
#import "SDImageView+SDWebCache.h"

@interface OTSPadProductPromotionView ()
@property (retain) NSArray      *gifts;
@property (retain) NSArray      *exchangeBuys;
@end

@implementation OTSPadProductPromotionView
@synthesize gifts = _gifts;
@synthesize exchangeBuys = _exchangeBuys;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_tableView release];
    [_gifts release];
    [_exchangeBuys release];
    
    [super dealloc];
}

-(void)awakeFromNib
{
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


#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gifts.count + self.exchangeBuys.count;
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
    
    MobilePromotionVO *promotion = [self promotionItem:indexPath.row];
    
    OTSProdPromHeadView *headView = [OTSProdPromHeadView viewFromNibWithOwner:self];
    headView.nameLabel.text = promotion.title;
    headView.timeLabel.hidden = YES;
    
    BOOL isGift = [self isGiftItem:indexPath.row];
    
    if (!isGift)
    {
        [headView swtichToExchangeBuy];
    }
    
    if ([_delegate isPopped])
    {
        [headView switchToPoppedMode];
    }
    
    int itemCount = promotion.productVOList.count;
    int itemCol = 4;
    //int itemRow = (itemCount / itemCol) + 1;
    int itemX = 0;
    int itemY = 0;
    //int currentItemNumber = 0;
    
    for (int i = 0; i < itemCount; i++)
    {
        ProductVO *product = [promotion.productVOList objectAtIndex:i];
        
        if (isGift)
        {
            product.isGift = [NSNumber numberWithInt:1];    // 手动修改赠品属性
        }
        else
        {
            product.hasRedemption = [NSNumber numberWithInt:1];    // 手动修改换购属性
        }
        
        OTSPromoteProductItemView *itemView = [OTSPromoteProductItemView viewFromNibWithOwner:self];
        
        itemView.delegate = self.delegate;
        [itemView updateWithProduct:product];
 
        itemView.btnAddToCart.hidden = YES;
        
        itemX = (i % itemCol) * itemView.width;
        itemY = OTSProdPromHeadView.height + (i / itemCol) * OTSPromoteProductItemView.height;
        itemView.frame = CGRectMake(itemX
                                    , itemY
                                    , itemView.width
                                    , OTSPromoteProductItemView.height);
        [cell.contentView addSubview:itemView];
    }
    
    
    [cell.contentView addSubview:headView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MobilePromotionVO *promotion = [self promotionItem:indexPath.row];
    
    int itemCount = promotion.productVOList.count;
    int itemCol = 4;
    int itemRow = (itemCount / itemCol) + 1;
    if (itemCount % itemCol == 0)
    {
        itemRow--;
    }
    
    float height = itemRow * OTSPromoteProductItemView.height + OTSProdPromHeadView.height;
    return height;
}

-(BOOL)isGiftItem:(int)anIndex
{
    return anIndex < self.gifts.count;
}

#pragma mark - 
-(MobilePromotionVO*)promotionItem:(NSUInteger)anIndex
{
    BOOL isGift = [self isGiftItem:anIndex];
    
    MobilePromotionVO *promotion = nil;
    if (isGift)
    {
        promotion = [self.gifts objectAtIndex:anIndex];
    }
    else
    {
        promotion = [self.exchangeBuys objectAtIndex:anIndex - self.gifts.count];
    }
    
    return promotion;
}

-(void)updateWithGift:(NSArray*)aGifts exchangeBuys:(NSArray*)aExchangeBuys
{
    self.gifts = aGifts;
    self.exchangeBuys = aExchangeBuys;
    
    [self.tableView reloadData];
}

@end
