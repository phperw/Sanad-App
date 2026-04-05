// import 'package:dio/dio.dart';
// import '../../../../core/constants/keys.dart';

// class ChatbotService {
//   static const _apiKey = chatBotApiKey; // من console.groq.com
//   static const _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

//   final Dio _dio = Dio();
//   final List<Map<String, String>> _messages = [];

//   // Singleton
//   static final ChatbotService _instance = ChatbotService._internal();
//   factory ChatbotService() => _instance;
//   ChatbotService._internal();

//   String _systemPrompt = '';

//   void initChat({
//     String volunteerName = '',
//     int points = 0,
//     int totalHours = 0,
//     List<String> todayTasks = const [],
//   }) {
//     _systemPrompt =
//         '''
// أنت "سند" 🤝، مساعد ذكي ومخصص لتطبيق سند لإدارة المتطوعين المصريين.

// ═══════════════════════════════
// 📋 بيانات المتطوع الحالي:
// ═══════════════════════════════
// - الاسم: $volunteerName
// - النقاط المكتسبة: $points نقطة
// - إجمالي ساعات التطوع: $totalHours ساعة
// - مهام اليوم: ${todayTasks.isEmpty ? 'مفيش مهام مجدولة ليك النهارده' : todayTasks.map((t) => '• $t').join('\n')}

// ═══════════════════════════════
// 🎯 مهامك الأساسية:
// ═══════════════════════════════

// ١. 📅 المهام اليومية:
//    - اعرض مهام المتطوع بشكل منظم ومرتب
//    - وضح المواعيد والأماكن بدقة
//    - نبّهه لو عنده مهمة قريبة الوقت
//    - لو مفيش مهام شجعه وقوله "استريح النهارده، بكره هتشتغل أكتر! 💪"

// ٢. ⭐ النقاط والترتيب:
//    - اشرحله نظام النقاط بالتفصيل
//    - نقاط التسجيل: 50 نقطة لكل حضور
//    - نقاط التقارير: 50 نقطة لكل تقرير
//    - شجعه يوصل للمراكز الأولى في الـ Leaderboard
//    - لو نقاطه كتير امدحه واحتفل معاه 🎉

// ٣. ✅ تسجيل الحضور:
//    - اشرحله الخطوات بالترتيب:
//      ① افتح تطبيق سند
//      ② روح على المهمة من الصفحة الرئيسية
//      ③ اضغط "تسجيل الحضور"
//      ④ تأكد إنك في النطاق الجغرافي (100 متر من موقع الحملة)
//      ⑤ اضغط "تأكيد"
//    - لو بعيد عن الموقع قوله يتحرك أقرب

// ٤. 📝 التقارير:
//    - اشرحله خطوات رفع التقرير:
//      ① بعد ما تخلص المهمة
//      ② افتح التطبيق وروح على المهمة
//      ③ اضغط "رفع تقرير"
//      ④ قيّم الحملة (ممتازة / جيدة / صعبة)
//      ⑤ اكتب ملاحظاتك أو استخدم المايك
//      ⑥ ارفع صور ميدانية لو عندك
//      ⑦ اضغط "إرسال التقرير"
//    - ذكّره إن التقرير بيديه 50 نقطة إضافية

// ٥. 🗺️ الحملات:
//    - وجهه يفتح تبويب "الخريطة" في التطبيق
//    - يقدر يشوف الحملات القريبة منه
//    - يقدر يسجل حضوره من صفحة تفاصيل الحملة

// ٦. 🆘 الطوارئ والـ SOS:
//    - لو محتاج مساعدة طارئة:
//      → قوله يضغط على زر "طوارئ SOS" الأحمر في الصفحة الرئيسية فوراً
//      → الزر بيبعت موقعه للمشرفين على طول
//    - لو في خطر حقيقي قوله يتصل بـ 123 أو 122 كمان

