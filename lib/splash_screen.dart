import 'package:flutter/material.dart';
import 'package:flutter_chess_game/chess_game3.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ChessGame3(),), (route) => false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: 
          
          Text("Lets play the game",
            textAlign: TextAlign.center,
            style: TextStyle(
              
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )),
          Positioned(
            bottom: 200,
            left: MediaQuery.of(context).size.width * 0.5 - 20,
            // left: double.infinity,
            // right: double.infinity,
            child: CircularProgressIndicator(color: Colors.deepOrange,),
          ),
        ],
      ),
    );
  }
}