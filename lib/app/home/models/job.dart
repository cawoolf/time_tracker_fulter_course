class Job {
  Job( {required this.name, required this.ratePerHour, required this.id});
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
     return Job (
       id: documentId,
         name: name,
     ratePerHour: ratePerHour);

  }

  Map<String, dynamic> toMap() {
    return {
      'name' : name,
      'ratePerHour' : ratePerHour
    };
  }


}

