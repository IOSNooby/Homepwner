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
#import "SecondVC.h"

#import "neoCell.h"
#import "superCellClass.h"

#import "ImageStore.h"
#import "thumbStore.h"

@interface INWTableViewController ()

@property (strong,nonatomic) INWItemStore* store;

@property (nonatomic,strong) IBOutlet UIView* headerView;


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
#pragma mark Class Initializers

// this is Designate initializer

-(instancetype) initWithStyle:(UITableViewStyle)style{
    return [self init];
    }

-(instancetype) init{
    return [super initWithStyle:UITableViewStylePlain];
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





#pragma mark Cell Modifications 

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /// make test CustomCell using Xib
    
    // ---* this Code Work !!!*-----
    
    /*NSArray* n = [[NSBundle mainBundle]loadNibNamed:@"newCell" owner:self options:nil];

    newCellTableViewCell* cell  = [n firstObject];
    */
    /// testing
    
    UITableViewCell* cellOut;
    
    if(indexPath.row < [[[INWItemStore sharedStore]allItems]count]){
        superCellClass * cell = [tableView dequeueReusableCellWithIdentifier:@"SuperCellX" forIndexPath:indexPath];

        INWitem* item = [[INWItemStore sharedStore]allItems][indexPath.row];
       
        cell.Name.text = item.itemName;
        cell.serial.text = item.serialNumber;
        
        cell.value.text = [NSString  stringWithFormat:@"$%@",item.valueInDollars ] ;
        
        UIColor* colorForPrice;
        
        if(item.valueInDollars.integerValue > 99){
              colorForPrice = [UIColor redColor];
        }
        else {colorForPrice = [UIColor greenColor];
        }

        cell.value.textColor = colorForPrice;
        
        // fetch from dictionary (shallow store)
         UIImage* img = [[thumbStore sharedStore] loadFromPersistentByKey:item.myUUID];
         [[thumbStore sharedStore]addImageToDic:img WithKey:item.myUUID];
        
        cell.imageThumb.image =  [[thumbStore sharedStore]imageDic][item.myUUID] ;
        
        NSLog(@"IMG THUMB = %@",cell.imageThumb);

        cellOut = cell;
    }
    else if(indexPath.row == [[[INWItemStore sharedStore] allItems]count]){
        neoCell* neoCell = [tableView dequeueReusableCellWithIdentifier:@"neoCellX" forIndexPath:indexPath];
        // name the last View cell appearance
        neoCell.myLabel.text = @"...";
        cellOut = neoCell;
    }
    
    return cellOut;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
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
        toreturn  = @"Remove YO!";
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
