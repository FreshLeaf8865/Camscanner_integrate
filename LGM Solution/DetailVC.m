//
//  DetailVC.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 4/24/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "DetailVC.h"
#import "Define.h"
#import "UIAlertView+NSBlock.h"
#import "FormObj.h"
#import "SelectObj.h"
#import "NameLogo.h"
#import "Textfield.h"
#import "ListView.h"
#import "ItemObj.h"
#import "CameraView.h"
#import "DatePickerView.h"
#import "TextLabel.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ControlPosition.h"
#import "GroupObj.h"
#import "RadioObj.h"
#import "SelectObj.h"
#import "Common.h"
#import "DataCenter.h"
#import "MBProgressHUD.h"
#import "ImageSendObj.h"

#import "ISBlockActionSheet.h"
#import <QuartzCore/CALayer.h>
#import "CSPdfPreviewViewController.h"
#import <CamScannerOpenAPIFramework/CamScannerOpenAPIController.h>

#define AppKey @"4M2DybKhBFSeEFYJr9QyL6yQ"
//#define PDFResultFilePath [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.pdf"]

@interface DetailVC ()

@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [self addGestureRecognizers];
    
    arrPostionControls = [[NSMutableArray alloc] init];
    arrGroups = [[NSMutableArray alloc] init];
    arrImageSend = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfEndEdit)];
    tapGesture.delegate = self;
    [scrollView setCanCancelContentTouches:YES];
    [scrollView addGestureRecognizer:tapGesture];
    NameLogo *namelogo = [[NameLogo alloc] initWithLogo:_objDetail.CompanyLogo title:_objDetail.CompanyName rect:CGRectMake(0, alignTop, widthOfScreen, 50)];
    [scrollView addSubview:namelogo];
    pointOfLastControl = 50+alignTop;
    countTagOfTextview = 0;
    countTagOfListview = 0;
    countTagOfCamera = 0;
    countTagOfSelect = 0;
    countTagOfSignature = 0;
    countTagOfTimePicker = 0;
    countTagOfDatePicker = 0;
    countTagOfRadio = 0;
    countTagOfTextLabel = 0;
    countTagOfQrCode = 0;
    [self drawViews:_objDetail.Form tagOfParrentControl:-1];
    btSend = [[UIButton alloc] initWithFrame:CGRectMake(alignLeft, pointOfLastControl+4*alignLeft, (widthOfScreen)/2-4*alignLeft, heightOfTextField)];
    [btSend setTitle:@"Submit" forState:UIControlStateNormal];
    [btSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btSend setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    [btSend addTarget:self  action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btSend];
    
    btCancel = [[UIButton alloc] initWithFrame:CGRectMake((widthOfScreen-alignLeft)-((widthOfScreen)/2-4*alignLeft), pointOfLastControl+4*alignLeft, (widthOfScreen)/2-4*alignLeft, heightOfTextField)];
    [btCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btCancel setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    [btCancel addTarget:self  action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btCancel];
    
    pointOfLastControl += heightOfTextField+alignBottom;
    [self changeScrView];
    currentKeyboardHeight = 0.0;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onReceiveImageFromCamScannar:)
                                                 name:@"onReceiveImageFromCamScannar"
                                               object:nil];
    
    html = [NSMutableString stringWithString: [NSString stringWithFormat:@"Dear %@<br/><br/>", _objDetail.CompanyName]];
}
    
- (void)onReceiveImageFromCamScannar:(NSNotification *)note
{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HaveImage" object:note.object userInfo:nil];
}
    
