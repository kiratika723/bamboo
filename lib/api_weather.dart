import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mytestapp/air.dart'; // ใช้ model สำหรับ AQI

class ApiWeather extends StatefulWidget {
  const ApiWeather({super.key});

  @override
  State<ApiWeather> createState() => _ApiWeatherState();
}

class _ApiWeatherState extends State<ApiWeather> {
  List<AqiData> aqiList = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoaded = false;
    });

    try {
      var response = await http.get(Uri.parse(
          'https://api.waqi.info/feed/bangkok/?token=a1deb1c5513311139943ae53e6e50a55dc395d2b'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          aqiList = [AqiData.fromJson(jsonResponse)];
          isLoaded = true;
        });
      } else {
        print("Invalid Data");
        setState(() {
          isLoaded = true;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoaded = true;
      });
    }
  }

  // ฟังก์ชันกำหนดสีพื้นหลังและการ์ด
  Color getAqiColor(int aqi) {
    if (aqi >= 301) return Colors.deepPurple.shade700; // Hazardous
    if (aqi >= 201) return Colors.red.shade700; // Very Unhealthy
    if (aqi >= 151) return Colors.orange.shade700; // Unhealthy
    if (aqi >= 101) return Colors.yellow.shade600; // Unhealthy for Sensitive Groups
    if (aqi >= 51) return Colors.lightGreen.shade700; // Moderate
    return Colors.green.shade700; // Good
  }

  // ฟังก์ชันกำหนดสีตัวอักษรเพื่อให้ตัดกับพื้นหลัง
  Color getTextColor(int aqi) {
    return (aqi >= 101) ? Colors.white : Colors.black;
  }

  // ฟังก์ชันกำหนดข้อความ
  String getAqiQuality(int aqi) {
    if (aqi >= 301) return "Hazardous";
    if (aqi >= 201) return "Very Unhealthy";
    if (aqi >= 151) return "Unhealthy";
    if (aqi >= 101) return "Unhealthy for Sensitive Groups";
    if (aqi >= 51) return "Moderate";
    return "Good";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Air Quality Index (AQI)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 245, 25, 9),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchData,
          ),
        ],
      ),
      body: isLoaded
          ? (aqiList.isNotEmpty
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: getAqiColor(aqiList[0].aqi), // พื้นหลังเปลี่ยนสีตาม AQI
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            aqiList[0].city,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: getTextColor(aqiList[0].aqi),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Colors.white.withOpacity(0.9), // ให้สีตัดกับพื้นหลัง
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Text(
                                    'AQI: ${aqiList[0].aqi}',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    getAqiQuality(aqiList[0].aqi),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  const Text(
                                    "Temperature",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${aqiList[0].temperature}°C',
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                           onPressed: fetchData,
                           style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.green, // 📌 ปุ่มสีเขียว
                           padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
                           shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(12), // 📌 ทำให้ปุ่มโค้งมน
                           ),
                           ),
                           child: const Text(
                            'Refresh Data',
                           style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                         ),
                        ],
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: Text(
                    "No data available",
                    style: TextStyle(fontSize: 18),
                  ),
                ))
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
