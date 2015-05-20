//
//  INWTableViewController.m
//  Homepwner
//
//  Created by Zenjougahara on 12/9/14.
//  Copyright (c) 2014 Zenjougahara. All rights reserved.
//

#import "INWTableViewController.h"
#import "INWItemStore.h"
#import "INWitem.h"

#import "INWSmallMenuVC.h"
#import "SecondVC.h"

#import "neoCell.h"
#import "superCellClass.h"

#import "ImageStore.h"
#import "QuickPreviewVC.h"

static NSDictionary* cellH;

@interface INWTableViewController ()

@property (strong,nonatomic) INWItemStore* store;

@property (nonatomic,strong) IBOutlet UIView* headerView;

@property(strong,nonatomic) UIPopoverController* popOver;

@property(strong,nonatomic) UIPopoverController* miniPopover;

@property (weak, nonatomic) IBOutlet UIButton *optionButton;

#pragma mark DynamicType Properties
// some of them has Lazy inits
@property (nonatomic) CGFloat dynamicRowH;

@property (nonatomic) CGFloat defaultRowH;

@property (nonatomic) CGFloat dynamicCellFontSize;

@property (strong,nonatomic) NSString* currentPreferredContentSize;

@end

@implementation INWTableViewController


#pragma mark View Settings

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


// this method loading the NIB (Graphics Information)
-(UIView*) headerView{
    
    if(!_headerView){
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
                                      owner:self options:nil];
    }
    return _headerView;
}

#pragma mark IBActions


-(IBAction)addNewItem:(id)sender
{
    [self addNewItem_Helper];
}

-(IBAction)toggleEditingMode:(id)sender
{
    // if current state = Editable Mode
    // flip it to = UnEditable Mode

    if(self.isEditing){
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    }
    else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
    
}


- (IBAction)Config:(id)sender {
    
    /// Show Popup
    /// inside Popup , there you could see a list of commands
    /// if you choose "Clear Disk"
    /// Every single Item removed
    /// Also , every single things in Persistent too
    
    INWSmallMenuVC* smallMenus = [INWSmallMenuVC singletonMenu];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
    
        UIPopoverController* pop = [[UIPopoverController alloc]initWithContentViewController:smallMenus];
        
        pop.popoverContentSize  =  CGSizeMake(100, 100);
        self.miniPopover =  pop;
    
        pop.delegate = self;
        
        
        CGRect whereArrowBe =
        [self.view  convertRect:self.optionButton.frame toView:self.view];
        
        [pop presentPopoverFromRect:whereArrowBe
                             inView:self.view
           permittedArrowDirections:UIPopoverArrowDirectionUp
                           animated:YES];
    }
    
    else{
        /*
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        smallMenus.modalPresentationStyle = UIModalPresentationFormSheet;
        */
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Menu"
                     message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ClearDisk = [UIAlertAction actionWithTitle:@"Clear Disk"
                                    style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                           /// do something
                                        
                                           /// clear the Persistent & clear the ItemStore
                                           /// tell user its Done or not
                                        
                                    }];
        
        UIAlertAction* Cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                           /// Cancel it
                                    }];
        
        
        [alert addAction: ClearDisk];
        [alert addAction:Cancel];
        [self presentViewController: alert animated:YES completion:nil];
    }
}

#pragma mark Class Initializers

// this is Designate initializer

-(instancetype) initWithStyle:(UITableViewStyle)style{
    return [self init];
    }

-(instancetype) init{
    self = [super initWithStyle:UITableViewStylePlain];
    if(self){
        
        self.defaultRowH = 50 ;
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                    selector:@selector(dynamicTypeUpdateFont:)
                    name:UIContentSizeCategoryDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                          selector:@selector(newFontSizeToCellHeight)
                          name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    
    return  self;
}


-(void) dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
             name:UIContentSizeCategoryDidChangeNotification object:nil];
}

//  Force every init method to return just 1 type (StylePlain)


- (void)viewDidLoad {
    [super viewDidLoad];
    /// this code Define Cell's soul (Prepare Cell's class) and add Identifier.
    /// You can modify the CELL to CustomCellClass by coding
    
    // common TableViewCell
    /*
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier: @"UITableViewCell"];
    */
    
    UINib* thenib = [UINib nibWithNibName:@"neoCell" bundle:nil]; // aka mainbundle
    [self.tableView registerNib:thenib  forCellReuseIdentifier:@"neoCellX" ];
    
    UINib* supercellNib =[UINib nibWithNibName:@"superCell" bundle:nil];
    [self.tableView registerNib:supercellNib forCellReuseIdentifier:@"SuperCellX"];
    
    // tell tableview whats nibfile you wann use ?
    // register cell by specify "name of cell" and specify "where does the cell from"
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self action:@selector(addNewItem_Helper)];
    
    [self.tableView setTableHeaderView:self.headerView];
     self.refreshControl = [UIRefreshControl new];
    
    [self.refreshControl addTarget:self action:@selector(refreshSelf:)
                  forControlEvents:UIControlEventValueChanged];
}

#pragma mark Lazy inits

