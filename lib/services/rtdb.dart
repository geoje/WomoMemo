import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class RTDB {
  static final instance = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://womoso-default-rtdb.firebaseio.com/',
  );
}
