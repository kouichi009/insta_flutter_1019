// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:instagram_flutter02/models/controller_datas/timeline_data.dart';
// import 'package:instagram_flutter02/models/post.dart';
// import 'package:instagram_flutter02/services/api/post_service.dart';

// class TimelineController extends StateNotifier<TimelineData> {
//   TimelineController([TimelineData? state])
//       : super(state ?? TimelineData.inital()) {
//     getPosts();
//   }

//   Future<void> getPosts() async {
//     try {
//       // _posts = await (_movieService.getPopularMovies(page: state.page));
//       Map values = await PostService.queryTimeline(
//           documentLimit: state.documentLimit,
//           lastDocument: state.lastDocument,
//           hasMore: state.hasMore);

//       state = state.copyWith(
//           posts: [...state.posts!, ...values['posts']],
//           userModels: [...state.userModels!, ...values['userModels']],
//           lastDocument: values['lastDocument'],
//           hasMore: values['hasMore']);
//     } catch (e) {
//       print(e);
//     }
//   }
// }
