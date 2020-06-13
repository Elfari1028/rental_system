import 'package:flutter/widgets.dart';
import 'package:bot_toast/bot_toast.dart';

abstract class CabinModel {
  List<String> getFieldNames();
  List<String> suGetFieldNames();
  Map<String, CabinModelComparator> getComparators();
  Map<String, Widget> getWidgets();
}

typedef CabinModelComparator = int Function(CabinModel a, CabinModel b);

extension on BotToast{
  showToast({Icon icon,String title,String subtitle}){
    BotToast.showNotification(
      leading:(_)=>icon,
      title: (_)=>Text(title),
      subtitle: (_)=>Text(subtitle),
    );
  }
}