import 'package:audioplayers/audioplayers.dart';

class SoundService {
  // ✅ แยก Player เป็น 2 ตัว
  static final _bgmPlayer = AudioPlayer();    // สำหรับเสียงธรรมชาติ (เล่นวน)
  static final _effectPlayer = AudioPlayer(); // สำหรับเสียง Effect สั้นๆ

  static bool? _lastIsSickState;

  // --- 1. เล่นเสียง Effect (Heal / Damage) ---
  static Future<void> playEffect({required bool isHealing}) async {
    // หยุดแค่เสียง Effect (ไม่กวนเสียงธรรมชาติ)
    await _effectPlayer.stop();

    if (isHealing) {
      await _effectPlayer.play(AssetSource('sounds/heal.mp3'));
    } else {
      await _effectPlayer.play(AssetSource('sounds/damage.mp3'));
    }
  }

  // --- 2. เล่นเสียงปุ่ม Start ---
  static Future<void> playStart() async {
    // หยุดแค่เสียง Effect
    await _effectPlayer.stop();
    await _effectPlayer.play(AssetSource('sounds/start.mp3'));
  }

  // --- 3. ระบบเสียงบรรยากาศ (Ambience) ---
  static Future<void> playAmbience({required bool isSick}) async {
    // เช็คว่าสถานะเปลี่ยนไหม หรือเพลงเล่นอยู่แล้วหรือไม่
    if (_lastIsSickState == isSick && _bgmPlayer.state == PlayerState.playing) {
      return;
    }

    _lastIsSickState = isSick;

    // หยุดเพลงเก่าและเริ่มเล่นใหม่เฉพาะ BGM
    await _bgmPlayer.stop();
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop); // เล่นวนซ้ำ
    await _bgmPlayer.setVolume(0.3); // ปรับระดับเสียง

    if (isSick) {
      // 😷 เสียงตอนโลกป่วย
      await _bgmPlayer.play(AssetSource('sounds/sick.mp3')); 
    } else {
      // 🌳 เสียงตอนปกติ
      await _bgmPlayer.play(AssetSource('sounds/nature.mp3'));
    }
  }

  // --- 4. หยุดเสียงทั้งหมด ---
  static Future<void> stopAmbience() async {
    await _bgmPlayer.stop();
    _lastIsSickState = null;
  }
}