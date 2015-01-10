//
//  StartViewController.m
//  Homepwner
//
//  Created by Zenjougahara on 1/8/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import "StartViewController.h"
#import "INWTableViewController.h"


@interface StartViewController ()

@property (strong, nonatomic) IBOutlet UIView *viewScreen;

@property (weak, nonatomic) IBOutlet UILabel *TitleBig;

@end

@implementation StartViewController

-(UIView*) viewScreen{
    if(!_viewScreen){
        [[NSBundle mainBundle] loadNibNamed:@"StartScreen"
                                      owner:self options:nil];
    }
    return _viewScreen;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.viewScreen];
}


- (IBAction)pushStartButton:(id)sender {
    
    // create the VC you wanna see next
    // call the GOD (UINavigation) to replace the topmost VC of the stack (PushVC) (This  code invoke view changing)
    INWTableViewController* inwTable = [[INWTableViewController alloc]init];
    [self.navigationController pushViewController:inwTable animated:YES];
    
}


@end
