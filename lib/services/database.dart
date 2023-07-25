abstract class Database {

}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;
}
