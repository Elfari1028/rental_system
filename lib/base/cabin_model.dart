import 'package:flutter/widgets.dart';

abstract class CabinModel {
  List<String> getFieldNames();
  List<String> suGetFieldNames();
  Map<String, CabinModelComparator> getComparators();
  Map<String, Widget> getWidgets();
}

typedef CabinModelComparator = int Function(CabinModel a, CabinModel b);
