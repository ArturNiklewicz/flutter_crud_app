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
  // if version incremented => onUpgrade: method will be run

  Future _createDB(Database db, int version) async {
    // defining variable types for SQL
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = "TEXT NOT NULL";
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    // creating the database table (schema)
    await db.execute('''
CREATE TABLE $tableNotes (
  ${NoteFields.id} $idType,
  ${NoteFields.isImportant} $boolType,
  ${NoteFields.number} $integerType,
  ${NoteFields.title} $textType,
  ${NoteFields.description} $textType,
  ${NoteFields.time} $textType,
  )
''');
// it's possible to create multiple data tables, just duplicate from "await.db.execute..."
  }

  // C for CRUD
  Future<Note> create(Note note) async {
    // a reference to the database
    final db = await instance.database;

    // call on the database's insert method
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
  },
}
