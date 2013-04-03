//
//  GCAccordionView.h
//  GCAccordion
//
//  Created by Gennady Chukin on 02.04.13.
//  Copyright (c) 2013 Gennady Chukin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCAccordionView;

@class GCAccordionHeaderView;

@protocol GCAccordionHeaderViewDelegate <NSObject>

- (void) didTouchAcordionHeaderView:(GCAccordionHeaderView *) headerView inSection: (NSInteger) section;

@end

@interface GCAccordionHeaderView : UIView {
    UIImageView *disclosureIndicatorView;
}

@property (nonatomic, readonly) NSInteger section;
-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)section delegate:(id <GCAccordionHeaderViewDelegate>)delegate;
@property (nonatomic, weak) id <GCAccordionHeaderViewDelegate> delegate;

@property (nonatomic) BOOL opened;

@property (nonatomic, strong) UIImage *disclosureIndicator;
@property (nonatomic) CGAffineTransform openTransform;

@end


@protocol GCAccordionViewDelegate <NSObject, UITableViewDelegate>

//Configuring Rows for the Table View
/*– tableView:heightForRowAtIndexPath:
– tableView:indentationLevelForRowAtIndexPath:
– tableView:willDisplayCell:forRowAtIndexPath:
 */
//Managing Accessory Views
/*– tableView:accessoryButtonTappedForRowWithIndexPath:
– tableView:accessoryTypeForRowWithIndexPath: Deprecated in iOS 3.0
 */
//Managing Selections
/*– tableView:willSelectRowAtIndexPath:
– tableView:didSelectRowAtIndexPath:
– tableView:willDeselectRowAtIndexPath:
– tableView:didDeselectRowAtIndexPath:
 */
//Modifying the Header and Footer of Sections
- (CGFloat) accordionView:(GCAccordionView *)accordionView heightForHeaderInSection:(NSInteger)section;
- (UIView *) accordionView:(GCAccordionView *)accordionView viewForHeaderInSection:(NSInteger)section;
/*– tableView:viewForHeaderInSection:
– tableView:viewForFooterInSection:

– tableView:heightForFooterInSection:
– tableView:willDisplayHeaderView:forSection:
– tableView:willDisplayFooterView:forSection:
 */
//Editing Table Rows
/*– tableView:willBeginEditingRowAtIndexPath:
– tableView:didEndEditingRowAtIndexPath:
– tableView:editingStyleForRowAtIndexPath:
– tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:
– tableView:shouldIndentWhileEditingRowAtIndexPath:
 */
//Reordering Table Rows
/*– tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:*/
//Tracking the Removal of Views
/*– tableView:didEndDisplayingCell:forRowAtIndexPath:
– tableView:didEndDisplayingHeaderView:forSection:
– tableView:didEndDisplayingFooterView:forSection:*/
//Copying and Pasting Row Content
/*– tableView:shouldShowMenuForRowAtIndexPath:
– tableView:canPerformAction:forRowAtIndexPath:withSender:
– tableView:performAction:forRowAtIndexPath:withSender:*/
//Managing Table View Highlighting
/*– tableView:shouldHighlightRowAtIndexPath:
– tableView:didHighlightRowAtIndexPath:
– tableView:didUnhighlightRowAtIndexPath:*/
@end

@protocol GCAccordionViewDataSource <NSObject>

- (NSInteger) numberOfSectionsInAccordionView: (GCAccordionView *) accordionView;

- (NSInteger) accordionView:(GCAccordionView *)accordionView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *) accordionView: (GCAccordionView *) accordionView cellForRowAtIndexPath: (NSIndexPath *) indexPath;

- (NSString *) accordionView: (GCAccordionView *) accordionView titleForHeaderInSection: (NSInteger) section;


/////////////////////
- (BOOL) accordionView: (GCAccordionView *) accordionView canExpandColapseSection: (NSInteger) section;

//Inserting or Deleting Table Rows

- (void) accordionView: (GCAccordionView *) accordionView commitEditingStyle: (UITableViewStyle *) style forRowAtIndexPath: (NSIndexPath *) indexPath;
- (BOOL) accordionView: (GCAccordionView *) accordionView canEditRowAtIndexPath: (NSIndexPath *) indexPath;

//Reordering Table Rows
//– tableView:canMoveRowAtIndexPath:
//– tableView:moveRowAtIndexPath:toIndexPath:


@end

@interface GCAccordionView : UITableView<UITableViewDataSource, UITableViewDelegate, GCAccordionHeaderViewDelegate>


@property (nonatomic, assign) IBOutlet id <GCAccordionViewDataSource> accordionDataSource;
@property (nonatomic, assign) IBOutlet id <GCAccordionViewDelegate> accordionDelegate;
@property (nonatomic) BOOL multipleExpandable;

- (UITableViewCell *) cellWithIdentifier: (NSString *) identifier;
- (GCAccordionHeaderView *) defaultHeaderForSection: (NSInteger) section;
@end
