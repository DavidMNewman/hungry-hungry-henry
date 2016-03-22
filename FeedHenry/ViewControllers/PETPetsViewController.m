//
// Created by David Newman on 3/7/16.
// Copyright (c) 2016 bluefletch. All rights reserved.
//

@import Foundation;
#import <FH/FHSyncNotificationMessage.h>
#import "PETPetsViewController.h"
#import "PETPet.h"
#import "PETPetService.h"
#import "PETPetDetailsViewController.h"

NSString *const petCellId = @"petCellIdDefault";

@interface PETPetsViewController ()
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray<PETPet *> *pets;
@property(nonatomic, strong) PETPetService *petService;
@property(nonatomic, strong) PETPet *selectedPet;
@end

@implementation PETPetsViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _petService = [PETPetService new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPets) name:kFHSyncStateChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadPets];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFHSyncStateChangedNotification object:nil];
}

- (IBAction)addNewPetClicked:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add New Pet" message:@"What's their name?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Add Pet"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *theAction) {
                                                       [_petService createPetWithName:[alert.textFields.firstObject text]];
                                                       [self loadPets];
                                                   }];
    [alert addAction:action];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadPets {
    _pets = [_petService getAllPets];
    [_tableView reloadData];
}

#pragma mark - UITableView Delegate and DataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PETPet *pet = _pets[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:petCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:petCellId];
    }

    [[cell textLabel] setText:pet.name];
    [[cell detailTextLabel] setText:[PETPet stringFromPetStatus:pet.status]];
    switch (pet.status) {
        case PetStatusWillNeedAttention:
            [[cell detailTextLabel] setTextColor:[UIColor yellowColor]];
            break;
        case PetStatusDoesntNeedAttention:
            [[cell detailTextLabel] setTextColor:[UIColor grayColor]];
            break;
        default:
            [[cell detailTextLabel] setTextColor:[UIColor redColor]];
            break;
    }

    return cell;
}


#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedPet = _pets[indexPath.row];
    [self performSegueWithIdentifier:@"SeguePetDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    PETPetDetailsViewController *vc = (id) [segue destinationViewController];
    vc.pet = _selectedPet;
}


@end