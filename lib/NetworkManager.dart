class NetworkManager {

  var firstToken = '1' ;
  var secondToken = '2' ;
  final String authURL = "https://oauth.vk.com/authorize?client_id=6784305&display=mobile&scope=262174&redirect_uri=https://oauth.vk.com/blank.html&response_type=token&v=5.92";

  static final NetworkManager _singleton = new NetworkManager._internal();

  factory NetworkManager() {
    return _singleton;
  }

  NetworkManager._internal();

  String groupsURL() {
    return "https://api.vk.com/method/groups.get?user_id=392688129&count=1000&access_token=$firstToken&v=5.92";
  }

  String videosURL() {
    return "https://api.vk.com/method/video.get?owner_id=392688129&album_id=3&count=20&access_token=$firstToken&v=5.92";
  }

  String photosURL() {
    return "https://api.vk.com/method/photos.getAlbums?owner_id=392688129&need_system=1&access_token=$firstToken&v=5.92";
  }

}

/*
var s1 = new Singleton();
  var s2 = new Singleton();
  print(identical(s1, s2));  // true
  print(s1 == s2);           
  */