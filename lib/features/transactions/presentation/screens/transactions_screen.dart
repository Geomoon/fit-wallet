import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All transactions'),
      ),
      body: const _TransactionsScreenView(),
    );
  }
}

class _TransactionsScreenView extends StatelessWidget {
  const _TransactionsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 4, left: 10, right: 10),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: TransactionsResume(),
          )
        ],
      ),
    );
  }
}

class TransactionsResume extends StatelessWidget {
  const TransactionsResume({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Icon(Icons.arrow_upward_rounded),
          ),
        ),
        Expanded(
          child: Card(
            child: Icon(Icons.arrow_downward_rounded),
          ),
        ),
      ],
    );
  }
}
