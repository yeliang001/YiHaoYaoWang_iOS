//
//  RecommendListView.m
//  TheStoreApp
//
//  Created by 林盼 on 14-4-2.
//
//


#import "RecommendListView.h"
#import "CategoryProductCell.h"
#import "mobidea4ec.h"
#import "ProductInfo.h"


@implementation RecommendListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _productList = [[NSMutableArray alloc] init];
        
        
        
      
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        _tableView.hidden = YES;
        
        
        
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self addSubview:_loadingView];
        [_loadingView startAnimating];

 
    }
    return self;
}






- (void)startLoadData:(NSString *)reommendType
{
    self.recommendType = reommendType;
    [BfdAgent recommend:self recommendType:reommendType options:nil];
    
    [_loadingView startAnimating];
}






#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _productList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*identify=@"cateProductCell";
    CategoryProductCell*cell=(CategoryProductCell*)[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell==nil)
    {
        cell=[[[CategoryProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    
    ProductInfo *product = (ProductInfo *)[_productList objectAtIndex:indexPath.row];
    
    
    cell.productNameLbl.text = product.name;
    [cell.the1MallLogo setHidden:YES];
    
    // 商品价格
    cell.priceLbl.text = [NSString stringWithFormat:@"¥ %@",product.price];
    cell.marketPriceLbl.text =[NSString stringWithFormat:@"¥ %@",product.marketPrice];
    

    cell.operateBtn.hidden = YES;
    [cell.giftLogo setHidden:YES];
    cell.imageView.image=[UIImage imageNamed:@"img_default.png"];
    [cell downloadImage:product.productImageUrl];
    
    //促销
//    [cell showGift:productVO.hasGift];
//    [cell showReduce:productVO.hasReduce];
    
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 101;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductInfo *product = _productList[indexPath.row];
    
    
    [BfdAgent feedback:nil recommendId:_recommendType itemId:product.productId options:nil];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedProductId:)])
    {
        [_delegate selectedProductId:product.productId];
    }
}

#pragma mark - BFD delegate
- (void)mobidea_Recs:(NSError *)error feedback:(id)feedback
{
    [_loadingView stopAnimating];
    _tableView.hidden = NO;
    
    if ([feedback isKindOfClass:[NSArray class]])
    {
        NSArray *result = (NSArray *)feedback;
        for (NSDictionary *dic in result)
        {
            ProductInfo *product = [[ProductInfo alloc] init];
            product.productId = [NSString stringWithFormat:@"%d",[dic[@"iid"] integerValue]];
            product.productImageUrl = dic[@"img"];
            product.price = [NSString stringWithFormat:@"%.2f", [dic[@"price"] floatValue]];
            product.marketPrice = [NSString stringWithFormat:@"%.2f", [dic[@"mktp"] floatValue]];
            product.name = dic[@"name"];
            
            [_productList addObject:product];
            [product release];
        }
        
        [_tableView reloadData];
    }
}

- (void)dealloc
{
    [_tableView release];
    [_productList release];
    [_loadingView release];
    [_recommendType release];
    [super dealloc];
}

@end