-(void)drawViews : (NSMutableArray*)arrForms tagOfParrentControl:(int)tagOfParrentControl{
    for (FormObj *objForm in arrForms) {
        if ([objForm.type isEqualToString:@"textfield"]) {
            Textfield *tf = [[Textfield alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*2+alignBottom) label:objForm.label validate:objForm.validate isEmpty:objForm.isEmpty alt:objForm.alt];
            if (objForm.alt.length > 0) {
                tf = [[Textfield alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*3+alignBottom) label:objForm.label validate:objForm.validate isEmpty:objForm.isEmpty alt:objForm.alt];
                pointOfLastControl+=heightOfTextField*3+alignTop+alignBottom;
            }else{
                pointOfLastControl+=heightOfTextField*2+alignTop+alignBottom;
            }
            tf.tag = countTagOfTextview;
            countTagOfTextview++;
            tf.delegate = self;
            [scrollView addSubview:tf];
            
            ControlPosition *objPostion = [[ControlPosition alloc] init];
            objPostion.classOfControl = [Textfield class];
            objPostion.tagOfControl = (int)tf.tag;
            objPostion.yOfControl = tf.frame.origin.y;
            objPostion.tagOfParrentControl = tagOfParrentControl;
            objPostion.label = objForm.label;
            objPostion.isEmpty = objForm.isEmpty;
            [arrPostionControls addObject:objPostion];
        }else if ([objForm.type isEqualToString:@"timepicker"]){
            TimePickerView *timepic = [[TimePickerView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*2+alignBottom) label:objForm.label];
            timepic.delegate = self;
            timepic.tag = countTagOfTimePicker;
            countTagOfTimePicker++;
            [scrollView addSubview:timepic];
            pointOfLastControl+=heightOfTextField*2+alignTop+alignBottom;
            
            ControlPosition *objPostion = [[ControlPosition alloc] init];
            objPostion.classOfControl = [TimePickerView class];
            objPostion.tagOfControl = (int)timepic.tag;
            objPostion.yOfControl = timepic.frame.origin.y;
            objPostion.tagOfParrentControl = tagOfParrentControl;
            objPostion.label = objForm.label;
            objPostion.isEmpty = objForm.isEmpty;
            [arrPostionControls addObject:objPostion];
        }else if ([objForm.type isEqualToString:@"text"]){
            TextLabel *textLabel = [[TextLabel alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField+alignBottom) label:objForm.label];
            if (objForm.label.length == 0) {
                textLabel = [[TextLabel alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField+alignBottom) label:objForm.alt];
            }
            textLabel.tag = countTagOfTextLabel;
            [scrollView addSubview:textLabel];
            pointOfLastControl+=heightOfTextField+alignTop+alignBottom;
            countTagOfTextLabel++;
            
            ControlPosition *objPostion = [[ControlPosition alloc] init];
            objPostion.classOfControl = [TextLabel class];
            objPostion.tagOfControl = (int)textLabel.tag;
            objPostion.yOfControl = textLabel.frame.origin.y;
            objPostion.tagOfParrentControl = tagOfParrentControl;
            objPostion.label = objForm.label;
            objPostion.isEmpty = objForm.isEmpty;
            [arrPostionControls addObject:objPostion];
        }else if ([objForm.type isEqualToString:@"datepicker"]){
            DatePickerView *datepic = [[DatePickerView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*2+alignBottom) label:objForm.label];
            datepic.delegate = self;
            datepic.tag = countTagOfDatePicker;
            countTagOfDatePicker++;
            [scrollView addSubview:datepic];
            pointOfLastControl+=heightOfTextField*2+alignTop+alignBottom;
            
            ControlPosition *objPostion = [[ControlPosition alloc] init];
            objPostion.classOfControl = [DatePickerView class];
            objPostion.tagOfControl = (int)datepic.tag;
            objPostion.yOfControl = datepic.frame.origin.y;
            objPostion.tagOfParrentControl = tagOfParrentControl;
            objPostion.label = objForm.label;
            objPostion.isEmpty = objForm.isEmpty;
            [arrPostionControls addObject:objPostion];
        }else if ([objForm.type isEqualToString:@"listview"]){
            ListView *list = [[ListView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*8+alignBottom) label:objForm.label arr:objForm.list];
            list.delegate = self;
            list.arrForms = [[NSMutableArray alloc] init];
            list.arrForms = [objForm.list copy];
            list.tag = countTagOfListview;
            countTagOfListview++;
            [scrollView addSubview:list];
            pointOfLastControl+= heightOfTextField*8+alignTop+alignBottom;
            
            ControlPosition *objPostion = [[ControlPosition alloc] init];
            objPostion.classOfControl = [ListView class];
            objPostion.tagOfControl = (int)list.tag;
            objPostion.yOfControl = list.frame.origin.y;
            objPostion.tagOfParrentControl = tagOfParrentControl;
            objPostion.label = objForm.label;
            objPostion.isEmpty = objForm.isEmpty;
            [arrPostionControls addObject:objPostion];
        }else if ([objForm.type isEqualToString:@"camera"]){
            CameraView *camera = [[CameraView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*5+alignBottom) label:objForm.label];
            camera.delegate = self;
            camera.tag = countTagOfCamera;
            countTagOfCamera++;
            [scrollView addSubview:camera];
            pointOfLastControl+= heightOfTextField*5+alignTop+alignBottom;
            
            ControlPosition *objPostion = [[ControlPosition alloc] init];
            objPostion.classOfControl = [CameraView class];
            objPostion.tagOfControl = (int)camera.tag;
            objPostion.yOfControl = camera.frame.origin.y;
            objPostion.tagOfParrentControl = tagOfParrentControl;
            objPostion.label = objForm.label;
            objPostion.isEmpty = objForm.isEmpty;
            [arrPostionControls addObject:objPostion];
        }else if ([objForm.type isEqualToString:@"select"]){
            SelectListView *select = [[SelectListView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*2+alignBottom) label:objForm.label arr:objForm.select];
            SelectObj *selectobj = [objForm.select firstObject];
            status = selectobj.text;
            if (_objDetail.Group.count > 0) {
                for (GroupObj *objGr in _objDetail.Group) {
                    for (SelectObj *objSelect in objForm.select) {
                        [USER_DEFAULT setValue:nil forKey:[NSString stringWithFormat:@"isOnchosen_%@", objSelect.onChosen]];
                        [USER_DEFAULT setValue:nil forKey:[NSString stringWithFormat:@"isOnchosen_%d", countTagOfSelect]];
                        if ([objGr.name isEqualToString:objSelect.onChosen]) {
                            objGr.tagOfParent = countTagOfSelect;
                            objGr.classOfParrent = [SelectListView class];
                            [arrGroups addObject:objGr];
                            break;
                        }
                    }
                }
            }
            
            if ([[objForm.label lowercaseString] isEqualToString:@"status"]) {
                tagOFStatus = countTagOfSelect;
            }
            select.delegate = self;
            select.tag = countTagOfSelect;
            countTagOfSelect++;
            [scrollView addSubview:select];
            pointOfLastControl+=heightOfTextField*2+alignTop+alignBottom;
            
            ControlPosition *objPostion = [[ControlPosition alloc] init];
            objPostion.classOfControl = [SelectListView class];
            objPostion.tagOfControl = (int)select.tag;
            objPostion.yOfControl = select.frame.origin.y;
            objPostion.tagOfParrentControl = tagOfParrentControl;
            objPostion.label = objForm.label;
            objPostion.isEmpty = objForm.isEmpty;
            SelectObj *objSelect = objForm.select[0];
            objPostion.value = objSelect.text;
            [arrPostionControls addObject:objPostion];
        }else if ([objForm.type isEqualToString:@"signature"]){
            SignatureView *signature = [[SignatureView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*6+alignBottom) label:objForm.label alt:objForm.alt];
            signature.delegate = self;
            signature.tag = countTagOfSignature;
            countTagOfSignature++;
            [scrollView addSubview:signature];
            pointOfLastControl+= heightOfTextField*5+alignTop+alignBottom;
            
            ControlPosition *objPostion = [[ControlPosition alloc] init];
            objPostion.classOfControl = [SignatureView class];
            objPostion.tagOfControl = (int)signature.tag;
            objPostion.yOfControl = signature.frame.origin.y;
            objPostion.tagOfParrentControl = tagOfParrentControl;
            objPostion.label = objForm.label;
            objPostion.isEmpty = objForm.isEmpty;
            [arrPostionControls addObject:objPostion];
        }else if ([objForm.type isEqualToString:@"checkbox"]){
            RadioView *radio = [[RadioView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*2+alignBottom) label:objForm.label radio:objForm.radio];
            radio.delegate = self;
            radio.tag = countTagOfRadio;
            [USER_DEFAULT setValue:@"no" forKey:[NSString stringWithFormat:@"clickYes_%d", countTagOfRadio]];
            if (_objDetail.Group.count > 0) {
                for (GroupObj *objGr in _objDetail.Group) {
                    for (RadioObj *objRadio in objForm.radio) {
                        if ([objGr.name isEqualToString:objRadio.onChosen]) {
                            objGr.tagOfParent = countTagOfRadio;
                            objGr.classOfParrent = [RadioView class];
                            [arrGroups addObject:objGr];
                            break;
                        }
                    }
                }
            }
            
            countTagOfRadio++;
            [scrollView addSubview:radio];
            pointOfLastControl+=heightOfTextField*2+alignTop+alignBottom;
            
            ControlPosition *objPostion = [[ControlPosition alloc] init];
            objPostion.classOfControl = [RadioView class];
            objPostion.tagOfControl = (int)radio.tag;
            objPostion.yOfControl = radio.frame.origin.y;
            objPostion.tagOfParrentControl = tagOfParrentControl;
            objPostion.label = objForm.label;
            objPostion.isEmpty = objForm.isEmpty;
            RadioObj *obj1 = [objForm.radio objectAtIndex:0];
            RadioObj *obj2 = [objForm.radio objectAtIndex:1];
            objPostion.value = [NSString stringWithFormat:@"%@/%@",obj1.label, obj2.label];
            objPostion.stringOfRadio = [NSString stringWithFormat:@"%@/%@",obj1.label, obj2.label];
            if (obj2.onChosen.length > 0) {
                objPostion.value = [NSString stringWithFormat:@"%@/%@",obj2.label, obj1.label];
                objPostion.stringOfRadio = [NSString stringWithFormat:@"%@/%@",obj2.label, obj1.label];
            }
            
            [arrPostionControls addObject:objPostion];
        }else if ([objForm.type isEqualToString:@"barcode"]){
            QrCodeView *qrcode = [[QrCodeView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*2+alignBottom) label:objForm.label];
            qrcode.delegate = self;
            qrcode.tag = countTagOfQrCode;
            countTagOfQrCode++;
            [scrollView addSubview:qrcode];
            pointOfLastControl+=heightOfTextField*2+alignTop+alignBottom;
            
            ControlPosition *objPostion = [[ControlPosition alloc] init];
            objPostion.classOfControl = [QrCodeView class];
            objPostion.tagOfControl = (int)qrcode.tag;
            objPostion.yOfControl = qrcode.frame.origin.y;
            objPostion.tagOfParrentControl = tagOfParrentControl;
            objPostion.label = objForm.label;
            objPostion.isEmpty = objForm.isEmpty;
            [arrPostionControls addObject:objPostion];
        }
    }
    
}
-(void)sendAction{
    if ([Common connectedInternet]) {
        for (ControlPosition *obj in arrPostionControls) {
            NSLog(@"%@ - %@", obj.label, obj.value);
            if ([obj.classOfControl isEqual:[CameraView class]]){
                if ([obj.isEmpty isEqualToString:@"no"] && obj.image == nil) {
                    [Common showAlert:[NSString stringWithFormat:@"%@ cannot be empty", obj.label]];
                    return;
                }
            }else if ([obj.classOfControl isEqual:[SignatureView class]]){
                if ([obj.isEmpty isEqualToString:@"no"] && obj.image == nil) {
                    [Common showAlert:[NSString stringWithFormat:@"%@ cannot be empty", obj.label]];
                    return;
                }
            }else{
                if ([obj.isEmpty isEqualToString:@"no"] && obj.value.length == 0) {
                    [Common showAlert:[NSString stringWithFormat:@"%@ cannot be empty", obj.label]];
                    return;
                }
            }
        }
        
        for (ControlPosition *obj in arrPostionControls) {
            if ([obj.classOfControl isEqual:[CameraView class]]){
                if (obj.image != nil) {
                    //send image
                    ImageSendObj *o = [[ImageSendObj alloc] init];
                    o.name = obj.label;
                    o.image = obj.image;
                    [arrImageSend addObject:o];
                }
            }else if ([obj.classOfControl isEqual:[SignatureView class]]){
                if (obj.image != nil) {
                    //send image
                    ImageSendObj *o = [[ImageSendObj alloc] init];
                    o.name = obj.label;
                    o.image = obj.image;
                    [arrImageSend addObject:o];
                }
            }else{
                if (obj.value.length > 0) {
                    //insert to html
                    [self getContentEmail:obj.label value:obj.value classOfControl:obj.classOfControl tagOfParrent:obj.tagOfParrentControl];
                }
            }
        }
        subject = [NSString stringWithFormat:@"Ticket#%@ / %@ / %@", ticket, status, _objDetail.CompanyName];
        NSLog(@"Subject : %@", subject);
        [html appendFormat:@"<br/><br/><b>Nom du technicien</b> : %@", [USER_DEFAULT objectForKey:@"Name"]];
        [html appendFormat:@"<br/><br/>Thank You,<br/><br/>%@<br/><br/>", _objDetail.CompanyName];
        
        NSLog(@"%@", html);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Send_mail_success:) name:k_send_mail_success object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Send_mail_fail:) name:k_send_mail_fail object:nil];
        [MBProgressHUD showHUDAddedTo:self.view WithTitle:@"Progressing..." animated:YES];
        DataCenter *ws = [[DataCenter alloc] init];
        [ws send_mail:[USER_DEFAULT objectForKey:@"Name"] to:_objDetail.MailAddress cc:[USER_DEFAULT objectForKey:@"Email"] subject:subject content:html images:arrImageSend];
        //[ws send_mail:[USER_DEFAULT objectForKey:@"Name"] to:@"pmtam@sdc.ud.edu.vn" cc:@"nvngoc@sdc.ud.edu.vn" subject:subject content:html images:arrImageSend];
    }else{
        [Common showAlert:@"Please check internet connection"];
    }
    
}
-(void) Send_mail_success:(NSNotification*)notif{
    //NSDictionary *dic = notif.object;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_send_mail_success object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_send_mail_fail object:nil];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [Common showAlert:@"Email was sent successfully"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) Send_mail_fail:(NSNotification*)notif{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_send_mail_success object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_send_mail_fail object:nil];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [Common showAlert:@"Cannot send this email"];
}
-(void)cancelAction{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Are you sure you want to discard the changes?"delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    alert.delegate = self;
    [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        // handle the button click
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
}
-(void)drawViewsNOTAddSubviews : (NSMutableArray*)arrForms{
    for (FormObj *objForm in arrForms) {
        if ([objForm.type isEqualToString:@"textfield"]) {
            Textfield *tf = [[Textfield alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*2+alignBottom) label:objForm.label validate:objForm.validate isEmpty:objForm.isEmpty alt:objForm.alt];
            if (objForm.alt.length > 0) {
                tf = [[Textfield alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*3+alignBottom) label:objForm.label validate:objForm.validate isEmpty:objForm.isEmpty alt:objForm.alt];
                pointOfLastControl+=heightOfTextField*3+alignTop+alignBottom;
            }else{
                pointOfLastControl+=heightOfTextField*2+alignTop+alignBottom;
            }
        }else if ([objForm.type isEqualToString:@"timepicker"]){
            TimePickerView *timepic = [[TimePickerView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*2+alignBottom) label:objForm.label];
            pointOfLastControl+=heightOfTextField*2+alignTop+alignBottom;
            NSLog(@"%@", timepic.description);
        }else if ([objForm.type isEqualToString:@"text"]){
            TextLabel *textLabel = [[TextLabel alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField+alignBottom) label:objForm.label];
            pointOfLastControl+=heightOfTextField+alignTop+alignBottom;
            NSLog(@"%@", textLabel.description);
        }else if ([objForm.type isEqualToString:@"datepicker"]){
            DatePickerView *datepic = [[DatePickerView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*2+alignBottom) label:objForm.label];
            pointOfLastControl+=heightOfTextField*2+alignTop+alignBottom;
            NSLog(@"%@", datepic.description);
        }else if ([objForm.type isEqualToString:@"listview"]){
            ListView *list = [[ListView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*8+alignBottom) label:objForm.label arr:objForm.list];
            
            pointOfLastControl+= heightOfTextField*8+alignTop+alignBottom;
            NSLog(@"%@", list.description);
        }else if ([objForm.type isEqualToString:@"camera"]){
            CameraView *camera = [[CameraView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*5+alignBottom) label:objForm.label];
            pointOfLastControl+= heightOfTextField*5+alignTop+alignBottom;
            NSLog(@"%@", camera.description);
        }else if ([objForm.type isEqualToString:@"select"]){
            SelectListView *select = [[SelectListView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*2+alignBottom) label:objForm.label arr:objForm.select];
            pointOfLastControl+=heightOfTextField*2+alignTop+alignBottom;
            NSLog(@"%@", select.description);
        }else if ([objForm.type isEqualToString:@"signature"]){
            SignatureView *signature = [[SignatureView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*6+alignBottom) label:objForm.label alt:objForm.alt];
            pointOfLastControl+= heightOfTextField*5+alignTop+alignBottom;
            NSLog(@"%@", signature.description);
        }else if ([objForm.type isEqualToString:@"checkbox"]){
            RadioView *radio = [[RadioView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*2+alignBottom) label:objForm.label radio:objForm.radio];
            pointOfLastControl+=heightOfTextField*2+alignTop+alignBottom;
            NSLog(@"%@", radio.description);
        }else if ([objForm.type isEqualToString:@"barcode"]){
            QrCodeView *qrcode = [[QrCodeView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, widthOfScreen, heightOfTextField*2+alignBottom) label:objForm.label];
            pointOfLastControl+=heightOfTextField*2+alignTop+alignBottom;
            NSLog(@"%@", qrcode.description);
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"onReceiveImageFromCamScannar" object:nil];
}
- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat deltaHeight = kbSize.height - currentKeyboardHeight;
    // Write code to adjust views accordingly using deltaHeight
    currentKeyboardHeight = kbSize.height;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,pointOfLastControl+deltaHeight);
}
- (void)keyboardWillHide:(NSNotification*)notification {
    currentKeyboardHeight = 0.0f;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,pointOfLastControl+50);
    //[scrollView setContentOffset:CGPointMake(0, 0)];
}
- (void) changeScrView
{
    scrollView.bouncesZoom = YES;
    scrollView.clipsToBounds = YES;
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,pointOfLastControl+50);
    // Do any additional setup after loading the view from its nib.
    yContent = scrollView.contentSize.height;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self selfEndEdit];
}
-(void)selfEndEdit{
    [self.view endEditing:YES];
}
- (void)addGestureRecognizers {
    [[self view] addGestureRecognizer:[self panGestureRecognizer]];
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handlePan:)];
    return recognizer;
}

