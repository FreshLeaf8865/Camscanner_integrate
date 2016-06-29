//
//  RadioView.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/8/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioViewDelegate.h"

@interface RadioView : UIView{
    UIButton *btYes;
    UIButton *btNo;
}
-(id)initWithRect:(CGRect)rect label:(NSString*)label radio:(NSMutableArray*)radio;
@property (nonatomic, retain) id<RadioViewDelegate> delegate;
@end
