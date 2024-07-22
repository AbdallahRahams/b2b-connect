import 'dart:collection';
import 'dart:convert';
import 'package:b2b_connect/models/wholesaler.dart';
import 'package:b2b_connect/models/wholesaler_category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/wholesalers_pagination.dart';

class WholesalersProvider extends ChangeNotifier {
  /// HOME PAGE
  bool _isInitialWholesalerLoading = false;
  bool _isWholesalerCategoryLoading = false;
  bool _isWholesalerLoading = false;
  final List<WholesalerCategory> _wholesalerCategories = [];
  final List<Wholesaler> _wholesalers = [];
  int _activeWholesalerCategoryID = 0;
  final String _sort = "desc";
  int _page = 1;
  int _limit = 10;
  WholesalersPagination _wholesalersPagination =
      WholesalersPagination(page: 0, total: 0, lastPage: 0, wholesalers: []);
  final ScrollController _scrollController = ScrollController();
  late Wholesaler _wholesaler;

  /// SEARCH PAGE
  bool _isSearchingWholesalerLoading = false;
  WholesalersPagination _searchWholesalersPagination =
      WholesalersPagination(page: 0, total: 0, lastPage: 0, wholesalers: []);
  final List<Wholesaler> _searchWholesalers = [];
  final ScrollController _wholesalersScrollController = ScrollController();
  String _wholesalerSearch = "";
  String _wholesalerSort = "desc";
  int _wholesalerPage = 1;
  int _wholesalerLimit = 10;

  ///
  late WholesalerCategory _wholesalerCategory;

  /// HOME GETTERS
  bool get isWholesalerCategoryLoading => _isWholesalerCategoryLoading;

  bool get isWholesalerLoading => _isWholesalerLoading;

  UnmodifiableListView<WholesalerCategory> get wholesalerCategories =>
      UnmodifiableListView(_wholesalerCategories);

  UnmodifiableListView<Wholesaler> get wholesalers =>
      UnmodifiableListView(_wholesalers);

  int get activeWholesalerCategoryID => _activeWholesalerCategoryID;

  WholesalersPagination get wholesalersPagination => _wholesalersPagination;

  ScrollController get scrollController => _scrollController;

  Wholesaler get wholesaler => _wholesaler;

  bool get isInitialWholesalerLoading => _isInitialWholesalerLoading;

  /// SEARCH GETTERS
  WholesalersPagination get searchPostPaginationResult =>
      _searchWholesalersPagination;

  bool get isSearchingWholesalerLoading => _isSearchingWholesalerLoading;

  UnmodifiableListView<Wholesaler> get searchPosts =>
      UnmodifiableListView(_searchWholesalers);

  String get wholesalerSearch => _wholesalerSearch;

  ScrollController get wholesalersScrollController =>
      _wholesalersScrollController;

  WholesalerCategory get wholesalerCategory => _wholesalerCategory;

  initialFunctions() {
    _page = 1;
    _limit = 10;
    fetchWholesalerCategories();
    scrollControl();
  }

  fetchWholesalerCategories() async {
    try {
      _isWholesalerCategoryLoading = true;
      _isInitialWholesalerLoading = true;
      http.Response categoriesResponse;
      categoriesResponse = await http.get(
        Uri.parse('$wholesalersURL/api/v1/wholesaler/categories'),
        headers: {'Content-Type': 'application/json'},
      );
      if (categoriesResponse.statusCode == 200) {
        var categoriesJson = json.decode(utf8.decode(categoriesResponse.bodyBytes));
        _wholesalerCategories.clear();
        categoriesJson.forEach((menu) =>
            {_wholesalerCategories.add(WholesalerCategory.fromJson(menu))});
        if (_wholesalerCategories.isNotEmpty) {
          _activeWholesalerCategoryID = _wholesalerCategories[0].id;
          fetchInitialWholesalers();
        }
        _isWholesalerCategoryLoading = false;
        notifyListeners();
        return;
      } else if (categoriesResponse.statusCode == 401) {
        _isWholesalerCategoryLoading = false;
        notifyListeners();
        return;
      } else {
        _isWholesalerCategoryLoading = false;
        notifyListeners();
        return;
      }
    } catch (e) {
      _isWholesalerCategoryLoading = false;
      notifyListeners();
      return;
    }
  }

  fetchInitialWholesalers() async {
    try {
      _isInitialWholesalerLoading = true;
      notifyListeners();
      http.Response wholesalersResponse;
      wholesalersResponse = await http.get(
        Uri.parse(
            "$wholesalersURL/api/v1/wholesalers?category=$_activeWholesalerCategoryID&sort=$_sort&page=$_page&limit=$_limit"),
        headers: {'Content-Type': 'application/json'},
      );

      if (wholesalersResponse.statusCode == 200) {
        var wholesalersJson =
            json.decode(utf8.decode(wholesalersResponse.bodyBytes));
        _wholesalersPagination =
            WholesalersPagination.fromJson(wholesalersJson);
        _wholesalers.clear();
        for (var wholesaler in _wholesalersPagination.wholesalers) {
          _wholesalers.add(wholesaler);
        }
        _isInitialWholesalerLoading = false;
        notifyListeners();
        return;
      } else if (wholesalersResponse.statusCode == 401) {
        _isInitialWholesalerLoading = false;
        notifyListeners();
        return;
      } else {
        _isInitialWholesalerLoading = false;
       notifyListeners();
        return;
      }
    } catch (e) {
      _isInitialWholesalerLoading = false;
      notifyListeners();
      return;
    }
  }

