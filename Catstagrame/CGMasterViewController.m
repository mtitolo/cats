//
//  CGMasterViewController.m
//  Catstagrame
//
//  Created by Michele Titolo on 6/13/13.
//  Copyright (c) 2013 Michele Titolo.
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
//

#import "CGMasterViewController.h"
#import "CGWebService.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSArray+IndexPaths.h"
#import "CGCatPhotoCell.h"

#define kCellImageViewTag                   20
#define kLoadMoreContentOffsetDistance      100 * 3

@interface CGMasterViewController ()

@property (strong, nonatomic) NSArray* catPhotos;
@property (strong, nonatomic) NSNumber* nextMaxID;
@property (assign, nonatomic) BOOL loadingMore;

@end

@implementation CGMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.collectionView registerClass:[CGCatPhotoCell class] forCellReuseIdentifier:@"CatCell"];
    
    [[CGWebService defaultService] getCatsWithNextMaxID:nil success:^(NSHTTPURLResponse *response, id JSON) {
        self.catPhotos = JSON[@"data"];
        self.nextMaxID = JSON[@"pagination"][@"next_max_id"];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Error getting cat photos: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMore
{
    self.loadingMore = YES;
    [[CGWebService defaultService] getCatsWithNextMaxID:self.nextMaxID success:^(NSHTTPURLResponse *response, id JSON) {
        int start = self.catPhotos.count;
        NSArray* newCats = JSON[@"data"];
        self.catPhotos = [self.catPhotos arrayByAddingObjectsFromArray:newCats];
        self.nextMaxID = JSON[@"pagination"][@"next_max_id"];
        [self.collectionView insertItemsAtIndexPaths:[NSArray arrayOfIndexPathsForRange:NSMakeRange(start, newCats.count)]];
        self.loadingMore = NO;
    } failure:^(NSError *error) {
        NSLog(@"Error getting cat photos: %@", error);
        self.loadingMore = NO;
    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.catPhotos.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGCatPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CatCell" forIndexPath:indexPath];
    
    NSDictionary* cellData = self.catPhotos[indexPath.row];
    
    NSString* imageURLString = cellData[@"images"][@"standard_resolution"][@"url"];
    
    if ([[UIScreen mainScreen] scale] < 2.0) {
        imageURLString = cellData[@"images"][@"low_resolution"][@"url"];
    }
    
    [cell.catImageView setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:[UIImage imageNamed:@"catPlaceholder"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        NSLog(@"-");
    }];

    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat loadMoreContentOffset = scrollView.contentSize.height - kLoadMoreContentOffsetDistance;
    
    if (!self.loadingMore && scrollView.contentOffset.y >= loadMoreContentOffset) {
        [self loadMore];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
