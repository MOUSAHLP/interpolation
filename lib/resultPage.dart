import 'package:flutter/material.dart';
import 'package:equations/equations.dart';
import 'package:interpolation/functions.dart';
import 'package:interpolation/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({
    super.key,
    required this.arrayOfX,
    required this.arrayOfY,
    required this.h,
  });
  final List arrayOfX;
  final List arrayOfY;
  final double h;
  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late FunctionsImp func;
  final equa =
      DurandKerner(precision: 1e-1, coefficients: [const Complex(2, 0)]);
  double? computedVal;
  List<SalesData> data = [];
  ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
      enableSelectionZooming: true,
      selectionRectBorderColor: Colors.red,
      selectionRectBorderWidth: 1,
      selectionRectColor: Colors.grey);
  @override
  void initState() {
    func = FunctionsImp(
        arrayOfX: widget.arrayOfX, arrayOfY: widget.arrayOfY, h: widget.h);
    List finalEquation = func.greatSum(widget.arrayOfX.length - 1);
    data.clear();
    equa.coefficients.clear();
    for (int i = 0; i < func.newton.nodes.length; i++) {
      data.add(SalesData(func.newton.nodes[i].x, func.newton.nodes[i].y));
      equa.coefficients.add(
          Complex(double.parse(finalEquation[i].toStringAsPrecision(4)), 0));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        actions: [
          Container(
            width: 250,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("F( "),
                SizedBox(
                    width: 60,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      showCursor: false,
                      cursorRadius: const Radius.circular(5),
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 1),
                        ),
                      ),
                      onChanged: (value) {
                        computedVal = double.tryParse(value);
                        setState(() {});
                      },
                    )),
                Text(" ) ="),
                Spacer(),
                Text(computedVal != null &&
                        computedVal.toString().isNumericalExpression
                    ? func.newton.compute(computedVal!).toStringAsFixed(4)
                    : ""),
                Spacer(),
              ],
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            height: 200,
            width: double.infinity,
            child: SfCartesianChart(
              zoomPanBehavior: _zoomPanBehavior,
              trackballBehavior: TrackballBehavior(
                  // Enables the trackball
                  enable: true,
                  tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
                  tooltipSettings: const InteractiveTooltip(
                      enable: true, color: Colors.red)),
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
              ),
              primaryXAxis: NumericAxis(
                crossesAt: 0,
              ),
              primaryYAxis: NumericAxis(
                crossesAt: 0,
              ),
              series: <LineSeries<SalesData, int>>[
                LineSeries<SalesData, int>(
                    name: "النقاط",
                    trendlines: [
                      Trendline(
                          name: "التابع",
                          color: Colors.red,
                          type: TrendlineType.polynomial,
                          polynomialOrder: func.newton.nodes.length,
                          enableTooltip: true)
                    ],
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    enableTooltip: true,
                    color: Colors.blue,
                    dataSource: data,
                    xValueMapper: (SalesData sales, _) => sales.x.floor(),
                    yValueMapper: (SalesData sales, _) => sales.y),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "${equa.toString().replaceAll("x", " (X -  ${widget.arrayOfX[0]}/ ${widget.h})").replaceFirst(" (X -  ${widget.arrayOfX[0]}/ ${widget.h})", "X")}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: const Text(
              "جدول الفروق الامامية",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Text(
                "ملاحظة : السطر الأول هي الفروق الأمامية",
                style: TextStyle(color: Colors.red, fontSize: 10),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: func.newton
                        .forwardDifferenceTable()
                        .columnCount
                        .toDouble() *
                    100,
                child: Table(
                  border: TableBorder.all(
                      width: 1, style: BorderStyle.solid, color: Colors.black),
                  children: [
                    TableRow(children: [
                      ...List.generate(
                          func.newton.forwardDifferenceTable().columnCount,
                          (i) {
                        return Text(
                          "$i",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        );
                      })
                    ]),
                    ...List.generate(
                        func.newton.forwardDifferenceTable().rowCount, (row) {
                      return TableRow(children: [
                        ...List.generate(
                            func.newton
                                .forwardDifferenceTable()
                                .toListOfList()[row]
                                .length, (i) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                func.newton
                                    .forwardDifferenceTable()
                                    .toListOfList()[row][i]
                                    .toStringAsFixed(4),
                                textAlign: TextAlign.center),
                          );
                        })
                      ]);
                    }),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.x, this.y);
  final double x;
  final double y;
}
