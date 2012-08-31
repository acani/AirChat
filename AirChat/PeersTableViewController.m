#import <GameKit/GameKit.h>
#import "PeersTableViewController.h"

@interface PeersTableViewController () <GKSessionDelegate> {
    NSString *_displayName;
    GKSession *_chatSession;
}
@end

@implementation PeersTableViewController

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear: %d", animated);
    AppSetNetworkActivityIndicatorVisible(YES);

    if (!_displayName) {
        PromptUserForDisplayName(nil, self);
    }
}

//#pragma mark - UITableViewDelegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//     MessagesViewController *messagesViewController = [[MessagesViewController alloc] initWithNibName:nil bundle:nil];
//     [self.navigationController pushViewController:messagesViewController animated:YES];
//}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_peerIDs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [_chatSession displayNameForPeer:[_peerIDs objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _displayName = [alertView textFieldAtIndex:0].text;
    if ([_displayName length]) {
        _chatSession = [[GKSession alloc] initWithSessionID:nil displayName:_displayName sessionMode:GKSessionModePeer];
        _chatSession.delegate = self;
        [_chatSession setDataReceiveHandler:self withContext:NULL];
        _chatSession.available = YES;
    } else {
        _displayName = nil;
        PromptUserForDisplayName(@"You must enter a name for others to see.", self);
    }
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    NSLog(@"displayName: %@ didChageState: %u", [_chatSession displayNameForPeer:peerID], state);
    _peerIDs = [_chatSession peersWithConnectionState:GKPeerStateAvailable];
    [self.tableView reloadData];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    AppSetNetworkActivityIndicatorVisible(NO);
    [_chatSession disconnectFromAllPeers];
    _chatSession.delegate = nil;
    _chatSession = nil;
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cannot Connect", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)context {
    NSLog(@"receiveData: %@ fromDisplayName: %@", data, [_chatSession displayNameForPeer:peerID]);
}

@end
