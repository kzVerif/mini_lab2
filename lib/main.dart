import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FutureBuilder Demo',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const FutureDemoScreen(),
    );
  }
}

class FutureDemoScreen extends StatefulWidget {
  const FutureDemoScreen({super.key});

  @override
  State<FutureDemoScreen> createState() => _FutureDemoScreenState();
}

class _FutureDemoScreenState extends State<FutureDemoScreen> {
  // ประกาศ Future เพื่อเก็บผลลัพธ์
  late Future<String> _calculation;

  // ฟังก์ชันจำลองงานช้า (3 วินาที)
  Future<String> simulateSlowOperation() {
    return Future.delayed(
      const Duration(seconds: 3),
      () {
        // ✅ ถ้าลองอยากทดสอบ error ให้ uncomment ด้านล่างนี้
        // throw Exception('เกิดข้อผิดพลาดโดยตั้งใจ');
        return 'ข้อมูลจากการทำงานที่ใช้เวลานาน';
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // เรียกฟังก์ชันและเก็บ Future ไว้ในตัวแปรใน initState
    _calculation = simulateSlowOperation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FutureBuilder Demo')),
      body: Center(
        child: FutureBuilder<String>(
          future: _calculation, // ส่ง Future ของเราเข้าไป
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('กำลังโหลดข้อมูล...'),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(
                'เกิดข้อผิดพลาด: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              );
            } else if (snapshot.hasData) {
              return Text(
                'สำเร็จ! ได้รับข้อมูล: ${snapshot.data}',
                style: const TextStyle(fontSize: 18, color: Colors.green),
              );
            } else {
              return const Text('ไม่มีข้อมูล');
            }
          },
        ),
      ),
    );
  }
}