// bypass object (represent INWItemStore sharedStore)

-(INWItemStore*)store{
    if(!_store){
        _store = [INWItemStore sharedStore];

    }
    return _store;
}
-(void) setstore:(INWItemStore *)store{
    _store = store;
}


-(NSString*) currentPreferredContentSize{
    // to avoid nil pointer app Crash
    if(!_currentPreferredContentSize){
        _currentPreferredContentSize = UIContentSizeCategoryLarge;
    }
    return _currentPreferredContentSize;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return  [[[INWItemStore sharedStore] allItems]count] +1 ;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if(self.dynamicRowH){
        
        NSLog(@"DYnaroW = %f",self.dynamicRowH);

        return self.dynamicRowH;
    }
    else{
        return self.defaultRowH;
    }
    
}



#pragma mark Cell Modifications 

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell* cellOut;
    
    if(indexPath.row < [[[INWItemStore sharedStore]allItems]count]){
        superCellClass * cell = [tableView dequeueReusableCellWithIdentifier:@"SuperCellX"
                                                                forIndexPath:indexPath];

        INWitem* item = [[INWItemStore sharedStore]allItems][indexPath.row];
      
        cell.Name.text = item.itemName;
        cell.serial.text = item.serialNumber;
        cell.value.text = [NSString  stringWithFormat:@"$%@",item.valueInDollars] ;
        // DynamicType for UI texts
        
        cell.ThumbSizeNumber = cellH[self.currentPreferredContentSize];
        
       // cell.ThumbSizeValue =
        UIFont* fontchange = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        
        NSLog(@"CurrentPrefContent = %@",self.currentPreferredContentSize);
        NSLog(@"UIFONT = %@",fontchange);

        cell.Name.font = fontchange;
        cell.serial.font = fontchange;
        cell.value.font = fontchange;
        
        UIColor* colorForPrice;
        
        if(item.valueInDollars.integerValue > 99){
              colorForPrice = [UIColor redColor];
        }else {colorForPrice = [UIColor greenColor];}
        
        cell.value.textColor = colorForPrice;
        cell.imageThumb.image = item.thumb ;
        
        // premature optimize
        // cell.thumbImgblock = [self returnBlockforImagethumbQuickview];
        
        __weak UIImageView* weakThumb = cell.imageThumb;
        
        
        cell.thumbImgblock = ^{
           
          // ** this code allow "Quick View" for iPad Mode **
            
          // call ImageStore , get Image via UUID of current cell item
          // create new QuickPreviewVC , set its image to Image you got
          // now , create POPOver (using QuickPreviewVC as content)
             // set POPOver  contentsize ,delegate , and Present it
            if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
                
                // got a chunck of Image and force it to VC
                UIImage* rawImageFromStore = [[ImageStore singletonImageStore]getImageFromKey:item.myUUID];
                UIImageView* rawimgview = [[UIImageView alloc]initWithImage:rawImageFromStore];
                QuickPreviewVC* quickVC = [[QuickPreviewVC alloc]init];
              //  quickVC.bigImage = rawImageFromStore;
                
                UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 600, 600)];
                
                scrollView.contentSize = rawImageFromStore.size;
                scrollView.delegate = self;
                scrollView.maximumZoomScale = 2.0;
                scrollView.minimumZoomScale = 1.0;
                [scrollView addSubview:rawimgview];
                quickVC.view = scrollView;
                
                // prepare ingradient for Popover cooking  (where the arrow begin)
                CGRect thumbPositionRealtiveToBigView = [self.view convertRect:weakThumb.bounds
                                                                  fromView:weakThumb];
                
                // Popover alloc / init and settings , size , delegate
                UIPopoverController* poppy = [[UIPopoverController alloc]
                                              initWithContentViewController:quickVC];
                poppy.backgroundColor = [UIColor blackColor];
                self.popOver = poppy;
                self.popOver.delegate = self;
                self.popOver.popoverContentSize = CGSizeMake(600, 600);
                [self.popOver presentPopoverFromRect:thumbPositionRealtiveToBigView
                                              inView:self.view
                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                            animated:YES];
           }
        };
        
        cellOut = cell;
    
    }
    else if(indexPath.row == [[[INWItemStore sharedStore] allItems]count]){
        neoCell* neoCell = [tableView dequeueReusableCellWithIdentifier:@"neoCellX"
                                                           forIndexPath:indexPath];
        // name the last View cell appearance
        neoCell.myLabel.text = @"...";
        cellOut = neoCell;
    }
    
    return cellOut;
}

-(void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    self.popOver = nil;
}



#pragma mark Edit / Add

