//
//  OTSPadTicketRuleFloatView.m
//  TheStoreApp
//
//  Created by dong yiming on 12-12-11.
//
//

#import "OTSPadTicketRuleFloatView.h"

@interface OTSPadTicketRuleFloatView ()
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation OTSPadTicketRuleFloatView
@synthesize delegate = _delegate;
@synthesize datas = _datas;
@synthesize defineType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    [_tableView release];
    [_datas release];
    OTS_SAFE_RELEASE(defineType);
    
    [_titleLabel release];
    [super dealloc];
}

-(void)awakeFromNib
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.layer.borderColor = [UIColor colorWithRed:201.0/255 green:201.0/255 blue:201.0/255 alpha:1.0].CGColor;
    self.tableView.layer.borderWidth =1;
    self.tableView.layer.cornerRadius = 7.0;
    self.tableView.layer.masksToBounds = YES;
    
}
-(void)showTitle{
    if (self.defineType.intValue == 5) {
        [_titleLabel setText:@"购买除以下商品可以使用抵用券："];
    }else{
        [_titleLabel setText:@"购买以下商品可以使用抵用券："];
    }
}
-(IBAction)closeAction:(id)sender
{
    SEL sel = @selector(hide);
    if ([_delegate respondsToSelector:sel])
    {
        [_delegate performSelector:sel];
    }
}




#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    
    cell.textLabel.text = [self.datas objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    return cell;
}

@end
