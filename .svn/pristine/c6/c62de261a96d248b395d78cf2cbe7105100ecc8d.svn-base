//
//  OTSPadProductCommentView.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-20.
//
//

#import <UIKit/UIKit.h>

@class OTSProgressBar;

@interface OTSPadProductCommentView : UIView
<UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) IBOutlet OTSProgressBar *goodProgressBar;
@property (retain, nonatomic) IBOutlet OTSProgressBar *midProgressBar;
@property (retain, nonatomic) IBOutlet OTSProgressBar *badProgressBar;

@property (retain, nonatomic) IBOutlet UILabel *goodPercentLabel;
@property (retain, nonatomic) IBOutlet UILabel *commentorLabel;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITableView *commentTV;
@property (retain, nonatomic) IBOutlet UIView *emptyView;


-(void)updateWithRating:(ProductRatingVO*)aRating;

@end
