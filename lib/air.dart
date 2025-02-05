class AqiData {
  final int aqi;
  final String city;
  final double temperature;

  // Constructor
  AqiData({required this.aqi, required this.city, required this.temperature});

  // จาก JSON ที่ได้รับจาก API
  factory AqiData.fromJson(Map<String, dynamic> json) {
    return AqiData(
      aqi: json['data']['aqi'] ?? 0, // หากไม่มีค่าให้เป็น 0
      city:
          json['data']['city']['name'] ?? 'Unknown', // หากไม่มีให้ใส่ 'Unknown'
      temperature:
          json['data']['iaqi']['t']?['v']?.toDouble() ?? 0.0, // ตรวจสอบ null
    );
  }

  // แปลงเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'aqi': aqi,
      'city': city,
      'temperature': temperature,
    };
  }
}