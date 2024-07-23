class GetIframeRes {
  String? status;

  String? frameUrl;

  GetIframeRes({
    this.status,
    this.frameUrl,
  });

  GetIframeRes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    frameUrl = json['iframe_url'];
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'iframe_url': frameUrl,
    };
  }
}
