import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyket/bucket/component/custom_add_text_field.dart';
import 'package:keyket/bucket/component/custom_progressbar.dart';
import 'package:keyket/bucket/component/input_box.dart';
import 'package:keyket/bucket/component/member_card.dart';
import 'package:keyket/bucket/const/text_style.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:keyket/bucket/model/custom_item_model.dart';
import 'package:keyket/bucket/provider/bucket_list_detail_provider.dart';
import 'package:keyket/bucket/provider/bucket_list_provider.dart';
import 'package:keyket/common/component/custom_underline_button.dart';
import 'package:keyket/common/component/list_item.dart';
import 'package:keyket/common/component/select_box.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/model/user_model.dart';
import 'package:keyket/common/provider/my_provider.dart';
import 'package:keyket/recommend/component/hash_tag_item_list.dart';
import 'package:keyket/recommend/model/recommend_item_model.dart';
import 'package:keyket/recommend/provider/recommend_provider.dart';
import 'package:keyket/recommend/provider/selected_filter_provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class BucketListDetailScreen extends ConsumerStatefulWidget {
  // 버킷리스트의 id
  final String bucketListId;
  final bool isShared;

  // 생성자에서 필요한 매개변수를 받아옵니다.
  const BucketListDetailScreen({
    super.key,
    required this.bucketListId,
    required this.isShared,
  });

  @override
  ConsumerState<BucketListDetailScreen> createState() =>
      _BucketListDetailScreenState();
}

