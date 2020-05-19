import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_formfield/flutter_datetime_formfield.dart';
import 'package:flutterapp/ExpensesModel.dart';

class _EditExpenseState extends State<EditExpense>{
  double _price;
  String _name;
  DateTime _time;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ExpensesModel _model;
  int _index;

  _EditExpenseState(this._model, this._index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Expense")),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _model.getName(_index),
                onSaved: (value){
                  _name = value;
                },
                decoration: InputDecoration(
                  labelText: "Name *",
                  //icon: Icon(Icons.subject)
                ),
              ),
              TextFormField(
                autovalidate: true,
                initialValue: _model.getPrice(_index),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (double.tryParse(value) != null){
                    return null;
                  } else{
                    return "Enter the valid price";
                  }
                },
                onSaved: (value){
                  _price = double.tryParse(value);
                },
                decoration: InputDecoration(
                    labelText: "Price *",
                    //icon: Icon(Icons.attach_money)
                ),
              ),
              DateTimeFormField(
                initialValue: _model.getTime(_index),
                label: "Date and Time *",
                autovalidate: true,
                validator: (value) {
                  if (value != null){
                    return null;
                  } else{
                    return "Date Time Required";
                  }
                },
                onSaved: (value){
                  _time = value;
                },
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()){
                    _formKey.currentState.save();
                    _model.editExpense(_name, _price, _time, _index);
                    Navigator.pop(context);
                  }
                },
                child: Text("Edit"),
              )
            ],
          ),
        ),
      )
    );
  }
}

class EditExpense extends StatefulWidget{
  final ExpensesModel _model;
  int _index;
  EditExpense(this._model, this._index);

  @override
  State<StatefulWidget> createState() => _EditExpenseState(_model, _index);
}