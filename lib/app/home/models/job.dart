import 'dart:ui';

class Job {
  Job({required this.name, required this.ratePerHour, required this.id});

  final String id;
  final String name;
  final int ratePerHour;

  /* factory methods keep all data conversion inside the model class itself
  Best practice. factory constructor doesn't always return a new instance
  can return null

  fromMap() and toMap() are common practices*/
  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    String name = data['name'];
    int ratePerHour = data['ratePerHour'];
    return Job(id: documentId, name: name, ratePerHour: ratePerHour);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'ratePerHour': ratePerHour};
  }

  /// Hash codes must be the same for objects that are equal to each other
  /// according to [operator ==].
  /// Objects with the same properties don't have the same HashCode by default. Unique instances.
  /// Good practice to implement these methods to compare objects
  /// This is the correct way to do it.
  @override
  int get hashCode => Object.hash(id, name, ratePerHour);

  // int get hashCode => hasValues(id, name, ratePerHour); // Deprecated?

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // Checks if the two Objects are the same reference in memory
    if (runtimeType != other.runtimeType) return false; // Checks if the other Object is of the same time as the original. If not return false.
    final Job otherJob = other as Job;
    return id == otherJob.id &&
        name == otherJob.name &&
        ratePerHour == otherJob.ratePerHour;

  }
}
