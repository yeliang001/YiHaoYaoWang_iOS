//
//  OTSPadProductCommentView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-20.
//
//

#import "OTSPadProductCommentView.h"
#import "OTSProgressBar.h"
#import "UIView+LoadFromNib.h"
#import "OTSProductCommentTVCell.h"
#import "OTSPadProductStarView.h"
#import "ProductRatingVO.h"
#import "ProductExperienceVO.h"

@interface OTSPadProductCommentView ()
@property (retain) ProductRatingVO*     ratingVO;
@end

@implementation OTSPadProductCommentView
@synthesize ratingVO = _ratingVO;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)dealloc {
    [_goodProgressBar release];
    [_scrollView release];
    [_midProgressBar release];
    [_badProgressBar release];
    [_commentTV release];
    [_ratingVO release];
    
    [_goodPercentLabel release];
    [_commentorLabel release];
    [_emptyView release];
    [super dealloc];
}

-(void)awakeFromNib
{
    self.scrollView.alwaysBounceVertical = YES;
    
    self.commentTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGRect goodProgressRc = self.goodProgressBar.frame;
    [self.goodProgressBar removeFromSuperview];
    self.goodProgressBar = [OTSProgressBar viewFromNibWithOwner:self];
    self.goodProgressBar.frame = goodProgressRc;
    self.goodProgressBar.percent = 80;
    [self.scrollView addSubview:self.goodProgressBar];
    
    CGRect midProgressRc = self.midProgressBar.frame;
    [self.midProgressBar removeFromSuperview];
    self.midProgressBar = [OTSProgressBar viewFromNibWithOwner:self];
    self.midProgressBar.frame = midProgressRc;
    self.midProgressBar.percent = 20;
    [self.scrollView addSubview:self.midProgressBar];
    
    CGRect badProgressRc = self.badProgressBar.frame;
    [self.badProgressBar removeFromSuperview];
    self.badProgressBar = [OTSProgressBar viewFromNibWithOwner:self];
    self.badProgressBar.frame = badProgressRc;
    self.badProgressBar.percent = 0;
    [self.scrollView addSubview:self.badProgressBar];
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OTSProductCommentTVCell *cell = [OTSProductCommentTVCell viewFromNibWithOwner:self];
    
    ProductExperienceVO *data = [self.ratingVO.top5Experience objectAtIndex:indexPath.row];
    
    [cell updateWithData:data];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = self.ratingVO.top5Experience.count;
    
    self.emptyView.hidden = (count > 0);
    
    return count;
}

#pragma mark - update
-(void)updateWithRating:(ProductRatingVO*)aRating
{
    self.ratingVO = aRating;
    if (aRating)
    {
        float goodPercent = [aRating.goodRating floatValue];
        float midPercent = [aRating.middleRating floatValue];
        float badPercent = [aRating.badRating floatValue];
        
        float totalPercent = goodPercent + midPercent + badPercent;
        if (totalPercent <= 0)
        {
            return; // invalid value
        }
        
        goodPercent = goodPercent / totalPercent;
        midPercent = midPercent / totalPercent;
        badPercent = badPercent / totalPercent;
        
        self.goodPercentLabel.text = [NSString stringWithFormat:@"%.0f%%", goodPercent * 100];
        
        self.commentorLabel.text = [NSString stringWithFormat:@"%d人参与评论", [aRating.totalExperiencesCount intValue]];
        
        self.goodProgressBar.percent = goodPercent * 100;
        self.midProgressBar.percent = midPercent * 100;
        self.badProgressBar.percent = badPercent * 100;
        
//        // test data
//        for (ProductExperienceVO *data in aRating.top5Experience) {
//            data.content = arc4random() % 2 ? @"asdasdajhsdghjasgdhjgasdhjgasjhdgasjhdgjhasgdjhasgdjhasgdjhasjdghjasdjasjdaadsashdjhagshdjgasjhdgjahsgdhjasgdhgsjdhagsjhdgasjhdgashdghjasgdhasgdjhgasdjhgashdgahjsdgjhasgdhjagsdhjgashdgajshdgahjsdghjasgdhjagsdjhgasjhdgajhsdgjhasgdjhasgdjhagsdjhgasjhgsdhjgsdajfgsjdfhgajkgdfjgsajd" : @"hehehe";
//        }
        
    }
    
    [self.commentTV reloadData];
}

@end
