//
//  TSInspectorCell.h
//  Tetris
//
//  Created by Junren Wong on 2018/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSInspectorCell : UITableViewCell

@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

NS_ASSUME_NONNULL_END
