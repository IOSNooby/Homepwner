//
//  INWSmallMenuVC.m
//  Homepwner
//
//  Created by Padme on 4/28/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import "INWSmallMenuVC.h"

@interface INWSmallMenuVC ()

@property (strong, nonatomic) IBOutlet UIView *baseView;

@end

@implementation INWSmallMenuVC


-(UIView*) baseView{
    if(!_baseView){
        [[NSBundle mainBundle] loadNibNamed: @"SmallMenu"
                                      owner:self options:nil];
    }
    return _baseView;
}


#pragma mark Modify Init methods to singleton paradigm

-(instancetype) initWithNibName :(NSString *)
                nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
     self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self dynamictypeImplementAddNotification];
    return self;
}

-(instancetype) init{
    
   return [self helperSingletonModifyInitmethods];
}

-(instancetype) helperSingletonModifyInitmethods{
    
    NSException* ex = [NSException exceptionWithName :@"Singleton Violation"
                                               reason:@"This Class cant be instance manually"
                                             userInfo:nil];
    @throw ex;
    return nil;
}

#pragma mark Special Init method

-(instancetype) initPrivate{
    self = [super init];
    if(self){
        [self dynamictypeImplementAddNotification];
    }
    return self;
}

#pragma mark helper Special Init method

-(void) dynamictypeImplementAddNotification{
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateFont)
     name:UIContentSizeCategoryDidChangeNotification
     object:nil];
}

#pragma mark Singleton Factory call

+(instancetype) singletonMenu{
   
        static INWSmallMenuVC*  sinMenu;
        static dispatch_once_t token;
        dispatch_once(&token, ^{
            sinMenu = [[INWSmallMenuVC alloc]initWithNibName:@"SmallMenu"
                                                      bundle:[NSBundle mainBundle]];
        });
       
    return sinMenu;
}

#pragma mark VC lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.preferredContentSize = CGSizeMake(100, 100);
    self.view = self.baseView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
       [[NSNotificationCenter defaultCenter] removeObserver:self
         name:UIContentSizeCategoryDidChangeNotification object:nil];
}


#pragma mark IBActions

- (IBAction)ClearDiskAction:(id)sender {
    ///
}

- (IBAction)CanCelAction:(id)sender {
    ///
}

#pragma mark DynamicType 

-(void) updateFont{
    
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
