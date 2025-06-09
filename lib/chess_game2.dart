// import 'package:chess/chess.dart' as ch;
// import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
// import 'package:flutter/material.dart';

// enum PieceType { king, queen, rook, bishop, knight, pawn }

// enum PieceColor { white, black }

// class ChessPiece {
//   final PieceType type;
//   final PieceColor color;

//   ChessPiece(this.type, this.color);

//   Widget get symbol {
//     switch (this.type) {
//       case PieceType.king:
//         return color == PieceColor.white ? WhiteKing() : BlackKing();
//       case PieceType.queen:
//         return color == PieceColor.white ? WhiteQueen() : BlackQueen();
//       case PieceType.rook:
//         return color == PieceColor.white ? WhiteRook() : BlackRook();
//       case PieceType.bishop:
//         return color == PieceColor.white ? WhiteBishop() : BlackBishop();
//       case PieceType.knight:
//         return color == PieceColor.white ? WhiteKnight() : BlackKnight();
//       case PieceType.pawn:
//         return color == PieceColor.white ? WhitePawn() : BlackPawn();
//     }
//   }
// }
// class ChessGame2 extends StatefulWidget {
//   const ChessGame2({super.key});

//   @override
//   State<ChessGame2> createState() => _ChessGame2State();
// }

// class _ChessGame2State extends State<ChessGame2> {
//  ch.Chess chess = ch.Chess();
//   String? selectedSquare;
//   List<String> possibleMoves = [];
//   List<String> moveHistory = [];
  
//   // Convert chess.dart piece to our custom ChessPiece
//   ChessPiece? convertPiece(ch.Piece? piece) {
//     if (piece == null) return null;
    
//     PieceType type=PieceType.pawn; // Default type
//     switch (piece.type) {
//       case ch.Chess.KING:
//         type = PieceType.king;
//         break;
//       case ch.Chess.QUEEN:
//         type = PieceType.queen;
//         break;
//       case ch.Chess.ROOK:
//         type = PieceType.rook;
//         break;
//       case ch.Chess.BISHOP:
//         type = PieceType.bishop;
//         break;
//       case ch.Chess.KNIGHT:
//         type = PieceType.knight;
//         break;
//       case ch.Chess.PAWN:
//         type = PieceType.pawn;
//         break;
//     }
    
//     PieceColor color = piece.color == ch.Color.WHITE ? PieceColor.white : PieceColor.black;
    
//     return ChessPiece(type, color);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.brown[50],
//       appBar: AppBar(
//         title: Text('Flutter Chess'),
//         backgroundColor: Colors.brown[800],
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           // Game status
//           Container(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Text(
//                   chess.game_over
//                       ? (chess.in_checkmate
//                           ? '${chess.turn ==ch.Color.WHITE ? 'Black' : 'White'} wins by checkmate!'
//                           : chess.in_stalemate
//                               ? 'Game drawn by stalemate'
//                               : chess.insufficient_material
//                                   ? 'Game drawn by insufficient material'
//                                   : 'Game over')
//                       : chess.in_check
//                           ? '${chess.turn ==ch. Color.WHITE ? 'White' : 'Black'} is in check!'
//                           : '${chess.turn ==ch. Color.WHITE ? 'White' : 'Black'} to move',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: chess.in_check ? Colors.red : Colors.brown[800],
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Move ${chess.move_number}',
//                   style: TextStyle(fontSize: 14, color: Colors.brown[600]),
//                 ),
//               ],
//             ),
//           ),
          
//           // Chess board
//           Expanded(
//             child: Center(
//               child: AspectRatio(
//                 aspectRatio: 1.0,
//                 child: Container(
//                   margin: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.brown[800]!, width: 3),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 8,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: buildChessBoard(),
//                 ),
//               ),
//             ),
//           ),
          
