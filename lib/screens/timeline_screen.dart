import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_flutter02/common_widgets/app_header.dart';
import 'package:instagram_flutter02/common_widgets/post_view.dart';
import 'package:instagram_flutter02/controllers/timeline_controller.dart';
import 'package:instagram_flutter02/models/controller_datas/timeline_data.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/screens/post_detail_screen.dart';
import 'package:instagram_flutter02/services/api/auth_service.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';

final timelineControllerProvider =
    StateNotifierProvider<TimelineController, TimelineData>((ref) {
  return TimelineController();
});

final selectedPostProvider = StateProvider<String?>((ref) {
  final _posts = ref.watch(timelineControllerProvider).posts;
  return null;
});

class TimelineScreen extends ConsumerWidget {
  String? currentUid;

  TimelineScreen({this.currentUid});

  late TimelineController _timelineController;
  late TimelineData _timelineData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _timelineController = ref.watch(timelineControllerProvider.notifier);
    _timelineData = ref.watch(timelineControllerProvider);

    return Scaffold(
        appBar: AppHeader(
          isAppTitle: true,
        ),
        body: RefreshIndicator(
            onRefresh: () => refresh(), child: _buildDisplayPosts()));
  }

  Widget _buildDisplayPosts() {
    List<PostView> postViews = [];
    final List<Post> _posts = _timelineData.posts!;
    final List<UserModel> _userModels = _timelineData.userModels!;

    if (_posts.length != 0) {
      return NotificationListener(
        onNotification: (dynamic _onScrollNotification) {
          if (_onScrollNotification is ScrollEndNotification) {
            final before = _onScrollNotification.metrics.extentBefore;
            final max = _onScrollNotification.metrics.maxScrollExtent;
            if (before == max) {
              _timelineController.getPosts();
              return true;
            }
            return false;
          }
          return false;
        },
        child: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (BuildContext _context, int _index) {
            return new GestureDetector(
              //You need to make my child interactive
              onTap: () => goToPostDetail(_context, _posts[_index]),
              child: PostView(
                currentUid: currentUid,
                userModel: _userModels[_index],
                post: _posts[_index],
              ),
            );
          },
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    }
  }

  goToPostDetail(context, post) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PostDetailScreen(currentUid: currentUid, post: post),
        ));
    if (result != null) {
      refresh();
    }
  }

  refresh() async {
    // Map values = await PostService.queryTimeline(documentLimit, null, true);

    // List<Post> posts = values['posts'];
    // List<UserModel> userModels = values['userModels'];
    // _posts = posts;
    // _userModels = userModels;
    // _hasMore = values['hasMore'];
    // _lastDocument = values['lastDocument'];
    // setState(() {
    //   _isLoading = false;
    // });
  }
}
