//
//  ContactAddressVC.h
//  小农人
//
//  Created by tomusng on 2017/9/11.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactAddressDelegate <NSObject>

- (void)sendContactAddress:(NSString *)address;

@end


@interface ContactAddressVC : UIViewController

@property (nonatomic, assign) id<ContactAddressDelegate> delegate;



@end
