import 'package:flutter/material.dart';
import 'dart:async';

class TrafficLightScreen extends StatefulWidget {
  @override
  _TrafficLightScreenState createState() => _TrafficLightScreenState();
}

class _TrafficLightScreenState extends State<TrafficLightScreen> {
  int _currentLight = 0; // 0 = Red, 1 = Yellow, 2 = Green
  int _timeLeft = 10; // ตั้งค่าเวลาถอยหลังเริ่มต้น
  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 1) {
          _timeLeft--;
        } else {
          _changeLight();
        }
      });
    });
  }

  void _changeLight() {
    setState(() {
      _currentLight = (_currentLight + 1) % 3;
      _timeLeft = (_currentLight == 1) ? 3 : 10; // ไฟเหลือง 3 วิ, ไฟแดง/เขียว 5 วิ
    });
  }

  void _resetLights() {
    setState(() {
      _currentLight = 0;
      _timeLeft = 5;
    });
    _startTimer();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Traffic Light Animation')),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTrafficLights(),
            SizedBox(height: 20),
            Text(
              '$_timeLeft วินาที',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetLights,
              child: Text('เริ่มใหม่', textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficLights() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black, // พื้นหลังสีดำ
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 4), // เส้นขอบรอบทั้งหมด
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLight(Colors.red, _currentLight == 0),
          SizedBox(height: 10),
          _buildLight(Colors.yellow, _currentLight == 1),
          SizedBox(height: 10),
          _buildLight(Colors.green, _currentLight == 2),
        ],
      ),
    );
  }

  Widget _buildLight(Color color, bool isActive) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3), // เส้นขอบสีขาว
        boxShadow: [
          BoxShadow(
            color: isActive ? color.withOpacity(0.8) : Colors.transparent,
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color.withOpacity(isActive ? 1.0 : 0.3),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}