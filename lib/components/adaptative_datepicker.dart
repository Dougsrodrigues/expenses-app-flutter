import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class AdaptativeDatePicker extends StatelessWidget {
  final isIos = Platform.isIOS;

  final DateTime? selectedDate;
  final Function(DateTime)? onDateChange;

  AdaptativeDatePicker({
    this.selectedDate,
    this.onDateChange,
  });

  _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;

      onDateChange!(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return isIos
        ? SizedBox(
            height: 180,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              minimumDate: DateTime(2019),
              maximumDate: DateTime.now(),
              onDateTimeChanged: onDateChange!,
            ),
          )
        : SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? 'Data selecionada ${DateFormat('dd/MM/y').format(selectedDate!)}'
                        : 'Nenhuma data selecionada',
                  ),
                ),
                TextButton(
                  child: Text('Selecionar Data',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: () => _showDatePicker(context),
                )
              ],
            ),
          );
  }
}
