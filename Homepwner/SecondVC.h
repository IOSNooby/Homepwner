//
//  SecondVC.h
//  Homepwner
//
//  Created by Zenjougahara on 12/16/14.
//  Copyright (c) 2014 Zenjougahara. All rights reserved.
//

#import <UIKit/UIKit.h>
@class INWitem;

@interface SecondVC : UIViewController

@property(strong,nonatomic) INWitem* item;
@property(nonatomic,copy) void (^refreshTVBlock)(void);


-(instancetype) initWithNewItem:(BOOL)isNew;



@end
