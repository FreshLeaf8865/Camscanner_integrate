//
//  LoginVc.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 4/24/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController<UITextFieldDelegate>{
    
    __weak IBOutlet UITextField *tf_Username;
    __weak IBOutlet UITextField *tf_Password;
    NSTimer *timer;
    int count;
    __weak IBOutlet UIScrollView *scrView;
}

- (IBAction)clickLogin:(id)sender;
@end
