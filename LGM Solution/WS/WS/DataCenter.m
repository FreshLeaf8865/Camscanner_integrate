//
//  UserObj.h
//  SmarkKid
//
//  Created by Phan Minh Tam on 3/22/14.
//  Copyright (c) 2014 SDC. All rights reserved.
//

#import "DataCenter.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "JSON.h"
#import "Define.h"
#import "AppDelegate.h"
#import "Common.h"
#import "ImageSendObj.h"
/*============================================================================
 PRIVATE METHOD
 =============================================================================*/
@interface DataCenter ()



@end

@implementation DataCenter


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super dealloc];
}

/*-(void)send_mail:(NSString*)name email:(NSString*)email to:(NSString*)to subject:(NSString*)subject content:(NSString*)content images:(NSMutableArray *)images{
    NSDictionary *parameter = @{@"name":name, @"email":email, @"to":to, @"subject":subject,@"content":content};
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:WS_LINK]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"sendMail.php" parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(int i = 0; i<images.count;i++) {
            ImageSendObj *obj = [images objectAtIndex:i];
            NSData *dataToUpload = UIImageJPEGRepresentation(obj.image, 1);
            [formData appendPartWithFileData:dataToUpload name:[NSString stringWithFormat:@"images[%d]", i] fileName:[NSString stringWithFormat:@"%d.png",i] mimeType:@"image/png"];
        }
    }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"%ld - %lld - %lld", (long)bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [operation.responseString JSONValue];
        NSLog(@"send_mail: %@",response);
        [[NSNotificationCenter defaultCenter] postNotificationName:k_send_mail_success object:response];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error ->send_mail: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:k_send_mail_fail object:error];
    }];
    [httpClient release];
    [operation start];
}*/
-(void)send_mail:(NSString*)name to:(NSString*)to cc:(NSString*)cc subject:(NSString*)subject content:(NSString*)content images:(NSMutableArray*)images{

    NSDictionary *parameter = @{@"name":name , @"to":to, @"cc":cc, @"subject":subject,@"content":content};
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:WS_LINK]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"sendMail.php" parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(int i = 0; i<images.count;i++) {
            ImageSendObj *obj = [images objectAtIndex:i];

            //MTPL: compress high quality image
//            NSData *dataToUpload = UIImageJPEGRepresentation(obj.image, 1);
            NSData *dataToUpload = [self compressImage:obj.image];

            [formData appendPartWithFileData:dataToUpload name:[NSString stringWithFormat:@"images[%d]", i] fileName:[NSString stringWithFormat:@"%d.jpg",i] mimeType:@"image/jpg"];
        }
    }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"%ld - %lld - %lld", (long)bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [operation.responseString JSONValue];
        NSLog(@"send_mail: %@",response);
        [[NSNotificationCenter defaultCenter] postNotificationName:k_send_mail_success object:response];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error ->send_mail: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:k_send_mail_fail object:error];
    }];
    [httpClient release];
    [operation start];
}

-(NSData*)compressImage:(UIImage*)img{
    //MTPL: compress high quality image
    CGSize size=CGSizeMake(img.size.width/4,img.size.height/4);
    UIImage *newImage = [self resizeImage:img newSize:size];

    NSData *imgData = UIImageJPEGRepresentation(newImage, 1.0);
    NSInteger fileSize = [imgData length]/1024;
    float scale = 1.0;

    while (fileSize > 500 && scale > 0.1) {
        scale = scale - 0.1;
        imgData = UIImageJPEGRepresentation(newImage, scale);
        fileSize = [imgData length]/1024;
    }

//    NSLog(@"Size of Image(bytes):%d",[imgData length]);

    return imgData;
}

- (UIImage *)resizeImage:(UIImage*)img newSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
