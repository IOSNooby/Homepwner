//
//  QuickPreviewVC.m
//  Homepwner
//
//  Created by Padme on 3/31/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import "QuickPreviewVC.h"

@interface QuickPreviewVC ()

@end

@implementation QuickPreviewVC



-(void) loadView{
    // if you not drag a built-in pointer (self.view)
    // to some real object view or create a new one , (self.view) would be nil (cuz its just a "built-in pointer" not real object)
   // UIImageView* aView = [[UIImageView alloc]init];
  //  aView.contentMode = UIViewContentModeScaleAspectFit;
  //  self.view = aView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated{
    // this vc always called - and trashed again , and again
    
   // UIImageView* selfView = (UIImageView*)self.view;
    //selfView.image = self.bigImage;
    
    // Everytime this QuickPreview created , 1) autumatically create UIImageView
    // 2) add
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
