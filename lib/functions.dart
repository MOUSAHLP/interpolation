import 'package:equations/equations.dart';

abstract class Functions {
  greatSum(index);
  List<double> makeElement(stop);
  List multiply(List tempList1, List tempList2);
  List addLists(List addList1, List addList2);
  int factorial(n);
}

class FunctionsImp implements Functions {
  final List arrayOfX;
  final List arrayOfY;
  final double h;
  NewtonInterpolation newton = NewtonInterpolation(
    nodes: [],
  );
  FunctionsImp(
      {required this.arrayOfX, required this.arrayOfY, required this.h}) {
    for (int i = 0; i < arrayOfX.length; i++) {
      newton.nodes.add(InterpolationNode(x: arrayOfX[i], y: arrayOfY[i]));
    }
  }

// هذه الدالة تقوم بجمع جميع الحدود
//هذه الدالة تكافئ زغما
  @override
  greatSum(index) {
    List greatList = [newton.forwardDifferenceTable().toListOfList()[0][0]];
    for (int i = 0; i < index; i++) {
      // prev نقوم بجمع العناصر ووضعها ب المصفوفة
      List prev = addLists(makeElement(i), greatList);

      // من الحدود القديمة greatList نقوم بمسح
      greatList.clear();

      for (int x = 0; x < prev.length; x++) {
        // greatList نقوم باعطاء الحدود الجديدة المجموعة الى المصفوفة
        greatList.add(prev[x]);
      }
    }

    return greatList;
  }

  // هذا الدالة الرئيسية التي تقوم بارجاع
  // حد واحد
  @override
  List<double> makeElement(stop) {
    // s هو متغير يعبر عن المتغير s
    List s = [1, 0];

    // لضرب الفرق ب التوافيق الموافق له
    for (int i = 1; i < stop + 1; i++) {
      // تكافئ حد
      // (s - 1) * (s - 2)*... مثال
      List tempList = [1, -1 * i];

      s = multiply(s, tempList);
    }

    List<double> element = [];
    // العاملي
    int fact = factorial(stop + 1);

    // فروق نيوتن
    double newtonDeff =
        newton.forwardDifferenceTable().toListOfList()[0][stop + 1];

    //  الحد الواحد
    // مثال
    // s (s - 1)(s - 2)/ 2!
    for (int j = 0; j < s.length; j++) {
      element.add((s[j] / fact) * newtonDeff);
    }

    return element;
  }

// لضرب الحدود مع بعضها
// مثال
// ( s ) * ( s + 1 ) = s^2 + s + 0
  @override
  List multiply(List tempList1, List tempList2) {
    List result = [];
    for (int i = tempList1.length - 1; i >= 0; i--) {
      List temp = [];

      for (int j = 0; j < tempList2.length; j++) {
        temp.add(tempList1[i] * tempList2[j]);
      }
      for (int k = 0; k < tempList1.length - i - 1; k++) {
        temp.add(0);
      }

      List prev = addLists(temp, result);

      result.clear();
      for (int x = 0; x < prev.length; x++) {
        int val = prev[x];
        result.add(val);
      }
    }
    return result;
  }

// لجمع مصفوفتين مع بعضهم
// مثال
// [ 1 , 0 ]  +  [ 2 , 1 , 0 ]  = [ 2 , 2 , 0 ]
  @override
  List addLists(List addList1, List addList2) {
    List big = [];
    List small = [];
    if (addList1.length > addList2.length) {
      big = addList1;
      small = addList2;
    } else {
      small = addList1;
      big = addList2;
    }
    List result = List.filled(big.length, 0);

    int deffraince = big.length - small.length;

    for (int k = 0; k < deffraince; k++) {
      small.insert(0, 0);
    }

    for (int x = 0; x < big.length; x++) {
      result[x] = big[x] + small[x];
    }

    return result;
  }

  // لحساب العاملي

  int factorial(n) {
    if (n == 1 || n == 0) {
      return 1;
    }
    return n * factorial(n - 1);
  }
}
