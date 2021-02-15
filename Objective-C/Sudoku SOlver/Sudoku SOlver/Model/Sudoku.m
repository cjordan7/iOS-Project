//
//  Sudoku.m
//  Sudoku SOlver
//
//  Created by Cosme Jordan on 04.02.21.
//

#import "Sudoku.h"

// Set to false for one solution. Set to true to get all solutions.
#define DOES_GET_ONE_SOLUTION true

@implementation Sudoku {

    SudokuWrapper array;
    SudokuSolutions sudokuSolutions;

    int FULL_NUMBER_ARRAY[9];

    int allCoordinatePairs[81][2];
}


- (instancetype)init {
    self = [super init];
    if(self) {
        sudokuSolutions = [self initSudokuSolutions];

        for(int i = 0; i < 9; ++i) {
            FULL_NUMBER_ARRAY[i] = i+1;
        }

        for(int i = 0; i < 9; ++i) {
            for(int j = 0; j < 9; ++j) {
                array.sudokuArray[i][j] = i;
            }
        }

        for(int i = 0; i < 9; ++i) {
            for(int j = 0; j < 9; ++j) {
                allCoordinatePairs[i*9+j][0] = i;
                allCoordinatePairs[i*9+j][1] = j;
            }
        }
    }
    return self;
}

- (void)swap:(int*)a b:(int*)b {
    int temp = *a;
    *a = *b;
    *b = temp;
}

- (void)swapPairs:(int*)a b:(int*)b {
    [self swap:&a[0] b:&b[0]];
    [self swap:&a[1] b:&b[1]];
}

- (void)shuffle:(int*)array {
    unsigned int seed = (unsigned int)time(NULL);
    srand(seed);

    for (int i = 8; i > 0; i--) {
        int j = rand() % (i + 1);

        [self swap:&array[i] b:&array[j]];
    }
}

- (SudokuWrapper*)getArray {
    return &(array);
}

- (void)setElementX:(int)x Y:(int) y {

}

- (NSNumber*)getElementX:(int)x Y:(int) y {
    return [NSNumber numberWithInt:array.sudokuArray[x][y]];
}

- (SudokuSolutions)createRandomBoard {
    SudokuSolutions solutions = [self initSudokuSolutions];

    [self shuffle:FULL_NUMBER_ARRAY];

    [self solveTemp:solutions.solution x:0 y:0 moreOne:true
          solutions:&solutions];

    [self copyCArraySudoku:solutions.original intoArraySudoku:solutions.solution];

    // TODO: Delete useless prints
    // [self printArray:solutions.original];
    // [self printArray:solutions.solution];
    return solutions;
}

- (SudokuSolutions)initSudokuSolutions {
    SudokuSolutions sudokuSolutions;
    sudokuSolutions.numberSolutions = 0;

    for(int i = 0; i < 9; ++i) {
        for(int j = 0; j < 9; ++j) {
            sudokuSolutions.original[i][j] = 0;
            sudokuSolutions.solution[i][j] = 0;
        }
    }

    return sudokuSolutions;
}

- (SudokuWrapper)initArray {
    SudokuWrapper array;
    array.sudokuArray[0][0] = 0;

    for(int i = 0; i < 9; ++i) {
        for(int j = 0; j < 9; ++j) {
            array.sudokuArray[i][j] = 0;
        }
    }

    return array;
}

- (int)getRandomNumberBetween:(int)from and:(int)to {
    return (int)from + arc4random() % (to-from+1);
}

- (SudokuWrapper)generateSudokuMethodOne {
    SudokuWrapper array = [self initArray];



    return array;
}

- (SudokuSolutions)generateSudoku:(int)difficulty {
   return [self deleteRandomElements:difficulty];
}

- (SudokuSolutions)deleteRandomElements:(int)difficulty {
    SudokuSolutions sudokuSolutions = [self createRandomBoard];

    [self printArray:sudokuSolutions.solution];

    int generateKNumber = difficulty;
    int saved[generateKNumber][2];

    for(int i = 0; i < generateKNumber; ++i) {
        saved[i][0] = 0;
        saved[i][1] = 0;
    }

    do {
        for(int i = 0; i < generateKNumber; ++i) {
            int end = 80-i;
            int index = [self getRandomNumberBetween:0 and:end];

            int x = allCoordinatePairs[index][0];
            int y = allCoordinatePairs[index][1];

            saved[i][0] = x;
            saved[i][1] = y;

            [self swapPairs:allCoordinatePairs[index] b:allCoordinatePairs[end]];

            sudokuSolutions.original[x][y] = 0;
        }

        sudokuSolutions.numberSolutions = 0;
        [self solveTemp:sudokuSolutions.original x:0 y:0 moreOne:true
              solutions:&sudokuSolutions];

        if(sudokuSolutions.numberSolutions >= 2) {
            for(int i  = 0; i < generateKNumber; ++i) {
                int temp = sudokuSolutions.solution[saved[i][0]][saved[i][1]];
                sudokuSolutions.original[saved[i][0]][saved[i][1]] = temp;
            }
        }
    } while(sudokuSolutions.numberSolutions >= 2);

    [self printArray:sudokuSolutions.original];
    [self printArray:sudokuSolutions.solution];

    return sudokuSolutions;
}