class _BucketListDetailScreenState
    extends ConsumerState<BucketListDetailScreen> {
  // 수정될 버킷 리스트 모델
  late BucketListModel modifiedBucketListModel;

  // 업데이트 된 custom bucketlist items 리스트
  List<CustomItemModel> updatedCustomBucketListItemList = [];

  // 새로 추가된 custom bucketlist items 리스트
  List<String> newCustomItemList = [];

  // 새로 추가된 완료된 custom bucketlist items 리스트
  List<String> newCustomItemCompletedList = [];

  // 삭제할 아이템 id list
  List<String> deleteList = [];

  // 아이템 추가 플래그
  bool addCustomItemFlag = false;

  // 버킷리스트의 변경 여부
  bool isChanged = false;

  // 초대하기 버튼 클릭 여부
  bool inviteFlag = false;

  // 배경화면 편집 모드가 활성화되었는지 나타내는 변수
  bool backgroundFlag = false;

  // 제목편집 버튼 클릭 여부
  bool titleFlag = false;

  File? tmpImage;

  bool _isSaving = false; // 저장중을 나타내는 플래그

  List<CustomItemModel> completeCustomItemList = [];
  List<CustomItemModel> uncompleteCustomItemList = [];
  List<RecommendItemModel> completeRecommendItemList = [];
  List<RecommendItemModel> uncompleteRecommendItemList = [];
  List<UserModel> userModelList = [];
  List<String> addUserInviteCodeList = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // 초기 데이터 구성
  }

  // 초기 데이터 구성
  void fetchData() async {
    // 현재 저장된 버킷리스트 모델 불러오기
    if (widget.isShared) {
      modifiedBucketListModel =
          ref.read(sharedBucketListListProvider.notifier).getBucketListModel(
                widget.bucketListId,
              )!;
    } else {
      modifiedBucketListModel =
          ref.read(myBucketListListProvider.notifier).getBucketListModel(
                widget.bucketListId,
              )!;
    }

    // 현재 저장된 버킷리스트 모델에 저장된 item의 content 불러오기
    getItems(
      widget.bucketListId,
      modifiedBucketListModel.uncompletedCustomItemList,
      modifiedBucketListModel.uncompletedRecommendItemList,
      modifiedBucketListModel.completedCustomItemList,
      modifiedBucketListModel.completedRecommendItemList,
    );

    await getUsers(modifiedBucketListModel.users);
    setState(() {
      userModelList = List<UserModel>.from(ref
          .read(bucketListUserProvider)[widget.bucketListId]!
          .map((user) => UserModel.copy(user))
          .toList());
    });
  }

  // Firestore에서 사용자들을 가져오는 함수
  Future<void> getUsers(List<String> userIds) async {
    if (!ref.read(bucketListUserProvider).containsKey(widget.bucketListId)) {
      await _fetchUsers(userIds);
    } else {
      Set<String> currentUserIdsSet = Set.from(ref
          .read(bucketListUserProvider)[widget.bucketListId]!
          .map((userModel) => userModel.id));

      bool isUserChanged = itemsChanged(currentUserIdsSet, userIds);

      if (isUserChanged) {
        await _fetchUsers(userIds);
      }
    }
  }

  Future<void> _fetchUsers(List<String> userIds) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // 가져온 사용자들을 저장할 빈 리스트 생성
    List<UserModel> users = [];
    int read = 0; // 현재까지 읽은 사용자 수

    // 사용자 ID 리스트를 전부 확인할 때까지 반복
    while (read < userIds.length) {
      // 10명 또는 남은 사용자 수만큼의 사용자 ID를 가져옴
      List<String> chunk =
          userIds.sublist(read, min(read + 10, userIds.length));

      // Firestore에서 해당 사용자들의 정보를 가져옴
      QuerySnapshot querySnapshot = await firestore
          .collection('user')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      for (var doc in querySnapshot.docs) {
        // doc의 data를 map으로 변환하고, 'id' 필드에 doc의 id를 추가
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        data['id'] = doc.id;

        // 변환한 map을 사용하여 UserModel을 생성
        UserModel user = UserModel.fromJson(data);

        // 조건에 따라 tempUsers의 첫 번째 위치에 추가하거나 끝에 추가
        if (user.id == modifiedBucketListModel.host) {
          users.insert(0, user); // 첫 번째 위치에 추가
        } else {
          users.add(user); // 끝에 추가
        }
      }

      read += chunk.length;
    }
    ref
        .read(bucketListUserProvider.notifier)
        .addBucketListUsers(widget.bucketListId, users);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: buildAppBar(context),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: buildBody(),
        endDrawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _MemberSection(
                    bucketListId: widget.bucketListId,
                    userModelList: userModelList,
                    host: modifiedBucketListModel.host,
                    removeUser: removeUser,
                    addUserIdList: addUserInviteCodeList,
                    cancelInvite: cancelInvite,
                  ),
                  _InviteSection(addUser: addUser),
                  _BackgroundEditSection(
                      backgroundFlag: backgroundFlag,
                      setStateCallback: () {
                        setState(() {
                          backgroundFlag = !backgroundFlag;
                        });
                      },
                      imagePickerCallback: () async {
                        final picker = ImagePicker();
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setState(() {
                            tmpImage = File(pickedFile.path);
                            isChanged = true;
                          });
                        }
                        changeFlag();
                      },
                      setDefaultCallback: () {
                        if (tmpImage != null) {
                          setState(() {
                            tmpImage = null;
                          });
                        }
                        if (modifiedBucketListModel.image != '') {
                          setState(() {
                            modifiedBucketListModel =
                                modifiedBucketListModel.copyWith(image: '');
                          });
                        }
                        changeFlag();
                      }),
                  _TitleEditSection(
                      titleFlag: titleFlag,
                      defaultName: modifiedBucketListModel.name,
                      setStateCallback: () {
                        setState(() {
                          titleFlag = !titleFlag;
                        });
                      },
                      nameChange: nameChange),
                  _DeleteBucketSection(deleteBucketList: deleteBucketList),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        ),
      ),
      if (_isSaving) // Add this condition
        Container(
          color: Colors.black.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
    ]);
  }

  void deleteBucketList() {
    ref
        .read(widget.isShared
            ? sharedBucketListListProvider.notifier
            : myBucketListListProvider.notifier)
        .deleteBucketList(widget.bucketListId);
  }

  void removeUser(String userId) {
    setState(() {
      modifiedBucketListModel.users.remove(userId);
      userModelList.removeWhere((user) => user.id == userId);
      isChanged = true;
    });
  }

  void cancelInvite(String inviteCode) {
    setState(() {
      addUserInviteCodeList.remove(inviteCode);
    });
    changeFlag();
  }

  void nameChange(newName) {
    setState(() {
      modifiedBucketListModel = modifiedBucketListModel.copyWith(name: newName);

      titleFlag = !titleFlag;
    });
    changeFlag();
  }

  void addUser(inviteCode) {
    addUserInviteCodeList.add(inviteCode);
    setState(() {
      isChanged = true;
      inviteFlag = !inviteFlag;
    });
  }

  // AppBar 구성
  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      // preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.16),
      preferredSize: const Size.fromHeight(140),
      child: AppBar(
        leading: buildAppBarLeading(context),
        backgroundColor:
            (tmpImage == null && modifiedBucketListModel.image == '')
                ? const Color(0xFFC4E4FA)
                : Colors.transparent,
        actions: <Widget>[
          Builder(builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                size: 30,
                color: Color(0xFF616161),
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          }),
        ],
        flexibleSpace: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            if (tmpImage != null)
              Image.file(
                tmpImage!,
                fit: BoxFit.fill,
              )
            else if (modifiedBucketListModel.image != '')
              Image.network(
                modifiedBucketListModel.image,
                fit: BoxFit.fill,
              ),
            buildFlexibleSpace(),
          ],
        ),
        elevation: 0,
      ),
    );
  }

  // 뒤로가기 버튼 구성
  IconButton buildAppBarLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Remix.arrow_left_s_line,
        color: Color(0xFF616161),
        size: 40,
      ),
      onPressed: () {
        Navigator.pop(context);
        if (widget.isShared) {
          ref
              .read(sharedBucketListListProvider.notifier)
              .getBucketList(ref.read(myInformationProvider)!.id, true);
        }
      },
    );
  }

  // appbar 내용 구성
  Column buildFlexibleSpace() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height * 0.05), // 빈공간
        // 제목
        Text(
          modifiedBucketListModel.name,
          style: const TextStyle(
            fontFamily: 'SCDream',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

        Container(
          height: 60.0, // 이 값은 필요에 따라 조정해야 합니다.
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              ...userModelList.map((userModel) {
                int index = userModelList.indexOf(userModel);
                return userModel.image != ''
                    ? Positioned(
                        left: MediaQuery.of(context).size.width * 0.5 -
                            (userModelList.length +
                                    addUserInviteCodeList.length +
                                    1) *
                                7.5 +
                            15.0 * index, // 이 부분은 원하는 위치에 따라 조절해야 합니다.
                        child: CircleAvatar(
                          radius: 15.0, // 이미지 크기를 30x30으로 조정했습니다.
                          backgroundImage: NetworkImage(userModel.image),
                        ),
                      )
                    : Positioned(
                        left: MediaQuery.of(context).size.width * 0.5 -
                            (userModelList.length +
                                    addUserInviteCodeList.length +
                                    1) *
                                7.5 +
                            15.0 * index, // 이 부분은 원하는 위치에 따라 조절해야 합니다.
                        child: CircleAvatar(
                          radius: 15.0, // 이미지 크기를 30x30으로 조정했습니다.
                          child: Text(
                            userModel.nickname[0],
                            style: TextStyle(fontSize: 18.0), // 텍스트 크기를 조정했습니다.
                          ),
                        ),
                      );
              }).toList(),
              ...addUserInviteCodeList.map((id) {
                int index =
                    userModelList.length + addUserInviteCodeList.indexOf(id);
                return Positioned(
                  left: MediaQuery.of(context).size.width * 0.5 -
                      (userModelList.length +
                              addUserInviteCodeList.length +
                              1) *
                          7.5 +
                      15.0 * index, // 이 부분은 원하는 위치에 따라 조절해야 합니다.
                  child: CircleAvatar(
                    radius: 15.0, // 이미지 크기를 30x30으로 조정했습니다.
                    child: Text(
                      id[0], textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0), // 텍스트 크기를 조정했습니다.
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),

        // 달성도
        CustomProgressBar(
            achievementRate: getAchievementRate(), height: 17, width: 180)
      ],
    );
  }

  // 본문을 구성
  Padding buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 10), // 빈공간
          buildSaveButton(), // 저장 버튼
          // 버킷리스트 내용 구성
          Expanded(child: buildListView()),
        ],
      ),
    );
  }

  Widget buildSaveButton() {
    // 변동사항이 있을 시만 생김
    return isChanged
        ? Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 60,
              height: 30,
              child: ElevatedButton(
                onPressed: _isSaving
                    ? null
                    : () async {
                        // 저장중일때는 버튼을 비활성화
                        setState(() {
                          _isSaving = true; // 저장중 플래그를 true로 변경
                        });
                        // FireStore에 변경사항 저장
                        await updateBucketListItems(
                            newCustomItemList, modifiedBucketListModel);
                        setState(() {
                          _isSaving = false; // 저장중 플래그를 false로 변경
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD9D9D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.all(0),
                ),
                child: const Text(
                  '저장',
                  style: TextStyle(color: PRIMARY_COLOR),
                ),
              ),
            ),
          )
        : const SizedBox(height: 0);
  }

  // 버킷리스트 내용 구성
  ListView buildListView() {
    return ListView.builder(
      itemCount: completeCustomItemList.length +
          completeRecommendItemList.length +
          uncompleteCustomItemList.length +
          uncompleteRecommendItemList.length +
          1,
      itemBuilder: (context, index) {
        if (isLastItem(index)) // 마지막 index 일때
        {
          if (addCustomItemFlag) // custom item 추가 버튼 클릭시
          {
            return CustomAddTextField(onPressed: addNewCustomItem);
          } else // custom item 추가 버튼
          {
            return buildAddItemButton();
          }
        } else // 마지막 index 아닐때 버킷리스트 구성 내용
        {
          return buildListItem(index);
        }
      },
    );
  }

  // 마지막 아이템인지 확인
  bool isLastItem(int index) {
    // index가 완료된 목록, 미완료된 목록 수를 더한것과 같을 때 마지막
    return index ==
        completeCustomItemList.length +
            completeRecommendItemList.length +
            uncompleteCustomItemList.length +
            uncompleteRecommendItemList.length;
  }

  // 아이템 추가 버튼을
  Container buildAddItemButton() {
    return Container(
      height: 80,
      alignment: Alignment.center,
      child: IconButton(
        onPressed: () {
          // 추가 버튼 클릭시 추가 메뉴 띄움
          showAddButtonBottomSheet();
        },
        icon: const Icon(
          Remix.add_line,
          color: PRIMARY_COLOR,
          size: 35,
        ),
      ),
    );
  }

  // 리스트의 각 항목을 구성
  ListItem buildListItem(int index) {
    ItemModel item;

    // 먼저 미완료 목록부터 띄움
    if (index < uncompleteCustomItemList.length) {
      item = uncompleteCustomItemList[index];
    } else if (index <
        uncompleteCustomItemList.length + uncompleteRecommendItemList.length) {
      item =
          uncompleteRecommendItemList[index - uncompleteCustomItemList.length];
    } else if (index <
        uncompleteCustomItemList.length +
            uncompleteRecommendItemList.length +
            completeCustomItemList.length) {
      item = completeCustomItemList[index -
          uncompleteCustomItemList.length -
          uncompleteRecommendItemList.length];
    } else {
      item = completeRecommendItemList[index -
          uncompleteCustomItemList.length -
          uncompleteRecommendItemList.length -
          completeCustomItemList.length];
    }

    final bool isCompleted = index >=
        (uncompleteCustomItemList.length + uncompleteRecommendItemList.length);

    return ListItem(
      // 추천 아이템
      selectFlag: true,
      isContain: isCompleted,
      isRecommendItem: false,
      isHome: false,
      removeItem: removeItem,
      modifyItem: modifyItem,
      onPressed: () {
        if (isCompleted) {
          removeComplete(item);
        } else {
          addComplete(item);
        }
      },
      item: item,
    );
  }

  // item 수정
  void modifyItem(String modifiedContent, Type type, bool isCompleted,
      String itemId, String beforeContent) {
    List<ItemModel> list;
    if (isCompleted) {
      if (type == CustomItemModel) {
        list = completeCustomItemList;
      } else {
        list = completeRecommendItemList;
      }
    } else {
      if (type == CustomItemModel) {
        list = uncompleteCustomItemList;
      } else {
        list = uncompleteRecommendItemList;
      }
    }

    int index = list.indexWhere(
        (item) => item.content == beforeContent); // list에 변경 Item할 index 알아냄
    if (index != -1) // 동일한 ID를 가진 항목이 존재하면
    {
      if (type == RecommendItemModel) {
        if (isCompleted) {
          setState(() {
            modifiedBucketListModel.completedRecommendItemList.remove(itemId);
            completeRecommendItemList.removeWhere((item) => item.id == itemId);
            completeCustomItemList
                .add(CustomItemModel(id: '', content: modifiedContent));
          });

          newCustomItemCompletedList.add(modifiedContent);
        } else {
          setState(() {
            modifiedBucketListModel.uncompletedRecommendItemList.remove(itemId);
            uncompleteRecommendItemList
                .removeWhere((item) => item.id == itemId);
            uncompleteCustomItemList
                .add(CustomItemModel(id: '', content: modifiedContent));
          });

          newCustomItemList.add(modifiedContent);
        }
      } else {
        CustomItemModel modifiedItem = list[index] as CustomItemModel;

        if (modifiedItem.id != '') {
          modifiedItem =
              modifiedItem.copyWith(content: modifiedContent); // 내용 변경

          setState(() {
            list[index] = modifiedItem;
          });

          index = updatedCustomBucketListItemList.indexWhere((item) =>
              item.id == modifiedItem.id); // updated list에서 업데이트 된적있는지 확인
          if (index != -1) // 업데이트된적 있다면 변경
          {
            updatedCustomBucketListItemList[index] = modifiedItem;
          } else // 업데이트된적 없다면 추가
          {
            updatedCustomBucketListItemList.add(modifiedItem);
          }
        } else {
          index = list.indexWhere(
              (item) => item.id == itemId); // list에 변경 Item할 index 알아냄

          setState(() {
            list[index] = (CustomItemModel(id: '', content: modifiedContent));
          });

          if (isCompleted) {
            index = newCustomItemCompletedList.indexWhere((content) =>
                content ==
                beforeContent); // newCustomItemCompletedList에서 변경 전 content index 검색

            newCustomItemCompletedList[index] = modifiedContent;
          } else {
            index = newCustomItemList.indexWhere((content) =>
                content ==
                beforeContent); // newCustomItemList에서 변경 전 content index 검색

            newCustomItemList[index] = modifiedContent;
          }
        }
      }

      setState(() {
        isChanged = true;
      });
    }
  }

  // 완료 목록에서 제거
  void removeComplete(ItemModel item) {
    setState(() {
      if (item.runtimeType == RecommendItemModel) {
        modifiedBucketListModel.completedRecommendItemList.remove(item.id);
        modifiedBucketListModel.uncompletedRecommendItemList.add(item.id);

        completeRecommendItemList.remove(item as RecommendItemModel);
        uncompleteRecommendItemList.add(item);
      } else {
        if (item.id == '') {
          newCustomItemCompletedList.remove(item.content);
          newCustomItemList.add(item.content);
        } else {
          modifiedBucketListModel.completedCustomItemList.remove(item.id);
          modifiedBucketListModel.uncompletedCustomItemList.add(item.id);
        }

        completeCustomItemList.remove(item as CustomItemModel);
        uncompleteCustomItemList.add(item);
      }
    });
    changeFlag();
  }

  // 완료 목록에 추가
  void addComplete(ItemModel item) {
    setState(() {
      if (item.runtimeType == RecommendItemModel) {
        modifiedBucketListModel.completedRecommendItemList.add(item.id);
        modifiedBucketListModel.uncompletedRecommendItemList.remove(item.id);

        completeRecommendItemList.add(item as RecommendItemModel);
        uncompleteRecommendItemList.remove(item);
      } else {
        if (item.id == '') {
          newCustomItemCompletedList.add(item.content);
          newCustomItemList.remove(item.content);
        } else {
          modifiedBucketListModel.completedCustomItemList.add(item.id);
          modifiedBucketListModel.uncompletedCustomItemList.remove(item.id);
        }

        completeCustomItemList.add(item as CustomItemModel);
        uncompleteCustomItemList.remove(item);
      }
    });
    changeFlag();
  }

  Future<void> getItems(
    String id,
    List<String> uncompletedCustomItemList,
    List<String> uncompletedRecommendItemList,
    List<String> completedCustomItemList,
    List<String> completedRecommendItemList,
  ) async {
    final bucketListCustomItemState = ref.read(customBucketListItemProvider);
    final bucketListRecommendItemState =
        ref.read(recommendBucketListItemProvider);

    // ID를 로컬에서 찾을 수 있는 경우 Firestore에 접근하지 않음
    if (!bucketListCustomItemState.containsKey(id) ||
        !bucketListRecommendItemState.containsKey(id)) {
      await _fetchAndUpdate(
        id,
        uncompletedCustomItemList,
        uncompletedRecommendItemList,
        completedCustomItemList,
        completedRecommendItemList,
      );
    } else {
      Set<String> currentCustomBucketUncompleteItemIdsSet = Set.from(
          bucketListCustomItemState[id]
                  ?.uncompleteItems
                  .map((item) => item.id) ??
              []);
      Set<String> currentCustomBucketCompleteItemIdsSet = Set.from(
          bucketListCustomItemState[id]?.completeItems.map((item) => item.id) ??
              []);
      Set<String> currentRecommendBucketUncompleteItemIdsSet = Set.from(
          bucketListRecommendItemState[id]
                  ?.uncompleteItems
                  .map((item) => item.id) ??
              []);
      Set<String> currentRecommendBucketCompleteItemIdsSet = Set.from(
          bucketListRecommendItemState[id]
                  ?.completeItems
                  .map((item) => item.id) ??
              []);

      bool isCustomUncompleteItemsChanged = itemsChanged(
          currentCustomBucketUncompleteItemIdsSet, uncompletedCustomItemList);
      bool isCustomCompleteItemsChanged = itemsChanged(
          currentCustomBucketCompleteItemIdsSet, completedCustomItemList);
      bool isRecommendUncompleteItemsChanged = itemsChanged(
          currentRecommendBucketUncompleteItemIdsSet,
          uncompletedRecommendItemList);
      bool isRecommendCompleteItemsChanged = itemsChanged(
          currentRecommendBucketCompleteItemIdsSet, completedRecommendItemList);

      if (isCustomUncompleteItemsChanged ||
          isCustomCompleteItemsChanged ||
          isRecommendUncompleteItemsChanged ||
          isRecommendCompleteItemsChanged) {
        await _fetchAndUpdate(
          id,
          uncompletedCustomItemList,
          uncompletedRecommendItemList,
          completedCustomItemList,
          completedRecommendItemList,
        );
      }
    }

    setState(() {
      CustomItems tmpCustomItems = ref
          .read(customBucketListItemProvider)[widget.bucketListId]!
          .deepCopy();
      RecommendItems tmpRecommendsItems = ref
          .read(recommendBucketListItemProvider)[widget.bucketListId]!
          .deepCopy();
      completeCustomItemList = tmpCustomItems.completeItems;
      uncompleteCustomItemList = tmpCustomItems.uncompleteItems;
      completeRecommendItemList = tmpRecommendsItems.completeItems;
      uncompleteRecommendItemList = tmpRecommendsItems.uncompleteItems;
    });
  }

  bool itemsChanged(Set<String> current, List<String> newItems) {
    Set<String> newItemSet = Set.from(newItems);
    return current.difference(newItemSet).isNotEmpty ||
        newItemSet.difference(current).isNotEmpty;
  }

  _fetchAndUpdate(
      String id,
      List<String> uncompletedCustomItemList,
      List<String> uncompletedRecommendItemList,
      List<String> completedCustomItemList,
      List<String> completedRecommendItemList) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    List<String> tmpCustomItemsList = List.from(uncompletedCustomItemList)
      ..addAll(completedCustomItemList);
    List<String> tmpRecommendItemsList = List.from(uncompletedRecommendItemList)
      ..addAll(completedRecommendItemList);

    // Firestore에서 해당하는 item 불러오기
    final List<CustomItemModel> fetchedCustomItems =
        (await _fetchItems(firestore, 'custom', tmpCustomItemsList))
            .map((item) => item as CustomItemModel)
            .toList();

    // 재정렬을 위해 id를 key로 가진 Map 생성
    final Map<String, CustomItemModel> idToItem = {
      for (var item in fetchedCustomItems) item.id: item
    };

    // 기존 순서(uncomplete앞, complete뒤)에 맞게 재정렬
    final List<CustomItemModel> customItems =
        tmpCustomItemsList.map((id) => idToItem[id]!).toList();

    final List<RecommendItemModel> fetchedRecommendItems =
        (await _fetchItems(firestore, 'recommend', tmpRecommendItemsList))
            .map((item) => item as RecommendItemModel)
            .toList();

    final Map<String, RecommendItemModel> idToRecommendItem = {
      for (var item in fetchedRecommendItems) item.id: item
    };

    final List<RecommendItemModel> recommendItems =
        tmpRecommendItemsList.map((id) => idToRecommendItem[id]!).toList();

    // Firestore에서 가져온 customItems id 목록
    Set<String> fetchedCustomItemsIds =
        Set.from(customItems.map((item) => item.id));

    // Firestore에서 존재하지 않으면 customItemList와 completedCustomItemList에서 제거
    int targetRemoveCount = uncompletedCustomItemList.length +
        completedCustomItemList.length -
        fetchedCustomItemsIds.length;
    int uncustomItemListRemovedCount = _removeNonExistentItems(
        uncompletedCustomItemList, fetchedCustomItemsIds, targetRemoveCount);
    int completedCustomItemListRemovedCount = 0;
    if (uncustomItemListRemovedCount < targetRemoveCount) {
      completedCustomItemListRemovedCount = _removeNonExistentItems(
          completedCustomItemList,
          fetchedCustomItemsIds,
          targetRemoveCount - uncustomItemListRemovedCount);
    }

    // 나눠 담기 위해 index 수정
    int uncompletedCustomItemsCount = uncompletedCustomItemList.length;
    int completedCustomItemsCount = completedCustomItemList.length;

    // 나눠 담기
    ref.read(customBucketListItemProvider.notifier).addCustomItemsToBucketList(
        id,
        CustomItems(
            completeItems: customItems
                .getRange(uncompletedCustomItemsCount,
                    uncompletedCustomItemsCount + completedCustomItemsCount)
                .toList(),
            uncompleteItems:
                customItems.getRange(0, uncompletedCustomItemsCount).toList()));

    ref
        .read(recommendBucketListItemProvider.notifier)
        .addRecommendItemsToBucketList(
            id,
            RecommendItems(
              completeItems: recommendItems
                  .getRange(
                      uncompletedRecommendItemList.length,
                      uncompletedRecommendItemList.length +
                          completedRecommendItemList.length)
                  .toList(),
              uncompleteItems: recommendItems
                  .getRange(0, uncompletedRecommendItemList.length)
                  .toList(),
            ));

    Map<String, dynamic> updates = {};

    // custom_item_list가 변경되었으면 updates에 추가
    if (uncustomItemListRemovedCount > 0) {
      updates['uncompletedCustomItemList'] = uncompletedCustomItemList;
    }

    // completed_custom_item_list가 변경되었으면 updates에 추가
    if (completedCustomItemListRemovedCount > 0) {
      updates['completedCustomItemList'] = completedCustomItemList;
    }

    // updates에 변경 사항이 있으면 Firestore에 한 번의 쓰기 작업으로 업데이트
    if (updates.isNotEmpty) {
      await firestore.collection('bucket_list').doc(id).update(updates);

      // 기존 BucketListModel 찾기
      final existingBucketList = widget.isShared
          ? ref
              .read(sharedBucketListListProvider.notifier)
              .getBucketListModel(widget.bucketListId)
          : ref
              .read(myBucketListListProvider.notifier)
              .getBucketListModel(widget.bucketListId);

      // 새로운 itemList로 BucketListModel 업데이트
      final updatedBucketList = existingBucketList!.copyWith(
        customItemList: uncompletedCustomItemList,
        completedCustomItemList: completedCustomItemList,
      );

      // StateNotifier를 통해 상태 업데이트
      widget.isShared
          ? ref
              .read(sharedBucketListListProvider.notifier)
              .updateBucketList(updatedBucketList)
          : ref
              .read(myBucketListListProvider.notifier)
              .updateBucketList(updatedBucketList);
    }
  }

  // FireStore에 접근해서 item 가져오기
  Future<List<ItemModel>> _fetchItems(FirebaseFirestore firestore,
      String collectionName, List<String> itemList) async {
    List<ItemModel> items = [];

    // FireStore에서는 한번에 10개씩 데이터를 가져올 수 있으므로 10개씩 분리하여 가져오기
    for (List<String> chunk in _chunkedList(itemList, 10)) {
      var querySnapshot = await firestore
          .collection(collectionName)
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id; // 모델에 넣기 위해 id도 map에 넣어주기

        // item 종류에 따라서 알맞은 모델 변환해서 넣기
        items.add(collectionName == 'recommend'
            ? RecommendItemModel.fromJson(data)
            : CustomItemModel.fromJson(data));
      }
    }

    return items;
  }

  // 리스트를 청크로 분리
  List<List<String>> _chunkedList(List<String> list, int chunkSize) {
    List<List<String>> chunks = [];
    for (int i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, min(i + chunkSize, list.length)));
    }
    return chunks;
  }

  int _removeNonExistentItems(List<String> itemList,
      Set<String> existingItemsIds, int targetRemoveCount) {
    int removedCount = 0;
    int currentIndex = 0;

    while (currentIndex < itemList.length && removedCount < targetRemoveCount) {
      if (!existingItemsIds.contains(itemList[currentIndex])) {
        itemList.removeAt(currentIndex);

        removedCount++;
      } else {
        currentIndex++;
      }
    }

    return removedCount; // 제거된 수
  }

  double getAchievementRate() {
    int completedCount =
        modifiedBucketListModel.completedCustomItemList.length +
            modifiedBucketListModel.completedRecommendItemList.length +
            newCustomItemCompletedList.length;
    int uncompletedCount =
        modifiedBucketListModel.uncompletedCustomItemList.length +
            modifiedBucketListModel.uncompletedRecommendItemList.length +
            newCustomItemList.length;

    return (completedCount) / (completedCount + uncompletedCount);
  }

  // 새로 추가된 cusotom item
  void addNewCustomItem(String content) {
    if (content != '') {
      setState(() {
        uncompleteCustomItemList.add(CustomItemModel(content: content, id: ''));
        newCustomItemList.add(content);
      });
    }
    setState(() {
      addCustomItemFlag = !addCustomItemFlag;
    });
    changeFlag();
  }

  // 새로 추가된 recommend item
  void addRecommendItem(RecommendItemModel item) {
    if (!modifiedBucketListModel.uncompletedRecommendItemList
            .contains(item.id) &&
        !modifiedBucketListModel.completedRecommendItemList.contains(item.id)) {
      setState(() {
        modifiedBucketListModel.uncompletedRecommendItemList.add(item.id);
      });
      uncompleteRecommendItemList.add(RecommendItemModel(
          id: item.id,
          region: item.region,
          theme: item.theme,
          content: item.content));
    }
    changeFlag();
  }

  // item 제거
  void removeItem(ItemModel item, bool isCompleted) {
    setState(() {
      if (item.runtimeType ==
          RecommendItemModel) // recommend item이면 다 id로 저장돼있으니 modifiedBucketListModel의 recommendItemList에서 제거
      {
        if (isCompleted) {
          modifiedBucketListModel.completedRecommendItemList.remove(item.id);
          completeRecommendItemList.remove(item);
        } else {
          modifiedBucketListModel.uncompletedRecommendItemList.remove(item.id);
          uncompleteRecommendItemList.remove(item);
        }
      } else // custom item이면
      {
        if (item.id == '') // 새로 생성돼서 아직 id가 없는경우
        {
          if (isCompleted) {
            newCustomItemCompletedList.remove(item.content);
            completeCustomItemList.remove(item);
          } else {
            newCustomItemList.remove(item.content);
            uncompleteCustomItemList.remove(item);
          }
        } else // 기존에 있던거라서 id가 있는 경우
        {
          if (isCompleted) {
            modifiedBucketListModel.completedCustomItemList.remove(item.id);
            completeCustomItemList.remove(item);
          } else {
            modifiedBucketListModel.uncompletedCustomItemList.remove(item.id);
            uncompleteCustomItemList.remove(item);
          }
          deleteList.add(item.id);
        }
      }
    });

    changeFlag();
  }

  void showAddButtonBottomSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
            height: 30.h,
            child: Column(
              children: [
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      width: 40.w,
                      height: 8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xFF616161))),
                ),
                SizedBox(height: 10.h),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  // 직접 추가 버튼
                  CustomUnderlineButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                          addCustomItemFlag = !addCustomItemFlag;
                        });
                      },
                      icon: Remix.check_line,
                      text: '직접 추가'),

                  const SizedBox(width: 50),
                  // 추천 list 버튼
                  CustomUnderlineButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showRecommendListBottomSheet();
                      },
                      icon: Remix.search_line,
                      text: '추천 List 보기'),
                ]),
              ],
            ));
      },
    );
  }

  void showRecommendListBottomSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
            height: 90.h,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _RecommendItemList(
                uncomplementedRecommendItemList:
                    modifiedBucketListModel.uncompletedRecommendItemList,
                complementedRecommendItemList:
                    modifiedBucketListModel.completedRecommendItemList,
                addRecommendItem: addRecommendItem,
                removeRecommendItem: removeItem,
              ),
            ));
      },
    );
  }

  // 저장버튼 노출을 위해서 변경 사항이 있다면 isChanged true
  void changeFlag() {
    setState(() {
      isChanged = isChange();
    });
  }

  // 변경된 필드가 있는지 확인
  bool isChange() {
    BucketListModel originalBucketListModel = widget.isShared
        ? ref
            .read(sharedBucketListListProvider.notifier)
            .getBucketListModel(widget.bucketListId)!
        : ref
            .read(myBucketListListProvider.notifier)
            .getBucketListModel(widget.bucketListId)!;
    return !listEquals(originalBucketListModel.completedCustomItemList,
            modifiedBucketListModel.completedCustomItemList) ||
        !listEquals(originalBucketListModel.completedRecommendItemList,
            modifiedBucketListModel.completedRecommendItemList) ||
        newCustomItemList.isNotEmpty ||
        newCustomItemCompletedList.isNotEmpty ||
        !listEquals(originalBucketListModel.uncompletedCustomItemList,
            modifiedBucketListModel.uncompletedCustomItemList) ||
        !listEquals(originalBucketListModel.uncompletedRecommendItemList,
            modifiedBucketListModel.uncompletedRecommendItemList) ||
        originalBucketListModel.name != modifiedBucketListModel.name ||
        originalBucketListModel.image != modifiedBucketListModel.image ||
        !listEquals(
            originalBucketListModel.users, modifiedBucketListModel.users) ||
        addUserInviteCodeList.isNotEmpty ||
        tmpImage != null;
  }

  Future<void> updateBucketListItems(List<String> newCustomItemList,
      BucketListModel modifiedBucketListModel) async {
    try {
      // Firestore에 접근하기 위한 참조를 생성
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      WriteBatch batch = firestore.batch(); // 전체 작업을 위한 단일 WriteBatch 생성
      bool hasUpdates = false;

      // 새로운 custom item FireStore에 추가
      if (newCustomItemList.isNotEmpty ||
          newCustomItemCompletedList.isNotEmpty) {
        hasUpdates = true;
        // 완료되지 않은 새로운 아이템 FireStore에 추가
        await _addNewCustomBucketListItems(
          firestore,
          newCustomItemList,
          uncompleteCustomItemList,
          modifiedBucketListModel.uncompletedCustomItemList,
          batch,
          false,
        );
        // 완료된 새로운 아이템 FireStore에 추가
        await _addNewCustomBucketListItems(
          firestore,
          newCustomItemCompletedList,
          completeCustomItemList,
          modifiedBucketListModel.completedCustomItemList,
          batch,
          true,
        );
      }

      // custom bucketlist item content 수정
      if (updatedCustomBucketListItemList.isNotEmpty) {
        hasUpdates = true;
        await _updateCustomBucketListItem(
            firestore, updatedCustomBucketListItemList, batch);
      }

      if (deleteList.isNotEmpty) {
        hasUpdates = true;
        await deleteItemsFromFirestore(firestore, deleteList, batch);
        deleteList = []; // 삭제 목록 초기화
      }

      if (hasUpdates) {
        await batch
            .commit()
            .then((value) => print('Batch committed successfully'))
            .catchError((error) => print('Failed to commit batch: $error'));

        modifiedBucketListModel =
            modifiedBucketListModel.copyWith(updatedAt: DateTime.now());
      }

      // Firebase Storage 인스턴스 생성
      FirebaseStorage storage = FirebaseStorage.instance;

      // bucket list model 업데이트
      await _updateChangedBucketListModel(
        modifiedBucketListModel,
        firestore,
        storage,
      );

      setState(() {
        isChanged = false; // 저장 버튼 없애기
      });
    } catch (e) {
      print(e);
    }
  }

  // 새로 추가한 bucketlist item firestore에 추가
  Future<void> _addNewCustomBucketListItems(
    FirebaseFirestore firestore,
    List<String> itemList,
    List<ItemModel> bucketListItemList,
    List<String> customItemList,
    WriteBatch batch,
    bool isCompleted,
  ) async {
    for (String content in List.from(itemList)) {
      DocumentReference docRef = firestore.collection('custom').doc(); // id 지정
      batch.set(docRef, {'content': content}); // id와 content 매칭해서 저장

      setState(() {
        customItemList.add(docRef.id); // complete, uncomplete 목록에 추가
        itemList.remove(content); // 임시 newList에서 제거
      });

      // 현재 item list에서 id ''였는데 생성한 id로 업데이트
      for (int i = 0; i < bucketListItemList.length; i++) {
        ItemModel item = bucketListItemList[i];
        if (item is CustomItemModel && item.content == content) {
          setState(() {
            bucketListItemList[i] = item.copyWith(id: docRef.id);
          });

          break;
        }
      }
    }
  }

  // 기존의 custom bucketList item 수정
  Future<void> _updateCustomBucketListItem(
    FirebaseFirestore firestore,
    List<CustomItemModel> updatedCustomBucketListItemList,
    WriteBatch batch,
  ) async {
    List<CustomItemModel> updatedItemsCopy =
        List.from(updatedCustomBucketListItemList);
    for (CustomItemModel updatedItem in updatedItemsCopy) {
      DocumentReference docRef =
          firestore.collection('custom').doc(updatedItem.id);
      batch.update(docRef, {'content': updatedItem.content}); // 변경 content로 추가

      setState(() {
        updatedCustomBucketListItemList.remove(updatedItem); // 업데이트 목록에서 제거
      });
    }
  }

  // Firestore에서 items을 삭제
  Future<void> deleteItemsFromFirestore(
    FirebaseFirestore firestore,
    List<String> deleteList,
    WriteBatch batch,
  ) async {
    for (String id in deleteList) {
      // 문서에 대한 참조 가져오기
      DocumentReference docRef = firestore.collection('custom').doc(id);

      // 배치에 삭제 작업 추가
      batch.delete(docRef);
    }
  }

  // 두 버킷 리스트 모델 간의 변경 사항을 확인하고, 필요한 경우 Firebase에 업데이트
  Future<void> _updateChangedBucketListModel(
    BucketListModel modifiedBucketListModel,
    FirebaseFirestore firestore,
    FirebaseStorage storage,
  ) async {
    Map<String, dynamic> updates = {};
    BucketListModel originalBucketListModel = widget.isShared
        ? ref
            .read(sharedBucketListListProvider.notifier)
            .getBucketListModel(widget.bucketListId)!
        : ref
            .read(myBucketListListProvider.notifier)
            .getBucketListModel(widget.bucketListId)!;

    // 완료된 custom bucketlist item 목록 확인
    if (!listEquals(originalBucketListModel.completedCustomItemList,
        modifiedBucketListModel.completedCustomItemList)) {
      updates['completedCustomItemList'] =
          modifiedBucketListModel.completedCustomItemList;
    }

    // 완료된 recommend bucketlist item 목록 확인
    if (!listEquals(originalBucketListModel.completedRecommendItemList,
        modifiedBucketListModel.completedRecommendItemList)) {
      updates['completedRecommendItemList'] =
          modifiedBucketListModel.completedRecommendItemList;
    }

    // 완료되지 않은 custom bucketlist item 목록 확인
    if (!listEquals(originalBucketListModel.uncompletedCustomItemList,
        modifiedBucketListModel.uncompletedCustomItemList)) {
      updates['uncompletedCustomItemList'] =
          modifiedBucketListModel.uncompletedCustomItemList;
    }

    // 완료되지 않은 recommend bucketlist item 목록 확인
    if (!listEquals(originalBucketListModel.uncompletedRecommendItemList,
        modifiedBucketListModel.uncompletedRecommendItemList)) {
      updates['uncompletedRecommendItemList'] =
          modifiedBucketListModel.uncompletedRecommendItemList;
    }

    // name이 변경되었는지 확인
    if (originalBucketListModel.name != modifiedBucketListModel.name) {
      updates['name'] = modifiedBucketListModel.name;
    }

    // 이미지가 변경되었는지 확인
    if (tmpImage != null) {
      // 기존의 이미지가 있으면 삭제합니다.
      if (originalBucketListModel.image != '') {
        Reference photoRef =
            FirebaseStorage.instance.refFromURL(originalBucketListModel.image);
        await photoRef.delete();
      }

      // 이미지를 Firebase Storage에 업로드하고 Firestore에 이미지 URL을 저장합니다.
      String imageUrl = await _uploadImageToFirebase(tmpImage!.path, storage);

      // 변경된 이미지 URL을 modifiedBucketListModel의 이미지로 설정합니다.
      modifiedBucketListModel =
          modifiedBucketListModel.copyWith(image: imageUrl);
      updates['image'] = imageUrl; // 변경된 URL을 업데이트에 추가
    } else if (originalBucketListModel.image != modifiedBucketListModel.image) {
      // tmpImage가 null이지만 original image와 modified image가 다른 경우
      // 사용자가 이미지를 삭제한 것으로 간주하고 Firestore를 업데이트
      if (originalBucketListModel.image != '') {
        // 기존 이미지가 있다면 Storage에서 삭제합니다.
        Reference photoRef =
            FirebaseStorage.instance.refFromURL(originalBucketListModel.image);
        await photoRef.delete();
      }
      updates['image'] =
          modifiedBucketListModel.image; // 변경된 URL(여기서는 '')을 업데이트에 추가
    }

    // addUserIdList가 있고 그 길이가 0이 아닌지 확인
    if (addUserInviteCodeList.isNotEmpty) {
      // addUserIdList를 10개씩 분할합니다. (Firestore의 제한으로 인해)
      List<List<String>> chunks = [];
      for (int i = 0; i < addUserInviteCodeList.length; i += 10) {
        chunks.add(addUserInviteCodeList.sublist(
            i,
            i + 10 > addUserInviteCodeList.length
                ? addUserInviteCodeList.length
                : i + 10));
      }

      for (List<String> chunk in chunks) {
        // 각 chunk에 대해 Firestore에서 사용자 정보를 가져옵니다.
        QuerySnapshot querySnapshot = await firestore
            .collection('user')
            .where('inviteCode', whereIn: chunk)
            .get();

        // 가져온 사용자 정보를 UserModel 형태로 변환하고 Provider의 상태에 추가합니다.
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
          data['id'] = doc.id;
          UserModel userModel = UserModel.fromJson(data);

          // 해당 사용자의 정보가 Provider 상태에 있는지 확인하고 없으면 추가합니다.

          ref
              .read(bucketListUserProvider.notifier)
              .addUserToBucketList(widget.bucketListId, userModel);

          setState(() {
            modifiedBucketListModel.users.add(userModel.id);
            userModelList.add(userModel);
          });
        }
      }

      setState(() {
        addUserInviteCodeList = [];
      });
    }

    // users 필드가 변경되었는지 확인하고 업데이트에 추가합니다.
    if (!listEquals(
        originalBucketListModel.users, modifiedBucketListModel.users)) {
      updates['users'] = modifiedBucketListModel.users;
    }

    // 다른 변경사항이 있을 시
    if (originalBucketListModel.updatedAt !=
        modifiedBucketListModel.updatedAt) {
      updates['updatedAt'] = DateTime.now();
    }

    if (originalBucketListModel.users.length > 1 &&
        modifiedBucketListModel.users.length == 1) {
      updates['isShared'] = false;
      modifiedBucketListModel =
          modifiedBucketListModel.copyWith(isShared: updates['isShared']);
    } else if (originalBucketListModel.users.length == 1 &&
        modifiedBucketListModel.users.length > 1) {
      updates['isShared'] = true;
      modifiedBucketListModel =
          modifiedBucketListModel.copyWith(isShared: updates['isShared']);
    }

    // 변경 사항이 있으면 Firebase에 업데이트
    if (updates.isNotEmpty) {
      updates['updatedAt'] = DateTime.now();

      await firestore
          .collection('bucket_list')
          .doc(modifiedBucketListModel.id)
          .update(updates);

      setState(() {
        modifiedBucketListModel =
            modifiedBucketListModel.copyWith(updatedAt: updates['updatedAt']);
      });

      // 변경된 버킷 리스트 모델을 로컬에 업데이트
      widget.isShared
          ? ref
              .read(sharedBucketListListProvider.notifier)
              .changeBucketListModel(
                  widget.bucketListId, modifiedBucketListModel)
          : ref.read(myBucketListListProvider.notifier).changeBucketListModel(
              widget.bucketListId, modifiedBucketListModel);

      // 공유 유무가 변경되었는지 확인
      if (updates['isShared'] != null) {
        // itemList에서 서로 위치 이동
        ref
            .read(updates['isShared']
                ? sharedBucketListListProvider.notifier
                : myBucketListListProvider.notifier)
            .addBucketList(modifiedBucketListModel);
        ref
            .read(updates['isShared']
                ? myBucketListListProvider.notifier
                : sharedBucketListListProvider.notifier)
            .deleteBucketListFromProvider(modifiedBucketListModel.id);
      }
      ref
          .read(customBucketListItemProvider.notifier)
          .replaceCustomItemsInBucketList(
              widget.bucketListId,
              CustomItems(
                completeItems: completeCustomItemList,
                uncompleteItems: uncompleteCustomItemList,
              ));
      ref
          .read(recommendBucketListItemProvider.notifier)
          .replaceRecommendItemsInBucketList(
              widget.bucketListId,
              RecommendItems(
                  completeItems: completeRecommendItemList,
                  uncompleteItems: uncompleteRecommendItemList));

      ref.read(bucketListUserProvider.notifier).removeUsersNotInIdList(
          widget.bucketListId, modifiedBucketListModel.users);
    }
  }

  Future<String> _uploadImageToFirebase(
      String imagePath, FirebaseStorage storage) async {
    File file = File(imagePath);
    String uniqueId = Uuid().v4();
    try {
      // 이미지를 Firebase Storage에 업로드하고 다운로드 URL을 가져옵니다.
      await storage.ref('images/$uniqueId').putFile(file);
      String downloadURL =
          await storage.ref('images/$uniqueId').getDownloadURL();
      return downloadURL;
    } catch (e) {
      // 이미지 업로드에 실패했습니다.
      print(e);
      return '';
    }
  }
}

