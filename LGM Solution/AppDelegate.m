//
//  AppDelegate.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 4/23/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LoginVC.h"
#import "Define.h"
#import "ISBlockActionSheet.h"
#import <QuartzCore/CALayer.h>
#import "CSPdfPreviewViewController.h"
#import <CamScannerOpenAPIFramework/CamScannerOpenAPIController.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self changeNavi];
    
    
    return YES;
}
    
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
    {
        if ([CamScannerOpenAPIController isSourceApplicationCamScanner:sourceApplication])
        {
            
            NSDictionary *userInfo = [CamScannerOpenAPIController userInfoFromURL:url andSourceApplication:sourceApplication];
            NSData *jpegData = [CamScannerOpenAPIController getJPEGDataFromCamScannerWithUserInfo:userInfo];
            UIImage *image = [UIImage imageWithData:jpegData];
            
            NSData *pdfData = [CamScannerOpenAPIController getPDFDataFromCamScannerWithUserInfo:userInfo];
            
            ViewController *controller = (ViewController *)[self.window rootViewController];
            //[controller updateImageViewWithImage:image];
            //[controller updatePdfFileWithData:pdfData];
            
            if( image )
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"onReceiveImageFromCamScannar" object:image];
            }
            
            NSString *returnCode = [userInfo objectForKey:kReturnCode];
            if (![returnCode isEqualToString:@"6000"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Code:%@", returnCode] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
        return YES;
    }
    
-(void)changeNavi{
    ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    if (![[USER_DEFAULT objectForKey:@"isLogedin"] isEqualToString:@"yes"]) {
        vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVC"];
        [USER_DEFAULT setValue:@"yes" forKey:@"isBeginLogin"];
    }else{
        [USER_DEFAULT setValue:@"no" forKey:@"isBeginLogin"];
    }
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    navi.navigationBarHidden = YES;
    self.window.rootViewController = navi;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
