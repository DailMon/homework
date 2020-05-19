import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_formfield/flutter_datetime_formfield.dart';
import 'package:flutterapp/ExpensesModel.dart';

class _AddExpensesState extends State<AddExpense>{
  double _price;
  String _name;
  DateTime _time;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ExpensesModel _model;

  _AddExpensesState(this._model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onSaved: (value){
                  _name = value;
                },
                decoration: InputDecoration(
                    labelText: "Name *",
                ),
              ),
              TextFormField(
                autovalidate: true,
                initialValue: "0",
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
                ),
              ),
              Container(
                alignment: AlignmentDirectional.centerEnd,
                child: DateTimeFormField(
                  initialValue: DateTime.now(),
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
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()){
                    _formKey.currentState.save();
                    _model.addExpense(_name, _price, _time);
                    Navigator.pop(context);
                  }
                },
                child: Text("Add"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddExpense extends StatefulWidget{
  final ExpensesModel _model;

  AddExpense(this._model);

  @override
  State<StatefulWidget> createState() => _AddExpensesState(_model);
  }
  