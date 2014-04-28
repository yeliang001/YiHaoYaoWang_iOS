//
//  OTSProductCommentTopViewV2.h
//  TheStoreApp
//
//  Created by towne on 13-3-25.
//
//

#import <UIKit/UIKit.h>
#import "ProductVO.h"
#import "ProductRatingVO.h"
#import "OTSProductCommentViewV2.h"

@interface OTSProductCommentTopViewV2 : UIView<OTSProductCommentTopDelegate>
{

    UILabel * gRPercentValueLabel;
    float gResultRate;
    float mResultRate;
    float bResultRate;
    float resultRate;
    UILabel * gRLabel;
}


- (id)initWithFrame:(CGRect)frame fromProduct:(ProductVO *)productVO;

@end
