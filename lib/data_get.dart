import 'package:flutter/material.dart';
import 'package:interpolation/custom_input.dart';
import 'package:interpolation/resultPage.dart';

class DataGet extends StatefulWidget {
  const DataGet({super.key});

  @override
  State<DataGet> createState() => _DataGetState();
}

class _DataGetState extends State<DataGet> {
  ScrollController scrollController = ScrollController();
  TextEditingController controller = TextEditingController();
  int inputs = 0;
  List<double?> controllersX = [];
  List<double?> controllersY = [];

  @override
  void initState() {
    controllersX = List.filled(100, null);
    controllersY = List.filled(100, null);
    controller.addListener(() {
      inputs = 1;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.asset("images/equation.png"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 80,
                      child: Custominput(
                        controller: controller,
                      )),
                  const Text(
                    "hأدخل قيمة ال ",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (controller.text != "" && controller.text != "0")
                SizedBox(
                  height: 160,
                  child: ListView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 60,
                            alignment: Alignment.center,
                            child: const Text("X"),
                          ),
                          Container(
                            width: 60,
                            alignment: Alignment.center,
                            child: const Text("Y"),
                          ),
                        ],
                      ),
                      ...List.generate(inputs, (int index) {
                        return inputsColumn(index);
                      })
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text("Calculate"),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.calculate_outlined,
                        ),
                      ],
                    ),
                    onPressed: () {
                      if (controller.text != "" && inputs > 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResultPage(
                                    arrayOfX:
                                        controllersX.sublist(0, inputs - 1),
                                    arrayOfY:
                                        controllersY.sublist(0, inputs - 1),
                                    h: double.parse(controller.text),
                                  )),
                        );
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  inputsColumn(i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 60,
            alignment: Alignment.center,
            child: input(
              i,
            ),
          ),
          Container(
            width: 60,
            alignment: Alignment.center,
            child: input(i, type: "y"),
          ),
        ],
      ),
    );
  }

  input(i, {type = "x"}) {
    return TextFormField(
      readOnly: type == "x" && i != 0 && controllersX[0] != null ? true : false,
      initialValue: type == "x" && i != 0 && controllersX[0] != null
          ? "${controllersX[0]! + i * double.parse(controller.text)}"
          : null,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      cursorColor: Colors.greenAccent,
      cursorRadius: const Radius.circular(5),
      decoration: const InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent, width: 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent, width: 1),
        ),
      ),
      onChanged: (value) {
        if (value != "-") {
          if (type == "y") {
            controllersY[i] = double.tryParse(value);
          } else {
            controllersX[i] = double.tryParse(value);
            if (value != "") {
              for (int j = i + 1; j < controllersX.length; j++) {
                controllersX[j] =
                    controllersX[i]! + double.parse(controller.text) * j;
              }
            }
          }
        }

        if (controllersX[0] == null || controllersX[0] == "-") {
          inputs = 1;
        }

        if (controllersX[i] != null &&
            controllersX[i] != "-" &&
            controllersY[i] != null &&
            controllersY[i] != "-") {
          inputs = i + 2;
          scrollController.animateTo(500.0 * inputs,
              duration: const Duration(milliseconds: 50), curve: Curves.ease);
        } else {
          inputs = i + 1;
        }

        setState(() {});
      },
    );
  }
}
