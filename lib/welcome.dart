import 'package:flutter/material.dart';
import 'package:interpolation/data_get.dart';
import 'package:lottie/lottie.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "برنامج لحساب الاستيفاء على طريقة نيوتن غريغوري",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Lottie.asset('images/welcome.json'),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DataGet()),
                  );
                },
                child: const Text("أبدا ")),
          ),
          Column(
            children: const [
              Text(" : تم اعداده بواسطة"),
              Text(
                "Mousa Al-Halabi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Issa Al-Halabi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
