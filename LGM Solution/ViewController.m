//
//  ViewController.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 4/23/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "ViewController.h"
#import "DetailVC.h"
#import "CompanyObj.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "CompanyDoc.h"
#import "CompanyDatabase.h"
#import "Define.h"
#import "Common.h"
#import "MBProgressHUD.h"
#import "XMLManage.h"
#import "UIAlertView+NSBlock.h"
#import "LoginVC.h"
#import "HomeCell.h"
#import "DetailObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (![[USER_DEFAULT objectForKey:@"isLogedin"] isEqualToString:@"yes"]) {
        [USER_DEFAULT setValue:@"yes" forKey:@"isLogedin"];
        [_arrData sortUsingComparator:^(CompanyObj *firstObject, CompanyObj *secondObject) {
            return [firstObject.CompanyName caseInsensitiveCompare:secondObject.CompanyName];
        }];
        [self loadDatabase];
        
    }else{
        arrImage = [[NSMutableArray alloc] init];
        arrImage = [CompanyDatabase loadScaryBugDocsCompany];
        [arrImage sortUsingComparator:^(CompanyDoc *firstObject, CompanyDoc *secondObject) {
            return [firstObject.data.CompanyName caseInsensitiveCompare:secondObject.data.CompanyName];
        }];
    }
    lbHello.text = [NSString stringWithFormat:@"Connecté en tant que: %@", [USER_DEFAULT objectForKey:@"Name"]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[tbView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrImage.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string_cell;
    string_cell = @"HomeCell";
    HomeCell *cell =(HomeCell *)[tableView dequeueReusableCellWithIdentifier:string_cell];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:string_cell owner:self options:nil];
        cell = homeCell;
        homeCell = nil;
    }
    CompanyDoc *obj = [arrImage objectAtIndex:indexPath.row];
    cell.lbCell.text = obj.data.CompanyName;
    if (obj.thumbImage != nil) {
        UIImage *image = [self imageWithImage:obj.thumbImage scaledToSize:CGSizeMake(148.0f, 80.0f)];
        [cell.imgCell setImage:image];
    }
    
    [cell.imgCell setContentMode:UIViewContentModeScaleAspectFit];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CompanyDoc *obj = [arrImage objectAtIndex:indexPath.row];
    DetailObject *objDetail = [[DetailObject alloc] init];
    objDetail.CompanyID = obj.data.CompanyID;
    objDetail.CompanyName = obj.data.CompanyName;
    objDetail.CompanyLogo = obj.thumbImage;
    objDetail.MailAddress = [XMLManage getEmail:[obj.docPath stringByAppendingPathComponent:kFullImageFile]];
    objDetail.Form = [XMLManage loadForm:[obj.docPath stringByAppendingPathComponent:kFullImageFile]];
    objDetail.Group = [XMLManage loadGroup:[obj.docPath stringByAppendingPathComponent:kFullImageFile]];
    DetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    vc.objDetail = objDetail;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)dowloadFileXMLCompaniesWithUsername:(NSString*)username password:(NSString*)password{
    [MBProgressHUD showHUDAddedTo:self.view WithTitle:@"Loading..." animated:YES];
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
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            arr = [XMLManage loadCompanies:filePath];
            [timer invalidate];
            timer = nil;
            count = 0;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [USER_DEFAULT setValue:filePath forKey:@"filePath"];
            [_arrData removeAllObjects];
            _arrData = arr;
            [_arrData sortUsingComparator:^(CompanyObj *firstObject, CompanyObj *secondObject) {
                return [firstObject.CompanyName caseInsensitiveCompare:secondObject.CompanyName];
            }];
            [self loadDatabase];
        }
    }];
}
-(void)timeout{
    count++;
    if (count == 120) {
        [timer invalidate];
        timer = nil;
        count = 0;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [Common showAlert:@"Request time out. Please check your internet connection"];
        count = 0;
    }
}
- (IBAction)clickRefresh:(id)sender {
    if ([Common connectedInternet]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Are you sure you want to refresh the data?"delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
        alert.delegate = self;
        [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            // handle the button click
            if (buttonIndex == 0) {
                
            }else if (buttonIndex == 1){
                count = 0;
                //timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeout) userInfo:nil repeats:YES];
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                arr = [CompanyDatabase loadScaryBugDocsCompany];
                for (CompanyDoc *ob in arr) {
                    [ob deleteDoc];
                }
                [self dowloadFileXMLCompaniesWithUsername:[USER_DEFAULT objectForKey:@"username"] password:[USER_DEFAULT objectForKey:@"password"]];
            }
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
            [alert dismissWithClickedButtonIndex:0 animated:NO];
        }];
        
    }else{
        [Common showAlert:@"No have internet connection"];
    }
}

- (IBAction)clickSignout:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            if (![[USER_DEFAULT objectForKey:@"isBeginLogin"] isEqualToString:@"yes"]) {
                [USER_DEFAULT setValue:@"no" forKey:@"isLogedin"];
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                arr = [CompanyDatabase loadScaryBugDocsCompany];
                for (CompanyDoc *ob in arr) {
                    [ob deleteDoc];
                }
                AppDelegate *app = [Common appDelegate];
                [app changeNavi];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}
- (void)downloadXMLFileWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, NSData *xml))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   completionBlock(YES,data);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}
-(void)loadDatabase{
    arrImage = [[NSMutableArray alloc] init];
    if ([Common connectedInternet]) {
        count = 0;
        //timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeout) userInfo:nil repeats:YES];
        [MBProgressHUD showHUDAddedTo:self.view WithTitle:@"Loading..." animated:YES];
       
        for (CompanyObj *obj in _arrData) {
            [self downloadImageWithURL:[NSURL URLWithString:obj.CompanyLogo] completionBlock:^(BOOL succeeded, UIImage *image) {
                CompanyDoc *objSave = [[CompanyDoc alloc] init];
                CompanyObj *objCom = [[CompanyObj alloc] initWithID:obj.CompanyID CompanyLogo:obj.CompanyLogo CompanyName:obj.CompanyName];
                objSave.data = objCom;
                objSave.thumbImage = image;
                NSLog(@"Complete image");
                [self downloadXMLFileWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", LINK_GET_DETAIL, obj.CompanyID]]  completionBlock:^(BOOL succeeded, NSData *xml) {
                    NSLog(@"Complete xml");
                    count = 0;
                    objSave.xmlFile = xml;
                    [objSave saveData];
                    [objSave saveImages];
                    [arrImage addObject:objSave];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (arrImage.count == _arrData.count) {
                            [arrImage sortUsingComparator:^(CompanyDoc *firstObject, CompanyDoc *secondObject) {
                                return [firstObject.data.CompanyName caseInsensitiveCompare:secondObject.data.CompanyName];
                            }];
                            [tbView reloadData];
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        }
                    });
                }];
            }];
        }
    }else{
        [Common showAlert:@"No have internet connection"];
    }
}
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    CGFloat actualHeight = image.size.height;
    CGFloat actualWidth = image.size.width;
    
    if(actualWidth <= newSize.width || actualHeight <= newSize.height)
    {
        return image;
    }
    else
    {
        if((actualWidth/actualHeight)<(newSize.width/newSize.height))
        {
            actualHeight=actualHeight*(newSize.width/actualWidth);
            actualWidth=newSize.width;
            
        }else
        {
            actualWidth=actualWidth*(newSize.height/actualHeight);
            actualHeight=newSize.height;
        }
    }
    // Create a graphics image context
    UIGraphicsBeginImageContext(CGSizeMake(actualWidth,actualHeight));
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,actualWidth,actualHeight)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

@end
