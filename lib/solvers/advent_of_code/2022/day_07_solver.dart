import 'package:aoc22/solvers/solver.dart';
import 'package:darq/darq.dart';

class Day07Solver extends Solver<String, String> {

  @override
  String get problemUrl => 'https://adventofcode.com/2022/day/7';

  @override
  String get solverCodeFilename => 'day_07_solver.dart';
  
  @override
  String getSolution(String input) {
    List<String> terminalInputOutput = input.split('\n').where((line) => line.isNotEmpty).toList(growable: false);

    // parse terminal input/output to file system structure
    List<_Folder> folders = [];
    _Folder? currentFolder;
    _Folder? rootFolder;
    for (String ioLine in terminalInputOutput) {
      if (ioLine.startsWith('\$ cd ..')) {
        // go back one folder
        currentFolder = currentFolder!.parent;
      } else if (ioLine.startsWith('\$ cd ')) {
        // go inside folder
        _Folder newFolder = _Folder(currentFolder, ioLine.substring(5), []);
        folders.add(newFolder);
        if (currentFolder != null) {
          currentFolder.children.add(newFolder);
        }
        currentFolder = newFolder;
        rootFolder ??= newFolder;
      } else if (ioLine.startsWith('\$ ls')) {
        // list folder contents
      } else {
        // show contents of current folder
        var splitLine = ioLine.split(' ');
        if (splitLine[0] == 'dir') {
          currentFolder!.children.add(_Folder(currentFolder, splitLine[1], []));
        } else {
          currentFolder!.children.add(_File(currentFolder, splitLine[1], int.parse(splitLine[0])));
        }
      }
    }
    
    // part 1
    int totalFolderSize = folders
        .map((folder) => folder.size)
        .where((size) => size <= 100000)
        .fold(0, (value, element) => value += element);

    // part 2
    int spaceNeeded = 30000000 - (70000000 - rootFolder!.size);
    int largeEnoughFolderSize = folders
        .map((folder) => folder.size)
        .where((size) => size >= spaceNeeded)
        .orderBy((size) => size)
        .first;

    return 'Total folder size: $totalFolderSize\nLarge enough folder size: $largeEnoughFolderSize';
  }

}

class _Folder extends _FileSystemObject {

  final List<_FileSystemObject> children;

  _Folder(super.parent, super.name, this.children);

  @override
  int get size => children.map((e) => e.size).fold(0, (value, element) => value + element);

}

class _File extends _FileSystemObject {

  final int _size;

  _File(super.parent, super.name, int size): _size = size;

  @override
  int get size => _size;

}

abstract class _FileSystemObject {

  const _FileSystemObject(this.parent, this.name);

  final _Folder? parent;
  final String name; 

  int get size;

}
