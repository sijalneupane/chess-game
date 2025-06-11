import 'package:flutter/material.dart';
import 'package:flutter_chess_game/utils/chess_piece.dart';
import 'package:flutter_chess_game/utils/colors.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;
  const Square({super.key,required this.isWhite,this.piece,required this.isSelected,required this.onTap,required this.isValidMove});

  @override
  Widget build(BuildContext context) {
    Color? sqaureColor;
    if(isSelected){
      sqaureColor=Colors.green;
    }
    else if(isValidMove){
sqaureColor=Colors.green[200];
    }
    else{
      sqaureColor= isWhite?foregroundColor:backgroundColor;
    }
    return GestureDetector(
      onTap:onTap ,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(0),
       margin: EdgeInsets.all(isValidMove?1:0),
        color: sqaureColor,
        child: piece?.symbol,
      ),
    );
  }
}