#include <CFNetwork/CFSocketStream.h>
#include <sys/socket.h>
#include <netinet/in.h>
//#include <unistd.h>
#import "UsersTableViewController.h"

@interface UsersTableViewController () <NSNetServiceDelegate, NSNetServiceBrowserDelegate> {
    CFSocketRef _chatSocket;
}
@end

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
    NSLog(@"viewWillAppear: %d", animated);
    AppSetNetworkActivityIndicatorVisible(YES);
    [self publishNetworkService];
    [self browseForNetworkServices];
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

#pragma mark - NSNetServiceDelegate

// This function is called by CFSocket when a new connection comes in.
static void SocketCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {

}

// TODO: DRY up repeated code. @refactor
- (void)publishNetworkService {

    // Publish a Network Service
    // https://developer.apple.com/library/prerelease/ios/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/Discovering,Browsing,AndAdvertisingNetworkServices/Discovering,Browsing,AndAdvertisingNetworkServices.html#//apple_ref/doc/uid/TP40010220-CH9-SW2

    // 1. Create a socket to listen for connections to the service.
    // a. Create _chatSocket to listen for connections.
    CFSocketContext socketContext = {0, (__bridge void *)(self), NULL, NULL, NULL};
    _chatSocket = CFSocketCreate(kCFAllocatorDefault, PF_INET6, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, (CFSocketCallBack)&SocketCallBack, &socketContext);
    if (!_chatSocket) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cannot Publish Presence", nil) message:NSLocalizedString(@"AirChat cannot publish your presence because it failed to create a network socket.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return;
    }
    int yes = 1; // allows _chatSocket to be reused for every connection
    setsockopt(CFSocketGetNative(_chatSocket), SOL_SOCKET, SO_REUSEADDR, (void *)&yes, sizeof(yes));

    // b. Bind _chatSocket to an address.
    struct sockaddr_in6 socketAddress;
    memset(&socketAddress, 0, sizeof(socketAddress));
    socketAddress.sin6_len = sizeof(socketAddress);
    socketAddress.sin6_family = AF_INET6;
    socketAddress.sin6_port = 0;                      // lets kernel choose arbitrary port
    socketAddress.sin6_flowinfo = 0;
    socketAddress.sin6_addr = in6addr_any;
    if (CFSocketSetAddress(_chatSocket, (__bridge CFDataRef)[NSData dataWithBytes:&socketAddress length:sizeof(socketAddress)]) != kCFSocketSuccess) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cannot Publish Presence", nil) message:NSLocalizedString(@"AirChat cannot publish your presence because it failed to bind the network socket to an address.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        CFSocketInvalidate(_chatSocket);
        CFRelease(_chatSocket);
        _chatSocket = NULL;
        return;
    }

    // c. Begin listening on _chatSocket by adding it to currentRunLoop.
    CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
    CFRunLoopSourceRef runLoopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _chatSocket, 0);
    CFRunLoopAddSource(currentRunLoop, runLoopSource, kCFRunLoopCommonModes);
    CFRelease(runLoopSource);

    // TODO: Use the DNS Service Discovery API to support Bluetooth.
    // 2. Create _netService with port of _chatSocket.
    NSData *socketAddressData = CFBridgingRelease(CFSocketCopyAddress(_chatSocket));
    memcpy(&socketAddress, [socketAddressData bytes], [socketAddressData length]);
    // TODO: Make name customizable.
    _netService = [[NSNetService alloc] initWithDomain:@"" type:@"_airchat._tcp." name:@"" port:ntohs(socketAddress.sin6_port)];
    if (!_netService) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cannot Publish Presence", nil) message:NSLocalizedString(@"AirChat cannot publish your presence because it failed to create a network service.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        CFSocketInvalidate(_chatSocket);
        CFRelease(_chatSocket);
        _chatSocket = NULL;
        return;
    }
    _netService.delegate = self;
    [_netService publish]; // continued in -netServiceDidPublish: or -netService:didNotPublish: ...
}

- (void)netServiceWillPublish:(NSNetService *)netService {
    NSLog(@"netServiceWillPublish: %@", netService);
}

- (void)netServiceDidPublish:(NSNetService *)netService {
    NSLog(@"netServiceDidPublish: %@", netService);
    AppSetNetworkActivityIndicatorVisible(NO);
}

- (void)netService:(NSNetService *)netService didNotPublish:(NSDictionary *)errorDictionary {
    AppSetNetworkActivityIndicatorVisible(NO);
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cannot Publish Presence", nil) message:[NSString stringWithFormat:NSLocalizedString(@"AirChat cannot publish your presence. Error code: %@", nil), [errorDictionary objectForKey:NSNetServicesErrorCode]] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    CFSocketInvalidate(_chatSocket);
    CFRelease(_chatSocket);
    _chatSocket = NULL;
    _netService.delegate = nil;
    _netService = nil;
}

- (void)netServiceDidStop:(NSNetService *)netService {
    NSLog(@"netServiceDidStop: %@", netService);
}

#pragma mark - NSNetServiceBrowserDelegate

- (void)browseForNetworkServices {
    _netServiceBrowser = [[NSNetServiceBrowser alloc] init];
	_netServiceBrowser.delegate = self;
	[_netServiceBrowser searchForServicesOfType:@"_airchat._tcp." inDomain:@""];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreComing {
    [_services addObject:netService];
    NSLog(@"didFindService: %@", netService);
    NSLog(@"moreComing: %i", moreComing);
    if (!moreComing) {
        [self.tableView reloadData];
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreComing {
    [_services removeObject:netService];
    NSLog(@"didRemoveService: %@", netService);
    NSLog(@"moreComing: %i", moreComing);
    if (!moreComing) {
        [self.tableView reloadData];
    }
}

@end
