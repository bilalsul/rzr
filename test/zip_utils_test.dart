import 'package:flutter_test/flutter_test.dart';
import 'package:rzr/models/zip_entry_model.dart';
import 'package:rzr/services/network/github_zip_service.dart';
import 'package:rzr/services/filesystem/app_directories.dart';
import 'package:rzr/utils/log/common.dart';

void main() {
  test('repo parsing rejects URLs and invalid input', () async {
    final svc = GitHubZipService.instance;
    expect(() => svc.downloadRepoZip('', token: null as dynamic), throwsA(isA<RZRLog>()));
    expect(() => svc.downloadRepoZip('https://github.com/owner/repo', token: null as dynamic), throwsA(isA<RZRLog>()));
    expect(() => svc.downloadRepoZip('owner', token: null as dynamic), throwsA(isA<RZRLog>()));
  });

  test('extraction folder name derived correctly', () {
    final name = AppDirectories.extractionFolderNameForZip('owner_repo.zip');
    expect(name, 'owner_repo');
  });

  test('zip entry model basic', () {
    final e = ZipEntryModel(filename: 'a.zip', size: 100, modified: DateTime.fromMillisecondsSinceEpoch(0));
    expect(e.filename, 'a.zip');
    expect(e.size, 100);
  });
}
