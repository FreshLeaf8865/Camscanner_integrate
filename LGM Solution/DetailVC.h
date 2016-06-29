//
//  DetailVC.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 4/24/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailObject.h"
#import "Textfield.h"
#import "TimePickerView.h"
#import "ListViewDelegate.h"
#import "CameraView.h"
#import "SelectListView.h"
#import "DatePickerView.h"
#import "SignatureView.h"
#import "RadioView.h"
#import "QrCodeView.h"

@interface DetailVC : UIViewController<UIGestureRecognizerDelegate,TextfieldDelegate,TimePickerViewDelegate, ListViewDelegate, CameraViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, SelectListViewDelegate, DatePickerViewDelegate, SignatureViewDelegate, RadioViewDelegate, QrCodeViewDelegate>{
    CGPoint velocityF;
    CGPoint velocityL;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIView *parentView;
    CGFloat pointOfLastControl;
    CGFloat currentKeyboardHeight;
    NSMutableArray *arrPostionControls;
    CGFloat yContent;
    NSMutableArray *arrGroups;
    
    int countTagOfTextview ;
    int countTagOfListview ;
    int countTagOfCamera ;
    int countTagOfSelect ;
    int countTagOfSignature ;
    int countTagOfTimePicker ;
    int countTagOfDatePicker ;
    int countTagOfRadio ;
    int countTagOfTextLabel ;
    int countTagOfQrCode ;
    float distanceControls;
    UIButton *btSend;
    UIButton *btCancel;
    
    NSString *subject;
    NSMutableString *html;
    NSMutableArray *arrImageSend;
    int tagOFStatus, tagOFImage;
    
    NSString *status,*companyName,*ticket;
}

- (IBAction)clickBack:(id)sender;
@property (nonatomic, retain) DetailObject *objDetail;
@end