-(void) tableView:(UITableView *)tableView
             commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
              forRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // if(indexPath.row < [[[INWItemStore sharedStore]allItems] count]){
        
        if(editingStyle == UITableViewCellEditingStyleDelete){
        
            INWitem* item = [[INWItemStore sharedStore]allItems][indexPath.row];
            [[INWItemStore sharedStore] removeItem:item];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
      }
        else if(editingStyle == UITableViewCellEditingStyleInsert){
            [self addNewItem_Helper];
        }
  //  }
}
-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    // if indexpath.row == lastIndex in Model's Array  (mean  you got those "very last cell"
    //  grant its cell style to "insertStyle"
    
    INWItemStore* store = [INWItemStore sharedStore];
    
    if(indexPath.row ==[store lastObjectIndex]+1){
        return    UITableViewCellEditingStyleInsert;
    }
    else{
        return UITableViewCellEditingStyleDelete;
    }
        return  UITableViewCellEditingStyleNone;
}

-(NSString*) tableView:(UITableView *)tableView
        titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * toreturn;
    
    if(indexPath.row < [[[INWItemStore sharedStore]allItems] count]){
        toreturn  = @"Remove";
    }
    else{
        toreturn  = @"          ";
    }
    return toreturn;
}
#pragma mark Moving Cell

-(void) tableView:(UITableView *)tableView
                    moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
                           toIndexPath:(NSIndexPath *)destinationIndexPath{

    if(destinationIndexPath.row != [tableView numberOfRowsInSection:0]-1){
      [[INWItemStore sharedStore] moveItemFromIndex:sourceIndexPath.row
                                          toIndex:destinationIndexPath.row];
    }
}

-(BOOL) tableView:(UITableView *)tableView
                canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row  == [[[INWItemStore sharedStore]allItems] count]){
        return NO;
    }
    return YES;
}


#pragma mark Navigation to Another VC  

-(void)tableView:(UITableView *)tableView
                  didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // fetch data from Store 
    if(indexPath.row != [[[INWItemStore sharedStore]allItems]count]){
    
        NSMutableArray* itemArray = [[INWItemStore sharedStore] allItems];
    
        INWitem* a = [itemArray objectAtIndex:indexPath.row];
        
        SecondVC* detailVC = [[SecondVC alloc]initWithNewItem:NO];
        detailVC.item = a;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
}


#pragma mark Helpers Methods

// This method run inside both Navigation's SystemButton "Add"
// and also Xib custom Header "add" button


-(void) newFontSizeToCellHeight{
    // Dynamictype
    //  create the Set of current H
    
    if(!cellH){
        cellH =  @{ UIContentSizeCategoryExtraSmall : @50,
                    UIContentSizeCategorySmall : @55,
                    UIContentSizeCategoryMedium : @60,
                    UIContentSizeCategoryLarge : @65,
                    UIContentSizeCategoryExtraLarge :@70,
                    UIContentSizeCategoryExtraExtraLarge :@75,
                    UIContentSizeCategoryExtraExtraExtraLarge : @80,
                    // this size activated only when you enable "More size please" in iOS settings
                    UIContentSizeCategoryAccessibilityMedium:@88,
                    UIContentSizeCategoryAccessibilityLarge :@99,
                    UIContentSizeCategoryAccessibilityExtraLarge :@100,
                    UIContentSizeCategoryAccessibilityExtraExtraLarge :@110,
                    UIContentSizeCategoryAccessibilityExtraExtraExtraLarge :@120
                  };
    }
    
    // We cant predict what size user will choose ,
    //  so ASK preferredContentSizeCategory from Application
    NSString * UIContentSizeCategoryString = [[UIApplication sharedApplication] preferredContentSizeCategory];
    // got size name user chosen , and bring the name to fetch value from Dictionary
    NSNumber* cellHeightValue =  cellH[UIContentSizeCategoryString];
    self.dynamicRowH =  cellHeightValue.floatValue;
    self.dynamicCellFontSize = cellHeightValue.floatValue;
    self.currentPreferredContentSize = UIContentSizeCategoryString;
}




-(void) addNewItem_Helper{
   
    INWitem* new = [[INWItemStore sharedStore]createINWItem];
    SecondVC*  vc = [[SecondVC alloc]initWithNewItem:YES];
    vc.item = new;
    vc.refreshTVBlock =^{ [self.tableView reloadData];};

    // alloc init new SecondVC , Blank Data
    // show those second VC in MODAL
    
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
}



-(void) refreshSelf: (UIRefreshControl*) sender {
    
    [sender endRefreshing];

}

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

-(void(^)(void)) returnBlockforImagethumbQuickview{
    return ^{                    };
}

#pragma mark DynamicType

-(void) dynamicTypeUpdateFont:(NSNotification*) noti{
    UIFont* newfont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    NSArray* subviews = self.headerView.subviews;
    for(UILabel* label in subviews){
        label.font = newfont;
    }
}

#pragma mark Unused Methods (Old versions)

// this method is Oldversion (unused)
-(void) addNewRandomItemAndNewCell{
    // Reason why buggy : self.tableView max Index = 9 , but you InsertRow at 10.
    INWitem* new = [[INWItemStore sharedStore] createINWItem];
    // the moment you createdINWItem , store size +1
    NSInteger lastRow = [[[INWItemStore sharedStore]allItems] indexOfObject:new];
    // got the lastRow Index (9+1)
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    // generate indexPath , compatable for TableView system (0 - 10)
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationTop];
    
}
@end
