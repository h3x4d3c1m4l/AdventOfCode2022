import 'dart:developer';
import 'dart:math';

import 'package:aoc22/solvers/solver.dart';
import 'package:collection/collection.dart' show groupBy;
import 'package:darq/darq.dart' hide Tuple2;
import 'package:tuple/tuple.dart';

typedef SensorWithClosestBeacon = Tuple2<Point<int>, Point<int>>;
typedef ColumnRange = Tuple2<int, int>;
typedef Line = Tuple2<Point<int>, Point<int>>;

class Day15Solver extends Solver<String, String> {

  @override
  String get problemUrl => 'https://adventofcode.com/2022/day/15';

  @override
  String get solverCodeFilename => 'day_15_solver.dart';

  @override
  String getSolution(String input) {
    List<SensorWithClosestBeacon> sensorsWithClosestBeacons =
        input.trim().split('\n').map((rawSensorLine) => rawSensorLine.split(' ')).map((splitSensorLine) {
      int sensorX = int.parse(splitSensorLine[2].substring(2, splitSensorLine[2].length - 1));
      int sensorY = int.parse(splitSensorLine[3].substring(2, splitSensorLine[3].length - 1));
      Point<int> sensorCoordinates = Point(sensorX, sensorY);
      int beaconX = int.parse(splitSensorLine[8].substring(2, splitSensorLine[8].length - 1));
      int beaconY = int.parse(splitSensorLine[9].substring(2));
      Point<int> beaconCoordinates = Point(beaconX, beaconY);

      return Tuple2(sensorCoordinates, beaconCoordinates);
    }).toList();

    int sensorsMinX = sensorsWithClosestBeacons.map((sensorWithClosestBeacon) => sensorWithClosestBeacon.item1.x).min();
    int sensorsMaxX = sensorsWithClosestBeacons.map((sensorWithClosestBeacon) => sensorWithClosestBeacon.item1.x).max();
    int beaconsMinX = sensorsWithClosestBeacons.map((sensorWithClosestBeacon) => sensorWithClosestBeacon.item2.x).min();
    int beaconsMaxX = sensorsWithClosestBeacons.map((sensorWithClosestBeacon) => sensorWithClosestBeacon.item2.x).max();
    int minX = min(sensorsMinX, beaconsMinX);
    int maxX = max(sensorsMaxX, beaconsMaxX);

    // part 1
    const int row = 2000000;
    List<ColumnRange> columnRanges = [];
    for (SensorWithClosestBeacon sensor in sensorsWithClosestBeacons) {
      int eucDistanceSensorToBeacon = (sensor.item1.x - sensor.item2.x).abs() + (sensor.item1.y - sensor.item2.y).abs();
      int eucDistanceSensorToRow = (sensor.item1.y - row).abs();

      int leftOverDistance = eucDistanceSensorToBeacon - eucDistanceSensorToRow;
      if (leftOverDistance <= 0) {
        continue;
      }

      int left = sensor.item1.x - leftOverDistance;
      int right = sensor.item1.x + leftOverDistance;
      columnRanges.add(ColumnRange(left, right));
    }

    
    int positions = 0;
    List<Point<int>> beacons = sensorsWithClosestBeacons.map((sensorsWithClosestBeacon) => sensorsWithClosestBeacon.item2).where((beacon) => beacon.y == row).toList();
    for (int i = minX * 2; i <= maxX * 2; i++) {
      if (beacons.any((beacon) => beacon.x == i)) {
        continue;
      }

      if (columnRanges.any((columnRange) => i >= columnRange.item1 && i <= columnRange.item2)) {
        positions++;
      }
    }

    ffs(sensorsWithClosestBeacons);

    // part 2
    print("PART 2");
    const int maxCoordinateValue = 4000000;
    Set<Point<int>> possibilities = <Point<int>>{};
    for (var sensorsWithClosestBeacon in sensorsWithClosestBeacons) {
      Point<int> sensor = sensorsWithClosestBeacon.item1;
      Point<int> beacon = sensorsWithClosestBeacon.item2;
      int eucDistanceSensorToBeacon = (sensor.x - beacon.x).abs() + (sensor.y - beacon.y).abs();

      for (int i = 0; i <= eucDistanceSensorToBeacon; i++) {
        if (i == 0) {
          addPoint(possibilities, Point<int>(sensor.x + (eucDistanceSensorToBeacon + 1), sensor.y), maxCoordinateValue);
          addPoint(possibilities, Point<int>(sensor.x - (eucDistanceSensorToBeacon + 1), sensor.y), maxCoordinateValue);
        } else if (i == eucDistanceSensorToBeacon) {
          addPoint(possibilities, Point<int>(sensor.x, sensor.y + (i + 1)), maxCoordinateValue);
          addPoint(possibilities, Point<int>(sensor.x, sensor.y - (i + 1)), maxCoordinateValue);
        } else {
          addPoint(possibilities, Point<int>(sensor.x + (eucDistanceSensorToBeacon + 1 - i), sensor.y - i), maxCoordinateValue);
          addPoint(possibilities, Point<int>(sensor.x - (eucDistanceSensorToBeacon + 1 - i), sensor.y - i), maxCoordinateValue);
          addPoint(possibilities, Point<int>(sensor.x + (eucDistanceSensorToBeacon + 1 - i), sensor.y + i), maxCoordinateValue);
          addPoint(possibilities, Point<int>(sensor.x - (eucDistanceSensorToBeacon + 1 - i), sensor.y + i), maxCoordinateValue);
        }
      }
    }

    for (var sensorsWithClosestBeacon in sensorsWithClosestBeacons) {
      print("Beacon: ${sensorsWithClosestBeacon.item1}, Sensor: ${sensorsWithClosestBeacon.item2}");

      Point<int> sensor = sensorsWithClosestBeacon.item1;
      Point<int> beacon = sensorsWithClosestBeacon.item2;
      int eucDistanceSensorToBeacon = (sensor.x - beacon.x).abs() + (sensor.y - beacon.y).abs();

      //possibilities.remove(sensor);
      //possibilities.remove(beacon);
      for (int i = 0; i <= eucDistanceSensorToBeacon; i++) {
        if (i % 10000 == 0) {
          print("it: $i/$eucDistanceSensorToBeacon");
        }
        for (int j = 0; j <= i; j++) {
          //possibilities.remove(Point<int>(sensor.x + (i - j), sensor.y - j));
          //possibilities.remove(Point<int>(sensor.x - (i - j), sensor.y - j));
          //possibilities.remove(Point<int>(sensor.x + (i - j), sensor.y + j));
          //possibilities.remove(Point<int>(sensor.x - (i - j), sensor.y + j));
        }
      }
    }

    print(possibilities.length);
    print(possibilities);
    print(possibilities.first.x * 4000000 + possibilities.first.y);
    var frequency = 0;

    return 'Positions that cannot contain beacon: $positions\nTop 3\'s total: $frequency';
  }