  scrollControl() {
    _scrollController.addListener(
      () async {
        if (_isWholesalerLoading == false) {
          if (_wholesalersPagination.lastPage >= _page) {
            _page++;
            fetchWholesalerPagination();
          }
        }
      },
    );
  }

  fetchWholesalerPagination() async {
    try {
      _isWholesalerLoading = true;
      notifyListeners();
      http.Response wholesalersResponse;
      wholesalersResponse = await http.get(
        Uri.parse(
            "$wholesalersURL/api/v1/wholesalers?category=$_activeWholesalerCategoryID&sort=$_sort&page=$_page&limit=$_limit"),
        headers: {'Content-Type': 'application/json'},
      );
      if (wholesalersResponse.statusCode == 200) {
        var wholesalersJson = json.decode(utf8.decode(wholesalersResponse.bodyBytes));
        _wholesalersPagination = WholesalersPagination.fromJson(wholesalersJson);
        for (var wholesaler in _wholesalersPagination.wholesalers) {
          _wholesalers.add(wholesaler);
        }

        _isWholesalerLoading = false;
        notifyListeners();
        return;
      } else if (wholesalersResponse.statusCode == 401) {
        _isWholesalerLoading = false;
        notifyListeners();
        return;
      } else {
        _isWholesalerLoading = false;
        notifyListeners();
        return;
      }
    } catch (e) {
      _isWholesalerLoading = false;
      notifyListeners();
      return;
    }
  }

  setActiveWholesalerCategory(int wholesalerCategoryID) {
    _page = 1;
    _limit = 10;
    _activeWholesalerCategoryID = wholesalerCategoryID;
    _isInitialWholesalerLoading = true;
    notifyListeners();
    fetchInitialWholesalers();
  }

  setActiveWholesaler(Wholesaler w) {
    _wholesaler = w;

    ///REVIEW CONCEPT
    // _commentPage = 1;
    // _commentLimit = 10;
    // _commentSort = "desc";
    // _comments.clear();
    notifyListeners();
  }

  resetReviews() {
    // _commentPage = 1;
    // _commentLimit = 10;
    // _commentSort = "desc";
    // _comments.clear();
  }

  fetchReviews() async {
    // try {
    //   _isCommentLoading = true;
    //   notifyListeners();
    //   http.Response commentsResponse;
    //   commentsResponse = await http.get(
    //     Uri.parse(
    //         "$postsManagementURL/api/v1/post/comments?post_id=${_post.id}&sort=$_commentSort&page=$_commentPage&limit=$_commentLimit"),
    //     headers: {'Content-Type': 'application/json'},
    //   );
    //
    //   if (commentsResponse.statusCode == 200) {
    //     var postsJson = json.decode(utf8.decode(commentsResponse.bodyBytes));
    //     _commentsPaginationResult = CommentPaginationResult.fromJson(postsJson);
    //     for (var comment in _commentsPaginationResult.comments) {
    //       _comments.add(comment);
    //     }
    //     _isCommentLoading = false;
    //     notifyListeners();
    //     return;
    //   } else if (commentsResponse.statusCode == 401) {
    //     _isCommentLoading = false;
    //     notifyListeners();
    //     return;
    //   } else {
    //     _isCommentLoading = false;
    //     notifyListeners();
    //     return;
    //   }
    // } catch (e) {
    //   _isCommentLoading = false;
    //   notifyListeners();
    //   return;
    // }
  }

  commentsScrollControl() {
    // _commentScrollController.addListener(
    //   () async {
    //     if (_isCommentLoading == false) {
    //       if (_commentsPaginationResult.lastPage! >= _commentPage) {
    //         _commentPage++;
    //         fetchComments();
    //       }
    //     }
    //   },
    // );
  }

  // setActiveComment(PostComment c) {
  //   _comment = c;
  //   _replyPage = 1;
  //   _replyLimit = 10;
  //   _replySort = "asc";
  //   _replies.clear();
  //   notifyListeners();
  // }

