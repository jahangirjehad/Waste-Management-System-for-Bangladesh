class Organization {
  final String name;
  final String title;
  final int member;
  final int totalPost;
  final List<Post> posts;

  Organization({
    required this.name,
    required this.title,
    required this.member,
    required this.totalPost,
    required this.posts,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      name: json['name'],
      title: json['title'],
      member: json['member'],
      totalPost: json['totalPost'],
      posts: (json['post'] as List).map((e) => Post.fromJson(e)).toList(),
    );
  }
}

class Post {
  final String postDate;
  final String statusText;
  final String statusImage;
  int likes;
  final int comments;

  Post({
    required this.postDate,
    required this.statusText,
    required this.statusImage,
    required this.likes,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postDate: json['postDate'],
      statusText: json['statusText'],
      statusImage: json['statusImage'],
      likes: json['likes'],
      comments: json['comments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postDate': postDate,
      'statusText': statusText,
      'statusImage': statusImage,
      'likes': likes,
      'comments': comments,
    };
  }
}
