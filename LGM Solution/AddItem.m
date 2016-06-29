//
//  TimePicker.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/6/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "AddItem.h"
#import "Define.h"
#import "FormObj.h"
#import "Common.h"
#import "ControlPosition.h"

@implementation AddItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)showInView:(UIView*) superView
{
    UIView *view = [[UIView alloc] initWithFrame:superView.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [view addSubview:self];
    //    [superView addSubview:view];
    id appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    [window addSubview:view];
    view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    self.center = CGPointMake(superView.center.x, superView.center.y+12);
    view.frame = window.frame;
    view.center = window.center;
    view.alpha = 0;
    
    [UIView beginAnimations:nil context:nil];
    
    view.alpha = 1.0;
    
    [UIView commitAnimations];
    
    self.maskView = view;
    
    frame = viewParent.frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    arrText = [[NSMutableArray alloc] init];
    arrPostionControls = [[NSMutableArray alloc] init];
    countTagOfTextview = 0;
    float width = self.frame.size.width;
    for (FormObj *objForm in _arrForms) {
        if ([objForm.type isEqualToString:@"textfield"]) {
            Textfield *tf = [[Textfield alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, width, heightOfTextField*2+alignBottom) label:objForm.label validate:objForm.validate isEmpty:objForm.isEmpty alt:objForm.alt];
            if (objForm.alt.length > 0) {
                tf = [[Textfield alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, width, heightOfTextField*3+alignBottom) label:objForm.label validate:objForm.validate isEmpty:objForm.isEmpty alt:objForm.alt];
                pointOfLastControl+=heightOfTextField*3+alignTop+alignBottom;
            }else{
                pointOfLastControl+=heightOfTextField*2+alignTop+alignBottom;
            }
            if ([objForm.validate isEqualToString:@"integer"]) {
                [tf.tf setKeyboardType:UIKeyboardTypeNumberPad];
            }else if ([objForm.validate isEqualToString:@"Decimal"]){
                [tf.tf setKeyboardType:UIKeyboardTypeDecimalPad];
            }
            tf.tag = countTagOfTextview;
            countTagOfTextview++;
            tf.delegate = self;
            [viewParent addSubview:tf];
            [arrText addObject:[NSString stringWithFormat:@"<b>%@</b> : ", objForm.label]];
            
            ControlPosition *objPostion = [[ControlPosition alloc] init];
            objPostion.classOfControl = [Textfield class];
            objPostion.tagOfControl = (int)tf.tag;
            objPostion.yOfControl = tf.frame.origin.y;
            objPostion.tagOfParrentControl = 0;
            objPostion.label = objForm.label;
            objPostion.isEmpty = objForm.isEmpty;
            [arrPostionControls addObject:objPostion];
            
        }else if ([objForm.type isEqualToString:@"barcode"]){
            QrCodeView *qrcode = [[QrCodeView alloc] initWithRect:CGRectMake(0, pointOfLastControl+alignTop, width, heightOfTextField*2+alignBottom) label:objForm.label];
            qrcode.delegate = self;
            qrcode.tag = countTagOfTextview;
            countTagOfTextview++;
            [viewParent addSubview:qrcode];
            pointOfLastControl+=heightOfTextField*2+alignTop+alignBottom;
            CGRect fr = viewParent.frame;
            fr.size.height +=heightOfTextField*2+alignBottom;
            viewParent.frame = fr;
            [arrText addObject:[NSString stringWithFormat:@"<b>%@</b> : ", objForm.label]];
            
            ControlPosition *objPostion = [[ControlPosition alloc] init];
            objPostion.classOfControl = [QrCodeView class];
            objPostion.tagOfControl = (int)qrcode.tag;
            objPostion.yOfControl = qrcode.frame.origin.y;
            objPostion.tagOfParrentControl = 0;
            objPostion.label = objForm.label;
            objPostion.isEmpty = objForm.isEmpty;
            [arrPostionControls addObject:objPostion];
        }
    }
    [self changeScrView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfEndEdit)];
    tapGesture.delegate = self;
    [scrollview setCanCancelContentTouches:YES];
    [scrollview addGestureRecognizer:tapGesture];
    
}
-(void)selfEndEdit{
    [self.superview endEditing:YES];
}
- (void) changeScrView
{
    scrollview.bouncesZoom = YES;
    scrollview.clipsToBounds = YES;
    
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width,pointOfLastControl+100);
}
- (void)hide
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [UIView animateWithDuration:0.3 animations:^{
        _maskView.alpha = 0;
    } completion:^(BOOL finished)
     {
         [_maskView removeFromSuperview];
         [self removeFromSuperview];
     }];
}

