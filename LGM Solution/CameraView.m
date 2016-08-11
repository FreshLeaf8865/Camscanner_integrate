//
//  CameraView.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/7/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "CameraView.h"
#import "Define.h"

@implementation CameraView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithRect:(CGRect)rect label:(NSString*)label{
    if (self = [super initWithFrame:rect]){
        [self setFrame:rect];
        [self setBackgroundColor:[UIColor whiteColor]];
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(alignLeft, 0, rect.size.width-2*alignLeft, heightOfTextField)];
        [lb setText:label];
        
        UIFont *font = lb.font;
        UIFontDescriptor * fontD = [font.fontDescriptor
                                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        font = [UIFont fontWithDescriptor:fontD size:15];
        [lb setFont:font];
        [lb setTextColor:colorLabel];
        [self addSubview:lb];
        
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(alignLeft, lb.frame.origin.y+lb.frame.size.height+alignTop/2, 90, heightOfTextField)];
        [bt setTitle:@"Camera" forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bt setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
        [bt addTarget:self  action:@selector(myCamera) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        
        UIButton *bt2 = [[UIButton alloc] initWithFrame:CGRectMake(alignLeft, bt.frame.origin.y+90-alignTop, 90, heightOfTextField)];
        [bt2 setTitle:@"Gallery" forState:UIControlStateNormal];
        [bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bt2 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
        [bt2 addTarget:self  action:@selector(myGellary) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt2];
        
        image = [[UIImageView alloc] initWithFrame:CGRectMake(bt.frame.size.width+alignLeft+20, bt.frame.origin.y-alignTop/2, 180, 120)];
        image.image = [UIImage imageNamed:@"default.png"];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:image];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(2*alignLeft, image.frame.origin.y+image.frame.size.height + alignBottom*2, rect.size.width-4*alignLeft, 1.5)];
        [line setBackgroundColor:[UIColor blueColor]];
        [line setAlpha:0.5];
        [self addSubview:line];
    }
    return  self;
}
-(void)myCamera{
    [self.superview endEditing:YES];
    [_delegate openCamera:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageSuccess:) name:@"HaveImage" object:nil];
}
-(void)myGellary{
    [self.superview endEditing:YES];
    [_delegate openGellary:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageSuccess:) name:@"HaveImage" object:nil];
}
-(void) getImageSuccess:(NSNotification*)notif{
    UIImage *img = notif.object;
    [image setImage:img];
    ////MTPL
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HaveImage" object:nil];
}
@end
