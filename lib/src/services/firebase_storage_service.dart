import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:universal_html/prefer_universal/html.dart' as html;

class FirebaseStorageServices {
  Future<String> uploadImageFile(html.File image, {String imageName}) async {
    try {
      fb.UploadTaskSnapshot task = await fb
          .storage()
          .ref('Images/${DateTime.now().millisecondsSinceEpoch}')
          .put(image)
          .future;

      return (await task.ref.getDownloadURL()).toString();
    } catch (e) {
      Utils.showMessage(e.toString());
      return null;
    }
  }
}
