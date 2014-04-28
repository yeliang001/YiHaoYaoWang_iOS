//
//  OTSProductCommentTVCell.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-20.
//
//

#import <UIKit/UIKit.h>

@class OTSPadProductStarView;
@class ProductExperienceVO;

@interface OTSProductCommentTVCell : UITableViewCell
@property (retain, nonatomic) IBOutlet OTSPadProductStarView *startView;
@property (retain, nonatomic) IBOutlet UILabel *userNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) IBOutlet UIImageView *bgIV;


-(void)updateWithData:(ProductExperienceVO *)aData;

@end
