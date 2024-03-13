class Version {
  final String current_version;
  final String update_status;
  Version({
    this.current_version,
    this.update_status,
  });

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      current_version: json['current_version'].toString(),
      update_status: json['update_status'],
    );
  }
}