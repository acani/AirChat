#import "AppDelegate.h"
#import "PeersTableViewController.h"

//#define NAVIGATION_CONTROLLER() \
//((UINavigationController *)_window.rootViewController)
//
//#define USERS_TABLE_VIEW_CONTROLLER() \
//((UsersTableViewController *)[NAVIGATION_CONTROLLER().viewControllers objectAtIndex:0])

@implementation AppDelegate // {
//    NSManagedObjectContext *_managedObjectContext;
// }

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    // Set up Core Data stack.
//    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AirChat" withExtension:@"momd"]]];
//    NSError *error;
//    NSAssert([persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"AirChat.sqlite"] options:nil error:&error], @"Add-Persistent-Store Error: %@", error);
//    _managedObjectContext = [[NSManagedObjectContext alloc] init];
//    [_managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];

    // Set up _window > UINavigationController > _peersTableViewController.
    PeersTableViewController *peersTableViewController = [[PeersTableViewController alloc] initWithStyle:UITableViewStylePlain];
//    peersTableViewController.managedObjectContext = _managedObjectContext;
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:peersTableViewController];
    [_window makeKeyAndVisible];
    return YES;
}

//- (void)applicationWillTerminate:(UIApplication *)application {
//    [self saveContext];
//}
//
//- (void)saveContext {
//    NSError *error = nil;
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//             // Replace this implementation with code to handle the error appropriately.
//             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        } 
//    }
//}

@end
