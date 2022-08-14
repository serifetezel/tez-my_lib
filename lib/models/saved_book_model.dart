// ignore_for_file: prefer_initializing_formals, non_constant_identifier_names, duplicate_ignore

class SavedBookInfo{
  String ?Author;
  String ?Genres;
  String ?Name;
  String ?Description;
  String ?Image_link;
  double ?Rating;
  String ?kullaniciid;
  String ?id;

  // ignore: non_constant_identifier_names
  SavedBookInfo({
    required this.Author,
    required this.Genres,
    required this.Name,
    required this.Description,
    required this.Image_link,
    required this.Rating,
    required this.kullaniciid,
    required this.id,
  });

  Map<String, dynamic> toMap(){
    return {
      'Author' : Author,
      'Genres' : Genres,
      'Name' : Name,
      'Description' : Description,
      'Image Link' : Image_link,
      'Rating' : Rating,
      'kullaniciid' : kullaniciid,
      'id' : id
    };
  }

  factory SavedBookInfo.fromMap(Map map) {
    return SavedBookInfo(
      Author: map['Author'], 
      Genres: map['Genres'], 
      Name: map['Name'], 
      Description: map['Description'], 
      Image_link: map['Image_link'], 
      Rating: map['Rating'], 
      kullaniciid: map['kullaniciid'],
      id: map['id']
    );
  }
}