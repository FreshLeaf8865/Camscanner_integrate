//
//  LoginVc.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 4/24/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "LoginVC.h"
#import "DetailVC.h"
#import "MBProgressHUD.h"
#import "Define.h"
#import "XMLManage.h"
#import "Common.h"
#import "ViewController.h"


@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tf_Password.delegate = self;
    tf_Username.delegate = self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    tf_Password.text = @"";
    tf_Username.text = @"";
    [self changeScrView];
    [scrView addGestureRecognizer:[self TapGestureRecognizer]];
}
- (UITapGestureRecognizer *)TapGestureRecognizer {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleTap:)];
    return recognizer;
}

- (void) handleTap:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}
- (void) changeScrView
{
    scrView.bouncesZoom = YES;
    scrView.clipsToBounds = YES;
    
    scrView.contentSize = CGSizeMake(scrView.frame.size.width,self.view.frame.size.width);
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    scrView.contentSize = CGSizeMake(scrView.frame.size.width,self.view.frame.size.width+300);
    [scrView setContentOffset:CGPointMake(0, tf_Password.frame.origin.y-200)];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    scrView.contentSize = CGSizeMake(scrView.frame.size.width,self.view.frame.size.width);
    [scrView setContentOffset:CGPointMake(0, 0)];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [self clickLogin:nil];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)dowloadFileXMLCompaniesWithUsername:(NSString*)username password:(NSString*)password{
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentDir stringByAppendingPathComponent:FILE_NAME_COMPANIES];
    NSString *url = [NSString stringWithFormat:@"%@?user_name=%@&password=%@", LINK_GET_COMPANIES, username, password];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Download Error:%@",error.description);
            [timer invalidate];
            timer = nil;
            count = 0;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        if (data) {
            [data writeToFile:filePath atomically:YES];
            NSLog(@"File is saved to %@",filePath);
            if (![XMLManage getStatus:filePath]) {
                [Common showAlert:@"Username or Password is incorrect"];
                [timer invalidate];
                timer = nil;
                count = 0;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }else{
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                arr = [XMLManage loadCompanies:filePath];
                [timer invalidate];
                timer = nil;
                count = 0;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [USER_DEFAULT setValue:[XMLManage getUsername:filePath] forKey:@"Name"];
                [USER_DEFAULT setValue:[XMLManage getUseremail:filePath] forKey:@"Email"];
                [USER_DEFAULT setValue:[Common trimString:tf_Username.text] forKey:@"username"];
                [USER_DEFAULT setValue:[Common trimString:tf_Password.text] forKey:@"password"];
                [USER_DEFAULT setValue:filePath forKey:@"filePath"];
                ViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                vc.arrData = arr;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
}
- (IBAction)clickLogin:(id)sender {
    if ([[Common trimString:tf_Username.text] length] == 0) {
        [Common showAlert:@"Username cannot be empty"];
    }else if ([[Common trimString:tf_Password.text] length] == 0) {
        [Common showAlert:@"Password cannot be empty"];
    }else{
        if ([Common connectedInternet]) {
            count = 0;
            //timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeout) userInfo:nil repeats:YES];
            [MBProgressHUD showHUDAddedTo:self.view WithTitle:@"Loading..." animated:YES];
            [self dowloadFileXMLCompaniesWithUsername:[Common trimString:tf_Username.text] password:[Common trimString:tf_Password.text]];
        }else{
            [Common showAlert:@"No have internet connection"];
        }
    }
}
-(void)timeout{
    count++;
    if (count == 120) {
        [timer invalidate];
        timer = nil;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [Common showAlert:@"Request time out. Please check your internet connection"];
        count = 0;
    }
}
@end
