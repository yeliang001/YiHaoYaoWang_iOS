//
//  PayInWebViewCell.m
//  yhd
//
//  Created by dev dev on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PayInWebViewCell.h"

@implementation PayInWebViewCell
@synthesize mpaymethodImageView;
@synthesize mpaymethodLabel;
@synthesize mUrl;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    mgouImageView.hidden = !selected;
}

-(void)loadimage
{
    SDWebDataManager * loader = [SDWebDataManager sharedManager];
    [loader downloadWithURL:[NSURL URLWithString:mUrl] delegate:self];
}
#pragma mark - delegate
- (void)webDataManager:(SDWebDataManager *)dataManager didFinishWithData:(NSData *)aData isCache:(BOOL)isCache
{
    self.mpaymethodImageView.image = [UIImage imageWithData:aData];
}
@end
