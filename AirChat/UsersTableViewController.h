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

@interface UsersTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *services;

@property (strong, nonatomic) NSNetService *netService;

@property (strong, nonatomic) NSNetServiceBrowser *netServiceBrowser;

//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
