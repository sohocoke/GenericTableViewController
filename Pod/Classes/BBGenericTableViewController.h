//
//  GenericViewController.h
//  diagnostics
//
//  Created by Andy Park on 12/05/15.
//
//

#import "BBRowViewModel.h"


@interface BBGenericTableViewController : UITableViewController

@property NSArray* items;

-(void) touchItem:(id)item;


-(NSString*)addRowForViewModel:(id<BBRowViewModel>)rowViewModel;


-(id<BBRowViewModel>)viewModelForRowId:(NSString*)rowId;

-(id<BBRowViewModel>)viewModelForIndexPath:(NSIndexPath*)indexPath;


-(UITableViewCell*)cellForViewModel:(id<BBRowViewModel>)rowViewModel;

-(NSIndexPath*) indexPathForViewModel:(id<BBRowViewModel>)rowViewModel;


-(void)refreshTable;

-(void) registerCellClass:(Class) cellClass;



// subclasses to implement, should they register a custom cell class.

-(void)populateCell:(id)cell withObject:(id)model;

-(UITableViewCell*)cellForObject:(id)model;

@end
