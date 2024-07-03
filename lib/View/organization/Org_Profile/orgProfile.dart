import 'package:flutter/material.dart';
import 'package:maps_app/Model/organizationModel.dart';
import 'package:maps_app/View/organization/organizationChat.dart';
import 'package:maps_app/utils/my_colors.dart';

class Orgprofile extends StatefulWidget {
  final Organization organizations;
  final int id;

  const Orgprofile({Key? key, required this.organizations, required this.id})
      : super(key: key);

  @override
  State<Orgprofile> createState() => _OrgprofileState();
}

class _OrgprofileState extends State<Orgprofile> {
  bool isJoined = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrganizationInfo(),
                  SizedBox(height: 24),
                  _buildActionButtons(),
                  SizedBox(height: 24),
                  Text(
                    'Recent Posts',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          _buildPostsList(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.organizations.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
            ),
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://media.assettype.com/TNIE%2Fimport%2F2018%2F10%2F3%2Foriginal%2FGreene.jpg?w=1200&auto=format%2Ccompress&fit=max',
              fit: BoxFit.cover,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.organizations.title,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 20),
            SizedBox(width: 4),
            Text('4.5',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(width: 16),
            Icon(Icons.people, color: MyColors.caribbeanGreen, size: 20),
            SizedBox(width: 4),
            Text('${widget.organizations.member} members',
                style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.post_add, color: MyColors.caribbeanGreen, size: 20),
            SizedBox(width: 4),
            Text('${widget.organizations.totalPost} posts',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isJoined = !isJoined;
              });
            },
            child: Text(isJoined ? 'Leave' : 'Join'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isJoined ? Colors.red : MyColors.caribbeanGreen,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  organizationId: widget.id,
                  organizationName: widget.organizations.name,
                ),
              ),
            );
          },
          child: Icon(Icons.message, color: Colors.white),
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.spaceCadet,
            shape: CircleBorder(),
            padding: EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildPostsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = widget.organizations.posts[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(post.statusImage),
                        radius: 20,
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.organizations.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(post.postDate,
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(post.statusText),
                  SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      post.statusImage,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.thumb_up,
                          color: post.likes > 0
                              ? MyColors.caribbeanGreen
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            post.likes = post.likes > 0 ? 0 : 1;
                          });
                        },
                      ),
                      Text('${post.likes} likes'),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {},
                      ),
                      Text('${post.comments} comments'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        childCount: widget.organizations.posts.length,
      ),
    );
  }
}
