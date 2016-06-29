//
//  SelectListView.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/7/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "SelectListView.h"
#import "Define.h"
#import "ActionSheetPicker.h"
#import "SelectObj.h"


@implementation SelectListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithRect:(CGRect)rect label:(NSString*)label arr:(NSMutableArray *)arr{
    if (self = [super initWithFrame:rect]){
        [self setFrame:rect];
        [self setBackgroundColor:[UIColor whiteColor]];
        lbel = label;
        indexSelected = 0;
        NSMutableArray *ar = [[NSMutableArray alloc] init];
        arrOnchoose = [[NSMutableArray alloc] initWithArray:arr];
        for (SelectObj *obj in arr) {
            [ar addObject:obj.text];
        }
        arrData = [[NSArray alloc] initWithArray:ar];
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(alignLeft, 0, rect.size.width-2*alignLeft, heightOfTextField)];
        [lb setText:label];
        
        UIFont *font = lb.font;
        UIFontDescriptor * fontD = [font.fontDescriptor
                                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        font = [UIFont fontWithDescriptor:fontD size:15];
        [lb setFont:font];
        [lb setTextColor:colorLabel];
        [self addSubview:lb];
        
        bt = [[UIButton alloc] initWithFrame:CGRectMake(alignLeft, lb.frame.origin.y+lb.frame.size.height+alignTop/2, rect.size.width-2*alignLeft, heightOfTextField)];
        [bt setTitle:arrData[0] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bt setBackgroundImage:[UIImage imageNamed:@"dropdown"] forState:UIControlStateNormal];
        [bt addTarget:self  action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(2*alignLeft, bt.frame.origin.y+bt.frame.size.height + alignBottom*2, rect.size.width-4*alignLeft, 1.5)];
        [line setBackgroundColor:[UIColor blueColor]];
        [line setAlpha:0.5];
        [self addSubview:line];
    }
    return  self;
}
-(void)select{
    [self.superview endEditing:YES];
    [ActionSheetStringPicker showPickerWithTitle:lbel
                                            rows:arrData
                                initialSelection:indexSelected
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSLog(@"Picker: %@", picker);
                                           NSLog(@"Selected Index: %d", (int)selectedIndex);
                                           NSLog(@"Selected Value: %@", selectedValue);
                                           indexSelected = (int)selectedIndex;
                                           [bt setTitle:selectedValue forState:UIControlStateNormal];
                                           SelectObj *obj = [arrOnchoose objectAtIndex:indexSelected];
                                           [_delegate getSelected:selectedValue onChosen:obj.onChosen view:self];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:self];
}
@end
