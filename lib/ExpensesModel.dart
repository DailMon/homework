import 'package:date_format/date_format.dart';
import 'package:flutterapp/DataBaseLite.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Expense.dart';

class ExpensesModel extends Model{

  List<Expense> _items = [
    Expense(1, DateTime.now(), 'mouse', 3000),
  ];

  DataBaseLite _database;

  int get recordsCount => _items.length;

  ExpensesModel() {
    _database = DataBaseLite();
    DateTime dateTime = DateTime.now();
    int month = dateTime.month;
    int year = dateTime.year;
    Load(month, year);
  }

  void Load(int month, int year) {
    Future<List<Expense>> future = _database.getExpenses(month, year);
    future.then((list){
      _items = list;
      notifyListeners();
    });
  }

  String GetKey (int index){
    return _items[index].id.toString();
  }

  String GetText (int index){
    var curRow = _items[index];
    return curRow.name + " for " + curRow.price.toString() + '\n' + formatDate(curRow.date, [yyyy, '-', mm, '-', dd, '  ', HH, ':', nn]);
  }

  String getPrice(int index) {
    return _items[index].price.toString();
  }

  String getName(int index) {
    return _items[index].name;
  }

  DateTime getTime(int index) {
    return _items[index].date;
  }

  void removeAt(int index, int month, int year) {
    Future<void> future = _database.removeAtDB(_items[index].id);
    future.then((_) {
      Load(month, year);
    });
  }

  void addExpense(String name, double price, DateTime time) {
    Future<void> future = _database.addExpenseDB(name, price, time);
    int month = time.month;
    int year = time.year;
    future.then((_) {
      Load(month, year);
    });
  }

  void editExpense(String name, double price, DateTime time, int index) {
    Future<void> future = _database.editExpenseDB(name, price, time, _items[index].id);
    int month = time.month;
    int year = time.year;
    future.then((_) {
      Load(month, year);
    });
  }

  double sum() {
    double _sum = 0;
    _items.forEach((it) {
      _sum += it.price;
    }
    );
    return _sum;
  }

  int getMonth() {
    return _items[0].date.month;
  }

  int getYear() {
    return _items[0].date.year;
  }

}



