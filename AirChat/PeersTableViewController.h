#import <UIKit/UIKit.h>

static NSUInteger _networkActivityIndicatorCount = 0;
UIKIT_STATIC_INLINE void AppSetNetworkActivityIndicatorVisible(BOOL visible) {
    if (visible) {
        ++_networkActivityIndicatorCount;
    } else {
        assert(_networkActivityIndicatorCount > 0);
        --_networkActivityIndicatorCount;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = (_networkActivityIndicatorCount > 0);
}

UIKIT_STATIC_INLINE void PromptUserForDisplayName(NSString *message, id delegate) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enter Display Name", nil) message:message delegate:delegate cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
    [alertView show];
}

@interface PeersTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *peerIDs;

//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
