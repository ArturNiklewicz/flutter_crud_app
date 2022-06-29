import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabse {
  // global field instance calling the private constructor
  static final NotesDatabase instance = NotesDatabase._init();

  // field for the database
  static Database? _database;

  // pritavte constructor
  NotesDatabase._init();

  // opening the asynchrounous connection for the database
  Future<Databse> get databse async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!
  }

  // initialize the database
  Future <Database> _initDB(String filePath) async {
  // store the database in our file storage system
  final dbPath = await getDatabasePath();
  //connect the dbPath with filePath
  final path = join(dbPath, filePath);

  return await openDatabase(path, version:1, onCreate: _createDB);

  Future _createDB(Database db, int version) async {

  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
  },
}
