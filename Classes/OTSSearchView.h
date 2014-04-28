//
//  OTSSearchView.h
//  TheStoreApp
//
//  Created by jiming huang on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchBar;
@interface OTSSearchView : UIView<UISearchBarDelegate> {
    SearchBar *m_SearchBar;
    id m_Delegate;
}

@property(nonatomic,readonly) SearchBar *m_SearchBar;

-(id)initWithFrame:(CGRect)frame delegate:(id)delegate;
@end
