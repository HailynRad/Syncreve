import 'package:syncreve/api/cloudreve_file_api.dart';
import 'package:syncreve/base/ui_model.dart';
import 'package:syncreve/data/file/cloudreve_file_data.dart';

class HomeFileUIModel extends BaseUIModel {
  List<String> path = [];

  CloudreveFileData? files;

  final pathScrollCtrl = ScrollController();

  @override
  Future loadData() async {
    final files = await handleError(() => CloudreveFileApi.ls(path),
        showFullScreenError: true);
    if (files == null) return;
    this.files = files;
    notifyListeners();
  }

  @override
  Future reloadData() {
    files = null;
    notifyListeners();
    return super.reloadData();
  }

  @override
  Future onErrorReloadData() {
    path = [];
    return super.onErrorReloadData();
  }

  void tapHome() {}

  void goDownload() {}

  void onChangeListStyle() {}

  Future<void> onChangeDir(List<String> path) async {
    this.path = path;
    reloadData();
    await Future.delayed(const Duration(milliseconds: 32));
    pathScrollCtrl.animateTo(pathScrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100), curve: Curves.linear);
  }

  void onTapFile(CloudreveFileObjectsData file) {
    if (file.type == "dir") {
      onChangeDir(path..add(file.name!));
    }
  }
}