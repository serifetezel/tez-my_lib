class User{
  final String id;
  final String name;
  final String email;
  final String creationTime;
   
  User({required this.id, required this.name,required this.email, required this.creationTime,});

  User.fromData(Map<String, dynamic> data)
    : id = data['id'],
    name = data['name'],
    email = data['email'],
    creationTime = data['creationTime'];

  Map<String, dynamic> toJson(){
    return {
      'id' : id,
      'name' : name,
      'email' : email,
      'creationTime' : creationTime,
    };
  }
}