class _RecommendItemList extends ConsumerStatefulWidget {
  final List<String> uncomplementedRecommendItemList;
  final List<String> complementedRecommendItemList;
  final Function addRecommendItem;
  final Function removeRecommendItem;

  const _RecommendItemList({
    required this.uncomplementedRecommendItemList,
    required this.complementedRecommendItemList,
    required this.addRecommendItem,
    required this.removeRecommendItem,
  });

  @override
  _RecommendItemListState createState() => _RecommendItemListState();
}

class _RecommendItemListState extends ConsumerState<_RecommendItemList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<RecommendItemModel> recommendItemList =
        ref.watch(recommendItemListProvider);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.center,
            child: Container(
                width: 40.w,
                height: 8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xFF616161))),
          ),
          const SizedBox(height: 20),
          // Flitering
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SelectBox(),
          ),
          SizedBox(
              height: (ref.watch(selectedRegionFilterProvider) != null ||
                      ref.watch(selectedThemeFilterListProvider).isNotEmpty)
                  ? 8
                  : 0),
          // HashTag
          SizedBox(
            width: 100.w - 32,
            child: const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: HashTagItemList(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
              child: ListView.builder(
                  itemCount: recommendItemList.length,
                  itemBuilder: (context, index) {
                    final RecommendItemModel recommendItem =
                        recommendItemList[index];
                    bool containedComplement = widget
                        .complementedRecommendItemList
                        .contains(recommendItem.id);
                    bool uncontainedComplement = widget
                        .uncomplementedRecommendItemList
                        .contains(recommendItem.id);
                    bool isContain =
                        containedComplement || uncontainedComplement;

                    return ListItem(
                      selectFlag: true,
                      isContain: isContain,
                      isHome: false,
                      isRecommendItem: true,
                      onPressed: () {
                        setState(
                          () {
                            if (isContain) {
                              widget.removeRecommendItem(
                                  recommendItem, containedComplement);
                            } else {
                              widget.addRecommendItem(recommendItem);
                            }
                          },
                        );
                      },
                      item: recommendItem,
                    );
                  }))
        ]);
  }
}

