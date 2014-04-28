//
//  OTSProductCommentTopCellV2.h
//  TheStoreApp
//
//  Created by towne on 13-4-2.
//
//

#import <UIKit/UIKit.h>
#import "ProductVO.h"
#import "ProductRatingVO.h"
#import "OTSProductCommentViewV2.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface OTSProductCommentTopCellV2 : UITableViewCell<OTSProductCommentTopCellDelegate>
{
    UILabel * gRPercentValueLabel;
    float gResultRate;
    float mResultRate;
    float bResultRate;
    float resultRate;
    UILabel * gRLabel;
}

/**
 *  功能:初始化方法
 */
- (id)initWithProductVO:(ProductVO *)aProductVO;

@end
