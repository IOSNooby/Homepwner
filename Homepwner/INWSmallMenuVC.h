//
//  INWSmallMenuVC.h
//  Homepwner
//
//  Created by Padme on 4/28/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INWSmallMenuVC : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *ClearDiskButton;
@property (weak, nonatomic) IBOutlet UIButton *CancelButton;


// this class is singleton , you can only call it via Factory method
+(instancetype) singletonMenu;

@end
