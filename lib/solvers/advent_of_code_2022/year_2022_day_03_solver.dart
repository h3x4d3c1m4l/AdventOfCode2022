import 'package:aoc22/solvers/solver.dart';

class Year2022Day03Solver extends Solver<String, String> {
  
  @override
  String getSolution(String input) {
    List<String> rawRucksacks = input.split('\n').where((rawRucksack) => rawRucksack.isNotEmpty).toList();

    // part 1
    int compartmentCommonItemPriorities = 0;
    for (String rawRucksack in rawRucksacks) {
      List<int> rucksackContentCodeUnits = rawRucksack.codeUnits;

      // find the item that appears in both compartments
      int halfOfList = rucksackContentCodeUnits.length ~/ 2;
      List<int> compartment1CodeUnits = rucksackContentCodeUnits.sublist(0, halfOfList);
      List<int> compartment2CodeUnits = rucksackContentCodeUnits.sublist(halfOfList);
      int commonCodeUnit = compartment1CodeUnits.where((c1CodeUnit) => compartment2CodeUnits.contains(c1CodeUnit)).first;
      
      compartmentCommonItemPriorities += _getRucksackItemPriority(commonCodeUnit);
    }

    // part 2
    int badgePriorities = 0;
    for (int i = 0; i < rawRucksacks.length; i += 3) {
      List<int> rucksack1CodeUnits = rawRucksacks[i].codeUnits;
      List<int> rucksack2CodeUnits = rawRucksacks[i + 1].codeUnits;
      List<int> rucksack3CodeUnits = rawRucksacks[i + 2].codeUnits;

      // find the item that appears in all rucksacks
      int commonCodeUnit = rucksack1CodeUnits
          .where((c1CodeUnit) => rucksack2CodeUnits.contains(c1CodeUnit) && rucksack3CodeUnits.contains(c1CodeUnit))
          .first;

      badgePriorities += _getRucksackItemPriority(commonCodeUnit);
    }

    return 'X: $compartmentCommonItemPriorities, Y: $badgePriorities';
  }

  int _getRucksackItemPriority(int rucksackItemCodeUnit) {
    final codeUnitLowercaseA = 'a'.codeUnitAt(0);
    final codeUnitUppercaseA = 'A'.codeUnitAt(0);

    if (rucksackItemCodeUnit >= codeUnitLowercaseA) {
      return rucksackItemCodeUnit - codeUnitLowercaseA + 1;
    } else {
      return rucksackItemCodeUnit - codeUnitUppercaseA + 27;
    }
  }

}
