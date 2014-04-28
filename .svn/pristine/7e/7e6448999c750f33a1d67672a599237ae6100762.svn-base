//
//  OTSProductNNPiecesTopView.h
//  TheStoreApp
//
//  Created by towne on 13-1-14.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class ProductVO;
@class OTSNNPiecesTopView;
@class MobilePromotionDetailVO;
@class NormResult;

@protocol OTSNNPiecesTopProductsDelegate

@required
-(void)iNNPiecesProductClicked:(NSNumber *) index;
-(void)iNNPiecesProductIsInOperation:(NSNumber *) hight;
-(void)iNNPiecesAddToCart;
-(void)iNNPiecesUpdateToCart;
-(void)iNNPiecesProductIsNull;
-(BOOL)iNNPiecesShowCart;
-(void)iNNPiecesSetShowCart;

@end

@interface OTSNNPiecesTopView : UIView
@property(nonatomic,retain) NSNumber *opHight;

-(id)initWithFrame:(CGRect)frame MobilePromotionDetailVO:(MobilePromotionDetailVO *)mpproductVO TopViewproducts:(NSMutableArray*)tpproductsArray isExistOptionalInCart:(NormResult *) existOptional MainView:(UIView*)mainView delegate:(id<OTSNNPiecesTopProductsDelegate>)delegate;
@end
