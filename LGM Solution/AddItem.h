//
//  TimePicker.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/6/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddItemDelegate.h"
#import "FormObj.h"
#import "Textfield.h"
#import "QrCodeView.h"

@interface AddItem : UIView<UITextFieldDelegate, TextfieldDelegate, UIGestureRecognizerDelegate, QrCodeViewDelegate>{
    
    NSString *text1;
    NSString *text2;
    NSString *text3;
    __weak IBOutlet UIView *viewParent;
    CGRect frame;
    CGFloat pointOfLastControl;
    int countTagOfTextview;
    __weak IBOutlet UIButton *btOK;
    __weak IBOutlet UIButton *btCancel;
    NSMutableArray *arrText;
    __weak IBOutlet UIScrollView *scrollview;
    NSMutableArray *arrPostionControls;
}
@property (nonatomic, retain) UIView *maskView;
@property (nonatomic, retain) id<AddItemDelegate> delegate;
@property (nonatomic , assign) BOOL isFromHome;
- (void) showInView:(UIView*) superView;
- (void) hide;
- (IBAction)clickOK:(id)sender;
- (IBAction)clickCancel:(id)sender;

@property (nonatomic, retain) NSMutableArray *arrForms;

@end
