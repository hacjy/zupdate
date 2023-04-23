
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class Zupdate {
  static const EventChannel _progressChannel =
  EventChannel('com.hacjy.zupdate');
  Stream<ZUpdateEvent>? _progressStream;

  /// Execute download and instalation of the plugin.
  /// Download progress and all success or error states are publish in stream as OtaEvent
  Stream<ZUpdateEvent> execute(
      String url, {
        Map<String, String> headers = const <String, String>{},
        String? androidProviderAuthority,
        String? destinationFilename,
        String? sha256checksum,
      }) {
    if (destinationFilename != null && destinationFilename.contains('/')) {
      throw UpdateException('Invalid filename $destinationFilename');
    }
    final StreamController<ZUpdateEvent> controller =
    StreamController<ZUpdateEvent>.broadcast();
    if (_progressStream == null) {
      _progressChannel.receiveBroadcastStream(
        <dynamic, dynamic>{
          'url': url,
          'androidProviderAuthority': androidProviderAuthority,
          'filename': destinationFilename,
          'checksum': sha256checksum,
          'headers': jsonEncode(headers)
        },
      ).listen((dynamic event) {
        final ZUpdateEvent otaEvent = _toUpdateEvent(event.cast<String>());
        controller.add(otaEvent);
        if (otaEvent.status != ZUpdateStatus.DOWNLOADING) {
          controller.close();
        }
      }).onError((Object error) {
        if (error is PlatformException) {
          controller.add(_toUpdateEvent(<String?>[error.code, error.message]));
        }
      });
      _progressStream = controller.stream;
    }
    return _progressStream!;
  }

  ZUpdateEvent _toUpdateEvent(List<String?> event) {
    return ZUpdateEvent(ZUpdateStatus.values[int.parse(event[0]!)], event[1]);
  }
}

///Event describing current status
class ZUpdateEvent {
  ///Constructor for ZUpdateEvent
  ZUpdateEvent(this.status, this.value);

  /// Current status as enum value
  ZUpdateStatus status;

  /// Additional status info e.g. percents downloaded or error message (can be null)
  String? value;
}

/// Enum values describing states
enum ZUpdateStatus {
  /// FILE IS BEING DOWNLOADED
  DOWNLOADING,

  /// INSTALLATION HAS BEEN TRIGGERED
  INSTALLING,

  /// DOWNLOAD IS ALREADY RUNNING
  ALREADY_RUNNING_ERROR,

  /// COULD NOT CONTINUE BECAUSE OF MISSING PERMISSIONS
  PERMISSION_NOT_GRANTED_ERROR,

  /// UNKWNON ERROR. SEE VALUE FOR MORE INFROMATION
  INTERNAL_ERROR,

  /// FILE COULD NOT BE DOWNLOADED. SEE VALUE FOR MORE INFORMATION
  DOWNLOAD_ERROR,

  /// CHECKSUM VERIFICATION FAILED. MOSTLY THIS IS DUE INCORRECT OR CORRUPTED FILE
  /// THIS IS ALSO RETURNED IF PLUGIN WAS UNABLE TO CALCULATE SHA 256 HASH OF DOWNLOADED FILE
  /// SEE VALUE FOR MORE INFORMATION
  CHECKSUM_ERROR
}

/// EXCEPTION FOR QUICK IDENTIFICATION OF ERRORS THROWN FROM THIS PLUGIN.
/// THIS IS USED CURRENTLY ONLY FOR INPUT PARAMETER VERIFICATION ERRORS. IF THERE IS PROBLEM WITH
/// DOWNLOADING THE FILE OR RUNNING UPDATE OtaEvent WITH ONE OF THE _ERROR STATUSES IS USED
class UpdateException implements Exception {
  /// DEFAULT CONSTRUCTOR
  UpdateException(this.message);

  /// ERROR MESSAGE
  final String message;

  @override
  String toString() {
    return 'Exception: $message';
  }
}
