//
//  TimePickerView.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/6/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "ListView.h"
#import "Define.h"
#import "ItemCell.h"
#import "UIAlertView+NSBlock.h"
#import "ItemObj.h"
#import "FormObj.h"

@implementation ListView

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
        
        arrData = [[NSMutableArray alloc] init];
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(alignLeft, 0, rect.size.width-80, heightOfTextField)];
        [lb setText:label];
        UIFont *font = lb.font;
        UIFontDescriptor * fontD = [font.fontDescriptor
                                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        font = [UIFont fontWithDescriptor:fontD size:15];
        [lb setFont:font];
        [lb setTextColor:colorLabel];
        [self addSubview:lb];
        
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(lb.frame.origin.x+lb.frame.size.width+10, lb.frame.origin.y, heightOfTextField, heightOfTextField)];
        [bt setBackgroundImage:[UIImage imageNamed:@"ic_add.png"] forState:UIControlStateNormal];
        [bt addTarget:self  action:@selector(myAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        
        UIView *viewTable = [[UIView alloc] initWithFrame:CGRectMake(alignLeft, lb.frame.origin.y+lb.frame.size.height, rect.size.width-2*alignLeft, rect.size.height- alignBottom*8)];
        [viewTable setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:viewTable];
        float xOfLabel = 0.0;
        for (FormObj *obj in arr) {
            UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(xOfLabel, 0, (viewTable.frame.size.width-arr.count-45)/(arr.count), heightOfTextField)];
            [lb1 setText:obj.label];
            [lb1 setBackgroundColor:[UIColor darkGrayColor]];
            lb1.textAlignment = NSTextAlignmentCenter;
            UIFont *f1 = lb1.font;
            UIFontDescriptor * fD1 = [font.fontDescriptor
                                      fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
            f1 = [UIFont fontWithDescriptor:fD1 size:11];
            [lb1 setFont:f1];
            [lb1 setTextColor:[UIColor whiteColor]];
            [viewTable addSubview:lb1];
            xOfLabel += (viewTable.frame.size.width-arr.count-45)/(arr.count)+1;
        }
        
        /*FormObj *obj1 = [arr objectAtIndex:0];
        FormObj *obj2 = [arr objectAtIndex:1];
        FormObj *obj3 = [arr objectAtIndex:2];
        
        UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewTable.frame.size.width/4, heightOfTextField)];
        [lb1 setText:obj1.label];
        [lb1 setBackgroundColor:[UIColor darkGrayColor]];
        lb1.textAlignment = NSTextAlignmentCenter;
        UIFont *f1 = lb1.font;
        UIFontDescriptor * fD1 = [font.fontDescriptor
                                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        f1 = [UIFont fontWithDescriptor:fD1 size:11];
        [lb1 setFont:f1];
        [lb1 setTextColor:[UIColor whiteColor]];
        [viewTable addSubview:lb1];
        
        UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(viewTable.frame.size.width/4, 0, viewTable.frame.size.width/4, heightOfTextField)];
        [lb2 setText:obj2.label];
        [lb2 setBackgroundColor:[UIColor darkGrayColor]];
        lb2.textAlignment = NSTextAlignmentCenter;
        UIFont *f2 = lb2.font;
        UIFontDescriptor * fD2 = [font.fontDescriptor
                                  fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        f2 = [UIFont fontWithDescriptor:fD2 size:11];
        [lb2 setFont:f2];
        [lb2 setTextColor:[UIColor whiteColor]];
        [viewTable addSubview:lb2];
        
        UILabel *lb3 = [[UILabel alloc] initWithFrame:CGRectMake(2*viewTable.frame.size.width/4, 0, viewTable.frame.size.width/4, heightOfTextField)];
        [lb3 setText:obj3.label];
        [lb3 setBackgroundColor:[UIColor darkGrayColor]];
        lb3.textAlignment = NSTextAlignmentCenter;
        UIFont *f3 = lb3.font;
        UIFontDescriptor * fD3 = [font.fontDescriptor
                                  fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        f3 = [UIFont fontWithDescriptor:fD3 size:11];
        [lb3 setFont:f3];
        [lb3 setTextColor:[UIColor whiteColor]];
        [viewTable addSubview:lb3];
         */
        UILabel *lb4 = [[UILabel alloc] initWithFrame:CGRectMake(xOfLabel, 0, 45, heightOfTextField)];
        [lb4 setText:@"Action"];
        [lb4 setBackgroundColor:[UIColor darkGrayColor]];
        lb4.textAlignment = NSTextAlignmentCenter;
        UIFont *f4 = lb4.font;
        UIFontDescriptor * fD4 = [font.fontDescriptor
                                  fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        f4 = [UIFont fontWithDescriptor:fD4 size:11];
        [lb4 setFont:f4];
        [lb4 setTextColor:[UIColor whiteColor]];
        [viewTable addSubview:lb4];
        
        tbView = [[UITableView alloc] initWithFrame:CGRectMake(0,heightOfTextField, viewTable.frame.size.width,  viewTable.frame.size.height- heightOfTextField)];
        tbView.delegate = self;
        tbView.dataSource = self;
        [tbView setBackgroundColor:[UIColor clearColor]];
        [viewTable addSubview:tbView];
        tbView.hidden = YES;
        
        lbNodata = [[UILabel alloc] initWithFrame:CGRectMake(alignLeft, viewTable.frame.size.height/2, viewTable.frame.size.width, heightOfTextField)];
        [lbNodata setText:@"No item was added"];
        lbNodata.textAlignment = NSTextAlignmentCenter;
        UIFont *font1 = lbNodata.font;
        UIFontDescriptor * fontD1 = [font.fontDescriptor
                                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        font1 = [UIFont fontWithDescriptor:fontD1 size:15];
        [lbNodata setFont:font1];
        [lbNodata setTextColor:colorLabel];
        [viewTable addSubview:lbNodata];
        lbNodata.hidden = NO;
        
        line = [[UIView alloc] initWithFrame:CGRectMake(2*alignLeft, viewTable.frame.origin.y+viewTable.frame.size.height + alignBottom*2, rect.size.width-4*alignLeft, 1.5)];
        [line setBackgroundColor:[UIColor blueColor]];
        [line setAlpha:0.5];
        [self addSubview:line];
    }
    return  self;
}
-(void)myAction{
    [self.superview endEditing:YES];
    AddItem *popup = [[[NSBundle mainBundle] loadNibNamed:@"AddItem" owner:self options:nil] objectAtIndex:0];
    popup.delegate = self;
    popup.arrForms = _arrForms;
    [popup showInView:self.superview];
}
-(void)clickOK:(NSMutableArray *)arrText{
    ItemObj *obj = [[ItemObj alloc] init];
    obj.arrText = [[NSMutableArray alloc] init];
    obj.arrText = arrText;
    [arrData addObject:obj];
    tbView.hidden = NO;
    lbNodata.hidden = YES;
    [tbView reloadData];
    [_delegate AddItem:arrData view:self];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string_cell;
    string_cell = @"ItemCell";
    ItemCell *cell =(ItemCell *)[tableView dequeueReusableCellWithIdentifier:string_cell];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:string_cell owner:self options:nil];
        cell = homeCell;
        homeCell = nil;
    }
    ItemObj *obj = [arrData objectAtIndex:indexPath.row];
    cell.arrText = obj.arrText;
    [cell awakeFromNib];
    cell.btDelete.tag = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

- (IBAction)clickDelete:(id)sender {
    UIButton *bt = (UIButton*)sender;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Are you sure you want to delete this item?"delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    alert.delegate = self;
    [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        // handle the button click
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            [arrData removeObjectAtIndex:bt.tag];
            if (arrData.count == 0) {
                tbView.hidden = YES;
                lbNodata.hidden = NO;
            }else{
                tbView.hidden = NO;
                lbNodata.hidden = YES;
            }
            [tbView reloadData];
            [_delegate AddItem:arrData view:self];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
}
@end
