import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final _player = AudioPlayer();

  // ฟังก์ชันเล่นเสียงตามประเภทการกระทำ
  static Future<void> playEffect({required bool isHealing}) async {
    // ถ้าจะเล่นซ้อนกันได้ต้องสร้าง player ใหม่ หรือใช้ mode low latency
    // แต่เพื่อความง่าย ใช้ player เดียว stop ก่อนเล่นใหม่
    await _player.stop();

    if (isHealing) {
      // 🌿 เสียงทำดี (Heal)
      await _player.play(AssetSource('sounds/heal.mp3'));
    } else {
      // 🔥 เสียงทำลาย (Damage)
      await _player.play(AssetSource('sounds/damage.mp3'));
    }
  }

  // ใน SoundService
  static Future<void> playStart() async {
    await _player.stop();
  
    await _player.play(AssetSource('sounds/start.mp3'));
  }
}
