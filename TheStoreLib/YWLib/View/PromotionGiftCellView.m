//
//  PromotionGiftCellView.m
//  TheStoreApp
//
//  Created by LinPan on 14-1-22.
//
//

#import "PromotionGiftCellView.h"
#import "PromotionIcon.h"
@implementation PromotionGiftCellView

- (id)initWithFrame:(CGRect)frame giftName:(NSString *)name count:(NSInteger)count
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        PromotionIcon *promotionIcon = [[PromotionIcon alloc] initWithFrame:CGRectMake(10, 10, 18, 18) promitionType:kYaoPromotion_MZ];
        [self addSubview:promotionIcon];
        [promotionIcon release];
        
        UILabel *promotionDescLbl = [[UILabel alloc] initWithFrame:CGRectMake(38, 0, 320 - 38-80, frame.size.height)];
        promotionDescLbl.backgroundColor = [UIColor clearColor];
        promotionDescLbl.font = [UIFont systemFontOfSize:13];
        promotionDescLbl.text = name;
        [self addSubview:promotionDescLbl];
        [promotionDescLbl release];
        
        UILabel *countLbl = [[UILabel alloc] initWithFrame:CGRectMake(240 ,0 , 20, frame.size.height)];
        countLbl.font = [UIFont systemFontOfSize:15];
        countLbl.backgroundColor = [UIColor clearColor];
        countLbl.text = [NSString stringWithFormat:@"%d",count];
        [self addSubview:countLbl];
        [countLbl release];
        
        
        UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 10, 40, frame.size.height-20)];
        [delBtn setBackgroundColor:[UIColor redColor]];
        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
        delBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:delBtn];
        [delBtn release];
        _deleteButton = [delBtn retain];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        [lineView setBackgroundColor:[UIColor colorWithString:@"#E5E5E5"]];
        [self addSubview:lineView];
        [lineView release];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action index:(NSInteger)index
{
    _deleteButton.tag = index;
    [_deleteButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc
{
    [_deleteButton release];
    [_gift release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
