import 'package:hive/hive.dart';

part '../Hive/VerseModal.g.dart';

@HiveType(typeId: 2)
class VerseModal {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String content;
  @HiveField(2)
  final String translationEng;
  @HiveField(3)
  final String audioData;

  VerseModal({
    required this.id,
    required this.content,
    required this.translationEng,
    required this.audioData,
  });
}
