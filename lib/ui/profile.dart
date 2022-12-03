import 'package:flutter/material.dart';

import '../widget/mini_post.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<ProfileScreen> {
  late TabController _tabController;
  late ScrollController _scrollViewController;

  Widget BuildImageProfile() {
    return ClipOval(
      child: Material(
          color: Colors.transparent,
          child: Ink.image(
            fit: BoxFit.cover,
            width: 128,
            height: 128,
            image: const AssetImage("assets/images/user.jpg"),
            child: InkWell(onTap: () => {}),
          )),
    );
  }

  Widget BuildEditProfileIcon() {
    return ClipOval(
        child: Container(
      padding: const EdgeInsets.all(8),
      color: const Color.fromRGBO(161, 20, 68, 1.0),
      child: const Icon(
        Icons.edit,
        color: Colors.white,
      ),
    ));
  }

  Widget BuildProfileInformation() {
    final double fontTitleSize = 13.0;
    final double fontSize = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
            child: Text(
          "Septian Putra Pratama",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        )),
        Center(
            child: Text(
          "septianpratama@gmail.com",
          style: TextStyle(color: Colors.grey[600]),
        )),
        Container(
          padding: EdgeInsets.only(left: 44, top: 20, right: 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "NIM",
                  style: TextStyle(fontSize: fontTitleSize),
                ),
              ),
              Text(
                "11310920001112",
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Major",
                  style: TextStyle(fontSize: fontTitleSize),
                ),
              ),
              Text(
                "Computer Science",
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Faculty",
                  style: TextStyle(fontSize: fontTitleSize),
                ),
              ),
              Text("Science & Technology",
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  )),
              Divider(
                color: Colors.black,
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              backgroundColor: Colors.white,
              forceElevated: boxIsScrolled,
              expandedHeight: 500,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 22, bottom: 22),
                            child: BuildImageProfile(),
                          ),
                          Positioned(
                            child: BuildEditProfileIcon(),
                            right: 4,
                            bottom: 15,
                          )
                        ],
                      ),
                    ),
                    BuildProfileInformation(),
                  ],
                ),
              ),
              bottom: TabBar(
                indicatorColor: Colors.black,
                indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(width: 2.0),
                    insets: EdgeInsets.symmetric(
                      horizontal: 8.0,
                    )),
                labelColor: Colors.black,
                tabs: const <Widget>[
                  Tab(
                    text: "Post",
                    icon: Icon(
                      Icons.post_add,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    text: "Returned",
                    icon: Icon(
                      Icons.check_box,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    text: "Bookmark",
                    icon: Icon(
                      Icons.bookmark_added,
                      color: Colors.black,
                    ),
                  )
                ],
                controller: _tabController,
              ),
            )
          ];
        },
        body: TabBarView(
          children: <Widget>[
            GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(10),
              children: const [
                MiniPost(),
                MiniPost(),
                MiniPost(),
                MiniPost(),
                MiniPost(),
                MiniPost(),
                MiniPost(),
                MiniPost(),
                MiniPost(),
              ],
            ),
            GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(10),
              children: const [
                MiniPost(),
                MiniPost(),
              ],
            ),
            GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(10),
              children: const [
                MiniPost(),
              ],
            ),
          ],
          controller: _tabController,
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
