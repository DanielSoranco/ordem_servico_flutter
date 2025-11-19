// lib/core/di/register_module.dart

import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  // Ensina o GetIt a criar uma instância de ImagePicker quando alguém pedir
  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();
}