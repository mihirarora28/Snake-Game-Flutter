import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snakegameflutter/foodPixel.dart';
import 'package:snakegameflutter/snake_pixel.dart';
import 'package:snakegameflutter/blank_pixel.dart';

void main(){
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Dem o',
      theme: ThemeData(

        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
enum SnakeDirection{
  UP,DOWN,RIGHT,LEFT
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int rowSize = 10;
  List<int>SnakePosition =[0,1,2];
  int foodPosition = 55;
  int currentScore = 0;
  bool gameStarted = false;

  int totalSquares = 100;
  var CurrentDirection = SnakeDirection.RIGHT;
  void startGame(){
    gameStarted = true;
    Timer.periodic(Duration(milliseconds: 150), (timer) {
      setState((){
        // add head
        moveSnake();

        // check game is over
        if(gameOver()){
          timer.cancel();
          showDialog(context: context, builder: (context){
            return AlertDialog(
              title: Text('Game Over'),
              content: Column(
                children: [
                  Text('Your Current score is ' + currentScore.toString()),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Enter Name'

                    ),

                  )
                ],
              ),
              actions: [
                MaterialButton(onPressed: (){
                  newGame();
                  Navigator.of(context).pop();
                },child: Text('Submit Score'),color: Colors.pink,)
              ],
            );
          });
        }
        // remove my tail
      });
    });
  }

  void moveSnake(){
    if(CurrentDirection == SnakeDirection.RIGHT){
      ////  if at right Wall
      if(SnakePosition.last % rowSize == 9){
        SnakePosition.add(SnakePosition.last + 1-rowSize);
      }
      else {
        SnakePosition.add(SnakePosition.last + 1);
      }
      // SnakePosition.removeAt(0);
    }
    else  if(CurrentDirection == SnakeDirection.LEFT){
      if(SnakePosition.last % rowSize == 0){
        SnakePosition.add(SnakePosition.last -   1 + rowSize);
      }
      else
        SnakePosition.add(SnakePosition.last -   1);
      // SnakePosition.removeAt(0);
    }
    else if(CurrentDirection == SnakeDirection.UP){
      if(SnakePosition.last < rowSize){
        SnakePosition.add(SnakePosition.last - rowSize + totalSquares);
      }
      else
        SnakePosition.add(SnakePosition.last -   rowSize);
      // SnakePosition.removeAt(0);
    }
    else  if(CurrentDirection == SnakeDirection.DOWN){
      if(SnakePosition.last + rowSize > totalSquares){
        SnakePosition.add(SnakePosition.last + rowSize - totalSquares);
      }
      else
        SnakePosition.add(SnakePosition.last +  rowSize);
      // SnakePosition.removeAt(0);
    }
    if(SnakePosition.last == foodPosition){
      eatFood();
    }
    else{
      SnakePosition.removeAt(0);

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 30.0,),
          Expanded(

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //user score
                    Text('Current Score ',style: TextStyle(color: Colors.white),),
                    Text(currentScore.toString(), style: TextStyle(fontSize: 36,color: Colors.white),),
                    //highScores

                  ],
                ),
                Text('High Scores',style: TextStyle(color: Colors.white),)
              ],
            ),
          ),
          Expanded(
              flex: 3 ,
              child: GestureDetector(
                onVerticalDragUpdate: (details){
                  if(details.delta.dy > 0 && CurrentDirection!=SnakeDirection.UP) {
                    print("MOVE DOWN");
                    CurrentDirection = SnakeDirection.DOWN;
                  }
                  else if(details.delta.dy < 0 && CurrentDirection!=SnakeDirection.DOWN){
                    print("MOVE UP");
                    CurrentDirection = SnakeDirection.UP;

                  }
                },
                onHorizontalDragUpdate: (details){
                  if(details.delta.dx > 0 && CurrentDirection!=SnakeDirection.LEFT) {
                    print("MOVE RIGHT");
                    CurrentDirection = SnakeDirection.RIGHT;

                  }
                  else if(details.delta.dx < 0 && CurrentDirection!=SnakeDirection.RIGHT){
                    print("MOVE LEFT");
                    CurrentDirection = SnakeDirection.LEFT;
                  }
                },
                child: GridView.builder(
                    itemCount: totalSquares,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: rowSize), itemBuilder: (context,index){
                  return SnakePosition.contains(index) ? SnakePixel():(foodPosition == index ? FoodPixel(): BlankPixel());
                  BlankPixel();
                }),
              )
          ),
          Expanded(

            child: Container(
              child: Center(
                child: MaterialButton(
                  onPressed:gameStarted ? (){

                  } : (){
                    startGame();

                  },
                  color:gameStarted?Colors.grey:Colors.pinkAccent,

                  child: Text('PLAY',style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void eatFood() {
    currentScore++;
    while(SnakePosition.contains(foodPosition)){
      foodPosition = Random().nextInt(totalSquares);
    }
  }
  void newGame(){
    setState((){
      SnakePosition = [
        0,1,2
      ];
      foodPosition = 35;
      gameStarted = false;
      currentScore = 0;
      CurrentDirection = SnakeDirection.RIGHT;
    });
  }
  bool gameOver(){
    // game over when duplicated values are there
    List<int>duplicates = [];
    Set<int>mapp = {};

    for(int i = 0 ;i < SnakePosition.length;i++){
      duplicates.add(SnakePosition[i]);
      mapp.add(SnakePosition[i]);
    }
    // for(int i = 0 ;i < duplicates.length;i++){
    //   if(SnakePosition.contains(duplicates[i])){
    //     return true;
    //   }
    // }
    if(mapp.length == SnakePosition.length){
      return false;
    }
    return true;
  }
}


