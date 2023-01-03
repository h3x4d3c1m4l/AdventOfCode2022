import 'dart:core';
import 'dart:math';

import 'package:aoc22/solvers/solver.dart';
import 'package:darq/darq.dart' hide Tuple2;
import 'package:petitparser/petitparser.dart';
import 'package:tuple/tuple.dart';

typedef PacketPair = Tuple2<List, List>;

class Day13Solver extends Solver<String, String> {

  @override
  String get problemUrl => 'https://adventofcode.com/2022/day/13';

  @override
  String get solverCodeFilename => 'day_13_solver.dart';
  
  @override
  String getSolution(String input) {
    String inputTrimmed = input.trim();
    List<PacketPair> pairs = _parsePairs(inputTrimmed);

    // part 1
    int sumOfIndices = 0;
    for (int i = 0; i < pairs.length; i++) {
      PacketPair pair = pairs[i];
      if (_testOrder(pair.item1, pair.item2) == true) {
        sumOfIndices += i + 1;
      }
    }
  
    // part 2
    List allPacketsInOrder = [
      ...pairs.map((pairTuple) => pairTuple.toList()).toList().flatten(),
      [[2]],
      [[6]],
    ]..sort((a, b) {
      bool? inOrder = _testOrder(a, b);
      return inOrder == true ? -1 : inOrder == false ? 1 : 0;
    });

    int indexFirst = 0, indexSecond = 0;
    for (int i = 0; i < allPacketsInOrder.length; i++) {
      List packet = allPacketsInOrder[i];
      if (packet.length == 1 && packet[0] is List && packet[0].length == 1 && packet[0][0] == 2) {
        indexFirst = i + 1;
      } else if (packet.length == 1 && packet[0] is List && packet[0].length == 1 && packet[0][0] == 6) {
        indexSecond = i + 1;
        break;
      }
    }
    int indicesMultiplied = indexFirst * indexSecond;

    return 'Sum of indices: $sumOfIndices\nDivider packet indices multiplied: $indicesMultiplied';
  }

  bool? _testOrder(dynamic obj1, dynamic obj2) {
    if (obj1 is int && obj2 is int) {
      return obj1 < obj2 ? true : obj1 > obj2 ? false : null;
    } else if (obj1 is List && obj2 is List) {
      int maxIndex = max(obj1.length, obj2.length);
      for (int i = 0; i < maxIndex; i++) {
        if (i >= obj1.length) {
          // left list ran out of items
          return true;
        } else if (i >= obj2.length) {
          // right list ran out of items
          return false;
        }

        bool? itemTestOrderResult = _testOrder(obj1[i], obj2[i]);
        if (itemTestOrderResult != null) {
          return itemTestOrderResult;
        }
      }
    } else if (obj1 is int && obj2 is List) {
      // convert the integer to a list which contains that integer as its only value
      return _testOrder([obj1], obj2);
    } else if (obj1 is List && obj2 is int) {
      // convert the integer to a list which contains that integer as its only value
      return _testOrder(obj1, [obj2]);
    }

    return null;
  }

  List<PacketPair> _parsePairs(String input) {
    // integer
    final Parser<int> number = digit().plus().flatten().trim().map(int.parse);

    // array (recusive)
    final SettableParser array = undefined();
    final ChoiceParser arrayItem = number | array;
    final Parser<List> arrayContents =
        arrayItem.starSeparated(char(',')).map((separatedList) => separatedList.elements);
    array.set((char('[') & arrayContents & char(']')).map((value) => value[1]));

    // packets
    final Parser<PacketPair> pairOfPackets =
        (array & string('\n') & array).map((rawParsed) => PacketPair(rawParsed[0], rawParsed[2]));
    final Parser<List<PacketPair>> pairsOfPackets = (pairOfPackets & (string('\n\n') | endOfInput()))
        .star()
        .map((rawParsedPairs) => rawParsedPairs.map((rawParsedPair) => rawParsedPair[0] as PacketPair).toList())
        .end();

    return pairsOfPackets.parse(input).value;
  }

}
