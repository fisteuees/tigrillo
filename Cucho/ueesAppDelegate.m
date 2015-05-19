//
//  ueesAppDelegate.m
//  Cucho
//
//  Created by Centro de Investigaciones on 29/05/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import "ueesAppDelegate.h"

@implementation ueesAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // app already launched
        NSLog(@"NO ES LA PRIMERA VEZ QUE SE ABRE");
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dir_niveles = [documentsDirectory stringByAppendingPathComponent:@"info_niveles.plist"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:dir_niveles];
        
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] initWithDictionary:[dict objectForKey:@"Niveles"]];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[dict2 objectForKey:@"Bosque"]];
        //NSLog(@"Mundo bosque %i",[arr count]);
        NSLog(@"%@",[arr objectAtIndex:0]);
        NSLog(@"%@",[arr objectAtIndex:1]);
        NSLog(@"%@",[arr objectAtIndex:2]);
        NSLog(@"%@",[arr objectAtIndex:3]);
        NSLog(@"%@",[arr objectAtIndex:4]);
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
        NSLog(@"ES LA PRIMERA VEZ QUE SE ABRE");
        // NSString *ruta_plist = [[NSBundle mainBundle] pathForResource:@"niveles" ofType:@"plist"];
        // NSMutableDictionary *contenido_plist = [[NSMutableDictionary alloc] initWithContentsOfFile:ruta_plist];
        // NSMutableDictionary *contenido_niveles = [[NSMutableDictionary alloc] initWithDictionary:[contenido_plist objectForKey:@"Niveles"]];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dir_niveles = [documentsDirectory stringByAppendingPathComponent:@"info_niveles.plist"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if(![fileManager fileExistsAtPath: dir_niveles])
        {
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"niveles" ofType:@"plist"];
            
            [fileManager copyItemAtPath:bundle toPath:dir_niveles error:&error];
            
            NSLog(@"SE COPIÓ EL PLIST AL DIRECTORIO");
            
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:dir_niveles];
            //NSLog(@"%i",[dict count]);
        }
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //<--- aqui esta pedro jose
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