- (SudokuWrapper)generateSudokuMethodTwo {
    SudokuWrapper array = [self initArray];

    return array;
}

- (BOOL)checkLineArray:(int[9][9]) array x:(int)x y:(int)y number:(int)number {
    for(int i = 0; i < 9; ++i) {
        if(array[i][y] == number) {
            return false;
        }
    }

    return true;
}

- (BOOL)checkColumnArray:(int[9][9])array x:(int)x y:(int)y number:(int)number {
    for(int j = 0; j < 9; ++j) {
        if(array[x][j] == number) {
            return false;
        }
    }

    return true;
}

- (BOOL)check3x3Grid:(int[9][9])array x:(int)x y:(int)y number:(int)number{
    int startX = (x/3)*3;
    int startY = (y/3)*3;
    for(int i = 0; i < 3; ++i) {
        for(int j = 0; j < 3; ++j) {
            if(array[i+startX][j+startY] == number) {
                return false;
            }
        }
    }

    return true;
}

- (BOOL)canPlace:(int[9][9])array x:(int)x y:(int)y number:(int)number {
    return [self checkColumnArray:array x:x y:y number:number] &&
    [self checkLineArray:array x:x y:y number:number] &&
    [self check3x3Grid:array x:x y:y number:number];
}

- (void)copyArraySudoku:(int[9][9])array intoArraySudoku:(SudokuWrapper*)arraySudoku {
    for(int i = 0; i < 9; ++i) {
        for(int j = 0; j < 9; ++j) {
            arraySudoku->sudokuArray[i][j] = array[i][j];
        }
    }
}

- (void)copyCArraySudoku:(int[9][9])copyTo intoArraySudoku:(int[9][9])copyFrom {
    for(int i = 0; i < 9; ++i) {
        for(int j = 0; j < 9; ++j) {
            copyTo[i][j] = copyFrom[i][j];
        }
    }
}

- (NSArray*)cArrayToNSArray:(int[9][9])c2DArray {
    NSMutableArray* temp = [[NSMutableArray alloc] init];

    for(int i = 0; i < 9; ++i) {
        NSMutableArray* tempLine = [[NSMutableArray alloc] init];

        for(int j = 0; j < 9; ++j) {
            NSNumber* number = [NSNumber numberWithInt:c2DArray[i][j]];
            [tempLine addObject:number];
        }

        [temp addObject:tempLine];
    }

    return [NSArray arrayWithArray:temp];
}

- (BOOL)solveTempTrue:(int[9][9])array x:(int)x y:(int)y solutions:(SudokuSolutions*)solutions {
    return [self solveTemp:array x:x y:y moreOne:true
                 solutions:solutions];
}

- (BOOL)solveTemp:(int[9][9])array x:(int)x y:(int)y moreOne:(BOOL)moreOne solutions:(SudokuSolutions*)solutions {
    if(x == 8 && y == 9) {
        solutions->numberSolutions++;

        if(moreOne && solutions->numberSolutions >= 2) {
            return true;
        }

        return !DOES_GET_ONE_SOLUTION;
    }

    if(y == 9) {
        y = 0;
        ++x;
    }

    if(array[x][y] > 0) {
        return [self solveTemp:array x:x y:y+1 moreOne:moreOne
                     solutions:solutions];
    }

    for(int e = 0; e < 9; ++e) {
        if([self canPlace:array x:x y:y number:FULL_NUMBER_ARRAY[e]]) {
            array[x][y] = FULL_NUMBER_ARRAY[e];
            if([self solveTemp:array x:x y:y+1 moreOne:moreOne
                     solutions:solutions]) {
                return true;
            }

            array[x][y] = 0;
        }
    }

    return false;
}

- (void)solve {
    int grid[9][9] = {{0}};

    [self solveTemp:grid x:0 y:0 moreOne:false solutions:&(sudokuSolutions)];
}

- (void)printArray:(int[9][9])array {
    for(int i = 0; i < 9; ++i) {
        for(int j = 0; j < 9; ++j) {
            printf("%d ",array[i][j]);
        }

        printf("\n");
    }
    printf("\n\n");
}

@end
