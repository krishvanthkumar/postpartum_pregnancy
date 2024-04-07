import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicproject/common.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Chatbot1(),
    );
  }
}

class Chatbot1 extends StatefulWidget {
  @override
  _Chatbot1State createState() => _Chatbot1State();
}

class _Chatbot1State extends State<Chatbot1> {
  List<String> messages = [];
  List<String> options = [];

  @override
  void initState() {
    super.initState();
    setupChat();
  }

  void setupChat() async {
    List<String> initialOptions = [
      "Emotions, Mood Swings, Mental Health",
      "Newborn Care Sleep",
      "Relationship Support",
      "Physical Recovery",
      "Breastfeeding",
      "Things to do when you are feeling stressed"
    ];
    setState(() {
      options = initialOptions;
      messages.add("How can I help you today?");
    });
  }

  void handleOptionClick(String option) async {
    Map<String, List<String>> questionAnswerMap = getQuestionAnswerMap();
    List<String>? questions = questionAnswerMap[option];
    print(questions);
    print("1" + option);

    if (questions != null && questions.isNotEmpty) {
      setState(() {
        options.clear();
        messages.add(option);
      });
      fetchData(option, questions);
    } else {
      setState(() {
        options.clear();
        messages.add(option);
      });
      // Pass an empty list to fetchData if questions is null
      fetchData(option, []);
    }
  } // Handle options without questions

  Map<String, List<String>> getQuestionAnswerMap() {
    return {
      "Emotions, Mood Swings, Mental Health": [
        "Is it normal to feel overwhelmed or anxious after giving birth?",
        "When should I seek help for postpartum depression?",
        "How can I cope with the emotional challenges of motherhood?",
        "How can I deal with sleepless nights? Is it affecting my mental health?",
        "Why am I struggling to bond with my baby? Will it improve over time?",
        "Why does it feel like my husband/partner does not understand what I am going through?",
        "Why do I feel frustrated and irritable when my baby is crying? How do I manage these emotions better?",
        "Am I a bad mother for not being able to calm/soothe my crying baby?",
        "What are the signs and symptoms of postpartum depression?",
        "When is the right time to consult the doctor?",
        "What role do hormones play in postpartum depression?",
        "At what point do mood swings become a concern, and when should I seek professional help?",
        "Is it normal to talk about mood swings with friends and family, or is it something you should hide?"
      ],
      "Newborn Care Sleep": [
        "How can I establish a sleep routine for my baby?",
        "What are some tips for soothing a crying baby?",
        "Is it normal for a baby to cry a lot?",
        "How can I help my older child adjust to having a new sibling?"
      ],
      "Relationship Support": [
        "How can I maintain a strong relationship with my partner after having a baby?",
        "What can friends and family do to support me during the postpartum period?",
        "I feel changes in my friendships since becoming a mother. Is this normal? How can I maintain them?",
        "How to discuss and share parenting responsibilities with my partner and family members?"
      ],
      "Physical Recovery": [
        "How long does it take for postpartum bleeding to stop?",
        "What are some effective ways to manage postpartum pain?",
        "When can I start exercising again after giving birth?",
        "Are there any exercises to help tone my abdominal muscles after childbirth?"
      ],
      "Breastfeeding": [
        "How do I know if my baby is latching properly?",
        "What can I do to increase my milk supply?",
        "Are there any foods I should avoid while breastfeeding?",
        "How often should I breastfeed my baby?",
        "How can I manage breastfeeding when returning to work?"
      ],
      "Things to do when you are feeling stressed": [
        "Deep Breathing Exercises",
        "Mindfulness Meditation",
        "Journaling",
        "Relaxation Techniques",
        "Self-Compassion Practices",
        "Creative Outlets",
        "Aromatherapy",
        "Warm Baths",
        "Positive Affirmations",
        "Gentle Exercise",
        "Listen to Calming Music",
        "Establish a Daily Routine",
        "Connect with Nature",
        "Mindful Eating"
      ]
    };
  }

  void fetchData(String qns, List<String> questions) async {
    String apiUrl = chaturi;
    print("kk " + qns);
    try {
      final response = await http.post(Uri.parse(apiUrl), body: {'qns': qns});
      if (response.statusCode == 200) {
        print(response.body);
        handleResponse(response.body, questions);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }

  void handleResponse(String response, List<String> questions) {
    print("JSON Response: $response");
    print(response);
    String ans = response;
    print(1);
    print(questions);
    if (ans.substring(1, ans.length - 1) == "hi") {
      options.addAll(questions);
    } else {
      ans = ans.substring(1, ans.length - 1);
      print(ans);
      messages.add(ans);
      options.addAll([
        "Emotions, Mood Swings, Mental Health",
        "Newborn Care Sleep",
        "Relationship Support",
        "Physical Recovery",
        "Breastfeeding",
        "Things to do when you are feeling stressed"
      ]);
    }
    setState(() {});
  }

  void handleError(dynamic error) {
    print("Volley Error: Error: $error");
    print("boooooo");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat With Mojo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length + options.length,
              itemBuilder: (BuildContext context, int index) {
                if (index < messages.length) {
                  return MessageWidget(message: messages[index]);
                } else {
                  return OptionWidget(
                    option: options[index - messages.length],
                    onTap: () =>
                        handleOptionClick(options[index - messages.length]),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String message;

  const MessageWidget({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.asset(
            'assets/images/human.jpg', // Path to your image
            width: 20,
            height: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: 'Poppins Semibold',
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OptionWidget extends StatelessWidget {
  final String option;
  final VoidCallback onTap;

  const OptionWidget({required this.option, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          option,
          style: TextStyle(
            fontFamily: 'Poppins Semibold',
            fontSize: 12,
            color: const Color.fromARGB(255, 3, 3, 3),
          ),
        ),
      ),
    );
  }
}
