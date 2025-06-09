import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';

enum PieceType { king, queen, rook, bishop, knight, pawn }

enum PieceColor { white, black }

class ChessPieces {
  final PieceType type;
  final PieceColor color;

  ChessPieces(this.type, this.color);

  Widget get symbol {
    switch (this.type) {
      case PieceType.king:
        return color == PieceColor.white ? WhiteKing() : BlackKing();
      case PieceType.queen:
        return color == PieceColor.white ? WhiteQueen() : BlackQueen();
      case PieceType.rook:
        return color == PieceColor.white ? WhiteRook() : BlackRook();
      case PieceType.bishop:
        return color == PieceColor.white ? WhiteBishop() : BlackBishop();
      case PieceType.knight:
        return color == PieceColor.white ? WhiteKnight() : BlackKnight();
      case PieceType.pawn:
        return color == PieceColor.white ? WhitePawn() : BlackPawn();
    }
  }
}

class ChessBoard extends StatefulWidget {
  @override
  _ChessBoardState createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  int? selectedRow, selectedCol;
  List<ChessPieces?> eliminatedPieces = [];
  // 8x8 board initialized with pieces
  List<List<ChessPieces?>> board = [];
  PieceColor currentTurn = PieceColor.white; // White starts
  List<Offset> validMoves = []; //
  @override
  void initState() {
    super.initState();
    board = List.generate(8, (_) => List.generate(8, (_) => null));
    setupBoard();
  }

  // Set up initial chess position
  void setupBoard() {
    // Place pawns
    for (int col = 0; col < 8; col++) {
      board[1][col] = ChessPieces(PieceType.pawn, PieceColor.black);
      board[6][col] = ChessPieces(PieceType.pawn, PieceColor.white);
    }
    // Place back rank pieces (simplified: only knights and kings for demo)
    board[0][0] = ChessPieces(PieceType.rook, PieceColor.black);
    board[0][1] = ChessPieces(PieceType.knight, PieceColor.black);
    board[0][2] = ChessPieces(PieceType.bishop, PieceColor.black);
    board[0][3] = ChessPieces(PieceType.queen, PieceColor.black);
    board[0][4] = ChessPieces(PieceType.king, PieceColor.black);
    board[0][5] = ChessPieces(PieceType.bishop, PieceColor.black);
    board[0][6] = ChessPieces(PieceType.knight, PieceColor.black);
    board[0][7] = ChessPieces(PieceType.rook, PieceColor.black);
    board[7][0] = ChessPieces(PieceType.rook, PieceColor.white);
    board[7][1] = ChessPieces(PieceType.knight, PieceColor.white);
    board[7][2] = ChessPieces(PieceType.bishop, PieceColor.white);
    board[7][3] = ChessPieces(PieceType.queen, PieceColor.white);
    board[7][5] = ChessPieces(PieceType.bishop, PieceColor.white);
    board[7][4] = ChessPieces(PieceType.king, PieceColor.white);
    board[7][6] = ChessPieces(PieceType.knight, PieceColor.white);
    board[7][7] = ChessPieces(PieceType.rook, PieceColor.white);
  }