- (void) handlePan:(UIPanGestureRecognizer *)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        velocityF = [recognizer velocityInView:self.view];
        velocityL = [recognizer velocityInView:self.view];
    }else if(recognizer.state == UIGestureRecognizerStateEnded) {
        velocityL = [recognizer velocityInView:self.view];
        
        if(velocityL.x > velocityF.x + 200)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Are you sure you want to discard the changes?"delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alert show];
            alert.delegate = self;
            [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                // handle the button click
                if (buttonIndex == 0) {
                    
                }else if (buttonIndex == 1){
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
/*---------------TextField--------------*/
-(NSString*)getText:(UITextField *)textfield view:(UIView *)view{
    if (view.tag == 0) {
        ticket = textfield.text;
    }
    for (int i = 0;i<arrPostionControls.count;i++) {
        ControlPosition *obj = [arrPostionControls objectAtIndex:i];
        if ([obj.classOfControl isEqual:[Textfield class]] && obj.tagOfControl == (int)view.tag) {
            obj.value = textfield.text;
            break;
        }
    }
    return textfield.text;
}
/*---------------TimePicker--------------*/
-(void)clickSet:(NSString *)time view:(UIView *)view{
    for (int i = 0;i<arrPostionControls.count;i++) {
        ControlPosition *obj = [arrPostionControls objectAtIndex:i];
        if ([obj.classOfControl isEqual:[TimePickerView class]] && obj.tagOfControl == (int)view.tag) {
            obj.value = time;
            break;
        }
    }
}
/*---------------DatePicker--------------*/
-(void)clickSetDate:(NSString *)time view:(UIView *)view{
    for (int i = 0;i<arrPostionControls.count;i++) {
        ControlPosition *obj = [arrPostionControls objectAtIndex:i];
        if ([obj.classOfControl isEqual:[DatePickerView class]] && obj.tagOfControl == (int)view.tag) {
            obj.value = time;
            break;
        }
    }
}
/*---------------ListView--------------*/
-(void)AddItem:(NSMutableArray *)arr view:(UIView *)view{
    NSMutableString *str = [NSMutableString stringWithFormat:@""];
    for (int i = 0 ; i < arr.count;i++) {
        ItemObj *obj = [arr objectAtIndex:i];
        [str appendFormat:@"&nbsp;&nbsp;<br/>%d.",i+1];
        for (NSString *s in obj.arrText) {
            [str appendFormat:@"%@<br/>&nbsp;&nbsp;&nbsp;", s];
        }
    }
    for (int i = 0;i<arrPostionControls.count;i++) {
        ControlPosition *obj = [arrPostionControls objectAtIndex:i];
        if ([obj.classOfControl isEqual:[ListView class]] && obj.tagOfControl == (int)view.tag) {
            obj.value = str;
            break;
        }
    }
}
/*---------------Camera--------------*/
-(void)openGellary:(UIView *)view{
    tagOFImage = (int)view.tag;
    [self ShouldStartPhotoLibrary];
}
-(void)openCamera:(UIView *)view{
    tagOFImage = (int)view.tag;
    [self ShouldStartCamera];
}

-(void)setCamScannerImage: (UIImage *)image{
    //Will set cam scanner image for submit
    for (int i = 0;i<arrPostionControls.count;i++) {
        ControlPosition *obj = [arrPostionControls objectAtIndex:i];
        if ([obj.classOfControl isEqual:[CameraView class]] && obj.tagOfControl == tagOFImage) {
            obj.image = image;
            break;
        }
    }

}

-(void) ShouldStartCamera{
    UIImagePickerController * cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    cameraUI.videoQuality = UIImagePickerControllerQualityTypeHigh;
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return;
}


-(void) ShouldStartPhotoLibrary{
    UIImagePickerController * cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    cameraUI.videoQuality = UIImagePickerControllerQualityTypeHigh;
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return;
}
- (CameraView*)getCurrentCamView
{
    CameraView *cameraView = nil;
    for (id tempView in scrollView.subviews)
    {
        //cameraView = [scrollView viewWithTag:obj.tagOfControl];
        if([tempView isKindOfClass:[CameraView class]])
        {
            cameraView = (CameraView*)tempView;
            if(cameraView.tag == tagOFImage)
            {
                return cameraView;
            }
        }
    }
    return nil;
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];//[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    for (int i = 0;i<arrPostionControls.count;i++) {
        ControlPosition *obj = [arrPostionControls objectAtIndex:i];
        if ([obj.classOfControl isEqual:[CameraView class]] && obj.tagOfControl == tagOFImage) {
            obj.image = image;
            break;
        }
    }
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HaveImage" object:image userInfo:info];
    //[picker dismissViewControllerAnimated:YES completion:nil];
    
    
    //MTPL
    CameraView *cameraView = [self getCurrentCamView];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSArray *applications = [CamScannerOpenAPIController availableApplications];
        
        BOOL canDo = [CamScannerOpenAPIController canOpenCamScannerHD];
        NSMutableArray *appNames = [[NSMutableArray alloc] init];
        for (NSString *application in applications)
        {
            NSString *appName = [self appName:application];
            if ([appName length] > 0)
            {
                [appNames addObject:appName];
            }
        }
        if ([applications count] > 0)
        {
            ISBlockActionSheet *actionSheet = [[ISBlockActionSheet alloc] initWithTitle:@"Choose application" cancelButtonTitle:@"Cancel" cancelBlock:^{
                
            } destructiveButtonTitle:nil destructiveBlock:^{
                
            } otherButtonTitles:appNames otherButtonBlock:^(NSInteger index) {
                NSLog(@"App selected");
                [[NSNotificationCenter defaultCenter] addObserver:cameraView selector:@selector(getImageSuccess:) name:@"HaveImage" object:nil];
                [CamScannerOpenAPIController sendImage:image toTargetApplication:[applications objectAtIndex:index] appKey:AppKey subAppKey:nil];
            }];
            [actionSheet showInView:self.view];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"You should install CamScanner First" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
    }];
}

