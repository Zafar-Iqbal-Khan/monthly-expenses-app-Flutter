import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTx;

  NewTransaction(this.addNewTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selecteddate;

  void _submitData() {
    final inputtext = _titleController.text;
    final inputamount = double.parse(_amountController.text);
    if (inputtext.isEmpty || inputamount <= 0 || _selecteddate == null) {
      return;
    }
    widget.addNewTx(inputtext, inputamount, _selecteddate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickeddate) {
      if (pickeddate == null) {
        return;
      }
      setState(() {
        _selecteddate = pickeddate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  // onChanged: (val) {
                  //   titleInput = val;
                  // },
                  onSubmitted: (_) => _submitData(),
                  controller: _titleController,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Amount'),
                  // onChanged: (val) => amountInput = val,
                  onSubmitted: (_) => _submitData(),
                  controller: _amountController,
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(_selecteddate == null
                            ? 'No Date Choosen!'
                            : 'Picked Date   ${DateFormat.yMd().format(_selecteddate)}'),
                      ),
                      FlatButton(
                        child: Text(
                          'Choose Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: _presentDatePicker,
                        textColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: _submitData,
                  //  () {
                  //   addNewTx(titleController.text,
                  //       double.parse(amountController.text));
                  // },
                  child: Text(
                    'Add Transaction',
                    style: TextStyle(fontSize: 15),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button.color,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
