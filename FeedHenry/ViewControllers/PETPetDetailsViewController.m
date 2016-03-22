//
// Created by David Newman on 3/14/16.
// Copyright (c) 2016 bluefletch. All rights reserved.
//

#import "PETPetDetailsViewController.h"
#import "PETPet.h"
#import "PETPetService.h"
#import "PETTask.h"

NSString *const taskCellId = @"taskCellIdDefault";

@interface PETPetDetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) PETPetService *petService;
@end

@implementation PETPetDetailsViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.petService = [PETPetService new];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(createTaskPressed)];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)createTaskPressed {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add New Task" message:@"What's the task's name?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Add Task"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *theAction) {
                                                       // Going with a static frequency to simplify demo
                                                       [_petService createTaskForPet:self.pet withName:[alert.textFields.firstObject text] frequency:60*60*12];
                                                       [_tableView reloadData];
                                                   }];
    [alert addAction:action];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pet.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PETTask *task = self.pet.tasks[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:taskCellId];
    }

    cell.textLabel.text = task.name;
    switch (task.status) {
        case TaskStatusNeedsAttention:
            cell.textLabel.textColor = [UIColor redColor];
            break;
        case TaskStatusWillNeedAttention:
            cell.textLabel.textColor = [UIColor orangeColor];
            break;
        case TaskStatusDoesntNeedAttention:
            cell.textLabel.textColor = [UIColor greenColor];
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewRowAction *deleteAction = [UITableViewRowAction
            rowActionWithStyle:UITableViewRowActionStyleDestructive
                         title:@"Delete"
                       handler:^(UITableViewRowAction *action, NSIndexPath *index) {
                           [self deleteItemForIndexPath:index fromTableView:tableView];
                       }];
    deleteAction.backgroundColor = [UIColor redColor];

    UITableViewRowAction *completeAction = [UITableViewRowAction
            rowActionWithStyle:UITableViewRowActionStyleDefault
                         title:@"Complete"
                       handler:^(UITableViewRowAction *action, NSIndexPath *index) {
                           PETTask *task = self.pet.tasks[index.row];
                           task.lastPerformedDate = [NSDate date];
                           task.nextPerformedDate = [NSDate dateWithTimeIntervalSinceNow:task.frequency];
                           [self.tableView reloadData];
                           [self.petService updatePet:self.pet];
                       }];

    completeAction.backgroundColor = [UIColor greenColor];



    return @[deleteAction, completeAction];
}

- (void)deleteItemForIndexPath:(NSIndexPath *)indexPath fromTableView:(UITableView *)tableView  {
    [self.pet.tasks removeObjectAtIndex:indexPath.row];
    [self.petService updatePet:self.pet];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}



@end