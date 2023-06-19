import 'dart:convert';

// class Pdf {
//   String link;
//   String items;
//
//   Pdf({
//     required this.link,
//     required this.items,
//   });
//
//   factory Pdf.fromRawJson(String str) => Pdf.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Pdf.fromJson(Map<String, dynamic> json) => Pdf(
//     link: json["link"],
//     items: json["items"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "link": link,
//     "items": items,
//   };
// }



List<Pdf> pdfFromJson(String str) => List<Pdf>.from(json.decode(str).map((x) => Pdf.fromJson(x)));

String pdfToJson(List<Pdf> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pdf {
  Pdf({
    required this.link,
    required this.items,
  });

  String link;
  String items;


  factory Pdf.fromJson(Map<String, dynamic> json) => Pdf(
    link: json["link"],
    items: json["items"],
  );

  Map<String, dynamic> toJson() => {
    "link": link,
    "items": items,
  };
}