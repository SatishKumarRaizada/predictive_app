import 'package:flutter/material.dart';

class PreTableWidget extends StatelessWidget {
  final String mVale;
  final String eVale;
  final String aVale;
  final String tVale;

  const PreTableWidget({
    Key? key,
    required this.mVale,
    required this.eVale,
    required this.aVale,
    required this.tVale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(),
                      bottom: BorderSide(),
                    ),
                  ),
                  child: const Text('Methane'),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(),
                      bottom: BorderSide(),
                    ),
                  ),
                  child: const Text('Ethane'),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(),
                      bottom: BorderSide(),
                    ),
                  ),
                  child: const Text('Acetylene'),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(),
                      bottom: BorderSide(),
                    ),
                  ),
                  child: const Text('TDCG'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(),
                      bottom: BorderSide(),
                    ),
                  ),
                  child: Text(mVale),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(),
                      bottom: BorderSide(),
                    ),
                  ),
                  child: Text(eVale),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(),
                      bottom: BorderSide(),
                    ),
                  ),
                  child: Text(aVale),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(),
                      bottom: BorderSide(),
                    ),
                  ),
                  child: Text(tVale),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
