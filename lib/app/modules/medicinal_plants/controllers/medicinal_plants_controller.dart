import 'package:get/get.dart';
import '../../../data/models/plant_model.dart';

class MedicinalPlantsController extends GetxController {
  final RxList<Plant> plants = <Plant>[].obs;
  final RxList<Plant> filteredPlants = <Plant>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPlants();
  }

  void loadPlants() {
    isLoading.value = true;
    
    // Medicinal plants from Pakhtunkhwa region
    plants.value = [
      Plant(
        id: '1',
        name: 'Caper Bush',
        botanicalName: 'Capparis spinosa',
        family: 'Capparaceae',
        habitat: 'Rocky slopes, dry hillsides, and disturbed areas in Pakhtunkhwa',
        description: 'A spiny shrub native to arid regions of Pakhtunkhwa. It produces flower buds called capers which are used as seasoning. The plant grows 1-2 meters tall with rounded leaves and showy white flowers.\n\nBotanical Characteristics: Caper Bush is a perennial shrub with a sprawling growth habit. The stems are woody at the base and herbaceous above, often scrambling over rocks. Leaves are simple, alternate, and orbicular to ovate, measuring 2-5 cm across. They are thick, fleshy, and smooth with a waxy coating that reduces water loss. The plant develops sharp spines at leaf axils which serve as protection against herbivores.\n\nFlowers and Fruit: The flowers are large and showy, measuring 4-6 cm across, with four white to pale pink petals and numerous long purple stamens. They open in the morning and wilt by afternoon. The fruit is an elongated capsule containing numerous seeds, but the unopened flower buds are the commercially valuable part. These buds are harvested and preserved in salt or vinegar to produce capers.\n\nGrowth and Ecology: Caper Bush thrives in rocky, well-drained soils typical of Pakhtunkhwa\'s mountainous terrain. It tolerates extreme heat and drought by entering a semi-dormant state. The deep root system can access water from considerable depths. The plant is often found growing in crevices of limestone and sandstone rocks where other vegetation cannot establish.\n\nTraditional Knowledge: Local communities in Pakhtunkhwa have used Caper Bush for generations. The root bark was traditionally used to treat skin conditions, while the flower buds were consumed for digestive ailments. The plant\'s ability to thrive in harsh conditions has made it a symbol of resilience in local folklore.',
        uses: 'Medicinal: Used for diabetes, kidney pain, and rheumatism. Culinary: Flower buds (capers) used as condiment. Leaves have antimicrobial properties.',
        image: 'assets/images/plants/caper.jpg',
        category: 'medicinal',
      ),
      Plant(
        id: '2',
        name: 'Harmal',
        botanicalName: 'Peganum harmala',
        family: 'Nitrariaceae',
        habitat: 'Dry waste places, saline soils, and rocky ground in Pakhtunkhwa',
        description: 'A perennial herb native to Pakhtunkhwa region. It grows 30-60 cm tall with spreading branches and produces characteristic five-petaled white flowers. The seeds contain medicinal alkaloids.\n\nBotanical Characteristics: Harmal is a bushy perennial herb with a woody rootstock and multiple branching stems. The plant typically grows 30-60 cm tall but can reach up to 1 meter under favorable conditions. The stems are smooth, glabrous, and somewhat succulent, with a pale green to grayish-green color. Leaves are alternate, sessile or short-stalked, and highly divided into narrow, linear segments, giving them a feathery appearance.\n\nFlowers and Fruit: Flowers are solitary, terminal, and white with five distinct petals that measure 10-15 mm across. They open in the morning and close by evening. The stamens are yellow and prominent. The fruit is a rounded capsule about 6-10 mm in diameter, containing numerous small, brown, reticulate seeds. These seeds are the primary source of medicinal alkaloids including harmine, harmaline, and harmalol.\n\nGrowth and Ecology: Harmal thrives in saline and alkaline soils common in parts of Pakhtunkhwa. It can tolerate high salt concentrations and poor soil conditions where other plants cannot survive. The plant is often found along roadsides, in wastelands, and around agricultural fields. It flowers throughout the warm season from April to October.\n\nTraditional Knowledge: In Pakhtunkhwa, Harmal has been an important medicinal plant for centuries. The seeds were traditionally used to treat eye infections, with practitioners dropping a weak infusion into affected eyes. The smoke from burning seeds was used to ward off evil spirits in traditional practices. The root was used as a treatment for rheumatism and neurological disorders.',
        uses: 'Medicinal: Used for asthma, Parkinson\'s disease, and as a sedative. Seeds have traditional uses for eye infections. Contains harmine and harmaline alkaloids.',
        image: 'assets/images/plants/harmal.jpg',
        category: 'medicinal',
      ),
      Plant(
        id: '3',
        name: 'Sage',
        botanicalName: 'Salvia officinalis',
        family: 'Lamiaceae',
        habitat: 'Dry slopes and rocky areas in Pakhtunkhwa highlands',
        description: 'An aromatic herb native to Pakhtunkhwa highlands. It has gray-green leaves and produces blue to purple flowers. The leaves are highly aromatic and used both medicinally and culinarily.\n\nBotanical Characteristics: Sage is a perennial, evergreen subshrub with woody stems and grayish leaves. The plant grows 20-70 cm tall with multiple square stems arising from the base. Leaves are opposite, simple, oblong to lanceolate, measuring 2-10 cm long and 1-3 cm broad. They are covered with fine hairs giving a silvery-gray appearance and have a wrinkled surface with prominent veins. The leaves emit a strong, characteristic aroma when crushed.\n\nFlowers and Fruit: Flowers are borne in whorls on upright spikes that rise above the foliage. Individual flowers are two-lipped, with the upper lip hooded and the lower lip spreading, colored in shades of blue to violet-purple, sometimes with white variations. Flowering occurs in late spring to early summer. The small nutlet fruits contain one to four seeds and are dark brown when mature.\n\nGrowth and Ecology: In Pakhtunkhwa, Sage grows in the cooler highland regions at elevations between 1,500 to 2,500 meters. It prefers well-drained, calcareous soils and full sun exposure. The plant is drought-tolerant once established and can survive cold winters. It often forms small clusters in rocky outcrops and along mountain trails.\n\nTraditional Knowledge: Local healers in Pakhtunkhwa highlands have long valued Sage for treating fever, digestive complaints, and respiratory conditions. The leaves were brewed into a strong tea for sore throats and mouth ulcers. Women traditionally used sage tea to regulate menstrual cycles and ease menopausal symptoms. The dried leaves were also used as a natural insect repellent in stored grains.',
        uses: 'Medicinal: Used for digestive problems, sore throats, and memory enhancement. Has antimicrobial and anti-inflammatory properties. Culinary: Used as flavoring in meats and stuffings.',
        image: 'assets/images/plants/sage.jpg',
        category: 'medicinal',
      ),
      Plant(
        id: '4',
        name: 'Mallow',
        botanicalName: 'Malva sylvestris',
        family: 'Malvaceae',
        habitat: 'Wastelands, roadsides, and fields throughout Pakhtunkhwa',
        description: 'A common herb found throughout Pakhtunkhwa region. It grows 60-100 cm tall with lobed leaves and pink-purple flowers. All parts of the plant are edible and have medicinal value.\n\nBotantical Characteristics: Mallow is an erect or spreading annual, biennial, or perennial herb with a deep taproot. Stems are hairy, branched, and can grow 60-100 cm tall. Leaves are alternate, rounded to heart-shaped with 5-7 shallow lobes, measuring 3-8 cm across. They are palmately veined with long petioles and have a soft, velvety texture due to dense stellate hairs. The plant exudes a mild mucilaginous substance when crushed.\n\nFlowers and Fruit: Flowers are borne singly or in small clusters in the leaf axils. Each flower has five pale pink to purple petals with darker veins, measuring 2-4 cm across. The center contains a prominent column of fused stamens surrounding the pistil. Flowering occurs from late spring through autumn. The fruit is a schizocarp that splits into 10-16 mericarps (seed segments), each containing one seed.\n\nGrowth and Ecology: Mallow is adaptable and grows throughout Pakhtunkhwa from plains to mid-hills. It colonizes disturbed soils, agricultural fields, roadsides, and waste areas. The plant prefers moist, fertile soils but can tolerate drought conditions. It is a common weed in wheat and barley fields and can grow in partial shade to full sun.\n\nTraditional Knowledge: In rural Pakhtunkhwa, Mallow has been a traditional food and medicine source for generations. Young leaves and shoots were cooked as a vegetable called "sonchal" in local dialect. The leaves were applied as poultices for skin irritations and insect bites. A soothing tea made from leaves and flowers was used for coughs, bronchitis, and digestive inflammation. The seeds were collected and ground into flour during times of scarcity.',
        uses: 'Medicinal: Used for coughs, sore throats, and skin irritation. Leaves and flowers have soothing demulcent properties. Edible: Young leaves used in salads and soups.',
        image: 'assets/images/plants/mallow.jpg',
        category: 'medicinal',
      ),
    ];
    
    filteredPlants.value = plants;
    isLoading.value = false;
  }

  void searchPlants(String query) {
    searchQuery.value = query.toLowerCase();
    if (query.isEmpty) {
      filteredPlants.value = plants;
    } else {
      filteredPlants.value = plants.where((plant) {
        return plant.name.toLowerCase().contains(searchQuery.value) ||
               plant.botanicalName.toLowerCase().contains(searchQuery.value) ||
               plant.uses.toLowerCase().contains(searchQuery.value) ||
               plant.habitat.toLowerCase().contains(searchQuery.value);
      }).toList();
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    filteredPlants.value = plants;
  }

  Plant? getPlantById(String id) {
    try {
      return plants.firstWhere((plant) => plant.id == id);
    } catch (e) {
      return null;
    }
  }
}
