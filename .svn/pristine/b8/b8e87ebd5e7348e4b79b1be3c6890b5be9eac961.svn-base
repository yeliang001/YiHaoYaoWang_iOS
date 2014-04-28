//
//  OTSProductCommentTVCell.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-20.
//
//

#import "OTSProductCommentTVCell.h"
#import "OTSPadProductStarView.h"
#import "UIView+LoadFromNib.h"
#import "ProductExperienceVO.h"

@implementation OTSProductCommentTVCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)dealloc {
    [_startView release];
    [_userNameLabel release];
    [_contentLabel release];
    [_bgIV release];
    [super dealloc];
}

- (void)awakeFromNib
{
    CGRect starRc = self.startView.frame;
    [self.startView removeFromSuperview];
    self.startView = [[[OTSPadProductStarView alloc] init] autorelease];
    self.startView.frame = starRc;
    [self addSubview:self.startView];
    
    //
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImage *bgImg = [UIImage imageNamed:@"pdCommentBubbleBg"];
    UIImage *stretchImg = [bgImg stretchableImageWithLeftCapWidth:20.f topCapHeight:70.f];
    self.bgIV.image = stretchImg;
}

-(void)updateWithData:(ProductExperienceVO *)aData
{
    if (aData)
    {
        if (aData.userName.length <= 0)
        {
            aData.userName = @"买家";
        }
        else if (aData.userName.length > 3)
        {
            aData.userName = [aData.userName substringToIndex:2];
            aData.userName = [NSString stringWithFormat:@"%@***", aData.userName];
        }
        
        self.userNameLabel.text = aData.userName;
        
        self.startView.count = [aData.ratingLog intValue];
        
        if (aData.content.length > 0)
        {
            self.contentLabel.text = aData.content;
            [self.contentLabel sizeToFit];
            
            CGRect bgRc = self.bgIV.frame;
            bgRc.size.height = CGRectGetMaxY(self.contentLabel.frame) + 10 - bgRc.origin.y;
            self.bgIV.frame = bgRc;
        }
        
        CGRect thisRc = self.frame;
        thisRc.size.height = CGRectGetMaxY(self.bgIV.frame) + 10;
        self.frame = thisRc;
    }
}

@end
