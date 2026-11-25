import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_paperplane/save.dart';

void main() {
  test('presentation skin milestones stop at 50K', () {
    expect(SaveData.skinMilestones, [0, 10000, 20000, 30000, 50000]);
  });
}
