import 'dart:js_util';

import 'package:cabin/base/cabin_model.dart';
import 'package:cabin/base/house.dart';
import 'package:cabin/base/order.dart';
import 'package:cabin/base/support_request.dart';
import 'package:cabin/base/user.dart';
import 'package:flutter/material.dart';

class CabinDataTable extends StatefulWidget {
  final List<CabinModel> items;
  final bool isSuperuser;
  CabinDataTable({@required this.items, this.isSuperuser = false});
  createState() => isSuperuser?EditableCabinDataTableState():CabinDataTableState();
}

class CabinDataTableState extends State<CabinDataTable> {
  double _screenWidth;
  double _screenHeight;
  double frameWidth = 1200;

  List<CabinModel> items;
  Map<String, Comparator<CabinModel>> comparators;
  List<String> fieldNames;
  int _sortColumnIndex;
  bool _sortAsc = true;
  @override
  void initState() {
    super.initState();
    items = widget.items;
    fieldNames = items.first.suGetFieldNames();
    comparators = items.first.getComparators();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal, child: body());
  }

  Widget body() {
    return DataTable(
      dataRowHeight: 150,
      columns: myColumns,
      rows: myRows,
      sortAscending: _sortAsc,
      sortColumnIndex: _sortColumnIndex,
    );
  }

  List<DataColumn> get myColumns {
    List<DataColumn> ret = new List<DataColumn>();
    for (int i = 0; i < fieldNames.length; i++) {
      ret.add(DataColumn(
          label: text(fieldNames[i]),
          onSort: (columnIndex, ascending) {
            onSort(i, columnIndex, ascending);
          }));
    }
    return ret;
  }

  void onSort(int i, int index, bool ascending) {
    setState(() {
      _sortAsc = ascending;
      _sortColumnIndex = index;
      items.sort(comparators[fieldNames[i]]);
      if (!ascending) items = items.reversed.toList();
    });
  }

  List<DataRow> get myRows {
    switch (items.first.runtimeType) {
      case User:
      case SupportRequest:
      case Order:
      case House:
        return items
            .map((house) => DataRow(cells: [
                  wrapper(text((house as House).id.toString()), () {}),
                  wrapper(text((house as House).title), () {}),
                  wrapper(text((house as House).capacity.title), () {}),
                  wrapper(text((house as House).term.title), () {}),
                  wrapper(text((house as House).status.title), () {}),
                  wrapper(text((house as House).intro), () {}),
                  wrapper(text((house as House).location), () {}),
                  wrapper(text((house as House).priceInYuan.toString()), () {}),
                  wrapper((house as House).cover, () {})
                ]))
            .toList();
    }
  }

  DataCell wrapper(Widget child, Function onTap) => DataCell(
      Container(width: frameWidth / House.fieldNames.length, child: child),
      onTap: onTap);

  Widget text(String text) => Text(text,
      softWrap: true,
      overflow: TextOverflow.fade,
      textWidthBasis: TextWidthBasis.parent);
}

class EditableCabinDataTableState extends CabinDataTableState {
  List<DataRow> get myRows {
    switch (items.first.runtimeType) {
      case User:
      case SupportRequest:
      case Order:
      case House:
        return items
            .map((house) => DataRow(cells: [
                  wrapper(text((house as House).id.toString()), () {}),
                  wrapper(text((house as House).title), () {}),
                  wrapper(text((house as House).capacity.title), () {}),
                  wrapper(text((house as House).term.title), () {}),
                  wrapper(text((house as House).status.title), () {}),
                  wrapper(text((house as House).intro), () {}),
                  wrapper(text((house as House).location), () {}),
                  wrapper(text((house as House).priceInYuan.toString()), () {}),
                  wrapper((house as House).cover, () {})
                ]))
            .toList();
    }
  }
}
