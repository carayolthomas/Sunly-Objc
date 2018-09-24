//
//  DashboardViewController.m
//  Sunly
//
//  Created by Thomas Carayol on 21/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "DashboardViewController.h"
#import "UIButton+Swag.h"
#import "WeatherCollectionViewCell.h"
#import "Constants.h"

#import <Lottie/Lottie.h>

@interface DashboardViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) LOTAnimationView *animationView;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.isAccessibilityElement = YES;
    self.collectionView.accessibilityIdentifier = @"Shadow";
    [[self presenter] viewDidLoad];
}

#pragma mark - DashboardPresenterToView

- (void)showWelcomeMessage:(NSString *)message {
    [self setTitle:message];
}

- (void)showComputing {
    [self showMainAnimation];
}

- (void)hideComputing {
    [self hideMainAnimation];
}

- (void)reloadData {
    [[self collectionView] performBatchUpdates:^{
        [[self collectionView] reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:nil];
}

#pragma mark - Lottie animation

- (void)showMainAnimation {
    if (!self.animationView) {
        self.animationView = [LOTAnimationView animationNamed:@"compute-data-animation"];
        [self.animationView setContentMode:UIViewContentModeScaleAspectFit];
        [self.animationView setLoopAnimation:YES];
        [self.animationView setAnimationSpeed:1.f];
        [self.animationView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.animationView play];
        [[self view] addSubview:self.animationView];
        [[[self.animationView centerXAnchor] constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
        [[[self.animationView centerYAnchor] constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
        [[[self.animationView widthAnchor] constraintEqualToConstant:200.f] setActive:YES];
        [[[self.animationView heightAnchor] constraintEqualToConstant:200.f] setActive:YES];
    } else {
        [self.animationView play];
    }
}

- (void)hideMainAnimation {
    if (self.animationView) {
        [self.animationView stop];
        [self.animationView setHidden:YES];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[self presenter] numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self presenter] numberOfRowsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WeatherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WeatherCollectionViewCellIdentifier forIndexPath:indexPath];
    [cell reload:[[self presenter] image:indexPath]
          topText:[[self presenter] purpose:indexPath]
          midText:[[self presenter] temperatureLocation:indexPath]
          bottomText:[[self presenter] info:indexPath]
          shadowColor:[[self presenter] shadowColor:indexPath]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(UIScreen.mainScreen.bounds.size.width - 60, 200);
}

@end
