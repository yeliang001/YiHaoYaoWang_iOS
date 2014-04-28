//
//  OTSNNPiecesTableCell.m
//  TheStoreApp
//
//  Created by towne on 13-1-14.
//
//

#import "OTSNNPiecesTableCell.h"

@implementation OTSNNPiecesTableCell
@synthesize productNameLbl;
@synthesize marketPriceLbl;
@synthesize priceLbl;
@synthesize operateBtn;
@synthesize productImage;
@synthesize soldoutLbl;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id<OTSNNPiecesTableCellDelegate>)aDelegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        self.delegate = aDelegate;
        //商品名称
        self.productNameLbl = [[[UILabel alloc] initWithFrame:CGRectMake(98, 10, 170, 38)] autorelease];
        self.productNameLbl.numberOfLines = 2;
        self.productNameLbl.font = [UIFont boldSystemFontOfSize:16];
        self.productNameLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.productNameLbl];
        
        //价格
        self.priceLbl = [[[UILabel alloc] initWithFrame:CGRectMake(98, 75, 85, 18)] autorelease];
        self.priceLbl.textColor = [UIColor colorWithRed:180.0/255.0 green:1.0/255.0 blue:0.0/255.0 alpha:1.0];
        self.priceLbl.font = [UIFont systemFontOfSize:16];
        self.priceLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.priceLbl];
        
        //市场价
        self.marketPriceLbl = [[[StrikeThroughLabel alloc] initWithFrame:CGRectMake(183, 75, 85, 18)] autorelease];
        self.marketPriceLbl.textColor = [UIColor grayColor];
        self.marketPriceLbl.font = [UIFont systemFontOfSize:14];
        self.marketPriceLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.marketPriceLbl];
        
        //商品图片
        self.productImage = [[[OTSImageView alloc] initWithFrame:CGRectMake(11, 10, 80, 80)] autorelease];
        [self.contentView addSubview:self.productImage];
        
        //加入购物车按钮
        self.operateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.operateBtn setImage:[UIImage imageNamed:@"product_cart.png"] forState:UIControlStateNormal];
        self.operateBtn.frame = CGRectMake(280, 35, 29, 29);
        [self.operateBtn addTarget:self action:@selector(accessoryButtonTap:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.operateBtn];
        
        //缺货
        self.soldoutLbl = [[[UILabel alloc] initWithFrame:CGRectMake(275, 65, 39, 20)] autorelease];
        self.soldoutLbl.text = @"缺货";
        self.soldoutLbl.textColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        self.soldoutLbl.font = [UIFont systemFontOfSize:16];
        self.soldoutLbl.backgroundColor = [UIColor clearColor];
        self.soldoutLbl.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.soldoutLbl];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithProductVO:(ProductVO *)productVO
{
    //商品名称
    self.productNameLbl.text = productVO.cnName;
    //市场价格
    //self.marketPriceLbl.text = [NSString stringWithFormat:@"￥%.2f", [productVO.maketPrice floatValue]];
    self.marketPriceLbl.text = @"";
    //商品价格
    self.priceLbl.text = [NSString stringWithFormat:@"￥%.2f", [productVO.price floatValue]];
    //操作按钮
    if ([productVO.canBuy isEqualToString:@"true"]) {
        self.operateBtn.frame = CGRectMake(280, 0, 50, 102);
        [self.operateBtn setImage:[UIImage imageNamed:@"nnpadd@2x.png"] forState:0];
        self.soldoutLbl.hidden = YES;
    } else {
        self.operateBtn.frame = CGRectMake(280, 35, 29, 29);
        [self.operateBtn setImage:[UIImage imageNamed:@"nnpadd_ni@2x.png"] forState:0];
        self.soldoutLbl.hidden = NO;
    }
    //商品图片
    self.productImage.image = [UIImage imageNamed:@"defaultimg85.png"];
    [self.productImage loadImgUrl:productVO.miniDefaultProductUrl];
}

- (void)accessoryButtonTap:(UIControl *)button withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(accessoryButtonTap:withEvent:)]) {
        [self.delegate accessoryButtonTap:button withEvent:event];
    }
}

- (void)dealloc
{
    self.productNameLbl = nil;
    self.marketPriceLbl = nil;
    self.priceLbl = nil;
    self.operateBtn = nil;
    self.productImage = nil;
    self.soldoutLbl = nil;
    self.delegate = nil;
    [super dealloc];
}

@end
