class InfoCardModel {
  final String icon;
  final String label;
  final String amount;

  InfoCardModel({
    required this.icon,
    required this.label,
    required this.amount,
  });
}

final List<InfoCardModel> infoCardData = [
  InfoCardModel(
    icon: 'lib/assets/credit-card.svg',
    label: 'Transfer via \nCard number',
    amount: '\$1200',
  ),
  InfoCardModel(
    icon: 'lib/assets/transfer.svg',
    label: 'Transfer via \nOnline Banks',
    amount: '\$150',
  ),
  InfoCardModel(
    icon: 'lib/assets/bank.svg',
    label: 'Transfer \nSame Bank',
    amount: '\$1500',
  ),
  InfoCardModel(
    icon: 'lib/assets/doc.svg',
    label: 'Transfer to \nOther Bank',
    amount: '\$1500',
  ),
];
