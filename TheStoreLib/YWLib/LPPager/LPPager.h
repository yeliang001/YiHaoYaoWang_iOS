//
//  LPPager.h
//  WisdomCloud
//
//  Created by Lin Pan on 12-10-16.
//
//

#import <UIKit/UIKit.h>

@interface LPPager : UIScrollView

@property(retain,nonatomic) NSArray *viewArr;
@property(assign,nonatomic) NSInteger gapX; //两个view之间的间隔


-(id)initWithFrame:(CGRect)frame viewArr:(NSArray *)aViewArr gapX:(NSInteger )aGapx;
@end
