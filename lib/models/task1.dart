class Task {
  int? id;
  String? title;
  int? color;
  double? lat;
  double? lan;

  Task({
    this.id,
    this.title,
    this.color,
    this.lat,
    this.lan,
});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    color = json['color'];
    lat = json['lat'];
    lan = json['lan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['color'] = this.color;
    data['lat'] = this.lat;
    data['lan'] = this.lan;
    return data;
  }
}