import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/helpers/functions/hex_to_color_class.dart';
import 'package:flutter_provider_app/widgets/common/go_to_subreddit.dart';

class LeftDrawer extends StatefulWidget {
  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        child: Consumer<UserInformationProvider>(
            builder: (BuildContext context, UserInformationProvider model, _) {
          if (model.signedIn) {
            if (model.state == ViewState.Busy) {
              return Center(child: CircularProgressIndicator());
            } else if (model.state == ViewState.Idle) {
              return Container(
                color: Theme.of(context).cardColor,
                child: CupertinoScrollbar(
                  controller: _controller,
                  child: CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _controller,
                    slivers: <Widget>[
                      DrawerSliverAppBar(),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            index = index - 2;
                            if (index == -2) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: GoToSubredditWidget(),
                              );
                            }
                            if (index == -1) {
                              return ListTile(
                                title: Text(
                                  'Frontpage',
                                  style: Theme.of(context).textTheme.subhead,
                                ),
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/default_icon.png'),
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                  maxRadius: 16,
                                ),
                                subtitle: Text("Posts from your subscriptions"),
                                dense: true,
                                onTap: () {
                                  Navigator.of(context, rootNavigator: false)
                                      .pop();
                                  return Navigator.of(
                                    context,
                                    rootNavigator: false,
                                  ).push(
                                    CupertinoPageRoute(
                                      builder: (context) => SubredditFeedPage(
                                        subreddit: "",
                                      ),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                },
                              );
                            }
                            return ListTile(
                              dense: true,
                              title: Text(
                                model.userSubreddits.data.children[index]
                                    .display_name,
                                style: Theme.of(context).textTheme.subhead,
                              ),
                              leading: CircleAvatar(
                                maxRadius: 16,
                                backgroundImage: model.userSubreddits.data
                                            .children[index].community_icon !=
                                        ""
                                    ? CachedNetworkImageProvider(
                                        model.userSubreddits.data
                                            .children[index].community_icon,
                                      )
                                    : model.userSubreddits.data.children[index]
                                                .icon_img !=
                                            ""
                                        ? CachedNetworkImageProvider(
                                            model.userSubreddits.data
                                                .children[index].icon_img,
                                          )
                                        : AssetImage('assets/default_icon.png'),
                                backgroundColor: model.userSubreddits.data
                                            .children[index].primary_color ==
                                        ""
                                    ? Theme.of(context).accentColor
                                    : HexColor(
                                        model.userSubreddits.data
                                            .children[index].primary_color,
                                      ),
                              ),
                              onTap: () {
                                Navigator.of(context, rootNavigator: false)
                                    .pop();
                                return Navigator.of(
                                  context,
                                  rootNavigator: false,
                                ).push(
                                  CupertinoPageRoute(
                                    builder: (context) => SubredditFeedPage(
                                      subreddit: model.userSubreddits.data
                                          .children[index].display_name,
                                    ),
                                    fullscreenDialog: true,
                                  ),
                                );
                              },
                            );
                          },
                          childCount:
                              model.userSubreddits.data.children.length + 2,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            SizedBox(
                                height: MediaQuery.of(context).padding.bottom)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          } else {
            return CupertinoScrollbar(
              controller: _controller,
              child: CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _controller,
                slivers: <Widget>[
                  DrawerSliverAppBar(),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: GoToSubredditWidget(),
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            SizedBox(
                              height: 150,
                            ),
                            Text(
                              "Hello 🥳",
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .copyWith(
                                    color:
                                        Theme.of(context).textTheme.title.color,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "You're not signed in",
                              style: Theme.of(context).textTheme.headline,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Sign in to Fritter to see your subscriptions",
                              style: Theme.of(context).textTheme.body2,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 56.0,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    14,
                                  ),
                                ),
                                child: Text("Sign In"),
                                onPressed: () {
                                  model.authenticateUser(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            );
          }
          return Container();
        }),
      ),
    );
  }
}

class DrawerSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      automaticallyImplyLeading: true,
      centerTitle: false,
      expandedHeight: 170,
      brightness: MediaQuery.of(context).platformBrightness,
      iconTheme: Theme.of(context).iconTheme,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        title: Text(
          "Subreddits",
        ),
      ),
    );
  }
}
