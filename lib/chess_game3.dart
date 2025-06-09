import 'package:flutter/material.dart';
import 'package:flutter_chess_game/chess_board.dart';
import 'package:flutter_chess_game/helper/helper_methods.dart';
import 'package:flutter_chess_game/utils/chess_piece.dart';
import 'package:flutter_chess_game/utils/square.dart';

class ChessGame3 extends StatefulWidget {
  const ChessGame3({super.key});

  @override
  State<ChessGame3> createState() => _ChessGame3State();
}

class _ChessGame3State extends State<ChessGame3> {
  ChessPiece? selectedPiece;
  int selectedRow = -1;
  int selectedCol = -1;

  late List<List<ChessPiece?>> board;

  List<List<int>> validMoves = [];

  List<ChessPiece> whiteKilledPieces = []; //by black player

  List<ChessPiece> blackKilledPieces = []; //by white player

  bool isWhiteTurn = true;

  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    List<List<ChessPiece?>> newBoard = List.generate(
      8,
      (_) => List.generate(8, (_) => null),
    );
    //for pawns in board initially
    for (int col = 0; col < 8; col++) {
      newBoard[1][col] = ChessPiece(ChessPieceType.pawn, false);
      newBoard[6][col] = ChessPiece(ChessPieceType.pawn, true);
    }
    // Place back rank pieces (simplified: only knights and kings for demo)
    newBoard[0][0] = ChessPiece(ChessPieceType.rook, false);
    newBoard[0][1] = ChessPiece(ChessPieceType.knight, false);
    newBoard[0][2] = ChessPiece(ChessPieceType.bishop, false);
    newBoard[0][3] = ChessPiece(ChessPieceType.queen, false);
    newBoard[0][4] = ChessPiece(ChessPieceType.king, false);
    // newBoard[4][4] = ChessPiece(ChessPieceType.knight, false);
    newBoard[0][5] = ChessPiece(ChessPieceType.bishop, false);
    newBoard[0][6] = ChessPiece(ChessPieceType.knight, false);
    newBoard[0][7] = ChessPiece(ChessPieceType.rook, false);
    newBoard[7][0] = ChessPiece(ChessPieceType.rook, true);
    newBoard[7][1] = ChessPiece(ChessPieceType.knight, true);
    newBoard[7][2] = ChessPiece(ChessPieceType.bishop, true);
    newBoard[7][3] = ChessPiece(ChessPieceType.queen, true);
    newBoard[7][5] = ChessPiece(ChessPieceType.bishop, true);
    newBoard[7][4] = ChessPiece(ChessPieceType.king, true);
    newBoard[7][6] = ChessPiece(ChessPieceType.knight, true);
    newBoard[7][7] = ChessPiece(ChessPieceType.rook, true);
    board = newBoard;
  }

  void _pieceSelected(int row, int col) {
    setState(() {
      // if no0 selection is made, this is what initially happendss
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          // Select a piece of the current player's color
          selectedRow = row;
          selectedCol = col;
          selectedPiece = board[row][col];
        }
      }
      //this is to change the selected piece of the surrent collor.
      //eg, to select the king when i am currrently selecting the
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedRow = row;
        selectedCol = col;
        selectedPiece = board[row][col];
      }
      // if theer is a piece and user taps on a swaure that is valid move , it moves there
      else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }
      validMoves = calculateRealValidMoves(
        selectedRow,
        selectedCol,
        selectedPiece,
        true,
      );
    });
  }

  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];
    if (piece == null) {
      return [];
    }
    int direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        // if the move we trying to make is in the board
        if (isInboard(row, col) && board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }
        // for firt move, 2 moves Allowed,
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInboard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }
        // this is to retunn moves when another kill can be done diagonally
        if (isInboard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (isInboard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }
        break;
      case ChessPieceType.rook:
        var directions = [
          [-1, 0], //up
          [1, 0], //doown
          [0, -1], //left
          [0, 1], //right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = row + i * direction[1];
            //there is no next move, ie end of the board
            if (!isInboard(newRow, newCol)) {
              break;
            }

            // killing the opposite color if there is another color in the new row+col
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:

        // All possible moves for a knight (L-shaped: 2 in one direction, 1 in perpendicular)
        List<List<int>> knightMoves = [
          [-2, -1], // 2 up, 1 left
          [-2, 1], // 2 up, 1 right
          [-1, -2], // 1 up, 2 left
          [-1, 2], // 1 up, 2 right
          [1, -2], // 1 down, 2 left
          [1, 2], // 1 down, 2 right
          [2, -1], // 2 down, 1 left
          [2, 1], // 2 down, 1 right
        ];
        for (var move in knightMoves) {
          int newRow = row + move[0];
          int newCol = col + move[1];
          if (!isInboard(newRow, newCol)) {
            continue;
          }
          // killing the opposite color if there is another color in the new row+col
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }

          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChessPieceType.bishop:
        // Bishop moves diagonally in all four directions
        var directions = [
          [-1, -1], // up-left
          [-1, 1], // up-right
          [1, -1], // down-left
          [1, 1], // down-right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInboard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([
                  newRow,
                  newCol,
                ]); //can kill the opposite color
              }
              break; //block the next move if the color is same.
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
        var directions = [
          [-1, 0], // up
          [1, 0], // down
          [0, -1], // left
          [0, 1], // right
          [-1, -1], // up-left
          [-1, 1], // up-right
          [1, -1], // down-left
          [1, 1], // down-right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInboard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        var directions = [
          [-1, 0], // up
          [1, 0], // down
          [0, -1], // left
          [0, 1], // right
          [-1, -1], // up-left
          [-1, 1], // up-right
          [1, -1], // down-left
          [1, 1], // down-right
        ];
        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if (!isInboard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;

      default:
    }
    return candidateMoves;
  }

  //calculate real valid moves
  List<List<int>> calculateRealValidMoves(
    int row,
    int col,
    ChessPiece? piece,
    bool checkSimulation,
  ) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculateRawValidMoves(row, col, piece);

    // filter out other move that can put king in check Status(),
    if (checkSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];
        if (simulationMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }
    return realValidMoves;
  }

  void movePiece(int newRow, int newCol) {
    // storing the killed pieces
    if (board[newRow][newCol] != null) {
      var killedPiece = board[newRow][newCol];
      if (killedPiece!.isWhite) {
        whiteKilledPieces.add(killedPiece);
      } else {
        blackKilledPieces.add(killedPiece);
      }
    }

    if (selectedPiece!.type == ChessPieceType.king) {
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }
    if (isKingInChecked(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });
    if (isCheckMate(!isWhiteTurn)) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog.adaptive(
              title: Text("CHECKMATE"),
              actions: [
                TextButton(
                  onPressed: () {
                    
      Navigator.pop(context);
      resetGame();
                  },
                  child: Text("Restart the game"),
                ),
              ],
            ),
      );
    }
    isWhiteTurn = !isWhiteTurn;
  }

  bool isKingInChecked(bool isWhiteKing) {
    // Use a list to store the king's position
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;
    // int kingRow = kingPosition[0];
    // int kingCol = kingPosition[1];

    // Check all opponent pieces to see if any can attack the king
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        // for same color, skip``
        if (board[row][col] == null ||
            board[row][col]!.isWhite == isWhiteKing) {
          continue;
        }

        //get the all available valid moves of  selected piece
        List<List<int>> pieceValidMoves = calculateRealValidMoves(
          row,
          col,
          board[row][col],
          false,
        );
        //return true is the kings position is any of this valid moves of the curret selected piece
        if (pieceValidMoves.any(
          (move) => move[0] == kingPosition[0] && move[1] == kingPosition[1],
        )) {
          return true;
        }
        // for (var move in pieceValidMoves) {
        //   if (move[0] == kingRow && move[1] == kingCol) {
        //     return true;
        //   }
        // }
      }
    }
    return false;
  }

  bool simulationMoveIsSafe(
    ChessPiece piece,
    int startRow,
    int startCol,
    int endRow,
    int endCol,
  ) {
    ChessPiece? originalDestinationPiece = board[endRow][endCol];
    //if the piece is king , save is cureent positionn and update to new one
    List<int>? originalKingPosition;
    if (piece.type == ChessPieceType.king) {
      originalKingPosition =
          piece.isWhite ? whiteKingPosition : blackKingPosition;

      //update king position
      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }

    // simulate the move
    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    // check if our king is underattack
    bool kingIsCheck = isKingInChecked(piece.isWhite);

    //restore to original state
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;

    //if the piece was king , restore its orifin position
    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }
    return !kingIsCheck;
  }

  bool isCheckMate(bool isWhiteKing) {
    // if king is not in check, it not Checkmate(),
    if (!isKingInChecked(isWhiteKing)) {
      return false;
    }

    //if there is at least one legal move for any  okayers piecesm then its not checkmate
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        // Check if the piece belongs to the player whose king is being checked
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves = calculateRealValidMoves(
          i,
          j,
          board[i][j],
          true,
        );
        if (pieceValidMoves.isNotEmpty) {
          return false;
        }
      }
    }

    // if none of the above conditions are met, then there is no legal moves left to make so it's checkmate
    return true;
  }

  void resetGame() {
    setState(() {
      _initializeBoard();
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
      whiteKilledPieces.clear();
      blackKilledPieces.clear();
      isWhiteTurn = true;
      whiteKingPosition = [7, 4];
      blackKingPosition = [0, 4];
      checkStatus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: resetGame,
        child: Text("Restart"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
              ),
              itemCount: whiteKilledPieces.length,
              itemBuilder: (context, index) {
                return whiteKilledPieces[index].symbol;
              },
            ),
          ),
          Text(checkStatus ? "CHECK ! ! !" : ""),
          Expanded(
            flex: 2,
            child: GridView.builder(
              itemCount: 64,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),

              itemBuilder: (context, index) {
                int row = index ~/ 8;
                int col = index % 8;
                bool isSelected = selectedRow == row && selectedCol == col;
                bool isValidMove = false;
                for (var position in validMoves) {
                  if (position[0] == row && position[1] == col) {
                    isValidMove = true;
                  }
                }
                return Center(
                  child: Square(
                    onTap: () {
                      return _pieceSelected(row, col);
                    },
                    isWhite: isWhite(index),
                    piece: board[row][col],
                    isSelected: isSelected,
                    isValidMove: isValidMove,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
              ),
              itemCount: blackKilledPieces.length,
              itemBuilder: (context, index) {
                return blackKilledPieces[index].symbol;
              },
            ),
          ),
        ],
      ),
    );
  }
}
