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
    label: 'Total; Sales',
    amount: '\$1200',
  ),
  InfoCardModel(
    icon: 'lib/assets/transfer.svg',
    label: 'Total Orders',
    amount: '\$150',
  ),
  InfoCardModel(
    icon: 'lib/assets/bank.svg',
    label: 'Food Items',
    amount: '\$1500',
  ),
  InfoCardModel(
    icon: 'lib/assets/doc.svg',
    label: 'Reviews',
    amount: '\$1500',
  ),
  InfoCardModel(
    icon: 'lib/assets/doc.svg',
    label: 'Visitors',
    amount: '\$1500',
  ),
  InfoCardModel(
    icon: 'lib/assets/doc.svg',
    label: 'Cancelled Orders',
    amount: '\$1500',
  ),
];
