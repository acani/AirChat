#import "AppDelegate.h"
#import "UsersTableViewController.h"

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

    // Set up _window > UINavigationController > _usersTableViewController.
    _usersTableViewController = [[UsersTableViewController alloc] initWithNibName:nil bundle:nil];
//    usersTableViewController.managedObjectContext = _managedObjectContext;
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:_usersTableViewController];
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Cancel any Bonjour-related services.
//    UsersTableViewController *usersTableViewController = USERS_TABLE_VIEW_CONTROLLER();
    [_usersTableViewController.netServiceBrowser stop];
    [_usersTableViewController.services removeAllObjects];
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