- (NSString *) appName:(NSString *) inputName
{
    if ([inputName isEqualToString:CamScannerLite])
    {
        return @"CamScanner Free";
    }
    if ([inputName isEqualToString:CamScanner])
    {
        return @"CamScanner+";
    }
    if ([inputName isEqualToString:CamScannerPro])
    {
        return @"CamScanner Pro";
    }
    if ([inputName isEqualToString:CamScannerHD])
    {
        return @"CamScanner HD";
    }
    if ([inputName isEqualToString:CamScannerHDPro])
    {
        return @"CamScanner HD Pro";
    }
    return nil;
}

-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/*---------------SelectListView--------------*/
-(void)getSelected:(NSString *)selected onChosen:(NSString *)onChosen view:(UIView *)view{
    if ((int)view.tag == tagOFStatus) {
        status = selected;
    }
    for (int i = 0;i<arrPostionControls.count;i++) {
        ControlPosition *obj = [arrPostionControls objectAtIndex:i];
        if ([obj.classOfControl isEqual:[SelectListView class]] && obj.tagOfControl == (int)view.tag) {
            obj.value = selected;
            break;
        }
    }
    BOOL isOnchosen = NO;
    float dis = pointOfLastControl;
    int indexControlStart = 0;
    for (GroupObj *objGroup in arrGroups) {
        if ([onChosen isEqualToString:objGroup.name]) {
            
            if (![[USER_DEFAULT objectForKey:[NSString stringWithFormat:@"isOnchosen_%d", (int)view.tag]] isEqualToString:onChosen]) {
                
                NSMutableArray *arrDelete = [[NSMutableArray alloc] init];
                int indexControlStart = 0;
                float HeightTotal = 0.0;
                for (int i = 0;i<arrPostionControls.count;i++) {
                    ControlPosition *obj = [arrPostionControls objectAtIndex:i];
                    if ([obj.classOfControl isEqual:[SelectListView class]] && obj.tagOfControl == (int)view.tag) {
                        for (int j = i+1; j < arrPostionControls.count; j++) {
                            ControlPosition *ob = [arrPostionControls objectAtIndex:j];
                            if (ob.tagOfParrentControl != -1) {
                                for (UIView *subview in scrollView.subviews) {
                                    if ([subview isKindOfClass:ob.classOfControl] && (int)subview.tag == ob.tagOfControl) {
                                        if ([subview isKindOfClass:[SelectListView class]]){
                                            countTagOfRadio--;
                                        }
                                        HeightTotal+= subview.frame.size.height+alignTop;
                                        [subview removeFromSuperview];
                                        [arrDelete addObject:ob];
                                        break;
                                    }
                                }
                            }else{
                                indexControlStart = j;
                                break;
                            }
                        }
                        break;
                    }
                }
                
                
                [arrPostionControls removeObjectsInArray:arrDelete];
                for (int j = indexControlStart-(int)arrDelete.count; j < arrPostionControls.count; j++) {
                    ControlPosition *ob = [arrPostionControls objectAtIndex:j];
                    for (UIView *subview in scrollView.subviews) {
                        if ([subview isKindOfClass:ob.classOfControl] && (int)subview.tag == ob.tagOfControl) {
                            CGRect fram = subview.frame;
                            fram.origin.y -= HeightTotal;
                            ob.yOfControl = fram.origin.y;
                            [subview setFrame:fram];
                            break;
                        }
                    }
                }
                pointOfLastControl -= HeightTotal;
                [self changeScrView];
                CGRect frSend = btSend.frame;
                frSend.origin.y = pointOfLastControl;
                [btSend setFrame:frSend];
                CGRect frCancel = btCancel.frame;
                frCancel.origin.y = pointOfLastControl;
                [btCancel setFrame:frCancel];
                
                
                
                [USER_DEFAULT setValue:nil forKey:[NSString stringWithFormat:@"isOnchosen_%@", [USER_DEFAULT objectForKey:[NSString stringWithFormat:@"isOnchosen_%d", (int)view.tag]]]];
                [USER_DEFAULT setValue:nil forKey:[NSString stringWithFormat:@"isOnchosen_%d", (int)view.tag]];
                
            }
            dis = pointOfLastControl;
            if (![[USER_DEFAULT objectForKey:[NSString stringWithFormat:@"isOnchosen_%@", onChosen]] isEqualToString:@"yes"] && objGroup.forms.count >0) {
                isOnchosen = YES;
                [USER_DEFAULT setValue:@"yes" forKey:[NSString stringWithFormat:@"isOnchosen_%@", onChosen]];
                [USER_DEFAULT setValue:onChosen forKey:[NSString stringWithFormat:@"isOnchosen_%d", (int)view.tag]];
                
                if (objGroup.tagOfParent == (int)view.tag && ([objGroup.classOfParrent isEqual:[RadioView class]]||[objGroup.classOfParrent isEqual:[SelectListView class]])) {
                    pointOfLastControl = view.frame.origin.y+view.frame.size.height;
                    [self drawViewsNOTAddSubviews:objGroup.forms];
                    
                    distanceControls = pointOfLastControl-view.frame.origin.y-view.frame.size.height;
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    for (int i = 0;i<arrPostionControls.count;i++) {
                        ControlPosition *obj = [arrPostionControls objectAtIndex:i];
                        if ([obj.classOfControl isEqual:[SelectListView class]] && obj.tagOfControl == (int)view.tag) {
                            for (int j = i+1; j < arrPostionControls.count; j++) {
                                ControlPosition *ob = [arrPostionControls objectAtIndex:j];
                                ob.yOfControl += distanceControls;
                                [arr addObject:ob];
                            }
                            break;
                        }
                    }
                    [arrPostionControls removeObjectsInArray:arr];
                    
                    pointOfLastControl = view.frame.origin.y+view.frame.size.height;
                    [self drawViews:objGroup.forms tagOfParrentControl:objGroup.tagOfParent];
                    
                    indexControlStart = (int)arrPostionControls.count;
                    [arrPostionControls addObjectsFromArray:arr];
                    for (int j = indexControlStart; j < arrPostionControls.count; j++) {
                        ControlPosition *ob = [arrPostionControls objectAtIndex:j];
                        for (UIView *subview in scrollView.subviews) {
                            if ([subview isKindOfClass:ob.classOfControl] && (int)subview.tag == ob.tagOfControl) {
                                CGRect fram = subview.frame;
                                fram.origin.y = ob.yOfControl;
                                [subview setFrame:fram];
                                break;
                            }
                        }
                    }
                    pointOfLastControl = dis+distanceControls;
                    [self changeScrView];
                    break;
                }
            }else{
                
            }
        }
    }
    
    if (isOnchosen) {
        NSLog(@"->>>>>>>>>>Ve thoi");
        CGRect frSend = btSend.frame;
        frSend.origin.y = pointOfLastControl;
        [btSend setFrame:frSend];
        CGRect frCancel = btCancel.frame;
        frCancel.origin.y = pointOfLastControl;
        [btCancel setFrame:frCancel];
        
        
    }else{
        if (![[USER_DEFAULT objectForKey:[NSString stringWithFormat:@"isOnchosen_%d", (int)view.tag]] isEqualToString:onChosen]) {
            
            NSMutableArray *arrDelete = [[NSMutableArray alloc] init];
            int indexControlStart = 0;
            float HeightTotal = 0.0;
            for (int i = 0;i<arrPostionControls.count;i++) {
                ControlPosition *obj = [arrPostionControls objectAtIndex:i];
                if ([obj.classOfControl isEqual:[SelectListView class]] && obj.tagOfControl == (int)view.tag) {
                    for (int j = i+1; j < arrPostionControls.count; j++) {
                        ControlPosition *ob = [arrPostionControls objectAtIndex:j];
                        if (ob.tagOfParrentControl != -1) {
                            for (UIView *subview in scrollView.subviews) {
                                if ([subview isKindOfClass:ob.classOfControl] && (int)subview.tag == ob.tagOfControl) {
                                    if ([subview isKindOfClass:[SelectListView class]]){
                                        countTagOfRadio--;
                                    }
                                    HeightTotal+= subview.frame.size.height+alignTop;
                                    [subview removeFromSuperview];
                                    [arrDelete addObject:ob];
                                    break;
                                }
                            }
                        }else{
                            indexControlStart = j;
                            break;
                        }
                    }
                    break;
                }
            }
            
            
            [arrPostionControls removeObjectsInArray:arrDelete];
            for (int j = indexControlStart-(int)arrDelete.count; j < arrPostionControls.count; j++) {
                ControlPosition *ob = [arrPostionControls objectAtIndex:j];
                for (UIView *subview in scrollView.subviews) {
                    if ([subview isKindOfClass:ob.classOfControl] && (int)subview.tag == ob.tagOfControl) {
                        CGRect fram = subview.frame;
                        fram.origin.y -= HeightTotal;
                        ob.yOfControl = fram.origin.y;
                        [subview setFrame:fram];
                        break;
                    }
                }
            }
            pointOfLastControl -= HeightTotal;
            [self changeScrView];
            CGRect frSend = btSend.frame;
            frSend.origin.y = pointOfLastControl;
            [btSend setFrame:frSend];
            CGRect frCancel = btCancel.frame;
            frCancel.origin.y = pointOfLastControl;
            [btCancel setFrame:frCancel];
            
            
            
            [USER_DEFAULT setValue:nil forKey:[NSString stringWithFormat:@"isOnchosen_%@", [USER_DEFAULT objectForKey:[NSString stringWithFormat:@"isOnchosen_%d", (int)view.tag]]]];
            [USER_DEFAULT setValue:nil forKey:[NSString stringWithFormat:@"isOnchosen_%d", (int)view.tag]];
            
        }
    }
}