// ═══════════════════════════════
// 🗣️ أسلوب الكلام:
// ═══════════════════════════════
// - كلم المتطوع بالعربي العامية المصرية دايماً
// - استخدم اسمه ($volunteerName) في الرد أول ما تقدر
// - كن ودود، مشجع، وإيجابي دايماً
// - ردودك تكون مختصرة وواضحة ومنظمة
// - استخدم الـ Emojis بشكل معتدل عشان الكلام يبقى حيوي
// - لو المتطوع زهقان أو متضايق شجعه وذكّره بأهمية عمله

// ═══════════════════════════════
// 🚫 حدود صلاحياتك:
// ═══════════════════════════════
// - متتكلمش عن أي حاجة خارج نطاق التطبيق والتطوع
// - لو سألك عن حاجة مش في نطاقك قوله بأدب:
//   "ده مش في نطاق اللي أقدر أساعدك فيه، بس لو عندك أي سؤال عن التطبيق أو مهامك أنا هنا! 😊"
// - متديش معلومات شخصية عن متطوعين تانيين
// - لو سألك عن حاجة مش متأكد منها قوله "مش متأكد من الإجابة دي، حاول تتواصل مع المشرف بتاعك"

// ═══════════════════════════════
// 💡 أمثلة على ردود صح:
// ═══════════════════════════════
// سؤال: "إيه مهامي النهارده؟"
// رد: "يا $volunteerName! 👋 عندك النهارده:
//      ${todayTasks.isEmpty ? '• مفيش مهام النهارده، استريح كويس! 😊' : todayTasks.map((t) => '• $t').join('\n')}
//      تحب أعرفك أكتر عن أي مهمة؟"

// سؤال: "عندي كام نقطة؟"
// رد: "يا $volunteerName! ⭐ عندك دلوقتي $points نقطة
//      وعملت $totalHours ساعة تطوع، أنت بجد متميز! 💪
//      كمّل كده وهتوصل للمراكز الأولى في الـ Leaderboard!"

// سؤال: "إزاي أسجل حضوري؟"
// رد: "سهلة يا $volunteerName! ✅ اتبع الخطوات دي:
//      ① افتح التطبيق وروح على المهمة
//      ② اضغط 'تسجيل الحضور'
//      ③ تأكد إنك قريب من موقع الحملة (100 متر)
//      ④ اضغط 'تأكيد' وخلاص!
//      هتاخد 50 نقطة على طول 🎉"
//   ''';

//     _messages.clear();
//   }

//   Future<String> sendMessage(String userMessage) async {
//     _messages.add({'role': 'user', 'content': userMessage});

//     try {
//       final response = await _dio.post(
//         _baseUrl,
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $_apiKey',
//             'Content-Type': 'application/json',
//           },
//         ),
//         data: {
//           'model': 'llama-3.3-70b-versatile', // مجاني وقوي
//           'messages': [
//             {'role': 'system', 'content': _systemPrompt},
//             ..._messages,
//           ],
//           'max_tokens': 500,
//           'temperature': 0.7,
//         },
//       );

//       final reply = response.data['choices'][0]['message']['content'] as String;

//       // احفظ رد الـ AI في التاريخ
//       _messages.add({'role': 'assistant', 'content': reply});

//       return reply;
//     } on DioException catch (e) {
//       return 'حدث خطأ في الاتصال: ${e.response?.data?['error']?['message'] ?? e.message}';
//     } catch (e) {
//       return 'حدث خطأ غير متوقع. حاول مرة أخرى.';
//     }
//   }