class _BackgroundEditButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final BorderRadiusGeometry borderRadius;

  const _BackgroundEditButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        minimumSize: MaterialStateProperty.all(const Size(230, 50)),
        backgroundColor: MaterialStateProperty.all(const Color(0xFFC4E4FA)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        elevation: MaterialStateProperty.all(0),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Remix.check_line,
            color: BLACK_COLOR,
          ),
          const SizedBox(width: 10),
          Text(text, style: inputBoxTextStyle),
        ],
      ),
    );
  }
}

class _MemberSection extends ConsumerWidget {
  final String bucketListId;
  final String host;
  final List<UserModel> userModelList;
  final Function(String) removeUser;
  final Function(String) cancelInvite;
  final List<String> addUserIdList;

  const _MemberSection({
    required this.bucketListId,
    required this.host,
    required this.userModelList,
    required this.removeUser,
    required this.cancelInvite,
    required this.addUserIdList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6.h),
        Container(
          height: 31,
          width: 85,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xFFD9D9D9),
          ),
          child: const Text(
            '멤버',
            style: TextStyle(
                fontFamily: 'SCDream',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: PRIMARY_COLOR),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height:
              userModelList.length <= 5 ? userModelList.length * 50.0 : 200.0,
          child: SingleChildScrollView(
            physics: userModelList.length <= 5
                ? const NeverScrollableScrollPhysics()
                : const ScrollPhysics(),
            child: Column(
              children: userModelList.map((user) {
                return MemberCard.fromModel(
                  model: user,
                  host: host,
                  bucketListId: bucketListId,
                  removeUser: removeUser,
                );
              }).toList(),
            ),
          ),
        ),
        if (userModelList.isNotEmpty)
          const Divider(
            height: 2,
            thickness: 1,
          ),
        if (addUserIdList.isNotEmpty)
          Column(
            children: addUserIdList.map((userId) {
              return MemberCard(
                  userId: userId,
                  nickname: userId,
                  image: null,
                  host: host,
                  bucketListId: bucketListId,
                  removeUser: cancelInvite);
            }).toList(),
          )
      ],
    );
  }
}