  // Future<ResponseMessage> addComment({required AddComment comment}) async {
  //   late ResponseMessage responseMessage;
  //   _isAddingCommentLoading = true;
  //   notifyListeners();
  //   try {
  //     Dio dio = Dio();
  //     var addCommentResponse =
  //         await dio.post('$postsManagementURL/api/v1/add/comment',
  //             data: json.encode({
  //               "id": comment.id,
  //               "user_id": comment.userID,
  //               "full_name": comment.fullName,
  //               "profile_image": comment.profileImage,
  //               "body": comment.body
  //             }));
  //     if (addCommentResponse.statusCode == 200) {
  //       if (addCommentResponse.data.containsKey('ERROR') &&
  //           addCommentResponse.data.containsKey('MESSAGE')) {
  //         responseMessage = ResponseMessage(
  //           error: addCommentResponse.data['ERROR'],
  //           message: addCommentResponse.data['MESSAGE'],
  //           unauthorized: false,
  //         );
  //         _isAddingCommentLoading = false;
  //         notifyListeners();
  //         return responseMessage;
  //       } else {
  //         responseMessage = ResponseMessage(
  //           error: true,
  //           unauthorized: false,
  //           message: "Failed to add comment",
  //         );
  //         _isAddingCommentLoading = false;
  //         notifyListeners();
  //         return responseMessage;
  //       }
  //     } else if (addCommentResponse.statusCode == 401) {
  //       responseMessage = ResponseMessage(
  //         error: true,
  //         message: "Unauthorized user",
  //         unauthorized: true,
  //       );
  //       _isAddingCommentLoading = false;
  //       notifyListeners();
  //       return responseMessage;
  //     } else if (addCommentResponse.statusCode == 400) {
  //       if (addCommentResponse.data.containsKey('ERROR') &&
  //           addCommentResponse.data.containsKey('MESSAGE')) {
  //         List<dynamic> messages = addCommentResponse.data['MESSAGE'];
  //         for (var message in messages) {
  //           responseMessage = ResponseMessage(
  //             error: addCommentResponse.data['ERROR'],
  //             message: message,
  //             unauthorized: false,
  //           );
  //         }
  //         _isAddingCommentLoading = false;
  //         notifyListeners();
  //         return responseMessage;
  //       } else {
  //         responseMessage = ResponseMessage(
  //           error: true,
  //           unauthorized: false,
  //           message: "Failed to add comment",
  //         );
  //         _isAddingCommentLoading = false;
  //         notifyListeners();
  //         return responseMessage;
  //       }
  //     } else {
  //       responseMessage = ResponseMessage(
  //         error: true,
  //         unauthorized: false,
  //         message: "Something went wrong",
  //       );
  //       _isAddingCommentLoading = false;
  //       notifyListeners();
  //       return responseMessage;
  //     }
  //   } catch (e) {
  //     responseMessage = ResponseMessage(
  //       error: true,
  //       unauthorized: false,
  //       message: "Something went wrong, retry",
  //     );
  //     _isAddingCommentLoading = false;
  //     notifyListeners();
  //     return responseMessage;
  //   }
  // }

  resetSearchWholesalerPage() {
    _wholesalerSearch = "";
    _wholesalerSort = "desc";
    _wholesalerPage = 1;
    _wholesalerLimit = 10;
    _searchWholesalers.clear();
  }

  searchingWholesalers(String value) {
    _wholesalerSearch = value;
    searchWholesalersPagination();
  }

  searchWholesalersPagination([isFromScrolling = false]) async {
    try {
      if (isFromScrolling == false) {
        _searchWholesalers.clear();
      }
      _isSearchingWholesalerLoading = true;
      notifyListeners();
      http.Response wholesalersResponse;
      wholesalersResponse = await http.get(
        Uri.parse(
            "$wholesalersURL/api/v1/wholesalers?search=$_wholesalerSearch&sort=$_wholesalerSort&page=$_wholesalerPage&limit=$_wholesalerLimit"),
        headers: {'Content-Type': 'application/json'},
      );

      if (wholesalersResponse.statusCode == 200) {
        var wholesalersJson =
            json.decode(utf8.decode(wholesalersResponse.bodyBytes));
        _searchWholesalersPagination =
            WholesalersPagination.fromJson(wholesalersJson);
        for (var wholesaler in _searchWholesalersPagination.wholesalers) {
          _searchWholesalers.add(wholesaler);
        }

        _isSearchingWholesalerLoading = false;
        notifyListeners();
        return;
      } else if (wholesalersResponse.statusCode == 401) {
        _isSearchingWholesalerLoading = false;
        notifyListeners();
        return;
      } else {
        _isSearchingWholesalerLoading = false;
        notifyListeners();
        return;
      }
    } catch (e) {
      _isSearchingWholesalerLoading = false;
      notifyListeners();
      return;
    }
  }

  searchPostScrollControl() {
    _wholesalersScrollController.addListener(
      () async {
        if (_isSearchingWholesalerLoading == false) {
          if (_searchWholesalersPagination.lastPage >= _wholesalerPage) {
            _wholesalerPage++;
            searchWholesalersPagination(true);
          }
        }
      },
    );
  }

  activateWholesalerCategory(WholesalerCategory c) {
    _wholesalerCategory = c;
    _wholesalers.clear();
    notifyListeners();
  }
}
