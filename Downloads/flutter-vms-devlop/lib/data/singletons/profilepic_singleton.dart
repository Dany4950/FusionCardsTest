import 'dart:io';

// import 'package:image_picker/image_picker.dart';
import 'package:vms/manager/utils.dart';

File? _profilePic;

// Future<void> _pickImage(ImageSource source) async {
//   final picker = ImagePicker();
//   final pickedFile = await picker.pickImage(source: source);

//   if (pickedFile != null) {
//     _profilePic = File(pickedFile.path);

//     // Save profile picture locally (optional)
//     await _saveProfilePic(_profilePic!);
//   }
// }

Future<void> _saveProfilePic(File image) async {
  final prefs = SessionManager.prefs;
  prefs.setString('profile_pic', image.path);
}

Future<void> _loadProfilePic() async {
  final prefs = SessionManager.prefs;
  final imagePath = prefs.getString('profile_pic');
  if (imagePath != null) {
    _profilePic = File(imagePath);
  }
}
