//
//  SecondVC.m
//  Homepwner
//
//  Created by Zenjougahara on 12/16/14.
//  Copyright (c) 2014 Zenjougahara. All rights reserved.
//

#import "SecondVC.h"
#import "INWitem.h"
@interface SecondVC ()


@property (strong, nonatomic) IBOutlet UIView *myview;

@property (weak, nonatomic) IBOutlet UITextField *namdField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *Date;

@end

@implementation SecondVC


-(UIView *)myview{
    if(!_myview){
        [[NSBundle mainBundle] loadNibNamed:@"SecondView"
                                      owner:self options:nil];
    }
    return _myview;
}

-(void) viewDidLoad{
    [self.view addSubview:self.myview];
}


-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"SecondVC did appear");
    
    [super viewWillAppear:animated];

    self.namdField.text = self.item.itemName;
    self.serialField.text = self.item.serialNumber;
    self.valueField.text =   [NSString stringWithFormat:@"%li",(long)self.item.valueInDollars];
    
    NSLog(@" textfield == %@",self.namdField.text);
    
    static NSDateFormatter* formatter = nil;
    
    if(!formatter){
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        self.Date.text = [formatter stringFromDate:self.item.dateCreated];
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    self.item.itemName = self.namdField.text;
    self.item.serialNumber =  self.serialField.text;
    self.item.valueInDollars = [self.valueField.text  intValue];
    
    
}



@end
