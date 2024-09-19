import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:match_app/constants/value_constants.dart';

class FunctionConstants {
  static resetVotes() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return;
    }
    FirebaseDatabase.instance
        .ref(ValueConstants.votes)
        .orderByChild("userId")
        .equalTo(userId)
        .once()
        .then((event) => {event.snapshot.ref.remove()});
  }
}
