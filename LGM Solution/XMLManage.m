//
//  PartyParser.m
//  XMLTest
//
//  Created by Ray Wenderlich on 3/17/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "XMLManage.h"
#import "GDataXMLNode.h"
#import "CompanyObj.h"
#import "FormObj.h"
#import "SelectObj.h"
#import "RadioObj.h"
#import "GroupObj.h"

@implementation XMLManage


////--------------------------------------PMT-------------------------------------------------////

////LOAD IMAGES
+ (NSMutableArray*)loadCompanies:(NSString *)filePath{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { NSLog(@"load fail");}
    
    NSArray *partyMembers = [doc nodesForXPath:@"//Data/CompanyList/Item" error:nil];
    for (GDataXMLElement *partyMember in partyMembers) {
        NSString *CompanyID,*CompanyName,*CompanyLogo;
        
        NSArray *CompanyIDs = [partyMember elementsForName:@"CompanyID"];
        if (CompanyIDs.count > 0) {
            CompanyID = ((GDataXMLElement *) [CompanyIDs objectAtIndex:0]).stringValue;
        } else continue;
        
        NSArray *CompanyNames = [partyMember elementsForName:@"CompanyName"];
        if (CompanyNames.count > 0) {
            CompanyName = ((GDataXMLElement *) [CompanyNames objectAtIndex:0]).stringValue;
        } else continue;
        
        NSArray *CompanyLogos = [partyMember elementsForName:@"CompanyLogo"];
        if (CompanyLogos.count > 0) {
            CompanyLogo = ((GDataXMLElement *) [CompanyLogos objectAtIndex:0]).stringValue;
        }
        
        CompanyObj *obj = [[CompanyObj alloc] init];
        obj.CompanyID = CompanyID;
        obj.CompanyLogo = CompanyLogo;
        obj.CompanyName = CompanyName;
        [arr addObject:obj];
    }
    return arr;
}
+ (BOOL)getStatus:(NSString *)filePath{
    BOOL status;
    NSString *StatusStr;
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { NSLog(@"load fail");}
    
    NSArray *partyMembers = [doc nodesForXPath:@"//Data" error:nil];
    for (GDataXMLElement *partyMember in partyMembers) {
        
        NSArray *Statuss = [partyMember elementsForName:@"Status"];
        if (Statuss.count > 0) {
            StatusStr = ((GDataXMLElement *) [Statuss objectAtIndex:0]).stringValue;
            break;
        } else continue;
        
    }
    if ([StatusStr isEqualToString:@"true"]) {
        status = YES;
    }else{
        status = NO;
    }
    return status;
}
+ (NSString*)getUsername:(NSString *)filePath{
    NSString *username;
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { NSLog(@"load fail");}
    
    NSArray *partyMembers = [doc nodesForXPath:@"//Data" error:nil];
    for (GDataXMLElement *partyMember in partyMembers) {
        
        NSArray *usernames = [partyMember elementsForName:@"Name"];
        if (usernames.count > 0) {
            username = ((GDataXMLElement *) [usernames objectAtIndex:0]).stringValue;
            break;
        } else continue;
        
    }
    return username;
}
+ (NSString*)getUseremail:(NSString *)filePath{
    NSString *username;
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { NSLog(@"load fail");}
    
    NSArray *partyMembers = [doc nodesForXPath:@"//Data" error:nil];
    for (GDataXMLElement *partyMember in partyMembers) {
        
        NSArray *usernames = [partyMember elementsForName:@"Email"];
        if (usernames.count > 0) {
            username = ((GDataXMLElement *) [usernames objectAtIndex:0]).stringValue;
            break;
        } else continue;
        
    }
    return username;
}
+ (NSString*)getEmail:(NSString *)filePath{
    NSString *email;
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { NSLog(@"load fail");}
    
    NSArray *partyMembers = [doc nodesForXPath:@"//LGMSolution/Head" error:nil];
    for (GDataXMLElement *partyMember in partyMembers) {
        
        NSArray *emails = [partyMember elementsForName:@"MailAddress"];
        if (emails.count > 0) {
            email = ((GDataXMLElement *) [emails objectAtIndex:0]).stringValue;
            break;
        } else continue;
        
    }
    return email;
}
+ (NSMutableArray*)loadForm:(NSString *)filePath{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { NSLog(@"load fail");}
    
    NSArray *partyMembers = [doc nodesForXPath:@"//LGMSolution/Form/Element" error:nil];
    for (GDataXMLElement *partyMember in partyMembers) {
        NSString *type,*label,*name,*validate,*isEmpty,*alt,*ios;
        
        type = [(GDataXMLElement *) [partyMember attributeForName:@"type"] stringValue];
        label = [(GDataXMLElement *) [partyMember attributeForName:@"label"] stringValue];
        name = [(GDataXMLElement *) [partyMember attributeForName:@"name"] stringValue];
        alt = [(GDataXMLElement *) [partyMember attributeForName:@"alt"] stringValue];
        validate = [(GDataXMLElement *) [partyMember attributeForName:@"validate"] stringValue];
        isEmpty = [(GDataXMLElement *) [partyMember attributeForName:@"isEmpty"] stringValue];
        ios = [(GDataXMLElement *) [partyMember attributeForName:@"ios"] stringValue];
        
        FormObj *obj = [[FormObj alloc] init];
        obj.type = type;
        obj.label = label;
        obj.name = name;
        obj.validate = validate;
        obj.alt = alt;
        obj.isEmpty = isEmpty;
        obj.list = [[NSMutableArray alloc] init];
        obj.select = [[NSMutableArray alloc] init];
        obj.radio = [[NSMutableArray alloc] init];
        
        if ([type isEqualToString:@"listview"]) {
            //NSArray *listview = [doc nodesForXPath:@"//LGMSolution/Form/Element/ListViewField" error:nil];
            NSArray *listview = [partyMember nodesForXPath:@"ListViewField" error:nil];
            for (GDataXMLElement *partyMember1 in listview) {
                FormObj *ob = [[FormObj alloc] init];
                ob.type = [(GDataXMLElement *) [partyMember1 attributeForName:@"type"] stringValue];
                ob.label = [(GDataXMLElement *) [partyMember1 attributeForName:@"label"] stringValue];
                ob.name = [(GDataXMLElement *) [partyMember1 attributeForName:@"name"] stringValue];
                ob.validate = [(GDataXMLElement *) [partyMember1 attributeForName:@"validate"] stringValue];
                ob.isEmpty = [(GDataXMLElement *) [partyMember1 attributeForName:@"isEmpty"] stringValue];
                [obj.list addObject:ob];
                
            }
        }else if ([type isEqualToString:@"select"]) {
            //NSArray *select = [doc nodesForXPath:@"//LGMSolution/Form/Element/Option" error:nil];
            NSArray *select = [partyMember nodesForXPath:@"Option" error:nil];
            for (GDataXMLElement *partyMember1 in select) {
                SelectObj *o = [[SelectObj alloc] init];
                o.value = [(GDataXMLElement *) [partyMember1 attributeForName:@"value"] stringValue];
                o.onChosen = [(GDataXMLElement *) [partyMember1 attributeForName:@"onChosen"] stringValue];
                o.text = [partyMember1 stringValue];
                
                [obj.select addObject:o];
            }
        }else if ([type isEqualToString:@"checkbox"]) {
            //NSArray *select = [doc nodesForXPath:@"//LGMSolution/Form/Element/Option" error:nil];
            NSArray *radio = [partyMember nodesForXPath:@"Radio" error:nil];
            for (GDataXMLElement *partyMember1 in radio) {
                RadioObj *o = [[RadioObj alloc] init];
                o.value = [(GDataXMLElement *) [partyMember1 attributeForName:@"value"] stringValue];
                o.label = [(GDataXMLElement *) [partyMember1 attributeForName:@"label"] stringValue];
                o.onChosen = [(GDataXMLElement *) [partyMember1 attributeForName:@"onChosen"] stringValue];
                
                [obj.radio addObject:o];
            }
        }
        
        if (ios == nil) {
         [arr addObject:obj];
        }else{
            if (ios.length >0) {
                obj.label = ios;
                [arr addObject:obj];
            }
        }
    }
    return arr;
}
+ (NSMutableArray*)loadGroup:(NSString *)filePath{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { NSLog(@"load fail");}
    
    NSArray *partyMembers = [doc nodesForXPath:@"//LGMSolution/ConditionElement/GroupElement" error:nil];
    for (GDataXMLElement *partyMember in partyMembers) {
        NSString *name;
        
        name = [(GDataXMLElement *) [partyMember attributeForName:@"name"] stringValue];
        
        GroupObj *objGroup = [[GroupObj alloc] init];
        objGroup.name = name;
        objGroup.forms = [[NSMutableArray alloc] init];
        
        NSArray *elements = [partyMember nodesForXPath:@"Element" error:nil];
        for (GDataXMLElement *partyMember1 in elements) {
            NSString *type,*label,*name,*validate,*isEmpty,*alt;
            
            type = [(GDataXMLElement *) [partyMember1 attributeForName:@"type"] stringValue];
            label = [(GDataXMLElement *) [partyMember1 attributeForName:@"label"] stringValue];
            name = [(GDataXMLElement *) [partyMember1 attributeForName:@"name"] stringValue];
            alt = [(GDataXMLElement *) [partyMember1 attributeForName:@"alt"] stringValue];
            validate = [(GDataXMLElement *) [partyMember1 attributeForName:@"validate"] stringValue];
            isEmpty = [(GDataXMLElement *) [partyMember1 attributeForName:@"isEmpty"] stringValue];
            
            FormObj *obj = [[FormObj alloc] init];
            obj.type = type;
            obj.label = label;
            obj.name = name;
            obj.validate = validate;
            obj.alt = alt;
            obj.isEmpty = isEmpty;
            obj.list = [[NSMutableArray alloc] init];
            obj.select = [[NSMutableArray alloc] init];
            obj.radio = [[NSMutableArray alloc] init];
            
            if ([type isEqualToString:@"listview"]) {
                //NSArray *listview = [doc nodesForXPath:@"//LGMSolution/Form/Element/ListViewField" error:nil];
                NSArray *listview = [partyMember1 nodesForXPath:@"ListViewField" error:nil];
                for (GDataXMLElement *partyMember0 in listview) {
                    FormObj *ob = [[FormObj alloc] init];
                    ob.type = [(GDataXMLElement *) [partyMember0 attributeForName:@"type"] stringValue];
                    ob.label = [(GDataXMLElement *) [partyMember0 attributeForName:@"label"] stringValue];
                    ob.name = [(GDataXMLElement *) [partyMember0 attributeForName:@"name"] stringValue];
                    ob.validate = [(GDataXMLElement *) [partyMember0 attributeForName:@"validate"] stringValue];
                    ob.isEmpty = [(GDataXMLElement *) [partyMember0 attributeForName:@"isEmpty"] stringValue];
                    [obj.list addObject:ob];
                }
            }else if ([type isEqualToString:@"select"]) {
                //NSArray *select = [doc nodesForXPath:@"//LGMSolution/Form/Element/Option" error:nil];
                NSArray *select = [partyMember1 nodesForXPath:@"Option" error:nil];
                for (GDataXMLElement *partyMember0 in select) {
                    SelectObj *o = [[SelectObj alloc] init];
                    o.value = [(GDataXMLElement *) [partyMember0 attributeForName:@"value"] stringValue];
                    o.text = [partyMember0 stringValue];
                    
                    [obj.select addObject:o];
                }
            }else if ([type isEqualToString:@"checkbox"]) {
                //NSArray *select = [doc nodesForXPath:@"//LGMSolution/Form/Element/Option" error:nil];
                NSArray *radio = [partyMember1 nodesForXPath:@"Radio" error:nil];
                for (GDataXMLElement *partyMember0 in radio) {
                    RadioObj *o = [[RadioObj alloc] init];
                    o.value = [(GDataXMLElement *) [partyMember0 attributeForName:@"value"] stringValue];
                    o.label = [(GDataXMLElement *) [partyMember0 attributeForName:@"label"] stringValue];
                    o.onChosen = [(GDataXMLElement *) [partyMember0 attributeForName:@"onChosen"] stringValue];
                    
                    [obj.radio addObject:o];
                }
            }
            
            [objGroup.forms addObject:obj];
        }
        
        
        [arr addObject:objGroup];
    }
    return arr;
}
@end
