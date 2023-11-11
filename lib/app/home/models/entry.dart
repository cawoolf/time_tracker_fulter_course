class Entry {
  Entry({
    required this.id,
    required this.jobId,
    required this.start,
    required this.end,
    required this.comment,
  });

  String id;
  String jobId;
  DateTime start;
  DateTime end;
  String comment;

  double get durationInHours =>
      end.difference(start).inMinutes.toDouble() / 60.0;

  factory Entry.fromMap(Map<dynamic, dynamic> value, String id) {
    final int startMilliseconds = value['start'];
    final int endMilliseconds = value['end'];
    return Entry(
      id: id,
      jobId: value['jobId'],
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
      comment: value['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jobId': jobId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
    };
  }

  /// Hash codes must be the same for objects that are equal to each other
  /// according to [operator ==].
  /// Objects with the same properties don't have the same HashCode by default. Unique instances.
  /// Good practice to implement these methods to compare objects
  /// This is the correct way to do it.
  @override
  int get hashCode => Object.hash(id, jobId, start, end, comment);

  // int get hashCode => hasValues(id, name, ratePerHour); // Deprecated?

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true; // Checks if the two Objects are the same reference in memory
    }
    if (runtimeType != other.runtimeType) {
      return false; // Checks if the other Object is of the same time as the original. If not return false.
    }
    final Entry otherEntry = other as Entry;
    return id == otherEntry.id &&
        jobId == otherEntry.jobId &&
        start == otherEntry.start &&
        end == otherEntry.end &&
        comment == otherEntry.comment;
  }
}