- (IBAction)clickOK:(id)sender {
    [self.superview endEditing:YES];
    /*if ([obj1.isEmpty isEqualToString:@"no"] && [Common trimString:tf1.text].length == 0) {
        [Common showAlert:[NSString stringWithFormat:@"%@ cannot be empty", obj1.label]];
        return;
    }else text1 = [Common trimString:tf1.text];
    if ([obj2.isEmpty isEqualToString:@"no"] && [Common trimString:tf2.text].length == 0) {
        [Common showAlert:[NSString stringWithFormat:@"%@ cannot be empty", obj2.label]];
        return;
    }else text2 = [Common trimString:tf2.text];
    if ([obj3.isEmpty isEqualToString:@"no"] && [Common trimString:tf3.text].length == 0) {
        [Common showAlert:[NSString stringWithFormat:@"%@ cannot be empty", obj3.label]];
        return;
    }else text3 = [Common trimString:tf3.text];
    [self hide];
    [_delegate clickOK:text1 text2:text2 text3:text3];*/
    for (ControlPosition *obj in arrPostionControls) {
        if (obj.isEmpty != nil && [obj.isEmpty isEqualToString:@"no"] && obj.value.length == 0) {
            [Common showAlert:[NSString stringWithFormat:@"%@ cannot be empty", obj.label]];
            return;
        }
    }
    
    [_delegate clickOK:arrText];
    [self hide];
}

- (IBAction)clickCancel:(id)sender {
    [self.superview endEditing:YES];
    [self hide];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.superview endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    /*CGRect fr = viewParent.frame;
    fr.origin.y -= 100;
    [viewParent setFrame:fr];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];*/
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width,pointOfLastControl+350);
}
- (void)keyboardWillHide:(NSNotification*)notification {
//    [viewParent setFrame:frame];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width,pointOfLastControl+100);
}

-(NSString*)getText:(UITextField *)textfield view:(UIView *)view{
    int tag = (int)view.tag;
    FormObj *objForm = [_arrForms objectAtIndex:tag];
    NSMutableString *html = [NSMutableString stringWithString: [NSString stringWithFormat:@"<b>%@</b> : %@", objForm.label, textfield.text]];
    if ([objForm.type isEqualToString:@"textfield"]) {
        if ([objForm.validate isEqualToString:@"Decimal"]){
            if ([[textfield.text substringFromIndex:textfield.text.length-1] isEqualToString:@"."]) {
                html = [NSMutableString stringWithString: [NSString stringWithFormat:@"<b>%@</b> : %@0", objForm.label, textfield.text]];
            }
        }
    }
    arrText[tag] = html;
    for (int i = 0;i<arrPostionControls.count;i++) {
        ControlPosition *obj = [arrPostionControls objectAtIndex:i];
        if ([obj.classOfControl isEqual:[Textfield class]] && obj.tagOfControl == (int)view.tag) {
            obj.value = textfield.text;
            break;
        }
    }
    return @"";
}
-(void)getTextScan:(NSString *)text view:(UIView *)view{
    int tag = (int)view.tag;
    FormObj *objForm = [_arrForms objectAtIndex:tag];
    NSMutableString *html = [NSMutableString stringWithString: [NSString stringWithFormat:@"<b>%@</b> : %@", objForm.label, text]];
    arrText[tag] = html;
    for (int i = 0;i<arrPostionControls.count;i++) {
        ControlPosition *obj = [arrPostionControls objectAtIndex:i];
        if ([obj.classOfControl isEqual:[QrCodeView class]] && obj.tagOfControl == (int)view.tag) {
            obj.value = text;
            break;
        }
    }
}
@end
