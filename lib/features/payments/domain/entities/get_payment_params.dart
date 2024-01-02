class GetPaymentParams {
  GetPaymentParams({
    this.dateType = DateType.desc,
    this.isCompleted,
  });

  bool? isCompleted;
  DateType dateType;
}

enum DateType { asc, desc }
