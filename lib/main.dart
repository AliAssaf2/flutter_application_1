import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(FocusTimerApp());

class FocusTimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FocusTimerScreen(),
    );
  }
}

class FocusTimerScreen extends StatefulWidget {
  @override
  _FocusTimerScreenState createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> {
  int workMinutes = 25;
  int breakMinutes = 5;
  int remainingSeconds = 0;
  bool isWorkSession = true;
  bool isRunning = false;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (timer != null) timer!.cancel(); // Cancel any existing timer

    setState(() {
      isRunning = true;
      remainingSeconds = isWorkSession ? workMinutes * 60 : breakMinutes * 60;
    });

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          t.cancel();
          switchSession();
        }
      });
    });
  }

  void stopTimer() {
    setState(() {
      isRunning = false;
    });
    timer?.cancel();
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      remainingSeconds = isWorkSession ? workMinutes * 60 : breakMinutes * 60;
    });
  }

  void switchSession() {
    setState(() {
      isWorkSession = !isWorkSession;
      remainingSeconds = isWorkSession ? workMinutes * 60 : breakMinutes * 60;
      startTimer();
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Focus Timer'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isWorkSession ? "Work Session" : "Break Session",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              formatTime(remainingSeconds),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? null : startTimer,
                  child: Text('Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: isRunning ? stopTimer : null,
                  child: Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: resetTimer,
                  child: Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text("Work Minutes", style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (workMinutes > 1) workMinutes--;
                            });
                          },
                          icon: Icon(Icons.remove),
                        ),
                        Text(workMinutes.toString(),
                            style: TextStyle(fontSize: 18)),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (workMinutes < 60) workMinutes++;
                            });
                          },
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Break Minutes", style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (breakMinutes > 1) breakMinutes--;
                            });
                          },
                          icon: Icon(Icons.remove),
                        ),
                        Text(breakMinutes.toString(),
                            style: TextStyle(fontSize: 18)),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (breakMinutes < 30) breakMinutes++;
                            });
                          },
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
