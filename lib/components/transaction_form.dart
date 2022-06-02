import 'package:expenses/components/adaptative_button.dart';
import 'package:expenses/components/adaptative_datepicker.dart';
import 'package:expenses/components/adaptative_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();

  final _valueController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  _submitForm() {
    final value = double.tryParse(_valueController.text) ?? 0.0;
    final title = _titleController.text;

    if (title.isEmpty || value <= 0) {
      return;
    }

    widget.onSubmit(_titleController.text, value, _selectedDate);
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;

      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(children: [
            AdaptativeTextfield(
              controller: _titleController,
              label: 'Título',
              onSubmitted: (_) => _submitForm(),
            ),
            AdaptativeTextfield(
              controller: _valueController,
              label: 'Valor (R\$)',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submitForm(),
            ),
            AdaptativeDatePicker(
              selectedDate: _selectedDate,
              onDateChange: (newDate) {
                setState(() {
                  _selectedDate = newDate;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AdaptativeButton(
                  label: 'Nova Transação',
                  onPress: _submitForm,
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
