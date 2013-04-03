//
//  GCViewController.m
//  GCAccordion
//
//  Created by Gennady Chukin on 02.04.13.
//  Copyright (c) 2013 Gennady Chukin. All rights reserved.
//

#import "GCViewController.h"

@interface GCViewController ()

@end

@implementation GCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger) numberOfSectionsInAccordionView:(GCAccordionView *)accordionView
{
    return 30;
}

- (NSInteger) accordionView:(GCAccordionView *)accordionView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *) accordionView:(GCAccordionView *)accordionView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [accordionView cellWithIdentifier:@"Cell"];
}

- (NSString *) accordionView:(GCAccordionView *)accordionView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Секция %d", section];
}

- (BOOL) accordionView:(GCAccordionView *)accordionView canExpandColapseSection:(NSInteger)section
{
    return YES;
}
@end
