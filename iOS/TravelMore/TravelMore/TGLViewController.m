//
//  TGLViewController.m
//  TGLStackedViewExample
//
//  Created by Tim Gleue on 07.04.14.
//  Copyright (c) 2014 Tim Gleue ( http://gleue-interactive.com )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "TGLViewController.h"
#import "TGLCollectionViewCell.h"

@interface UIColor (randomColor)

+ (UIColor *)randomColor;

@end

@implementation UIColor (randomColor)

+ (UIColor *)randomColor {
    
    CGFloat comps[3];
    
    for (int i = 0; i < 3; i++) {
        
        NSUInteger r = arc4random_uniform(256);
        comps[i] = (CGFloat)r/255.f;
    }
    
    return [UIColor colorWithRed:comps[0] green:comps[1] blue:comps[2] alpha:1.0];
}
@end

@interface TGLViewController ()

@property (strong, readonly, nonatomic) NSMutableArray *cards;

@end

@implementation TGLViewController

@synthesize cards = _cards;

- (void)viewDidLoad {

    [super viewDidLoad];

    // Set to NO to prevent a small number
    // of cards from filling the entire
    // view height evenly and only show
    // their -topReveal amount
    //
    self.stackedLayout.fillHeight = YES;

    // Set to NO to prevent a small number
    // of cards from being scrollable and
    // bounce
    //
    self.stackedLayout.alwaysBounce = YES;
    
    // Set to NO to prevent unexposed
    // items at top and bottom from
    // being selectable
    //
    self.unexposedItemsAreSelectable = YES;
    
    if (self.doubleTapToClose) {
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        
        recognizer.delaysTouchesBegan = YES;
        recognizer.numberOfTapsRequired = 2;
        
        [self.collectionView addGestureRecognizer:recognizer];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}

#pragma mark - Accessors

- (NSMutableArray *)cards {

    NSString *file = [[NSBundle mainBundle] pathForResource:@"fri" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:file];
    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    if (_cards == nil) {
        NSArray *data = [dic1 objectForKey:@"data"];
        _cards = [NSMutableArray array];
        
        for (NSInteger i = 1; i < 13; i++) {
            NSDictionary *dic = data[i];
            NSDictionary *card = @{@"id":[dic objectForKey:@"id"], @"name" : [dic objectForKey:@"name"], @"color" : [UIColor randomColor] };
            
            [_cards addObject:card];
        }
        
    }
    
    return _cards;
}

-(void)managerRatingForCell:(TGLCollectionViewCell *)cell    {
    cell.rate1.hidden = YES;
    cell.rate2.hidden = YES;
    cell.rate3.hidden = YES;
    cell.rate4.hidden = YES;
    cell.rate5.hidden = YES;

    int random = [self randomNumber];
    if (random == 1) {
        cell.rate1.hidden = NO;
    } if (random == 2) {
        cell.rate1.hidden = NO;
        cell.rate2.hidden = NO;
    } if (random == 3) {
        cell.rate1.hidden = NO;
        cell.rate2.hidden = NO;
        cell.rate3.hidden = NO;
    } if (random == 4) {
        cell.rate1.hidden = NO;
        cell.rate2.hidden = NO;
        cell.rate3.hidden = NO;
        cell.rate4.hidden = NO;
    } if (random == 5) {
        cell.rate1.hidden = NO;
        cell.rate2.hidden = NO;
        cell.rate3.hidden = NO;
        cell.rate4.hidden = NO;
        cell.rate5.hidden = NO;
    }
}

#pragma mark - Actions

- (IBAction)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (int)randomNumber {
    return rand() % (5 - 1) + 1; //create the random number.
}

#pragma mark - CollectionViewDataSource protocol

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.cards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TGLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
    NSDictionary *card = self.cards[indexPath.item];
    
    cell.title = card[@"name"];
    cell.color = card[@"color"];

    dispatch_queue_t queue = dispatch_queue_create("", nil);
    dispatch_async(queue, ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",card[@"id"]]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.profilePic.image = [UIImage imageWithData:imageData];
        });
    });
    cell.timeVisited.text = [NSString stringWithFormat:@"%d time visited",[self randomNumber]];
    cell.imageView.image = [UIImage imageNamed:@"bg_1_blur"];
    [self managerRatingForCell:cell];
    return cell;
}

#pragma mark - Overloaded methods

- (void)moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    // Update data source when moving cards around
    //
    NSDictionary *card = self.cards[fromIndexPath.item];
    
    [self.cards removeObjectAtIndex:fromIndexPath.item];
    [self.cards insertObject:card atIndex:toIndexPath.item];
}

@end
