class Landmark {
  Landmark({
    required this.x,
    required this.y,
    required this.z,
  });

  factory Landmark.fromJson(Map<String, dynamic> json) {
    return Landmark(
      x: json['x'] as double,
      y: json['y'] as double,
      z: json['z'] as double,
    );
  }
  final double x;
  final double y;
  final double z;
}
