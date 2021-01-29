import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';

import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  TransactionList(this.transactions, this.deleteTransaction);
  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 200,
        child: transactions.isEmpty
            ? LayoutBuilder(builder: (ctx, Constraints) {
                return Column(
                  children: [
                    Text(
                      'No Transactions Added Yet..',
                      style: Theme.of(context).textTheme.title,
                    ),
                    Container(
                      height: Constraints.maxHeight * 0.7,
                      child: Image.asset(
                        'assets/images/image.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              })
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return TransactionItem(
                      transaction: transactions[index],
                      deleteTransaction: deleteTransaction);
                },
                itemCount: transactions.length,
              )
        // child: Column(
        //   children: transactions.map((tx) {
        //     return
        //   }).toList(),
        // ),

        );
  }
}
