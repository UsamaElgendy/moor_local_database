// assuming that your file is called filename.dart. This will give an error at first,
// but it's needed for moor to know about the generated code

import 'package:moor_flutter/moor_flutter.dart';

/// to generate file ==> flutter packages pub run build_runner watch
part 'database_helper.g.dart';

// @DataClassName('TaskTable')
class Tasks extends Table {
  // autoIncrement sets this to be the primary key
  IntColumn get id => integer().autoIncrement()(); // => .call()
  TextColumn get name => text().withLength(min: 1, max: 50)();

  DateTimeColumn get dueDate => dateTime().nullable()();

  /// we can pass null value to this

  BoolColumn get completed => boolean().withDefault(Constant(false))();
}

// _$AppDatabase is the name of the generated class
@UseMoor(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite',
            // Good for debugging - prints SQL in the console
            logStatements: true));

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;

  Future<List<Task>> getAllTasks() => select(tasks).get();

  Stream<List<Task>> watchAllTasks() => select(tasks).watch();

  Future insertTask(Task task) => into(tasks).insert(task);

  Future updateTask(Task task) => update(tasks).replace(task);

  Future deleteTask(Task task) => delete(tasks).delete(task);
}
