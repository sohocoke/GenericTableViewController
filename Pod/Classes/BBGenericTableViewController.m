//
//  GenericTableViewController.m
//  diagnostics
//
//  Created by Andy Park on 12/05/15.
//
//

#import "BBGenericTableViewController.h"

#import <YOLOKit/YOLO.h>
#import <SSDataSources/SSDataSources.h>


@interface BBGenericTableViewController ()
{
    SSArrayDataSource* arrayDataSource;
}
@end


@implementation BBGenericTableViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    id obj = [super initWithCoder:aDecoder];
    
    [self setupDataSource];
    
    return obj;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    id obj = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    [self setupDataSource];
    
    return obj;
}


#pragma mark - datasource

-(void) setupDataSource {
    arrayDataSource = [[SSArrayDataSource alloc] initWithItems:@[]];

    arrayDataSource.cellConfigureBlock = ^(UITableViewCell* cell, id<BBRowViewModel> modelObject, id c, id d) {
        cell.textLabel.text = modelObject.identifier;
    };
    
    arrayDataSource.tableActionBlock = ^(SSCellActionType a, id b, id c) {
        return NO;
    };
    
    self.tableView.dataSource = arrayDataSource;
}

#pragma mark - row management

-(NSString*)addRowForViewModel:(id<BBRowViewModel>)rowViewModel {
//    [[self memoryStorage] addItem:rowViewModel];
    
    [arrayDataSource appendItem:rowViewModel];
    
    // return a row id to be used as a handle for future operations
    return rowViewModel.identifier;
}

-(id<BBRowViewModel>)viewModelForRowId:(NSString*)rowId {
    // find from data source using rowId.
    id<BBRowViewModel> rowViewModel = arrayDataSource.allItems.find(^(id<BBRowViewModel> model){
        return [model.identifier isEqual:rowId];
    });
    
    return rowViewModel;
}

-(id<BBRowViewModel>)viewModelForIndexPath:(NSIndexPath*)indexPath {
    return arrayDataSource.allItems[indexPath.row];
}

-(UITableViewCell*)cellForViewModel:(id<BBRowViewModel>)rowViewModel {
    NSIndexPath* indexPath = [self indexPathForViewModel:rowViewModel];
    id resultCell = [self.tableView cellForRowAtIndexPath:indexPath];
    return resultCell;
}


#pragma mark -

-(NSArray*) items {
    return arrayDataSource.allItems;
}

-(void) setItems:(NSArray*)items {
    [arrayDataSource removeAllItems];
    [arrayDataSource appendItems:items];
    
    [self refreshTable];
}

-(void) touchItem:(id)item {
    NSUInteger i = [self.items indexOfObject:item];
    if (i != NSNotFound) {
        [arrayDataSource moveItemAtIndex:i toIndex:0];
    } else {
        NSLog(@"item %@ not found, so can't touch.", item);
    }
}

-(NSIndexPath*) indexPathForViewModel:(id<BBRowViewModel>)rowViewModel {
    return [arrayDataSource indexPathForItem:rowViewModel];
}

#pragma mark -

-(void) registerCellClass:(Class) cellClass {
//  REFACTOR push down.
//
    // STUB specific for ResultsViewController
    
    __weak BBGenericTableViewController* weakSelf = self;
    
    arrayDataSource.cellConfigureBlock = ^(UITableViewCell* cell, NSObject<BBRowViewModel>* model, id parentView, id indexPath) {
        [weakSelf populateCell:cell withObject:model];
    };
    
    arrayDataSource.cellCreationBlock = ^id(NSObject<BBRowViewModel>* model,
                                            UITableView *tableView,
                                            NSIndexPath *indexPath) {
        // TODO try dequeuing first.
        
        return [weakSelf cellForObject:model];
    };
}

-(void)refreshTable {
    //    HACK work around the yet-unexplained clobbering of datasource.
    self.tableView.dataSource = arrayDataSource;
    
    [self.tableView reloadData];
}

@end
