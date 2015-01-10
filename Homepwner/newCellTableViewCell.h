//
//  newCellTableViewCell.h
//  Homepwner
//
//  Created by Zenjougahara on 1/10/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UISwitch *onOff;

@property (weak, nonatomic) IBOutlet UILabel *myLabel;

@property (weak, nonatomic) IBOutlet UISlider *Slider;

@end
