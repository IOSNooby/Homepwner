//
//  StartViewController.m
//  Homepwner
//
//  Created by Zenjougahara on 1/8/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import "StartViewController.h"
#import "INWTableViewController.h"
#import "InsaneToolVC.h"

@interface StartViewController ()

@property (strong, nonatomic) IBOutlet UIView *viewScreen;

@property (weak, nonatomic) IBOutlet UIButton *StartButton;

@property (weak, nonatomic) IBOutlet UILabel *TitleBig;

@end

@implementation StartViewController

-(instancetype) init{
    self = [super init];
    if(self){
        NSNotificationCenter* cen = [NSNotificationCenter defaultCenter];
        [cen addObserver:self
                selector:@selector(dynamicTypeUpdateFont)
                    name:UIContentSizeCategoryDidChangeNotification
                  object:nil];
    }
    return self;
}


-(void) dynamicTypeUpdateFont{
    UIFont* newest = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.TitleBig.font = newest;
    self.StartButton.titleLabel.font= newest;
}




-(UIView*) viewScreen{
    if(!_viewScreen){
        [[NSBundle mainBundle] loadNibNamed:@"StartScreen"
                                      owner:self options:nil];
    }
    return _viewScreen;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = self.viewScreen;
}


- (IBAction)pushStartButton:(id)sender {
    
    // create the VC you wanna see next
    // call the GOD (UINavigation) to replace the topmost VC of the stack (PushVC) (This  code invoke view changing)
    
    //InsaneToolVC* insane =[[InsaneToolVC alloc]init];
    
    INWTableViewController* inwTable = [[INWTableViewController alloc]init];
    [self.navigationController pushViewController:inwTable animated:YES];
    
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
      name:UIContentSizeCategoryDidChangeNotification object:nil];
}


@end
