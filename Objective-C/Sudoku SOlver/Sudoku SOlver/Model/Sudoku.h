//
//  Sudoku.h
//  Sudoku SOlver
//
//  Created by Cosme Jordan on 04.02.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Sudoku : NSObject

typedef struct {
    int sudokuArray[9][9];
} SudokuWrapper;

typedef struct  {
    int original[9][9];
    int solution[9][9];
    int numberSolutions;
} SudokuSolutions;

- (instancetype)init;

- (SudokuWrapper*)getArray;
- (void)setElementX:(int)x Y:(int) y;
- (NSNumber*)getElementX:(int)x Y:(int) y;
- (SudokuSolutions)createRandomBoard;

- (SudokuSolutions)generateSudoku:(int)difficulty;
- (void)solve;



@end

NS_ASSUME_NONNULL_END
