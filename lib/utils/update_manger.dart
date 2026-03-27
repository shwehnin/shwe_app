import 'package:in_app_update/in_app_update.dart';

class UpdateManager {
  static Future<void> checkAndUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();

        // Choose update type based on priority
        // if (updateInfo.immediateUpdateAllowed) {
        //   // Critical update - force immediate update
        //   await InAppUpdate.performImmediateUpdate();
        // } else if (updateInfo.flexibleUpdateAllowed) {
        //   // Optional update - background download
        //   await InAppUpdate.startFlexibleUpdate();
        //   // You can show a notification to complete later
        //   // await InAppUpdate.completeFlexibleUpdate();
        // }
      }
    } catch (e) {
     // print('Update check failed: $e');
    }
  }
}
