//
//  SecondVC.m
//  Homepwner
//
//  Created by Zenjougahara on 12/16/14.
//  Copyright (c) 2014 Zenjougahara. All rights reserved.
//

#import "SecondVC.h"
#import "INWitem.h"
#import "INWItemStore.h"
#import "ImageStore.h"

@interface SecondVC () <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate>


@property (strong, nonatomic) IBOutlet UIView *myview;

@property (weak, nonatomic) IBOutlet UITextField *namdField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *Date;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;


@property (strong,nonatomic) UIPopoverController* cameraPopOver;
@property (strong,nonatomic) UIImagePickerController* imgPicker;


@end

@implementation SecondVC

#pragma mark Property Lazy init

-(UIView *)myview{
    if(!_myview){
        [[NSBundle mainBundle] loadNibNamed:@"SecondView"
                                      owner:self options:nil];
    }
    return _myview;
}

-(UIImagePickerController*) imgPicker{
    
    if(!_imgPicker){
        
        _imgPicker= [[UIImagePickerController alloc]init];
        
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            // Device has Camera
            NSArray* availableTypesToCapture = [UIImagePickerController
                                                availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            _imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            // this code make Video capture available !
            _imgPicker.mediaTypes = availableTypesToCapture;
            
        }
        else{
            // Device has no Camera
            _imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
            _imgPicker.delegate = self;

    }
    return _imgPicker;
}

-(UIPopoverController*) cameraPopOver{
    if(!_cameraPopOver){
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
            _cameraPopOver = [[UIPopoverController alloc]initWithContentViewController:self.imgPicker];
            _cameraPopOver.delegate = self;
        }
    }
    return _cameraPopOver;
}

#pragma mark Actions methods

- (IBAction)takepic:(id)sender {
    // when you push a camera button
    // alloc init UIImagePickerController
    // imagePicker should not hold any ref
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        [self.cameraPopOver presentPopoverFromBarButtonItem:self.cameraButton
             permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    else { [self presentViewController:self.imgPicker  animated:YES  completion:nil];
        };
    
}
- (IBAction)chooseFromPhotoLibary:(id)sender {
    /*
    UIImagePickerController * imgPicker = [[UIImagePickerController alloc]init];
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.delegate = self;
    */

    
    [self presentViewController:self.imgPicker animated:YES completion:nil];
}


- (IBAction)removePhotoFromView:(id)sender {
    
    [[ImageStore singletonImageStore] deleteImageByKey:self.item.myUUID];
    self.imgView.image  = nil;
}

#pragma mark Init

// Override to Erectile Dysfuction

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
        NSException* a = [NSException exceptionWithName:
                          @"This Init Method was Erectile Dysfuction"
                                                 reason:@"" userInfo:nil];
        @throw a;
    
    return nil;
}


// this Method use in case CreateNew CELL ROW only

-(instancetype) initWithNewItem:(BOOL)isNew{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
         self.item = [INWitem createBlankItem];
        
        if(isNew){
            
            [self prepareMiniNavigationForCenterModal];
        }
        // else , return old
        
    }
    return self;
}


#pragma mark VC Life Cycle

-(void) viewDidLoad{
    
    self.view = self.myview;
    [self addSubviewsToBossView];
    
    [self defineDelegateOfEachTextfields];
    [self defineTagToEachTextfields];
    [self preparePlaceHolders];
    [self LetsHideKeyboardWhenTouchingEmptyArea];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self loadData];
    
   // if(self.item.hasImage == NO){
        [self loadImageFromStore];
   // }
    [self loadDateData];
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.view endEditing:YES]; // dismissKeyboard
    
    [self saveData];
    NSLog(@"saveImageData RUN (buggySpot)");
    
    [self saveImageData];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
       [self loadImageFromStore];
    }
    
    [self comfirmThisItemHasImageOrNot];
    [[ImageStore singletonImageStore]clearStore];
    
    NSLog(@"howmany in ImageStore Dic %ld",(long)[[ImageStore singletonImageStore] howmanyCount]);
    NSLog(@"howmany IN PERSISTENT  %ld " ,(long) [[ImageStore singletonImageStore] howmanyInSandbox]);
    
}


#pragma mark Helper Methods Data

-(void) saveData{
    
    self.item.itemName = self.namdField.text;
    self.item.serialNumber =  self.serialField.text;
    
    if(self.valueField.text != nil){
       self.item.valueInDollars = [NSNumber numberWithInteger:[self.valueField.text  intValue]];
    }
    ///
    //[[ImageStore singletonImageStore] deleteOnlyImageInImageStoreDic:self.item.myUUID];
}

// called in viewWillDisappear
-(void) saveImageData{
    BOOL succeedsaveStore =[[ImageStore singletonImageStore] saveStoreToPersistent];
    NSLog(@"succeed savestore = %i",succeedsaveStore);
}

-(void) saveCurrentDate{
    
    self.item.dateCreated = [NSDate date];

}

-(void) loadImageFromStore{
    // Load EXISTING image from store (if this Object really has image)
    
    self.imgView.image = [[ImageStore singletonImageStore]
                          getImageFromKey:self.item.myUUID];
    
    [self.imgView setNeedsDisplay];
    
}

-(void) loadData{
    self.namdField.text = self.item.itemName;
    self.serialField.text = self.item.serialNumber;
    if(self.item.valueInDollars ){

       self.valueField.text =   [NSString stringWithFormat:@"%@",self.item.valueInDollars];
    }
}

