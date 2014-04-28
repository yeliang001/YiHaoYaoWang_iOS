//
//  OTSNNPiecesTableCell.h
//  TheStoreApp
//
//  Created by towne on 13-1-14.
//
//

#import <UIKit/UIKit.h>
#import "StrikeThroughLabel.h"
#import "SDWebDataManager.h"
#import "OTSImageView.h"
#import "ProductVO.h"

@protocol OTSNNPiecesTableCellDelegate

- (void)accessoryButtonTap:(UIControl *)button withEvent:(UIEvent *)event;

@end

@interface OTSNNPiecesTableCell : UITableViewCell<SDWebDataManagerDelegate>

@property(nonatomic, retain)  UILabel *productNameLbl;
@property(nonatomic, retain)  StrikeThroughLabel *marketPriceLbl;
@property(nonatomic, retain)  UILabel *priceLbl;
@property(nonatomic, retain)  UIButton *operateBtn;
@property(nonatomic, retain)  OTSImageView *productImage;
@property(nonatomic, retain)  UILabel *soldoutLbl;
@property(nonatomic, assign)  id delegate;

/**
 *  功能:初始化方法
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id<OTSNNPiecesTableCellDelegate>)aDelegate;

/**
 *  功能:刷新显示
 */
- (void)updateWithProductVO:(ProductVO *)productVO;
@end
