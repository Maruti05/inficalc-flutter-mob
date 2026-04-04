import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

/// Service that manages Android in-app updates using Google Play Core.
/// Safely no-ops on non-Android platforms.
class UpdateService {
  AppUpdateInfo? _updateInfo;

  /// Whether the current platform supports in-app updates.
  bool get isSupported => Platform.isAndroid;

  /// Checks Google Play for an available update.
  /// Returns the [AppUpdateInfo] if an update is available, null otherwise.
  Future<AppUpdateInfo?> checkForUpdate() async {
    if (!isSupported) return null;

    try {
      _updateInfo = await InAppUpdate.checkForUpdate();

      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        return _updateInfo;
      }
    } catch (e) {
      debugPrint('InfiCalc UpdateService: $e');
    }
    return null;
  }

  /// Starts a flexible update (downloads in background, user can keep using the app).
  /// Call [completeFlexibleUpdate] once the download finishes.
  Future<void> startFlexibleUpdate() async {
    if (!isSupported) return;
    try {
      await InAppUpdate.startFlexibleUpdate();
    } catch (e) {
      debugPrint('InfiCalc UpdateService (flexible): $e');
    }
  }

  /// Completes a previously downloaded flexible update by restarting the app.
  Future<void> completeFlexibleUpdate() async {
    if (!isSupported) return;
    try {
      await InAppUpdate.completeFlexibleUpdate();
    } catch (e) {
      debugPrint('InfiCalc UpdateService (complete): $e');
    }
  }

  /// Performs an immediate (blocking) update — full-screen Play Store flow.
  Future<void> performImmediateUpdate() async {
    if (!isSupported) return;
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      debugPrint('InfiCalc UpdateService (immediate): $e');
    }
  }

  /// Whether the available update supports flexible mode.
  bool get flexibleUpdateAllowed =>
      _updateInfo?.flexibleUpdateAllowed ?? false;

  /// Whether the available update supports immediate mode.
  bool get immediateUpdateAllowed =>
      _updateInfo?.immediateUpdateAllowed ?? false;

  /// How many days since Google Play learned of the update (staleness).
  /// Useful for escalating from flexible → immediate after N days.
  int? get updateStaleness =>
      _updateInfo?.clientVersionStalenessDays;

  /// The update priority set in the Play Console (0–5).
  int get updatePriority =>
      _updateInfo?.updatePriority ?? 0;
}
