// the name of the table for storing notes
final String tableNotes = 'notes';

class NoteFields {
  static final String id = '_id';
    final bool isImportant = 'isImportant';
  final int number = 'number';
  final String title = 'title';
  final String description = 'description';
  final DateTime createdTime = 'createdTime';
}

class NoteFields {

}

class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Note copy ({
    int? id,
    int? id;
    bool isImportant;
    int number;
    String title;
    String description;
    DateTime createdTime;
  }) => 
      Note(
        id: id ?? this.id,
      );

  Map <String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.isImportant: isImportant ? 1 : 0,
        NoteFields.number: number,
        NoteFields.description: description,
        NoteFields.createdTime: createdTime.toIso8601String(),
  };
}