-(void) loadDateData{
    
    static NSDateFormatter* formatter = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token,^{
        
        formatter = [[NSDateFormatter alloc]init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
    });
    self.Date.text = [formatter stringFromDate:self.item.dateCreated];

}

#pragma mark Delegates

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self saveToDataModelAndDismissKeyboardOfTextField:textField];
    [textField resignFirstResponder];

    return YES;
}

#pragma mark UIImagePickerDelegate

// When the Modal Photo library got "selected" a Photo user desire for.

-(void) imagePickerController:(UIImagePickerController *)picker
            didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // "info" is Dictionary !
    
    // connect between Array - Dictionary (two diffrent ADT)
    // ( Normally , sequenced ADT cant compatible with unsequenced ADT )
    // UUID bridge this GAP !
    UIImage* img = info[UIImagePickerControllerOriginalImage];
    self.imgView.image = img;

    [[ImageStore singletonImageStore] setImage:img
                                   withNameKey:self.item.myUUID];
    
    NSURL* mediaURL = info[UIImagePickerControllerMediaURL];
    if(mediaURL){
        if( UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([mediaURL path])){
            UISaveVideoAtPathToSavedPhotosAlbum([mediaURL path], nil, nil, nil);
            [[NSFileManager defaultManager] removeItemAtPath:[mediaURL path]
                                                       error:nil];
        }
    }
    // Release from memory (Dont worry about dangling pointer ,
    // Cuz "picker" parameter above , still hold these object. Till the end of this Deleagate operation.
    
    self.imgPicker = nil;
    
    // case 1 : iPAD (Pop Modal)
    
    if(self.cameraPopOver){
        
        [self.cameraPopOver dismissPopoverAnimated:YES];
        self.cameraPopOver = nil;
        [self dismissViewControllerAnimated:YES completion:nil];


    }
    // case 2 : iPhone (FullScreen Modal)
    else{
       [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark UIPopover Delegate

-(void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    
    self.cameraPopOver = nil;
    
}

#pragma mark Helper Methods Shorten Codes

-(void) comfirmThisItemHasImageOrNot{
    if(self.imgView.image){
        self.item.hasImage = YES;
    }
    else{
        self.item.hasImage = NO;
    }
}



-(void) save: (UIBarButtonItem*) sender {
    // Use with Button
    [self saveData];
    [self saveCurrentDate];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:
     self.refreshTVBlock];

}

-(void) cancel: (UIBarButtonItem*) sender{
    // Use with Button
    [[INWItemStore sharedStore]removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:
     self.refreshTVBlock];
    
}

-(void) prepareMiniNavigationForCenterModal{
    
    UIBarButtonItem* done = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                             target:self action:@selector(save:)];
    
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                               target:self action:@selector(cancel:)];
    
    self.navigationItem.rightBarButtonItem = cancel;
    self.navigationItem.leftBarButtonItem = done;
    
}

-(void) preparePlaceHolders{
    self.namdField.placeholder = @"name here";
    self.serialField.placeholder = @"serial number";
    self.valueField.placeholder = @"value number";
}

-(void) defineDelegateOfEachTextfields{
    
    self.namdField.delegate  = self;
    self.serialField.delegate = self;
    self.valueField.delegate =self;
    
}

-(void) defineTagToEachTextfields{
    self.namdField.tag =1;
    self.serialField.tag = 2;
    self.valueField.tag =3;
}

-(void) addSubviewsToBossView{
    [self.view addSubview:self.Date];
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.imgView];
}


-(void) saveToDataModelAndDismissKeyboardOfTextField:(UITextField*) textField{
    
    if(textField.tag == 1){
        id valueUnknowType = [self ConvertToPropertyModel:[self.item valueForKey:@"itemName"]
                               textToConvert:textField.text];
        
        self.item.itemName =  valueUnknowType;
    }
    else if(textField.tag ==2){
        id valueUnknowType = [self ConvertToPropertyModel:[self.item valueForKey:@"serialNumber"]
                                                    textToConvert:textField.text];

        self.item.serialNumber = valueUnknowType;
    }
    else if(textField.tag ==3){
        id valueUnknowType = [self ConvertToPropertyModel:[self.item valueForKey:@"valueInDollars"]
                                            textToConvert:textField.text];
        self.item.valueInDollars = valueUnknowType;

    }
}

#pragma mark Helpers Method Conversion

-(id) ConvertToPropertyModel:(id) propertyInModel
                         textToConvert:(NSString*) text {
    
    if([propertyInModel isKindOfClass:[NSNumber class]]){
        
       return [NSNumber numberWithInteger:[text integerValue]];
    }
    else if([propertyInModel isKindOfClass:[NSString class]]){

       return text;
    }
    
    return nil;
}


#pragma mark Navigations

-(void) LetsHideKeyboardWhenTouchingEmptyArea{
    UITapGestureRecognizer* letsTap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissAllViewFromResponder)];
    
    [letsTap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:letsTap];
}

-(void) dismissAllViewFromResponder{
    
    NSArray* everyview = [self.myview subviews];
    for(UITextField* a in everyview){
        [a resignFirstResponder];
    }
}

#pragma mark Override SuperClass's protocol

-(void) willTransitionToTraitCollection:(UITraitCollection *)newCollection
              withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    if(newCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        self.cameraButton.enabled = YES;
        
    }
    
    else if(newCollection.userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        
        if(newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact ){
            // hide button
            self.cameraButton.enabled = NO;
            self.imgView.contentMode = UIViewContentModeScaleToFill;
        }
        else  {
            self.cameraButton.enabled = YES;
            self.imgView.contentMode = UIViewContentModeScaleAspectFit;

        }
    }
}



@end
