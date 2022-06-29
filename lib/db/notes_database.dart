import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class NotesDatabase {
  // variable: 'instance' calling the private constructor
  static final NotesDatabase instance = NotesDatabase._init();

  // variable: the database
  static Database? _database;

  // contructor
  NotesDatabase._init();

  // creating a connection with the database
  Future<Database> get database async {
    // check: if the database already exists
    if (_database != null) return _database!;

    // initialize: the database if it does not exist
    _database = await _initDB('notes.db');
    return _database!;
  }

  // method: initializing the database
  Future<Database> _initDB(String filePath) async {
    // variable: 'dbPath' => path to the database
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print(path);
    // open the database
    // IF ONE WANTS TO INTRODUCE NEW SCHEMA version => if incremented onUpgrade: will be ran
    // onCreate => the database schema
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // the database schema
  Future _createDB(Database db, int version) async {
    // defining the types for the fields
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    // Name of the SQL table
    // Structure of the SQL table (columns)
    await db.execute('''
CREATE TABLE $tableNotes ( 
  ${NoteFields.id} $idType, 
  ${NoteFields.isImportant} $boolType,
  ${NoteFields.number} $integerType,
  ${NoteFields.title} $textType,
  ${NoteFields.description} $textType,
  ${NoteFields.createdTime} $textType
  )
''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;

    // raw insert => for unique SQL statements
    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    // after inserting the converted note object to tableNotes
    // we get a generated id back
    final id = await db.insert(tableNotes, note.toJson());
    // copying the note object and inserting the generated id to it
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
    // check: whether the maps are not empty
    if (maps.isNotEmpty) {
      // convert the map form JSON to Note
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${NoteFields.createdTime} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  // closing the database
  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
