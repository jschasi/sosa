import 'dart:math';
import '../models/link_model.dart';

class LinkService {
  static LinkModel? currentLink;
  static String? currentUser;

  static String generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ123456789';
    final rand = Random();
    return List.generate(6, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  static void createLink(String user) {
    currentUser = user;
    currentLink = LinkModel(
      code: generateCode(),
      owner: user,
      members: [user],
    );
  }

  static bool joinLink(String code, String user) {
    if (currentLink == null) return false;
    if (currentLink!.code != code) return false;
    if (currentLink!.members.contains(user)) return false;

    currentLink!.members.add(user);
    currentUser = user;
    return true;
  }

  static bool isLinked() => currentLink != null;
}