  void _plotCoordinates(List<Point<int>> coordinatesList) {
    if (coordinatesList.isEmpty) {
      print("EMPTY");
      return;
    }
    String grid = '\n';
    int xMin = coordinatesList.map((coordinates) => coordinates.x).min();
    int xMax = coordinatesList.map((coordinates) => coordinates.x).max();
    int yMin = coordinatesList.map((coordinates) => coordinates.y).min();
    int yMax = coordinatesList.map((coordinates) => coordinates.y).max();
    for (int y = yMin; y <= yMax; y++) {
      for (int x = xMin; x <= xMax; x++) {
        if (coordinatesList.any((coordinates) => coordinates.x == x && coordinates.y == y)) {
          grid += '#';
        } else {
          grid += '.';
        }
      }

      grid += '\n';
    }
    print("width: ${xMax - xMin}, height: ${yMax - yMin}");
    print(grid);
  }

  void addPoint(Set<Point<int>> possibilitiesList, Point<int> newPoint, int maxCoordinateValue) {
    if (newPoint.x < 0 || newPoint.x > maxCoordinateValue || newPoint.y < 0 || newPoint.y > maxCoordinateValue) {
      return;
    }

    possibilitiesList.add(newPoint);
  }
  
  void ffs(List<SensorWithClosestBeacon> sensorsWithClosestBeacons) {
    int minX = 0;
    int maxX = 4000000;
    for (int row = 0; row <= maxX; row++) {
      if (row % 1000 == 0) {
        print(row);
      }      
      List<ColumnRange> columnRanges = [];
      for (SensorWithClosestBeacon sensor in sensorsWithClosestBeacons) {
        int eucDistanceSensorToBeacon =
            (sensor.item1.x - sensor.item2.x).abs() + (sensor.item1.y - sensor.item2.y).abs();
        int eucDistanceSensorToRow = (sensor.item1.y - row).abs();

        int leftOverDistance = eucDistanceSensorToBeacon - eucDistanceSensorToRow;
        if (leftOverDistance <= 0) {
          continue;
        }

        int left = sensor.item1.x - leftOverDistance;
        int right = sensor.item1.x + leftOverDistance;
        columnRanges.add(ColumnRange(left, right));
      }

      int positions = 0;
      List<Point<int>> beacons = sensorsWithClosestBeacons
          .map((sensorsWithClosestBeacon) => sensorsWithClosestBeacon.item2)
          .where((beacon) => beacon.y == row)
          .toList();
      for (int i = minX; i <= maxX; i++) {
        if (beacons.any((beacon) => beacon.x == i)) {
          continue;
        }

        if (!columnRanges.any((columnRange) => i >= columnRange.item1 && i <= columnRange.item2)) {
          print(Point(i, row));
          print("WTF");
        }
      }
    }
  }

}
