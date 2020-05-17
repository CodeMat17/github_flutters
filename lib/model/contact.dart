class Contact {
  final String login;
  final String avatar;
  final String html;

  Contact({
    this.login,
    this.avatar,
    this.html,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      login: json['login'],
      avatar: json['avatar_url'],
      html: json['html_url'],
    );
  }
}