//           // Control buttons
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       chess.reset();
//                       selectedSquare = null;
//                       possibleMoves = [];
//                       moveHistory = [];
//                     });
//                   },
//                   child: Text('New Game'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.brown[700],
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: chess.history.isNotEmpty ? () {
//                     setState(() {
//                       chess.undo_move();
//                       selectedSquare = null;
//                       possibleMoves = [];
//                       if (moveHistory.isNotEmpty) {
//                         moveHistory.removeLast();
//                       }
//                     });
//                   } : null,
//                   child: Text('Undo'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.brown[700],
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text('Move History'),
//                           content: Container(
//                             width: double.maxFinite,
//                             height: 300,
//                             child: ListView.builder(
//                               itemCount: chess.history.length,
//                               itemBuilder: (context, index) {
//                                 return ListTile(
//                                   leading: Text('${index + 1}.'),
//                                   title: Text(chess.history[index]['san']),
//                                 );
//                               },
//                             ),
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.of(context).pop(),
//                               child: Text('Close'),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                   child: Text('History'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.brown[700],
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildChessBoard() {
//     return GridView.builder(
//       physics: NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 8,
//       ),
//       itemCount: 64,
//       itemBuilder: (context, index) {
//         int row = index ~/ 8;
//         int col = index % 8;
//         String square = '${String.fromCharCode(97 + col)}${8 - row}';
        
//         bool isLight = (row + col) % 2 == 0;
//         bool isSelected = selectedSquare == square;
//         bool isPossibleMove = possibleMoves.contains(square);
//         bool isLastMove = moveHistory.isNotEmpty &&
//                          (moveHistory.last.startsWith('$square-') ||
//                           moveHistory.last.endsWith('-$square'));
        
//         Color squareColor;
//         if (isSelected) {
//           squareColor = Colors.blue[300]!;
//         } else if (isPossibleMove) {
//           squareColor = Colors.green[300]!;
//         } else if (isLastMove) {
//           squareColor = Colors.yellow[300]!;
//         } else {
//           squareColor = isLight ? Colors.brown[100]! : Colors.brown[400]!;
//         }
        
//         ch.Piece? piece = chess.get(square);
//         ChessPiece? chessPiece = convertPiece(piece);
        
//         return GestureDetector(
//           onTap: () => onSquareTapped(square),
//           child: Container(
//             decoration: BoxDecoration(
//               color: squareColor,
//               border: Border.all(
//                 color: Colors.brown[800]!,
//                 width: 0.5,
//               ),
//             ),
//             child: Stack(
//               children: [
//                 // Coordinate labels
//                 if (col == 0)
//                   Positioned(
//                     top: 2,
//                     left: 2,
//                     child: Text(
//                       '${8 - row}',
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                         color: isLight ? Colors.brown[800] : Colors.brown[100],
//                       ),
//                     ),
//                   ),
//                 if (row == 7)
//                   Positioned(
//                     bottom: 2,
//                     right: 2,
//                     child: Text(
//                       String.fromCharCode(97 + col),
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                         color: isLight ? Colors.brown[800] : Colors.brown[100],
//                       ),
//                     ),
//                   ),
                
//                 // Piece using custom ChessPiece widgets
//                 if (chessPiece != null)
//                   Center(
//                     child: chessPiece.symbol,
//                   ),
                
//                 // Possible move indicator
//                 if (isPossibleMove && chessPiece == null)
//                   Center(
//                     child: Container(
//                       width: 20,
//                       height: 20,
//                       decoration: BoxDecoration(
//                         color: Colors.green[600],
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
                
//                 // Capture indicator
//                 if (isPossibleMove && chessPiece != null)
//                   Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Colors.red,
//                         width: 3,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void onSquareTapped(String square) {
//     if (chess.game_over) return;

//     setState(() {
//       if (selectedSquare == null) {
//         // First tap - select piece
//         Piece? piece = chess.get(square);
//         if (piece != null && piece.color == chess.turn) {
//           selectedSquare = square;
//           possibleMoves = chess.moves({'square': square, 'verbose': true})
//               .map((move) => move['to'] as String)
//               .toList();
//         }
//       } else if (selectedSquare == square) {
//         // Tap same square - deselect
//         selectedSquare = null;
//         possibleMoves = [];
//       } else if (possibleMoves.contains(square)) {
//         // Valid move - make the move
//         var move = chess.move({
//           'from': selectedSquare,
//           'to': square,
//           'promotion': 'q', // Auto-promote to queen
//         });
        
//         if (move != null) {
//           moveHistory.add('${move['from']}-${move['to']}');
//         }
        
//         selectedSquare = null;
//         possibleMoves = [];
//       } else {
//         // Tap different piece - select new piece
//         Piece? piece = chess.get(square);
//         if (piece != null && piece.color == chess.turn) {
//           selectedSquare = square;
//           possibleMoves = chess.moves({'square': square, 'verbose': true})
//               .map((move) => move['to'] as String)
//               .toList();
//         } else {
//           selectedSquare = null;
//           possibleMoves = [];
//         }
//       }
//     });
//   }

// }