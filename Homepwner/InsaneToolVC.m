//
//  InsaneToolVC.m
//  Homepwner
//
//  Created by Padme on 1/23/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import "InsaneToolVC.h"

@interface InsaneToolVC ()

@end

@implementation InsaneToolVC

-(UIView*) baseView{
    
    if(!_baseView){
        [[NSBundle mainBundle]loadNibNamed:@"InsaneTools"
                                     owner:self
                                   options:nil];
    }
    return _baseView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.baseView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
