//
//  Define.h
//  Saverpassport
//
//  Created by Phan Minh Tam on 6/9/14.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#ifndef Define_h

#define APP_NAME                @"OSCAR BY LGM Solution"

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
#define LINK_GET_COMPANIES  @"http://www.lgmsolution.com/LGMForm/companylist2.php"
#define LINK_GET_DETAIL     @"http://www.lgmsolution.com/LGMForm/xml.php?ID="
#define FILE_NAME_COMPANIES @"companies_list.xml"
#define kDataKey        @"Data"
#define kDataFile       @"data.plist"
#define kThumbImageFile @"thumbImage.png"
#define kFullImageFile  @"xmlFile.xml"
#define heightOfTextField 30
#define widthOfTextField rect.size.width-2*alignLeft

#define colorLabel [UIColor colorWithRed:0.0/255.0 green:46.0/255.0 blue:115.0/255.0 alpha:1.0]
#define colorAlt [UIColor colorWithRed:180.0/255.0 green:26.0/255.0 blue:13.0/255.0 alpha:1.0]

#define alignLeft 10
#define alignTop  20
#define alignBottom  5
#define widthOfScreen self.view.frame.size.width
//#define WS_LINK @"http://xmpp.tech-natives.com/lgm_ws/sendMail.php"
#define WS_LINK @"http://www.lgmsolution.com/intranet/lib/sendMail.php"
#define k_send_mail_success @"k_send_mail_success"
#define k_send_mail_fail @"k_send_mail_fail"
#endif
