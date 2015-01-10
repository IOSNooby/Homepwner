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
#import "newCellTableViewCell.h"


@interface INWTableViewController ()

@property (strong,nonatomic) INWItemStore* store;

@property (nonatomic,strong) IBOutlet UIView* headerView;

@property (strong, nonatomic) IBOutlet newCellTableViewCell *myCell;

@end

@implementation INWTableViewController

@synthesize myCell = _myCell;

#pragma mark View Settings

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

/*

-(newCellTableViewCell*) myCell{
    
    if(!_myCell){
        
        NSLog(@"loadNib in myNewCell's getter ");

        [[NSBundle mainBundle]loadNibNamed:@"newCell"
                                     owner:self options:nil];
    }
    return _myCell;
}
*/

// this method loading the NIB (Graphics Information)
-(UIView*) headerView{
    
    if(!_headerView){
        [[NSBundle mainBundle] loadNibNamed:@"newCell"
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
    
    
    /*
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    */
    
    /*[self.tableView registerClass:[newCellTableViewCell class]
                        forCellReuseIdentifier:@"newCellX"];
    */
    UINib* thenib = [UINib nibWithNibName:@"newCell" bundle:nil];
    [self.tableView registerNib:thenib forCellReuseIdentifier:@"newCell"];
    [[NSBundle mainBundle]loadNibNamed:@"newCell" owner:self options:nil];
    
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self action:@selector(addNewItem_Helper)];
    
    [self.tableView setTableHeaderView:self.headerView];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath]; */
    
    /// make test CustomCell using Xib
    
    //[[NSBundle mainBundle]loadNibNamed:@"newCell" owner:self options:nil];

  /*  newCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"newCell"
                                                           forIndexPath:indexPath];
    */
    
    NSArray* n = [[NSBundle mainBundle]loadNibNamed:@"newCell" owner:self options:nil];
    
    newCellTableViewCell* cell  = [n firstObject];
    
    if(indexPath.row < [[[INWItemStore sharedStore]allItems]count]){
        INWitem* item = [[INWItemStore sharedStore]allItems][indexPath.row];
        cell.myLabel.text = item.itemName;
       // cell.textLabel.text = item.itemName;
    }
    else if(indexPath.row == [[[INWItemStore sharedStore] allItems]count]){
        // name the last View cell appearance
        cell.myLabel.text = @"...";
    }
    
    NSLog(@"What the HELL IS CELL NOW ? = %@",cell);

    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(void) tableView:(UITableView *)tableView
             commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
              forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row < [[[INWItemStore sharedStore]allItems] count]){
        
        if(editingStyle == UITableViewCellEditingStyleDelete){
        
            INWitem* item = [[INWItemStore sharedStore]allItems][indexPath.row];
            [[INWItemStore sharedStore] removeItem:item];
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
      }
    }
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

-(void) tableView:(UITableView *)tableView
                    moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
                           toIndexPath:(NSIndexPath *)destinationIndexPath{
    
      [[INWItemStore sharedStore] moveItemFromIndex:sourceIndexPath.row
                                          toIndex:destinationIndexPath.row];
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
    
    if(indexPath.row != [[[INWItemStore sharedStore]allItems]count]){
    
        NSMutableArray* itemArray = [[INWItemStore sharedStore] allItems];
    
        INWitem* a = [itemArray objectAtIndex:indexPath.row];
        
        SecondVC* detailVC = [[SecondVC alloc]init];
        detailVC.item = a;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
}



/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView 
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

#pragma mark Helpers Methods

// This method run inside both Navigation's SystemButton "Add" and also Xib custom Header "add" button

-(void) addNewItem_Helper{
    // Reason why buggy : self.tableView max Index = 9 , but you InsertRow at 10.
    INWitem* new = [[INWItemStore sharedStore] createINWItem];
    // the moment you createdINWItem , store size +1
    NSInteger lastRow = [[[INWItemStore sharedStore]allItems] indexOfObject:new];
    // got the lastRow Index (9+1)
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    // generate indexPath , compatable for TableView system (0 - 10)
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationTop];
    
    // At last , Insert ROW at [10] position
}



@end
