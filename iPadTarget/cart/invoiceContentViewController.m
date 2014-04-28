//
//  invoiceContentViewController.m
//  yhd
//
//  Created by xuexiang on 12-8-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "invoiceContentViewController.h"
#import "OTSServiceHelper.h"

@interface invoiceContentViewController ()

@end

@implementation invoiceContentViewController
@synthesize delegate;
@synthesize contentArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    contentArray = [[NSArray alloc] initWithObjects:@"酒", @"饮料", @"食品", @"玩具", @"日用品", 
//						   @"装修材料", @"化妆品", @"办公用品", @"学生用品", 
//						   @"饰品", @"服装", @"箱包", @"精品", @"家电", @"劳防用品", nil];
    contentArray = [[NSArray alloc]initWithObjects:@"酒", @"饮料", @"食品", @"玩具", @"日用品",
                    @"装修材料", @"化妆品", @"图书", @"办公用品", @"音像用品", @"学生用品",
                    @"饰品", @"服装", @"箱包", @"精品", @"家电", @"劳防用品",nil];
}
#pragma mark -
#pragma mark tableView 相关 delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell.textLabel.text = [contentArray objectAtIndex:[indexPath row]];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"System" size:17];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [contentArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(contentChooseAtIndex::)]) {
        [delegate contentChooseAtIndex:[indexPath row] :nil];
    }
}

#pragma mark -
#pragma mark 内存施放
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc{
    [super dealloc];
}
@end