class _InviteSection extends StatefulWidget {
  final Function(String) addUser;

  const _InviteSection({required this.addUser});

  @override
  State<_InviteSection> createState() => _InviteSectionState();
}

class _InviteSectionState extends State<_InviteSection> {
  bool inviteFlag = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.only(right: 16, left: 10)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Remix.add_line,
                size: 30,
                color: PRIMARY_COLOR,
              ),
              SizedBox(width: 10),
              Text(
                '초대하기',
                style: TextStyle(
                    fontFamily: 'SCDream',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: PRIMARY_COLOR),
              )
            ],
          ),
          onPressed: () {
            setState(() {
              inviteFlag = !inviteFlag;
            });
          },
        ),
        inviteFlag
            ? InputBox(
                inputType: '초대코드를 입력해주세요',
                onLeftPressed: (text) {
                  if (text != '') {
                    widget.addUser(text);
                  }

                  setState(() {
                    inviteFlag = !inviteFlag;
                  });
                },
                onRightPressed: () {
                  setState(() {
                    inviteFlag = !inviteFlag;
                  });
                },
              )
            : const SizedBox(height: 0),
      ],
    );
  }
}

class _BackgroundEditSection extends StatelessWidget {
  final bool backgroundFlag;
  final Function setStateCallback;
  final Function() imagePickerCallback;
  final Function() setDefaultCallback;

