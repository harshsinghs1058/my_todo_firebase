import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_todo/main.dart';

class DataBaseService {
  final todoCollection = FirebaseFirestore.instance.collection(userUid);
  Future<void> addTodo(task, date, uid) async {
    return await FirebaseFirestore.instance.collection(uid).doc().set({
      "tasks": task,
      "time": date,
    });
  }

  Future<void> deleteTask(uid, id) async {
    return await FirebaseFirestore.instance.collection(uid).doc(id).delete();
  }

//
// deleteTodos(item) {
//   DocumentReference documentReference =
//   FirebaseFirestore.instance.collection("MyTodos").document(item);
//s
//   documentReference.delete().whenComplete(() {
//     print("$item deleted");
//   });
// }
}
