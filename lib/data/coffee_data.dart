import '../models/branch/branch.dart';
import '../models/product/product.dart';

const List<Product> products = [
  // --- Arabic Coffee (بن عربي) ---
  Product(
    id: "ground-plain-light",
    name: "بن سادة فاتح",
    nameEn: "Plain Light Roast",
    category: "arabic",
    price: 45.0,
    image: "assets/images/product-1.jpg",
    description:
        "أجود حبوب البن الهرري المختارة بعناية، محمصة تحميصاً فاتحاً للحفاظ على النكهة الأصلية",
    sensory: "حموضة متزنة... قوام خفيف يداعب الحواس",
    tags: ["سادة", "خفيف"],
    isFeatured: true,
    isNew: false,
    calories: 5,
    sizes: [
      ProductSize(label: "٢٥٠ جرام", price: 45.0),
      ProductSize(label: "٥٠٠ جرام", price: 85.0),
      ProductSize(label: "١ كيلو", price: 160.0),
    ],
  ),
  Product(
    id: "ground-plain-dark",
    name: "بن سادة غامق",
    nameEn: "Plain Dark Roast",
    category: "arabic",
    price: 45.0,
    image: "assets/images/product-1.jpg",
    description:
        "بن هرري محمحص بعناية لدرجة داكنة، يمنحك نكهة قوية وقواماً غنياً",
    sensory: "قوي كالليل... مرارة مستساغة تترك أثراً باقياً",
    tags: ["سادة", "قوي"],
    isNew: true,
    isFeatured: true,
    calories: 5,
    sizes: [
      ProductSize(label: "٢٥٠ جرام", price: 45.0),
      ProductSize(label: "٥٠٠ جرام", price: 85.0),
      ProductSize(label: "١ كيلو", price: 160.0),
    ],
  ),
  Product(
    id: "ground-cardamom-light",
    name: "بن محوج هيل فاتح",
    nameEn: "Cardamom Light Blend",
    category: "arabic",
    price: 55.0,
    image: "assets/images/product-1.jpg",
    description:
        "مزيجنا الخاص من البن الفاتح مع أفخر أنواع الهيل الهندي الأخضر",
    sensory: "عطر يملأ المكان... دفء الهيل في كل رشفة",
    tags: ["محوج", "هيل"],
    isFeatured: true,
    calories: 8,
    sizes: [
      ProductSize(label: "٢٥٠ جرام", price: 55.0),
      ProductSize(label: "٥٠٠ جرام", price: 100.0),
      ProductSize(label: "١ كيلو", price: 190.0),
    ],
  ),
  Product(
    id: "ground-special",
    name: "بن الغالي مخصوص",
    nameEn: "Al-Ghali Special Blend",
    category: "arabic",
    price: 70.0,
    image: "assets/images/product-1.jpg",
    description:
        "خلطة بن الغالي السرية، مزيج من البن والهيل والزعفران والخلطات العربية الأصيلة",
    sensory: "ملكي بامتياز... رحلة في أعماق التراث العربي",
    tags: ["مخصوص", "فاخر"],
    isNew: true,
    isFeatured: true,
    calories: 12,
    sizes: [
      ProductSize(label: "٢٥٠ جرام", price: 70.0),
      ProductSize(label: "٥٠٠ جرام", price: 130.0),
      ProductSize(label: "١ كيلو", price: 250.0),
    ],
  ),

  // --- Turkish Coffee (بن تركي) ---
  Product(
    id: "turkish-plain",
    name: "بن تركي سادة",
    nameEn: "Turkish Plain",
    category: "turkish",
    price: 40.0,
    image: "assets/images/product-1.jpg",
    description: "بن تركي مطحون ناعم جداً لتحضير القهوة التركية التقليدية",
    sensory: "عبق التقاليد في فنجان واحد",
    tags: ["تركي", "ناعم"],
    isFeatured: false,
    sizes: [
      ProductSize(label: "١٢٥ جرام", price: 40.0),
      ProductSize(label: "٢٥٠ جرام", price: 75.0),
    ],
  ),
  Product(
    id: "turkish-cardamom",
    name: "بن تركي محوج",
    nameEn: "Turkish Cardamom",
    category: "turkish",
    price: 50.0,
    image: "assets/images/product-1.jpg",
    description: "بن تركي فاخر مع الهيل المطحون لنكهة تركية أصيلة",
    sensory: "مذاق يجمع بين الأصالة والتميز",
    tags: ["تركي", "هيل"],
    isFeatured: true,
    sizes: [
      ProductSize(label: "١٢٥ جرام", price: 50.0),
      ProductSize(label: "٢٥٠ جرام", price: 95.0),
    ],
  ),

  // --- Espresso (إسبريسو) ---
  Product(
    id: "espresso-blend",
    name: "حبوب إسبريسو",
    nameEn: "Espresso Blend Beans",
    category: "espresso",
    price: 120.0,
    image: "assets/images/product-1.jpg",
    description: "مزيج من أرابيكا وروبوستا لضمان أفضل كريمة وطعم متوازن",
    sensory: "طاقة مكثفة وقوام حريري",
    tags: ["حبوب", "قوي"],
    isNew: true,
    sizes: [
      ProductSize(label: "٢٥٠ جرام", price: 120.0),
      ProductSize(label: "١ كيلو", price: 420.0),
    ],
  ),

  // --- French Coffee (بن فرنساوي) ---
  Product(
    id: "french-hazelnut",
    name: "بن فرنساوي بالبندق",
    nameEn: "French Hazelnut",
    category: "french",
    price: 60.0,
    image: "assets/images/product-1.jpg",
    description: "بن فاخر ممزوج بنكهة البندق المحمص والكريمة الغنية",
    sensory: "لحظة من الرفاهية الفرنسية",
    tags: ["بندق", "كريمي"],
    isFeatured: true,
    sizes: [
      ProductSize(label: "٢٥٠ جرام", price: 60.0),
      ProductSize(label: "٥٠٠ جرام", price: 110.0),
    ],
  ),
  Product(
    id: "french-chocolate",
    name: "بن فرنساوي بالشوكولاتة",
    nameEn: "French Chocolate",
    category: "french",
    price: 60.0,
    image: "assets/images/product-1.jpg",
    description: "تجربة ساحرة تجمع بين جودة البن ولذة الشوكولاتة الداكنة",
    sensory: "غرق في عالم من السعادة",
    tags: ["شوكولاتة", "حلو"],
    sizes: [
      ProductSize(label: "٢٥٠ جرام", price: 60.0),
      ProductSize(label: "٥٠٠ جرام", price: 110.0),
    ],
  ),
];

