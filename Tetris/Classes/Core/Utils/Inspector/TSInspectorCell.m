//
//  TSInspectorCell.m
//  Tetris
//
//  Created by Junren Wong on 2018/11/15.
//

#import "TSInspectorCell.h"

@implementation TSInspectorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _urlLabel = [self generateLabel];
    _descLabel = [self generateLabel];
    _classLabel = [self generateLabel];
    
    [self.contentView addSubview:_urlLabel];
    [self.contentView addSubview:_descLabel];
    [self.contentView addSubview:_classLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    
    CGFloat x = 5, w = self.contentView.frame.size.width - 10;
    CGFloat y_offset = 5;
    CGFloat h = (self.contentView.frame.size.height - 2 * y_offset) / 3.0;
    
    _urlLabel.frame = CGRectMake(x, 0 * h + y_offset, w, h);
    _classLabel.frame = CGRectMake(x, 1 * h + y_offset, w, h);
    _descLabel.frame = CGRectMake(x, 2 * h + y_offset, w, h);
    
}

- (UILabel *)generateLabel {
    UILabel *label = [UILabel new];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    return label;
}

@end
