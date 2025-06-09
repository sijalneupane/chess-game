import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';

enum ChessPieceType { king, queen, rook, bishop, knight, pawn }

// enum PieceColor { white, black }

class ChessPiece {
  final ChessPieceType type;
  final bool isWhite;
  // final PieceColor color;

  ChessPiece(this.type,
  //  this.color,
   this.isWhite);

  Widget get symbol {
    switch (this.type) {
      case ChessPieceType.king:
        return isWhite ? WhiteKing() : BlackKing();
      case ChessPieceType.queen:
        return isWhite ? WhiteQueen() : BlackQueen();
      case ChessPieceType.rook:
        return isWhite ? WhiteRook() : BlackRook();
      case ChessPieceType.bishop:
        return isWhite ? WhiteBishop() : BlackBishop();
      case ChessPieceType.knight:
        return isWhite ? WhiteKnight() : BlackKnight();
      case ChessPieceType.pawn:
        return isWhite ? WhitePawn() : BlackPawn();
    }
  }
}