  const _BackgroundEditSection({
    required this.backgroundFlag,
    required this.setStateCallback,
    required this.imagePickerCallback,
    required this.setDefaultCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.only(right: 16, left: 10)),
          ),
          child: const Row(
            children: [
              Icon(
                Remix.folder_open_line,
                size: 30,
                color: Color(0xFF1A1A1A),
              ),
              SizedBox(width: 10),
              Text(
                '배경화면 편집',
                style: TextStyle(
                    fontFamily: 'SCDream',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1A1A1A)),
              ),
              Spacer(),
              Icon(
                Remix.arrow_down_s_line,
                size: 30,
                color: Color(0xFF1A1A1A),
              ),
            ],
          ),
          onPressed: () => setStateCallback(),
        ),
        backgroundFlag
            ? Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  width: 230.0,
                  height: 100.0,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _BackgroundEditButton(
                          text: '앨범에서 사진 선택',
                          onPressed: imagePickerCallback,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 0,
                        color: Colors.grey,
                        thickness: 1.0,
                      ),
                      Expanded(
                        child: _BackgroundEditButton(
                          text: '기본 이미지로 설정',
                          onPressed: setDefaultCallback,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox(height: 0),
      ],
    );
  }
}

class _TitleEditSection extends StatelessWidget {
  final bool titleFlag;
  final Function setStateCallback;
  final String defaultName;
  final Function(String) nameChange;

