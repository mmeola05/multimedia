class Track {
  final String trackName;
  final String artistName;
  final String artworkUrl;
  final String previewUrl;

  Track({
    required this.trackName,
    required this.artistName,
    required this.artworkUrl,
    required this.previewUrl,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      trackName: json['trackName'] ?? 'Unknown Track',
      artistName: json['artistName'] ?? 'Unknown Artist',
      artworkUrl: json['artworkUrl100'] ?? '',
      previewUrl: json['previewUrl'] ?? '',
    );
  }
}
