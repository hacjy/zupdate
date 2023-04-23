
class DownloadModel {
  DownloadModel();

  DownloadModel.fromJson(dynamic json) {
    url = json['url'];
    path = json['path'];
    progress = json['progress'];
    status = json['status'];
  }
  String url = '';
  String path  = '';
  double progress = 0;
  DownloaderStatus status  = DownloaderStatus.unstarted;

  String get statusDescription {
    switch (status) {
      case DownloaderStatus.downloading:
        return "downloading";
      case DownloaderStatus.paused:
        return "paused";
      case DownloaderStatus.failed:
        return "failed";
      case DownloaderStatus.succeeded:
        return "succeeded";
      default:
        return "unstarted";
    }
  }

  DownloaderStatus get downloadStatus {
    switch (status) {
      case DownloaderStatus.downloading:
        return DownloaderStatus.downloading;
      case DownloaderStatus.paused:
        return DownloaderStatus.paused;
      case DownloaderStatus.failed:
        return DownloaderStatus.failed;
      case DownloaderStatus.succeeded:
        return DownloaderStatus.succeeded;
      default:
        return DownloaderStatus.unstarted;
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['path'] = path;
    map['progress'] = progress;
    map['status'] = status;
    return map;
  }

}

enum DownloaderStatus { unstarted, downloading, paused, failed, succeeded }