/*---------------SignatuteView--------------*/
-(void)getSignature:(UIImage *)image view:(UIView *)view{
    for (int i = 0;i<arrPostionControls.count;i++) {
        ControlPosition *obj = [arrPostionControls objectAtIndex:i];
        if ([obj.classOfControl isEqual:[SignatureView class]] && obj.tagOfControl == (int)view.tag) {
            obj.image = image;
            break;
        }
    }
}
/*---------------RadioView--------------*/
-(void)clickYes:(UIView *)view{
    if (![[USER_DEFAULT objectForKey:[NSString stringWithFormat:@"clickYes_%d", (int)view.tag]] isEqualToString:@"yes"]) {
        //        for (ControlPosition *obj in arrPostionControls) {
        //            NSLog(@"---------%@ - %d - %f ->>>> %d", obj.classOfControl, obj.tagOfControl, obj.yOfControl, obj.tagOfParrentControl);
        //        }
        float dis = pointOfLastControl;
        int indexControlStart = 0;
        for (GroupObj *objGroup in arrGroups) {
            if (objGroup.tagOfParent == (int)view.tag && [objGroup.classOfParrent isEqual:[RadioView class]]) {
                pointOfLastControl = view.frame.origin.y+view.frame.size.height;
                [self drawViewsNOTAddSubviews:objGroup.forms];
                
                distanceControls = pointOfLastControl-view.frame.origin.y-view.frame.size.height;
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (int i = 0;i<arrPostionControls.count;i++) {
                    ControlPosition *obj = [arrPostionControls objectAtIndex:i];
                    if ([obj.classOfControl isEqual:[RadioView class]] && obj.tagOfControl == (int)view.tag) {
                        for (int j = i+1; j < arrPostionControls.count; j++) {
                            ControlPosition *ob = [arrPostionControls objectAtIndex:j];
                            ob.yOfControl += distanceControls;
                            [arr addObject:ob];
                        }
                        break;
                    }
                }
                [arrPostionControls removeObjectsInArray:arr];
                for (GroupObj *objGroup in arrGroups) {
                    if (objGroup.tagOfParent == (int)view.tag && [objGroup.classOfParrent isEqual:[RadioView class]]) {
                        pointOfLastControl = view.frame.origin.y+view.frame.size.height;
                        [self drawViews:objGroup.forms tagOfParrentControl:objGroup.tagOfParent];
                        break;
                    }
                }
                indexControlStart = (int)arrPostionControls.count;
                [arrPostionControls addObjectsFromArray:arr];
                for (int j = indexControlStart; j < arrPostionControls.count; j++) {
                    ControlPosition *ob = [arrPostionControls objectAtIndex:j];
                    for (UIView *subview in scrollView.subviews) {
                        if ([subview isKindOfClass:ob.classOfControl] && (int)subview.tag == ob.tagOfControl) {
                            CGRect fram = subview.frame;
                            fram.origin.y = ob.yOfControl;
                            [subview setFrame:fram];
                            break;
                        }
                    }
                }
                pointOfLastControl = dis+distanceControls;
                [self changeScrView];
                break;
            }
        }
        
        CGRect frSend = btSend.frame;
        frSend.origin.y = pointOfLastControl;
        [btSend setFrame:frSend];
        CGRect frCancel = btCancel.frame;
        frCancel.origin.y = pointOfLastControl;
        [btCancel setFrame:frCancel];
        
        
        [USER_DEFAULT setValue:@"yes" forKey:[NSString stringWithFormat:@"clickYes_%d", (int)view.tag]];
    }
    for (int i = 0;i<arrPostionControls.count;i++) {
        ControlPosition *obj = [arrPostionControls objectAtIndex:i];
        if ([obj.classOfControl isEqual:[RadioView class]] && obj.tagOfControl == (int)view.tag) {
            NSRange range = [obj.stringOfRadio rangeOfString:@"/"];
            obj.value = [obj.stringOfRadio substringToIndex:range.location];
            break;
        }
    }
}
-(void)clickNo:(UIView *)view{
    if (![[USER_DEFAULT objectForKey:[NSString stringWithFormat:@"clickYes_%d", (int)view.tag]] isEqualToString:@"no"]) {
        NSMutableArray *arrDelete = [[NSMutableArray alloc] init];
        int indexControlStart = 0;
        float HeightTotal = 0.0;
        for (int i = 0;i<arrPostionControls.count;i++) {
            ControlPosition *obj = [arrPostionControls objectAtIndex:i];
            if ([obj.classOfControl isEqual:[RadioView class]] && obj.tagOfControl == (int)view.tag) {
                for (int j = i+1; j < arrPostionControls.count; j++) {
                    ControlPosition *ob = [arrPostionControls objectAtIndex:j];
                    if (ob.tagOfParrentControl != -1) {
                        for (UIView *subview in scrollView.subviews) {
                            if ([subview isKindOfClass:ob.classOfControl] && (int)subview.tag == ob.tagOfControl) {
                                if ([subview isKindOfClass:[RadioView class]]){
                                    countTagOfRadio--;
                                }
                                HeightTotal+= subview.frame.size.height+alignTop;
                                [subview removeFromSuperview];
                                [arrDelete addObject:ob];
                                break;
                            }
                        }
                    }else{
                        indexControlStart = j;
                        break;
                    }
                }
                break;
            }
        }
        
        
        [arrPostionControls removeObjectsInArray:arrDelete];
        for (int j = indexControlStart-(int)arrDelete.count; j < arrPostionControls.count; j++) {
            ControlPosition *ob = [arrPostionControls objectAtIndex:j];
            for (UIView *subview in scrollView.subviews) {
                if ([subview isKindOfClass:ob.classOfControl] && (int)subview.tag == ob.tagOfControl) {
                    CGRect fram = subview.frame;
                    fram.origin.y -= HeightTotal;
                    ob.yOfControl = fram.origin.y;
                    [subview setFrame:fram];
                    break;
                }
            }
        }
        
        pointOfLastControl -= HeightTotal;
        [self changeScrView];
        
        CGRect frSend = btSend.frame;
        frSend.origin.y = pointOfLastControl;
        [btSend setFrame:frSend];
        CGRect frCancel = btCancel.frame;
        frCancel.origin.y = pointOfLastControl;
        [btCancel setFrame:frCancel];
        
        
        for (int i = 0;i<arrPostionControls.count;i++) {
            ControlPosition *obj = [arrPostionControls objectAtIndex:i];
            if ([obj.classOfControl isEqual:[RadioView class]] && obj.tagOfControl == (int)view.tag) {
                NSRange range = [obj.stringOfRadio rangeOfString:@"/"];
                obj.value = [obj.stringOfRadio substringFromIndex:range.location];
                break;
            }
        }
        
        
        [USER_DEFAULT setValue:@"no" forKey:[NSString stringWithFormat:@"clickYes_%d", (int)view.tag]];
    }
}
/*---------------QrCodeView--------------*/
-(void)getTextScan:(NSString *)text view:(UIView *)view{
    for (int i = 0;i<arrPostionControls.count;i++) {
        ControlPosition *obj = [arrPostionControls objectAtIndex:i];
        if ([obj.classOfControl isEqual:[QrCodeView class]] && obj.tagOfControl == (int)view.tag) {
            obj.value = text;
            break;
        }
    }
}
- (IBAction)clickBack:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Are you sure you want to discard the changes?"delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    alert.delegate = self;
    [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        // handle the button click
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
}
-(void)getContentEmail:(NSString*)title value:(NSString*)value classOfControl:(id)classOfControlpe tagOfParrent:(int)tagOfParrent{
    if (tagOfParrent > -1) {
        if ([classOfControlpe isEqual:[RadioView class]]) {
            if ([value rangeOfString:@"/"].location != NSNotFound) {
                NSRange range = [value rangeOfString:@"/"];
                value = [value substringFromIndex:range.location];
            }
            [html appendFormat:@"&nbsp;<b>%@</b> : %@<br/>",title, value];
        }else [html appendFormat:@"&nbsp;%@ : %@<br/>",title, value];
    }else{
        if ([classOfControlpe isEqual:[TextLabel class]]) {
            [html appendFormat:@"<b>%@</b><br/>",title];
        }else
        {
            if ([classOfControlpe isEqual:[ListView class]]) [html appendFormat:@"<br/>"];
            [html appendFormat:@"<b>%@</b> : %@<br/>",title, value];
        }
    }
    
}

@end
