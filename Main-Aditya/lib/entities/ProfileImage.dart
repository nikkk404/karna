class ProfileImage {
  String? imageURL;

  ProfileImage(this.imageURL);

  void setProfileImage(String url) {
    imageURL = url;
  }

  String? get getProfileImage {
    return imageURL;
  }
}
