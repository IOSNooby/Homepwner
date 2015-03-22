//
//  superCellClass.h
//  Homepwner
//
//  Created by Padme on 3/15/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface superCellClass : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imageThumb;

@property (weak, nonatomic) IBOutlet UILabel *Name;

@property (weak, nonatomic) IBOutlet UILabel *serial;

@property (weak, nonatomic) IBOutlet UILabel *value;


-(void) setThumbnailFromImage:(UIImage*) imageOriginal;

@end
