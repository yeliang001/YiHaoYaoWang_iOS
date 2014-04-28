//
//  LoadingMoreLabel.h
//  TheStoreApp
//
//  Created by jiming huang on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingMoreLabel : UILabel {
    BOOL m_FirstScroll;
    CGFloat m_ScrollViewContentHeight;
    BOOL m_NeedLoadMore;
    UIActivityIndicatorView *m_LoadMoreIndicator;
    BOOL m_IndicatorAnimating;
    UIScrollView *m_ScrollView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView selector:(SEL)aSelector target:(id)target;
- (void)reset;
@end
