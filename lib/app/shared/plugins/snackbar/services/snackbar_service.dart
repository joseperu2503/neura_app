import 'package:neura_app/app/shared/plugins/snackbar/enums/snackbar_type.dart';
import 'package:neura_app/app/shared/plugins/snackbar/models/snackbar_model.dart';
import 'package:neura_app/app/shared/plugins/snackbar/providers/snackbar_provider.dart';

class SnackbarService {
  static SnackbarModel? show(
    String message, {
    SnackbarType type = SnackbarType.info,
  }) {
    if (snackbarKey.currentState != null) {
      final newSnackbar = snackbarKey.currentState!.addSnackbar(message, type);
      return newSnackbar;
    }

    return null;
  }

  static remove(SnackbarModel? snackbar) {
    if (snackbarKey.currentState != null) {
      snackbarKey.currentState!.removeSnackbar(snackbar);
    }
  }
}
