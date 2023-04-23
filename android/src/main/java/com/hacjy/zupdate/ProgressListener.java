package com.hacjy.zupdate;

/**
 * Listener for progress updates
 */
public interface ProgressListener {
    void onDownloadProgress(long bytesRead, long contentLength, boolean done);
}
