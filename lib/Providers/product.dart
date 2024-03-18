class Medicine {
  final String medId;
  final String medName;
  final String imageUrl;
  int medCount;
  final String desc;
  final String expirydate;

  Medicine(this.medId, this.medName, this.imageUrl, this.medCount,
      this.expirydate, this.desc);
}

String imageUrl =
    'https://onemg.gumlet.io/l_watermark_346,w_240,h_240/a_ignore,w_240,h_240,c_fit,q_auto,f_auto/hx2gxivwmeoxxxsc1hix.png';

List<Medicine> med = [
  Medicine(
      '1',
      'Crocin',
      imageUrl, // Replace with actual image URL
      10,
      '10 July',
      'This is used for fever (Paracetamol)'),
  Medicine(
      '2',
      'Paracetamol',
      imageUrl, // Replace with actual image URL
      500,
      '31 December',
      'Pain relief and fever reduction'),
  Medicine(
      '3',
      'Ibuprofen',
      imageUrl, // Replace with actual image URL
      200,
      '15 August',
      'Pain and inflammation relief'),
  Medicine(
      '4',
      'Loratadine',
      imageUrl, // Replace with actual image URL
      10,
      '20 February',
      'Allergies - relieves runny nose, sneezing, itchy eyes (Antihistamine)'),
  Medicine(
      '5',
      'Omeprazole',
      imageUrl, // Replace with actual image URL
      20,
      '14 May',
      'Reduces stomach acid - for heartburn and ulcers (Proton pump inhibitor)'),
  Medicine(
      '6',
      'Cetirizine',
      imageUrl, // Replace with actual image URL
      10,
      '25 September',
      'Allergies - similar to Loratadine (Antihistamine)'),
  Medicine(
      '7',
      'Salbutamol inhaler',
      imageUrl, // Replace with actual image URL
      60,
      '01 January',
      'Relieves asthma symptoms - relaxes airways (Bronchodilator)'),
  Medicine(
      '8',
      'Amoxicillin',
      imageUrl, // Replace with actual image URL
      500,
      '12 March', // Placeholder, update with actual expiry date
      'Antibiotic for bacterial infections'),
  Medicine(
      '9',
      'Simvastatin',
      imageUrl, // Replace with actual image URL
      20,
      '08 June', // Placeholder, update with actual expiry date
      'Lowers cholesterol (Statin)'),
  Medicine(
      '10',
      'Metformin',
      imageUrl, // Replace with actual image URL
      500,
      '19 November', // Placeholder, update with actual expiry date
      'Manages blood sugar levels in type 2 diabetes'),
];