  const _TitleEditSection({
    required this.titleFlag,
    required this.setStateCallback,
    required this.defaultName,
    required this.nameChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.only(right: 16, left: 10)),
          ),
          child: const Row(
            children: [
              Icon(
                Remix.edit_line,
                size: 30,
                color: Color(0xFF1A1A1A),
              ),
              SizedBox(width: 10),
              Text(
                '제목 편집',
                style: TextStyle(
                    fontFamily: 'SCDream',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1A1A1A)),
              ),
              Spacer(),
              Icon(
                Remix.arrow_down_s_line,
                size: 30,
                color: Color(0xFF1A1A1A),
              ),
            ],
          ),
          onPressed: () => setStateCallback(),
        ),
        titleFlag
            ? InputBox(
                inputType: '제목을 입력해주세요',
                defaultName: defaultName,
                onLeftPressed: nameChange,
                onRightPressed: () => setStateCallback(),
              )
            : const SizedBox(height: 0),
      ],
    );
  }
}

class _DeleteBucketSection extends StatefulWidget {
  final Function() deleteBucketList;
  const _DeleteBucketSection({super.key, required this.deleteBucketList});

  @override
  State<_DeleteBucketSection> createState() => __DeleteBucketSectionState();
}

class __DeleteBucketSectionState extends State<_DeleteBucketSection> {
  bool isSelect = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.only(right: 16, left: 10)),
          ),
          child: const Row(
            children: [
              Icon(
                Remix.delete_bin_line,
                size: 30,
                color: Color(0xFF1A1A1A),
              ),
              SizedBox(width: 10),
              Text(
                '삭제하기',
                style: TextStyle(
                  fontFamily: 'SCDream',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Spacer(),
              Icon(
                Remix.arrow_down_s_line,
                size: 30,
                color: Color(0xFF1A1A1A),
              ),
            ],
          ),
          onPressed: () {
            setState(() {
              isSelect = !isSelect;
            });
          },
        ),
        isSelect
            ? Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 230,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color(0xFFC4E4FA)),
                    child: const Text(
                      '삭제하시겠습니까?',
                      style: TextStyle(
                        fontFamily: 'SCDream',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      children: [
                        CustomButton(
                          buttonText: '예',
                          onPressed: () {
                            widget.deleteBucketList();
                            setState(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          },
                        ),
                        const Spacer(),
                        CustomButton(
                          buttonText: '아니요',
                          onPressed: () {
                            setState(() {
                              isSelect = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const SizedBox(height: 0)
      ],
    );
  }
}
