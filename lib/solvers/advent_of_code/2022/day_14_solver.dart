import 'dart:core';
import 'dart:math';

import 'package:aoc22/solvers/solver.dart';
import 'package:darq/darq.dart';

class Day14Solver extends Solver<String, String> {

  @override
  String get problemUrl => 'https://adventofcode.com/2022/day/14';

  @override
  String get solverCodeFilename => 'day_14_solver.dart';
  
  @override
  String getSolution(String input) {
    List<List<Point<int>>> pointGroups = input
        .trim()
        .split('\n')
        .map(
          (rawLine) => rawLine.split(' -> ').map(
            (rawCoordinates) {
              List<int> rawSplitCoordinates = rawCoordinates.split(',').map(int.parse).toList();
              return Point(rawSplitCoordinates[0], rawSplitCoordinates[1]);
            },
          ).toList(),
        )
        .toList();

    // part 1
    List<List<_Tile>> gridPart1 = _buildGrid(pointGroups);
    int part1Steps = _simulateSand(gridPart1);

    // part 2
    List<List<_Tile>> gridPart2 = _buildGrid(pointGroups, 0, 1000, true);
    int part2Steps = _simulateSand(gridPart2);

    return 'Sum of indices: $part1Steps\nDivider packet indices multiplied: $part2Steps';
  }

  List<List<_Tile>> _buildGrid(List<List<Point<int>>> pointGroups, [int? minX, int? maxX, bool addFloor = false, int sandStartPointX = 500]) {
    int actualMinX = minX ?? pointGroups.flatten().min((point1, point2) => point1.x.compareTo(point2.x)).x;
    int actualMaxX = maxX ?? pointGroups.flatten().max((point1, point2) => point1.x.compareTo(point2.x)).x;
    int actualMaxY = pointGroups.flatten().max((point1, point2) => point1.y.compareTo(point2.y)).y + (addFloor ? 2 : 0);
    int gridWidth = actualMaxX - actualMinX + 1;
    int gridHeight = actualMaxY + 1;

    List<List<_Tile>> grid = List.generate(gridHeight, (_) => List.filled(gridWidth, _Tile.air));

    for (List<Point<int>> pointGroup in pointGroups) {
      Point<int>? lastPoint;
      for (Point<int> point in pointGroup) {
        if (lastPoint == null) {
          lastPoint = point;
          continue;
        }

        int gridPointX = point.x - actualMinX;
        int gridLastPointX = lastPoint.x - actualMinX;

        if (point.x == lastPoint.x) {
          int minY = min(point.y, lastPoint.y);
          int maxY = max(point.y, lastPoint.y);
          for (int y = minY; y <= maxY; y++) {
            grid[y][gridPointX] = _Tile.rock;
          }
        } else if (point.y == lastPoint.y) {
          grid[point.y].fillRange(min(gridPointX, gridLastPointX), max(gridPointX + 1, gridLastPointX + 1), _Tile.rock);
        } else {
          throw 'Points $point and $lastPoint expected to form a straight line';
        }

        lastPoint = point;
      }
    }

    // set sand starting point
    int actualSandStartPointX = sandStartPointX - actualMinX, actualSandStartPointY = 0;
    grid[actualSandStartPointY][actualSandStartPointX] = _Tile.sandStart;

    // add floor if needed
    if (addFloor) {
      grid[actualMaxY].fillRange(0, gridWidth, _Tile.rock);
    }

    return grid;
  }

  int _simulateSand(List<List<_Tile>> grid) {
    int gridWidth = grid[0].length, gridHeight = grid.length;
    int steps = 0;
    int sandStartPointX = grid[0].indexOf(_Tile.sandStart), sandStartPointY = 0;
    while (true) {
      int sandX = sandStartPointX, sandY = sandStartPointY;
      while (true) {
        if ((sandX - 1) < 0 || (sandX + 1) >= gridWidth || (sandY + 1) >= gridHeight) {
          // sand would fall off the grid
          return steps;
        } else if (grid[sandY + 1][sandX] == _Tile.air) {
          // move downwards
          sandY++;
        } else if (grid[sandY + 1][sandX - 1] == _Tile.air) {
          // move diagonally left
          sandX--;
          sandY++;
        } else if (grid[sandY + 1][sandX + 1] == _Tile.air) {
          // move diagonally right
          sandX++;
          sandY++;
        } else if (sandX == sandStartPointX && sandY == sandStartPointY) {
          // sand origin point is blocked
          return ++steps;
        } else {
          // sand has settled
          grid[sandY][sandX] = _Tile.sand;
          break;
        }
      }

      steps++;
    }
  }

}

enum _Tile {
  air,
  rock,
  sand,
  sandStart,
}
