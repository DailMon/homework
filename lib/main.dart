import 'package:flutter/material.dart';
import 'package:flutterapp/ExpensesModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutterapp/EditExpense.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManExp',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Manager Expenses'),
    );
  }
}

class MyHomePage extends StatelessWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  List<String> months = ["January", "February", "March", "April", "May", "June", "Jule",
                         "August", "September", "October", "November", "December"];
  int _month = DateTime.now().month;
  int _year = DateTime.now().year;
  double _sum = 0;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ExpensesModel>(
      model: ExpensesModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => Container(
            child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: model.recordsCount + 2,
                itemBuilder: (context, index){
                  _sum = model.sum();
                  if (model.recordsCount > 0){
                    _month = model.getMonth();
                    _year = model.getYear();
                  }
                  if (index == 0){
                    return Container(
                      child: ListTile(
                        title: Center(
                          child: Text(
                            months[_month - 1] + " " + _year.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                            ),
                          ),
                        ),
                        leading: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _month -= 1;
                            if (_month < 1) {
                              _month = 12;
                              _year -= 1;
                            }
                            model.Load(_month, _year);
                          },
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _month += 1;
                            if (_month > 12) {
                              _month = 1;
                              _year += 1;
                            }
                            model.Load(_month, _year);
                          },
                        ),
                      ),
                      color: Colors.blue,
                    );
                  }

                  else if (index == 1){
                    return ListTile(
                      title: Text("Total expenses for month: $_sum"),
                    );
                  }

                  else{
                    index -= 2;
                    return Dismissible(
                      key: Key(model.GetKey(index)),
                      child: ListTile(
                        title: Text(model.GetText(index)),
                        leading: Icon(Icons.edit),
                        trailing: Icon(Icons.delete),
                      ),
                      // ignore: missing_return
                      confirmDismiss: (direction){
                        if (direction == DismissDirection.endToStart){
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                content: Text("Do you accept?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("No"),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Yes"),
                                    onPressed: (){
                                      model.removeAt(index, _month, _year);
                                      index += 1;
                                      Navigator.of(context).pop(true);
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(content: Text("Deleted record $index"))
                                      );
                                      index -= 1;
                                    },
                                  ),
                                ],
                                elevation: 24,
                              )
                          );
                        } else{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context){
                                    return EditExpense(model, index);
                                  }
                              )
                          );
                        }
                      },
                      background: Container(
                        color: Colors.amber[800],
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "edit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                          ),
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red[800],
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          "delete",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                          ),
                        ),
                      ),
                    );
                  }
                },
            ),
          ),
        ),
         floatingActionButton: ScopedModelDescendant<ExpensesModel>(
           builder: (context, child, model) => FloatingActionButton(
             onPressed: () {
               Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context){
                       return EditExpense(model, -1);
                     }
                   )
               );
             },
             child: Icon(Icons.add),
           ),
         ),
      ),
    );
  }
}

