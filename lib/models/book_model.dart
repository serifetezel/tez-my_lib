// ignore_for_file: prefer_initializing_formals, non_constant_identifier_names, duplicate_ignore

class BookInfo{
  String ?Author;
  String ?Genres;
  String ?Name;
  String ?Description;
  String ?Image_link;
  double ?Rating;

  // ignore: non_constant_identifier_names
  BookInfo(String Author, String Genres, String Name, String Description, String Image_link, double Rating){
    this.Author = Author;
    this.Genres = Genres;
    this.Name = Name;
    this.Description = Description;
    this.Image_link = Image_link;
    this.Rating = Rating;
  }

  BookInfo.fromJson(Map json)
  :Author = json['Author'],
  Genres = json['Genres'],
  Name = json['Name'],
  Description = json['Description'],
  Image_link = json['Image Link'],
  Rating = json['Rating'];

  Map toJson(){
    return {
      'Author' : Author,
      'Genres' : Genres,
      'Name' : Name,
      'Description' : Description,
      'Image Link' : Image_link,
      'Rating' : Rating,
    };
  }
}