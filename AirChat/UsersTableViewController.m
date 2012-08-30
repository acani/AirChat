#import "UsersTableViewController.h"

@implementation UsersTableViewController

#pragma mark - UITableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.services = [NSMutableArray array];
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [self searchForNetworkServices];
}

//#pragma mark - UITableViewDelegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//     MessagesViewController *messagesViewController = [[MessagesViewController alloc] initWithNibName:nil bundle:nil];
//     [self.navigationController pushViewController:messagesViewController animated:YES];
//}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_services count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = ((NSNetService *)[_services objectAtIndex:indexPath.row]).name;
    return cell;
}

#pragma mark - NSNetServiceBrowserDelegate

- (void)searchForNetworkServices {
    _netServiceBrowser = [[NSNetServiceBrowser alloc] init];
	_netServiceBrowser.delegate = self;
	[_netServiceBrowser searchForServicesOfType:@"_airchat._tcp." inDomain:@""];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {
    [_services addObject:netService];
    NSLog(@"didFindService: %@", netService);
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {
    [_services removeObject:netService];
    NSLog(@"didRemoveService: %@", netService);
}

@end
