import 'package:neura_app/app/shared/plugins/snackbar/enums/snackbar_type.dart';

class SnackbarModel {
  final String id;
  final String message;
  final SnackbarType type;

  SnackbarModel({
    required this.id,
    required this.message,
    required this.type,
  });
}
