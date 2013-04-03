//
//  GCAccordionView.m
//  GCAccordion
//
//  Created by Gennady Chukin on 02.04.13.
//  Copyright (c) 2013 Gennady Chukin. All rights reserved.
//

#import "GCAccordionView.h"

@implementation GCAccordionHeaderView

- (void) didTouch
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchAcordionHeaderView:inSection:)])  [self.delegate didTouchAcordionHeaderView:self inSection:self.section];
}

- (void) setOpened:(BOOL)opened
{
    if (_opened != opened)
    {
        _opened = opened;
        [UIView animateWithDuration:0.2 animations:^{
            if (_opened && disclosureIndicatorView)
                disclosureIndicatorView.transform = CGAffineTransformMakeRotation(M_PI_2);
            else
                disclosureIndicatorView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}

- (void) setDisclosureIndicator:(UIImage *)disclosureIndicator
{
    if (_disclosureIndicator != disclosureIndicator)
    {
        _disclosureIndicator = disclosureIndicator;
        if (!disclosureIndicatorView)
        {
            disclosureIndicatorView = [[UIImageView alloc] initWithImage:_disclosureIndicator];
            [self addSubview:disclosureIndicatorView];
            CGRect diframe = disclosureIndicatorView.frame;
            diframe.origin.x = 12;
            diframe.origin.y = self.frame.size.height/2-diframe.size.height/2;
            disclosureIndicatorView.frame = diframe;
        }
    }
}

- (void) setupOpenClose:(NSNotification *) notification
{
    if ([[notification.userInfo objectForKey:@"section"] isEqualToString:[NSString stringWithFormat:@"%d",self.section]])
    {
        self.opened = [[notification.userInfo objectForKey:@"opened"] boolValue];
    }
}

- (id) initWithFrame:(CGRect)frame title:(NSString *)title section:(NSInteger)section delegate:(id<GCAccordionHeaderViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:0.427 green:0.435 blue:0.459 alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
        label.backgroundColor= [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:17.0];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        _section = section;
        self.delegate = delegate;
        [self addSubview:label];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];
        [self addGestureRecognizer:tapGesture];
        _delegate = delegate;
        self.userInteractionEnabled = YES;
        self.opened = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupOpenClose:) name:@"DidOpenCloseSection" object:nil];
    }
    return  self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


@interface GCAccordionView ()

@property (nonatomic, strong, readonly) NSMutableArray *expandedSections;


@end


@implementation GCAccordionView


- (void) setup
{
    self.delegate = self;
    self.dataSource = self;
    self.multipleExpandable = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id) init
{
    self  = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void) setDataSource:(id<UITableViewDataSource>)dataSource
{
    if (dataSource == self) [super setDataSource:dataSource];
}

- (void) setDelegate:(id<UITableViewDelegate>)delegate
{
    if (delegate == self) [super setDelegate:delegate];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.accordionDataSource) return [self.accordionDataSource numberOfSectionsInAccordionView:self]; else return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.accordionDataSource)
    {
        if (![_expandedSections containsObject: [NSString stringWithFormat:@"%d", section]]) return  0;
        return [self.accordionDataSource accordionView:self numberOfRowsInSection:section];
    }else return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.accordionDataSource) return [self.accordionDataSource accordionView:self cellForRowAtIndexPath:indexPath]; else return nil;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.accordionDataSource)
    {
        NSString * title;
        if ([self.accordionDataSource respondsToSelector:@selector(accordionView:titleForHeaderInSection:)]) title = [self.accordionDataSource accordionView:self titleForHeaderInSection:section];
        if (!title) title = [NSString stringWithFormat:@"Section %d", section];
        return title;
    } else return nil;
}


#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.accordionDelegate && [self.accordionDelegate respondsToSelector:@selector(accordionView:heightForHeaderInSection:)]) return [self.accordionDelegate accordionView:self heightForHeaderInSection:section]; else return 50;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GCAccordionHeaderView *headerView;
    if (self.accordionDelegate && [self.accordionDelegate respondsToSelector:@selector(accordionView:viewForHeaderInSection:)])
    {
        headerView = [self.accordionDelegate accordionView:self viewForHeaderInSection:section];
    } else {
        NSString *title = ([self.accordionDataSource respondsToSelector:@selector(accordionView:titleForHeaderInSection:)]) ? [self.accordionDataSource accordionView:self titleForHeaderInSection:section] : [self tableView:tableView titleForHeaderInSection:section];
        headerView = [[GCAccordionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50) title:title section:section delegate:self];
    }
    headerView.disclosureIndicator = [UIImage imageNamed:@"arrow.png"];
    headerView.opened = [self isExpandedSection:section];
    return headerView;
}

#pragma  mark - Expand Collapse Logic

- (BOOL) isExpandedSection: (NSInteger) section
{
    if (!_expandedSections) _expandedSections = [[NSMutableArray alloc] init];
    return [_expandedSections containsObject:[NSString stringWithFormat:@"%d", section]];
}


- (void) expandSection: (NSInteger) section
{
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    if (![self isExpandedSection:section])
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",section], @"section", [NSNumber numberWithBool:YES], @"opened", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidOpenCloseSection" object:nil userInfo:userInfo];
        if (!self.multipleExpandable)
        {
            for (NSString *sectionToCollapse in _expandedSections) {
                [self collapseSection:[sectionToCollapse integerValue]];
            }
        }
        [_expandedSections addObject:[NSString stringWithFormat:@"%d", section]];
        for (NSInteger i = 0; i<[self tableView:self numberOfRowsInSection:section]; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        [self beginUpdates];
        [self insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationTop];
        [self endUpdates];
    }
}

- (void) collapseSection: (NSInteger) section
{
    if ([self isExpandedSection:section])
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",section], @"section", [NSNumber numberWithBool:NO], @"opened", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidOpenCloseSection" object:nil userInfo:userInfo];
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        //Collapse logic
        for (NSInteger i = 0; i<[self tableView:self numberOfRowsInSection:section]; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        [_expandedSections removeObject:[NSString stringWithFormat:@"%d", section]];
        [self beginUpdates];
        [self deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
        [self endUpdates];
    }
}

- (void) toggleSection: (NSInteger) section
{
    if (self.accordionDataSource && [self.accordionDataSource respondsToSelector:@selector(accordionView:canExpandColapseSection:)] && [self.accordionDataSource accordionView:self canExpandColapseSection:section])
    {
        if ([self isExpandedSection:section]) [self collapseSection:section]; else [self expandSection:section];
    }
}

#pragma mark - GCAccordionHeaderViewDelegate

- (void) didTouchAcordionHeaderView:(GCAccordionHeaderView *)headerView inSection:(NSInteger)section
{
    [self toggleSection:section];
}


#pragma mark - helpers
- (UITableViewCell *) cellWithIdentifier:(NSString *)identifier
{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    return cell;
}

@end
