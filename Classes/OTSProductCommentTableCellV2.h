//
//  OTSProductCommentViewTableCell.h
//  TheStoreApp
//
//  Created by towne on 13-3-25.
//
//

#import <UIKit/UIKit.h>
#import "ProductExperienceVO.h"

@interface OTSProductCommentTableCellV2 : UITableViewCell

@property(nonatomic, retain)  UILabel *commentScoreLbl;
//分割线
//@property(nonatomic, retain) UIImageView * lineImgColumView;
@property(nonatomic, retain)  UILabel *contentLabel;
@property(nonatomic, retain)  UILabel *commentUserLbl;
@property(nonatomic, retain)  UILabel *commentDateLbl;

/**
 *  功能:刷新显示
 */
- (void)updateWithProductExperienceVO:(ProductExperienceVO *)experienceVO;

@end