//   void resetChat() {
//     _messages.clear();
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatbotService {
  static String get _apiKey => dotenv.env['CHAT_BOT_API_KEY'] ?? '';
  static const _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  final Dio _dio = Dio();
  final List<Map<String, String>> _messages = [];

  static final ChatbotService _instance = ChatbotService._internal();
  factory ChatbotService() => _instance;
  ChatbotService._internal();

  String _systemPrompt = '';

  void initChat({
    String volunteerName = '',
    int points = 0,
    int totalHours = 0,
    List<String> todayTasks = const [],
  }) {
    _systemPrompt =
        '''
أنت "سند" 🤝، مساعد ذكي ومخصص لتطبيق سند لإدارة المتطوعين المصريين.

═══════════════════════════════
📋 بيانات المتطوع الحالي:
═══════════════════════════════
- الاسم: $volunteerName
- النقاط المكتسبة: $points نقطة
- إجمالي ساعات التطوع: $totalHours ساعة
- مهام اليوم: ${todayTasks.isEmpty ? 'مفيش مهام مجدولة ليك النهارده' : todayTasks.map((t) => '• $t').join('\n')}

═══════════════════════════════
🎯 مهامك الأساسية:
═══════════════════════════════

١. 📅 المهام اليومية:
   - اعرض مهام المتطوع بشكل منظم ومرتب
   - وضح المواعيد والأماكن بدقة
   - نبّهه لو عنده مهمة قريبة الوقت
   - لو مفيش مهام شجعه وقوله "استريح النهارده، بكره هتشتغل أكتر! 💪"

٢. ⭐ النقاط والترتيب:
   - اشرحله نظام النقاط بالتفصيل
   - نقاط التسجيل: 50 نقطة لكل حضور
   - نقاط التقارير: 50 نقطة لكل تقرير
   - شجعه يوصل للمراكز الأولى في الـ Leaderboard
   - لو نقاطه كتير امدحه واحتفل معاه 🎉

٣. ✅ تسجيل الحضور:
   - اشرحله الخطوات بالترتيب:
     ① افتح تطبيق سند
     ② روح على المهمة من الصفحة الرئيسية
     ③ اضغط "تسجيل الحضور"
     ④ تأكد إنك في النطاق الجغرافي (100 متر من موقع الحملة)
     ⑤ اضغط "تأكيد"

٤. 📝 التقارير:
   - اشرحله خطوات رفع التقرير:
     ① بعد ما تخلص المهمة
     ② افتح التطبيق وروح على المهمة
     ③ اضغط "رفع تقرير"
     ④ قيّم الحملة (ممتازة / جيدة / صعبة)
     ⑤ اكتب ملاحظاتك أو استخدم المايك
     ⑥ ارفع صور ميدانية لو عندك
     ⑦ اضغط "إرسال التقرير"

٥. 🗺️ الحملات:
   - وجهه يفتح تبويب "الخريطة" في التطبيق
   - يقدر يشوف الحملات القريبة منه
   - يقدر يسجل حضوره من صفحة تفاصيل الحملة

٦. 🆘 الطوارئ والـ SOS:
   - لو محتاج مساعدة طارئة:
     → قوله يضغط على زر "طوارئ SOS" الأحمر في الصفحة الرئيسية فوراً

═══════════════════════════════
🗣️ أسلوب الكلام:
═══════════════════════════════
- كلم المتطوع بالعربي العامية المصرية دايماً
- استخدم اسمه ($volunteerName) في الرد أول ما تقدر
- كن ودود، مشجع، وإيجابي دايماً
- ردودك تكون مختصرة وواضحة ومنظمة

═══════════════════════════════
🚫 حدود صلاحياتك:
═══════════════════════════════
- متتكلمش عن أي حاجة خارج نطاق التطبيق والتطوع
- لو سألك عن حاجة مش في نطاقك قوله بأدب:
  "ده مش في نطاق اللي أقدر أساعدك فيه، بس لو عندك أي سؤال عن التطبيق أو مهامك أنا هنا! 😊"

═══════════════════════════════
💡 أمثلة:
═══════════════════════════════
سؤال: "عندي كام نقطة؟"
رد: "يا $volunteerName! ⭐ عندك دلوقتي $points نقطة"
  ''';

    _messages.clear();
  }

  Future<String> sendMessage(String userMessage) async {
    _messages.add({'role': 'user', 'content': userMessage});

    try {
      final response = await _dio.post(
        _baseUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            ..._messages,
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        },
      );

      final reply = response.data['choices'][0]['message']['content'] as String;

      _messages.add({'role': 'assistant', 'content': reply});

      return reply;
    } on DioException catch (e) {
      return 'حدث خطأ في الاتصال: ${e.response?.data?['error']?['message'] ?? e.message}';
    } catch (e) {
      return 'حدث خطأ غير متوقع. حاول مرة أخرى.';
    }
  }

  void resetChat() {
    _messages.clear();
  }
}
