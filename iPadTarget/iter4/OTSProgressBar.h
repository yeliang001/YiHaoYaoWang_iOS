//
//  OTSProgressBar.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-20.
//
//

#import <UIKit/UIKit.h>

@interface OTSProgressBar : UIView
@property (retain, nonatomic) IBOutlet UIImageView *bgView;
@property   NSUInteger      percent;    // 0~100
@end
