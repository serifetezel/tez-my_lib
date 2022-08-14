import 'package:http/http.dart' as http;

class BookApi{
  static Future getRecommendBooks(){
    return http.get(Uri.parse("http://172.20.10.9:5000/book_title?title=The%20Leadership%20Pipeline:%20How%20to%20Build%20the%20Leadership-Powered%20Company"));
  }
}

class AllBookApi{
  static Future getAllBooks(){
    return http.get(Uri.parse("http://172.20.10.9:5000/books"));
  }
}

class PopularBooksApi{
  static Future getPopularBooks(){
    return http.get(Uri.parse("http://172.20.10.9:5000/popular"));
  }
}

