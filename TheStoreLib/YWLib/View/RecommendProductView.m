//
//  RecommendProductView.m
//  TheStoreApp
//
//  Created by 林盼 on 14-4-4.
//
//

#import "RecommendProductView.h"
#import "OTSImageView.h"
#import "ProductInfo.h"

@implementation RecommendProductView

- (id)initWithFrame:(CGRect)frame product:(ProductInfo *)product target:(id)aTarget  action:(SEL)act
{
    frame = CGRectMake(0, 0, 104, 134);
    

    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _imageView = [[OTSImageView alloc] initWithFrame:CGRectMake(0, 0, 104, 104)];
        [_imageView setImage:[UIImage imageNamed:@"defaultimg82.png"]];
        [self addSubview:_imageView];
        [_imageView loadImgUrl:product.productImageUrl];
        
        _priceLbl= [[UILabel alloc] initWithFrame:CGRectMake(0, 104-25, 104, 25)];
        [_priceLbl setBackgroundColor:[UIColor blackColor]];
        _priceLbl.alpha = 0.3;
        _priceLbl.textColor = [UIColor whiteColor];
        [self addSubview:_priceLbl];
        _priceLbl.text = [NSString stringWithFormat:@" ¥ %@",product.price];
        
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 134-35, 104, 40)];
        _nameLbl.font = [UIFont systemFontOfSize:13];
        _nameLbl.numberOfLines = 0;
        _nameLbl.text = product.name;
        [self addSubview:_nameLbl];
        
        _act = act;
        _target = aTarget;
        
        self.product = product;
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [_imageView release];
    [_priceLbl release];
    [_nameLbl release];
    [_product release];
    [super dealloc];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 1)
    {
        if (_target && [_target respondsToSelector:_act])
        {
            [_target performSelector:_act withObject:self];
        }
    }
    
}

@end
