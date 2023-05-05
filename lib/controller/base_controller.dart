import 'package:tracker/services/exception.dart';
import 'package:tracker/widgets/exception.dart';

class BaseController {
  void handleError(error) {
    // hideLoading();
    if (error is BadRequestException) {
      var message = error.message;
      ErrorWidgets.showErrorDialog(description: message);
    } else if (error is FetchDataException) {
      var message = error.message;
      ErrorWidgets.showErrorDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      var message = 'Oops! It took longer to respond.';
      ErrorWidgets.showErrorDialog(description: message);
    }
  }

  showLoading([String? message]) {
    ErrorWidgets.showLoading(message);
  }

  hideLoading() {
    ErrorWidgets.hideLoading();
  }
}