const List<Branch> branches = [
  Branch(
    id: "b1",
    name: "فرع الجمهورية (رمادا)",
    city: "المنصورة",
    address: "شارع الجمهورية، بجوار فندق رمادا، المنصورة",
    hours: "٠٨:٠٠ ص - ٠٢:٠٠ ص",
    phone: "+20502200788",
    isOpen: true,
    waitTime: "٥ دقائق",
    x: 25.0,
    y: 60.0,
  ),
  Branch(
    id: "b2",
    name: "فرع بوابة الجامعة",
    city: "المنصورة",
    address: "شارع الجمهورية، أمام بوابة الجامعة الجديدة، المنصورة",
    hours: "٠٨:٠٠ ص - ٠٣:٠٠ ص",
    phone: "+205022033353",
    isOpen: true,
    waitTime: "٧ دقائق",
    x: 35.0,
    y: 45.0,
  ),
  Branch(
    id: "b3",
    name: "فرع كلية الآداب",
    city: "المنصورة",
    address: "شارع الآداب، أمام المعرض السوري، المنصورة",
    hours: "٠٨:٠٠ ص - ٠٣:٠٠ ص",
    phone: "+20502265672",
    isOpen: true,
    waitTime: "١٠ دقائق",
    x: 45.0,
    y: 30.0,
  ),
  Branch(
    id: "b4",
    name: "فرع المشاية",
    city: "المنصورة",
    address: "شارع المشاية السفلي، أمام كلية الحقوق، المنصورة",
    hours: "٠٨:٠٠ ص - ٠٣:٠٠ ص",
    phone: "+201097800835",
    isOpen: true,
    waitTime: "٥ دقائق",
    x: 55.0,
    y: 55.0,
  ),
  Branch(
    id: "b5",
    name: "فرع الجيش (المحافظة)",
    city: "المنصورة",
    address: "شارع الجيش، أمام مبنى المحافظة، المنصورة",
    hours: "٠٩:٠٠ ص - ٠٢:٠٠ ص",
    phone: "+201095100995",
    isOpen: true,
    waitTime: "٨ دقائق",
    x: 65.0,
    y: 70.0,
  ),
  Branch(
    id: "b6",
    name: "فرع حي الجامعة (بوابة توشكى)",
    city: "المنصورة",
    address: "حي الجامعة، أمام بوابة توشكى ، المنصورة",
    hours: "٠٨:٠٠ ص - ٠٣:٠٠ ص",
    phone: "+201011887777",
    isOpen: true,
    waitTime: "١٢ دقيقة",
    x: 15.0,
    y: 20.0,
  ),
];

String toArabicNum(num number) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  String result = number.toString();
  for (int i = 0; i < english.length; i++) {
    result = result.replaceAll(english[i], arabic[i]);
  }
  return result;
}