  // Get valid moves for a piece
  List<Offset> getValidMoves(int row, int col) {
    List<Offset> moves = [];
    ChessPieces? piece = board[row][col];
    if (piece == null) return moves;

    if (piece.type == PieceType.pawn) {
      int direction = piece.color == PieceColor.white ? -1 : 1;
      int startRow = piece.color == PieceColor.white ? 6 : 1;

      // Move forward one square
      if (isValidSquare(row + direction, col) &&
          board[row + direction][col] == null) {
        moves.add(Offset((row + direction).toDouble(), col.toDouble()));
      }
      // Move forward two squares from starting position
      if (row == startRow &&
          isValidSquare(row + 2 * direction, col) &&
          board[row + direction][col] == null &&
          board[row + 2 * direction][col] == null) {
        moves.add(Offset((row + 2 * direction).toDouble(), col.toDouble()));
      }
      // Capture diagonally
      if (isValidSquare(row + direction, col - 1) &&
          board[row + direction][col - 1] != null &&
          board[row + direction][col - 1]!.color != piece.color) {
        moves.add(Offset((row + direction).toDouble(), (col - 1).toDouble()));
      }
      if (isValidSquare(row + direction, col + 1) &&
          board[row + direction][col + 1] != null &&
          board[row + direction][col + 1]!.color != piece.color) {
        moves.add(Offset((row + direction).toDouble(), (col + 1).toDouble()));
      }
    } else if (piece.type == PieceType.knight) {
      // Knight moves in L-shape
      List<Offset> knightMoves = [
        Offset(-2, -1),
        Offset(-2, 1),
        Offset(-1, -2),
        Offset(-1, 2),
        Offset(1, -2),
        Offset(1, 2),
        Offset(2, -1),
        Offset(2, 1),
      ];
      for (var move in knightMoves) {
        int newRow = row + move.dx.toInt();
        int newCol = col + move.dy.toInt();
        if (isValidSquare(newRow, newCol) &&
            (board[newRow][newCol] == null ||
                board[newRow][newCol]!.color != piece.color)) {
          moves.add(Offset(newRow.toDouble(), newCol.toDouble()));
        }
      }
    }
    // else if(piece.type==PieceType.queen){
    //   List<Offset> queenMkoves = [
    //     Offset(1, 0), Offset(-1, 0), Offset(0, 1), Offset(0, -1), // Rook moves
    //     Offset(1, 1), Offset(-1, -1), Offset(1, -1), Offset(-1, 1) // Bishop moves
    //   ];
    //   for(var move in queenMkoves) {
    //     for (int i = 1; i < 8; i++) {
    //       int newRow = row + (move.dx * i).toInt();
    //       int newCol = col + (move.dy * i).toInt();
    //       if (!isValidSquare(newRow, newCol)) break;
    //       if (board[newRow][newCol] == null) {
    //         moves.add(Offset(newRow.toDouble(), newCol.toDouble()));
    //       } else {
    //         if (board[newRow][newCol]!.color != piece.color) {
    //           moves.add(Offset(newRow.toDouble(), newCol.toDouble()));
    //         }
    //         break; // Stop at first piece
    //       }
    //     }
    //   }
    // }
    return moves;
  }

  // Check if a square is within the board
  bool isValidSquare(int row, int col) {
    return row >= 0 && row < 8 && col >= 0 && col < 8;
  } // Handle tap on a square

