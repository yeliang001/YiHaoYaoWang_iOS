//
//  GameGiftBtn.m
//  TheStoreApp
//
//  Created by yuan jun on 12-10-31.
//
//

#import "GameGiftBtn.h"

@implementation GameGiftBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame=CGRectMake(0, 0, 150, 120);
        self.titleLabel.numberOfLines=2;
        self.titleLabel.font=[UIFont systemFontOfSize:14];
        self.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.titleLabel.backgroundColor=[UIColor clearColor];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}
-(void)giftName:(NSString*)name{
    if (giftnameLab==nil) {
        giftnameLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 50, 40)];
        giftnameLab.font=[UIFont systemFontOfSize:14];
        giftnameLab.backgroundColor=[UIColor clearColor];
        giftnameLab.textColor=[UIColor colorWithRed:(80.0/255.0) green:(36.0/255.0) blue:(12.0/255.0) alpha:0.8];
        giftnameLab.numberOfLines=2;
        [self addSubview:giftnameLab];
        [giftnameLab release];
    }
    giftnameLab.text=name;
}

-(void)giftValue:(NSString*)price{
    if (giftvalueLab==nil) {
        giftvalueLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 60, 50, 20)];
        giftvalueLab.font=[UIFont systemFontOfSize:13];
        giftvalueLab.textColor=[UIColor colorWithRed:(80.0/255.0) green:(36.0/255.0) blue:(12.0/255.0) alpha:0.8];
        giftvalueLab.backgroundColor=[UIColor clearColor];
        [self addSubview:giftvalueLab];
        [giftvalueLab release];
    }
    giftvalueLab.text=price;
}
- (CGRect)contentRectForBounds:(CGRect)bounds{
    return CGRectMake(0, 0, 150, 120);
}
- (CGRect)backgroundRectForBounds:(CGRect)bounds{
    return CGRectMake(0, 0, 150, 120);
}
//- (CGRect)titleRectForContentRect:(CGRect)contentRect{
//   return  CGRectMake(10, 20, 70, 40);
//}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return  CGRectMake(60, 10, 85, 85);
}

-(void)selectImg:(NSString*)selectStr{
    [self setImage:[UIImage imageWithData:[[SDWebDataManager sharedManager]dataWithURL:[NSURL URLWithString:selectStr]]] forState:UIControlStateSelected];
}

-(void)unselectImg:(NSString*)unSelectStr{
    [self setImage:[UIImage imageWithData:[[SDWebDataManager sharedManager]dataWithURL:[NSURL URLWithString:unSelectStr]]] forState:UIControlStateNormal];
}
#pragma mark - SDWebDelegate
//- (void)downloadImage:(NSString*)url{
//    SDWebDataManager * datamanager = [SDWebDataManager sharedManager];
//    if ([url isKindOfClass:[NSString class]]&&[url length]) {
//        [datamanager downloadWithURL:[NSURL URLWithString:url] delegate:self refreshCache:YES];
//    }else {
//        
//    }
//}
- (void)downloadUnpickImage:(NSString*)url{
    SDWebDataManager * datamanager = [SDWebDataManager sharedManager];
    if ([url isKindOfClass:[NSString class]]&&[url length]) {
        [datamanager downloadWithURL:[NSURL URLWithString:url] delegate:self];
    }
}
- (void)webDataManager:(SDWebDataManager *)dataManager didFinishWithData:(NSData *)aData isCache:(BOOL)isCache
{
    UIImage*image = [UIImage imageWithData:aData];
    [self setImage:image forState:UIControlStateNormal];
//    [self setImage:[UIImage imageNamed:@"game_loadError.png"] forState:UIControlStateSelected];
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
