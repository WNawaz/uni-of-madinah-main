import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AcknowledgementsScreen extends StatelessWidget {
  const AcknowledgementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          excludeSemantics: true,
          label: "Acknowledgements screen.",
          child: const Text('Acknowledgements'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Semantics(
                excludeSemantics: true,
                label: "Funded Project Title.",
                child: _buildTitle(
                  context,
                  'Funded Project Title',
                ),
              ),
              const SizedBox(height: 8.0),
              Semantics(
                excludeSemantics: true,
                label:
                    'A Trusted and Accessibility-Supported Islamic Knowledge Delivery Platform for Non-Arabic Speakers.',
                child: _buildDescription(
                  context,
                  'A Trusted and Accessibility-Supported Islamic Knowledge Delivery Platform for Non-Arabic Speakers',
                ),
              ),
              const SizedBox(height: 16.0),
              Semantics(
                excludeSemantics: true,
                label: "Research Team.",
                child: _buildTitle(
                  context,
                  'Research Team',
                ),
              ),
              const SizedBox(height: 8.0),
              Semantics(
                excludeSemantics: true,
                label:
                    'Dr. Waqas Nawaz from Islamic University of Madinah - PI. Dr. Qaiser Abbas from Islamic University of Madinah - Co-PI. Dr. Abdallah Namoun from Islamic University of Madinah - Co-PI. Dr. Fazal Noor from Islamic University of Madinah - Co-PI. Dr. Toqeer Ali from Islamic University of Madinah - Co-PI. Dr. Fahad Alsisi from Islamic University of Madinah - Co-PI. Dr. Kifayat Ullah Khan from FAST-NU Islamabad, Pakistan and Birmingham City University, UK - Consultant. Mr. Rayan, MS Data Science student at Islamic University of Madinah - Student. Mr. Zakariya, BS student at Islamic University of Madinah - Student.',
                child: _buildDescription(
                  context,
                  '1. Dr. Waqas Nawaz (Islamic University of Madinah) - PI\n'
                  '2. Dr. Qaiser Abbas (Islamic University of Madinah) - CO-PI\n'
                  '3. Dr. Abdallah Namoun (Islamic University of Madinah) - CO-PI\n'
                  '4. Dr. Fazal Noor (Islamic University of Madinah) - CO-PI\n'
                  '5. Dr. Toqeer Ali (Islamic University of Madinah) - CO-PI\n'
                  '6. Dr. Fahad Alsisi (Islamic University of Madinah) - CO-PI\n'
                  '7. Dr. Kifayat Ullah Khan (FAST-NU Islamabad, Pakistan | Birmingham City University, UK) - Consultant\n'
                  '8. Mr. Rayan (MS Data science student at Islamic University of Madinah) – Student\n'
                  '9. Mr. Zakariya (BS student at Islamic University of Madinah) - Student',
                ),
              ),
              const SizedBox(height: 16.0),
              Semantics(
                excludeSemantics: true,
                label: "Acknowledgements Statements.",
                child: _buildTitle(
                  context,
                  'Acknowledgements Statements',
                ),
              ),
              const SizedBox(height: 8.0),
              Semantics(
                excludeSemantics: true,
                label:
                    'The authors extend their sincere gratitude to all those who contributed to this study, notably the Islamic University of Madinah, National University of Computer and Emerging Sciences (FAST-NU), and Birmingham City University. Financial support for this research was generously provided by the Deanship of Scientific Research at the Islamic University of Madinah, KSA, under the research groups (first) project no. 956.',
                child: _buildDescription(
                  context,
                  'The authors extend their sincere gratitude to all those who contributed to this study, notably the Islamic University of Madinah, National University of Computer and Emerging Sciences (FAST-NU), and Birmingham City University. Financial support for this research was generously provided by the Deanship of Scientific Research at the Islamic University of Madinah, KSA, under the research groups (first) project no. 956.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(
    BuildContext context,
    String text,
  ) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: HexColor("#171C1F"),
          ),
    );
  }

  Widget _buildDescription(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: HexColor("#40484C"),
          ),
    );
  }
}