  void handleTap(int row, int col) {
    setState(() {
      if (selectedRow == null &&
          board[row][col] != null &&
          board[row][col]!.color == currentTurn) {
        // Select a piece of the current player's color
        selectedRow = row;
        selectedCol = col;
        validMoves = getValidMoves(row, col);
      } else if (selectedRow != null && selectedCol != null) {
        // Try to move to the tapped square
        if (validMoves.contains(Offset(row.toDouble(), col.toDouble()))) {
          // Move piece
          board[row][col] = board[selectedRow!][selectedCol!];
          // If capturing a piece, add it to eliminated pieces
          if (board[selectedRow!][selectedCol!]!= null &&
              board[selectedRow!][selectedCol!]!.color != currentTurn) {
            setState(() {
              eliminatedPieces.add(board[row][col]);
              board[row][col] = null; // Remove captured piece from board
              board[selectedRow!][selectedCol!] = null; // Remove moved piece
            });
          }
          board[selectedRow!][selectedCol!] = null;
          // Switch turns
          currentTurn =
              currentTurn == PieceColor.white
                  ? PieceColor.black
                  : PieceColor.white;
        }
        // Deselect
        selectedRow = null;
        selectedCol = null;
        validMoves = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.brown[100],
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(8.0),
              child: Row(
                children:
                    eliminatedPieces.map((piece) {
                      return piece != null && piece.color != PieceColor.black
                          ? piece.symbol
                          : SizedBox.shrink(); // Show piece symbol or empty space
                    }).toList(),
              ),
            ),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemCount: 64,
                itemBuilder: (context, index) {
                  int row = index ~/ 8;
                  int col = index % 8;
                  bool isLightSquare = (row + col) % 2 == 0;
                  bool isSelected = selectedRow == row && selectedCol == col;
                  bool isValidMove = validMoves.contains(
                    Offset(row.toDouble(), col.toDouble()),
                  );
              
                  return GestureDetector(
                    onTap: () => handleTap(row, col),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Colors.yellow[300] // Highlight selected piece
                                : isValidMove
                                ? Colors.green[300] // Highlight valid moves
                                : isLightSquare
                                ? Colors.brown[200]
                                : Colors.brown[700],
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Center(child: board[row][col]?.symbol ?? SizedBox()),
                    ),
                  );
                },
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(8.0),
              child: Row(
                children:
                    eliminatedPieces.map((piece) {
                      return piece != null && piece.color != PieceColor.white
                          ? piece.symbol
                          : SizedBox.shrink(); // Show piece symbol or empty space
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.brown[100],
  //     body: Container(
  //       height: MediaQuery.of(context).size.height,
  //       color: Colors.brown[100],
  //       child: GridView.builder(
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 8,
  //         ),
  //         itemCount: 64,
  //         itemBuilder: (BuildContext context, int index) {
  //           int row = index ~/ 8;
  //           int col = index % 8;

  //           return GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 if (selectedRow == null) {
  //                   selectedRow = row;
  //                   selectedCol = col;
  //                 } else {
  //                   if (selectedRow != row || selectedCol != col) {}
  //                   selectedRow = null;
  //                   selectedCol = null;
  //                 }
  //               });
  //             },
  //             child: Stack(
  //               children: [
  //                 Container(
  //                   decoration: BoxDecoration(
  //                     color:
  //                         (index ~/ 8 + index % 8) % 2 == 0
  //                             ? Colors.brown[200]
  //                             : Colors.brown[700],
  //                     border: Border.all(color: Colors.black12),
  //                   ),
  //                   child:
  //                       selectedRow == index ~/ 8 && selectedCol == index % 8
  //                           ? Center(
  //                             child: Icon(Icons.check, color: Colors.yellow),
  //                           )
  //                           : null,
  //                 ),
  //                 if ((index + 8) % 8 == 0) ...[
  //                   Positioned(child: Text("12"), left: 2),
  //                 ],
  //               ],
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  // void _initBoard() {
  //   // Place pawns
  //   for (int i = 0; i < 8; i++) {
  //     board[1][i] = ChessPiece(PieceType.pawn, PieceColor.black);
  //     board[6][i] = ChessPiece(PieceType.pawn, PieceColor.white);
  //   }
  //   // Place other pieces
  //   List<PieceType> order = [
  //     PieceType.rook,
  //     PieceType.knight,
  //     PieceType.bishop,
  //     PieceType.queen,
  //     PieceType.king,
  //     PieceType.bishop,
  //     PieceType.knight,
  //     PieceType.rook
  //   ];
  //   for (int i = 0; i < 8; i++) {
  //     board[0][i] = ChessPiece(order[i], PieceColor.black);
  //     board[7][i] = ChessPiece(order[i], PieceColor.white);
  //   }
  // }

  // void _onTileTap(int row, int col) {
  //   setState(() {
  //     if (selectedRow == null) {
  //       if (board[row][col] != null) {
  //         selectedRow = row;
  //         selectedCol = col;
  //       }
  //     } else {
  //       if (selectedRow != row || selectedCol != col) {
  //         board[row][col] = board[selectedRow!][selectedCol!];
  //         board[selectedRow!][selectedCol!] = null;
  //       }
  //       selectedRow = null;
  //       selectedCol = null;
  //     }
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return AspectRatio(
  //     aspectRatio: 1,
  //     child: Column(
  //       children: List.generate(8, (row) {
  //         return Expanded(
  //           child: Row(
  //             children: List.generate(8, (col) {
  //               bool isSelected = selectedRow == row && selectedCol == col;
  //               bool isLight = (row + col) % 2 == 0;
  //               return Expanded(
  //                 child: GestureDetector(
  //                   onTap: () => _onTileTap(row, col),
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                       color: isSelected
  //                           ? Colors.yellow
  //                           : isLight
  //                               ? Colors.brown[200]
  //                               : Colors.brown[700],
  //                       border: Border.all(color: Colors.black12),
  //                     ),
  //                     child: Center(
  //                       child: Text(
  //                         board[row][col]?.symbol ?? '',
  //                         style: TextStyle(
  //                           fontSize: 32,
  //                           color: board[row][col]?.color == PieceColor.white
  //                               ? Colors.white
  //                               : Colors.black,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             }),
  //           ),
  //         );
  //       }),
  //     ),
  //   );
  // }
}
