import 'package:get/get.dart';
import '../../../data/models/plant_model.dart';
import '../../../data/services/firebase_service.dart';
import '../../../routes/app_routes.dart';

class PlantListController extends GetxController {
  final String category = Get.arguments['category'] ?? '';
  final String title = Get.arguments['title'] ?? 'Plants';
  
  final RxList<Plant> plants = <Plant>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadPlants();
  }

  Future<void> loadPlants() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final loadedPlants = await FirebaseService.getPlantsByCategory(category);
      
      if (loadedPlants.isEmpty) {
        // Load sample data if Firebase is empty
        plants.value = getSamplePlants(category);
      } else {
        plants.value = loadedPlants;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load plants: $e';
      // Load sample data on error
      plants.value = getSamplePlants(category);
    } finally {
      isLoading.value = false;
    }
  }

  List<Plant> getSamplePlants(String category) {
    final Map<String, List<Plant>> sampleData = {
      'weeds': [
        Plant(
          id: '1',
          name: 'Parthenium hysterophorus',
          botanicalName: 'Parthenium hysterophorus',
          family: 'Asteraceae',
          habitat: 'Wastelands, roadsides, agricultural fields',
          description: 'Scientific Name: Parthenium hysterophorus L.\n\nCommon Names: Parthenium weed, carrot grass, starweed, white top, congress grass, bitterweed, feverfew\n\nOrigin and Distribution: Native to the American tropics, particularly Mexico and the Caribbean region. Accidentally introduced to other regions through contaminated wheat and grain shipments during the 1950s. Now invasive in over 40 countries across Asia, Africa, Australia, and the Pacific. In Pakistan, it is widespread in Pakhtunkhwa, Punjab, and Sindh.\n\nBotanical Characteristics: Annual herb, 0.5-2 meters tall with branched, hairy stems covered in trichomes. Leaves are pale green, deeply divided into feathery lobes (2-3 pinnatifid), covered with soft hairs, 5-20 cm long. Small creamy-white flowers in terminal clusters produce thousands of tiny, black, wedge-shaped seeds with white scales. The plant has a strong, unpleasant odor when crushed. Root system is taproot with fibrous secondary roots.\n\nGrowth and Reproduction: One plant can produce 15,000-25,000 seeds per season. Seeds remain viable in soil for 5-7 years. Germination occurs throughout the year with peaks after rains. Flowering begins 4-6 weeks after germination and continues until frost.\n\nEnvironmental Impact: One of the seven most devastating invasive weeds globally. It causes severe allergic reactions including dermatitis, asthma, rhinitis, and hay fever in humans - affecting millions. Toxic to livestock, causing tainted meat, reduced milk production, and various health disorders. Reduces crop yields by 40-90% in heavily infested areas. Displaces native vegetation through allelopathy, releasing chemicals that inhibit other plants.\n\nControl Methods: Manual removal before flowering is essential; uprooted plants must be bagged and destroyed as they can set seed even after removal. Competitive replacement with species like Cassia, marigold, and sunflower suppresses growth. Biological control using Zygogramma bicolorata beetle and Epiblema strenuana moth has shown success. Herbicides like glyphosate, atrazine, and 2,4-D provide chemical control but require repeated applications.',
          uses: 'None significant; highly toxic and allergenic - primarily a harmful invasive weed',
          image: 'assets/images/plants/parthenium.jpg',
          category: 'weeds',
        ),
        Plant(
          id: '2',
          name: 'Chenopodium album',
          botanicalName: 'Chenopodium album',
          family: 'Amaranthaceae',
          habitat: 'Agricultural fields, gardens, roadsides, disturbed areas',
          description: 'Scientific Name: Chenopodium album L.\n\nCommon Names: Lamb\'s quarters, bathua, white goosefoot, pigweed, fat hen, wild spinach, goosefoot, melde\n\nOrigin and Distribution: Native to Europe but now cosmopolitan in distribution. Found throughout temperate and tropical regions worldwide. In Pakistan, it is common in all provinces including Pakhtunkhwa, thriving in agricultural fields, home gardens, roadsides, and waste areas.\n\nBotanical Characteristics: Fast-growing annual herb, 0.3-2 meters tall with erect, branched stems. Stems are grooved, green to purplish, often with red or purple stripes. Leaves are alternate, simple, rhombic-ovate to triangular, 2-8 cm long, irregularly toothed or lobed, mealy-white coating on both surfaces. Flowers are small, greenish, clustered in dense panicles at stem tips. Seeds are small, round, black, glossy, enclosed in a thin papery covering.\n\nGrowth and Reproduction: Germinates readily in spring and after summer rains. Completes life cycle in 40-60 days under favorable conditions. Each plant produces 50,000-75,000 seeds that remain viable for many years in soil. Wind, water, animals, and agricultural equipment disperse seeds.\n\nEcological Significance: Pioneer species that colonizes disturbed soils and prevents erosion. Serves as food source for various insects, birds, and wildlife. Host plant for several insect pests including leaf miners and aphids that can transfer to crops.\n\nCultural and Economic Uses: Highly valued as leafy vegetable in South Asian cuisine - rich in protein, vitamins A and C, calcium, phosphorus, and iron. Seeds processed into flour for bread-making. Used in traditional medicine for digestive disorders, inflammation, and as a laxative. Young tender shoots are harvested before flowering for best flavor.\n\nManagement: Hand weeding before seed set prevents spread. Cultivation and crop rotation reduce populations. Competes strongly with crops for nutrients, requiring management in agricultural settings.',
          uses: 'Leaves used as leafy vegetable in traditional cooking, seeds ground into flour, traditional medicine',
          image: 'assets/images/plants/chenopodium.jpg',
          category: 'weeds',
        ),
        Plant(
          id: '3',
          name: 'Amaranthus viridis',
          botanicalName: 'Amaranthus viridis',
          family: 'Amaranthaceae',
          habitat: 'Disturbed areas, agricultural fields, gardens, roadsides',
          description: 'Scientific Name: Amaranthus viridis L.\n\nCommon Names: Green amaranth, slender amaranth, green pigweed, wild amaranth, chaulai, rajgira\n\nOrigin and Distribution: Native to tropical Americas but now distributed throughout tropical, subtropical, and warm temperate regions globally. Common in South Asia, Africa, Southeast Asia, and Pacific islands. In Pakistan, widespread in Pakhtunkhwa and all provinces, particularly in summer months.\n\nBotanical Characteristics: Annual herb, 0.5-1.5 meters tall with erect, branched, smooth or slightly hairy green stems. Leaves are simple, alternate, long-petioled, ovate to rhombic-lanceolate, 3-15 cm long, pointed tips, entire margins, bright green color. Flowers are small, greenish, inconspicuous, clustered in dense axillary and terminal spikes. Seeds are tiny, black, shiny, lens-shaped, 1-1.5 mm diameter, produced in large quantities.\n\nGrowth and Reproduction: Fast-growing warm-season annual. Germinates at temperatures above 15°C. Flowering begins 3-5 weeks after germination. Each plant produces 100,000-500,000 seeds with long viability in soil. Seeds disperse by wind, water, animals, and human activities.\n\nEcological Role: Colonizer of disturbed soils and agricultural fields. Provides food and habitat for various insects and birds. Some species serve as hosts for crop pests. Can accumulate nitrates from soil, making it useful as indicator of soil nitrogen status.\n\nNutritional and Culinary Uses: Highly nutritious leafy vegetable rich in protein, vitamins A, C, K, folate, calcium, iron, magnesium, and potassium. Tender leaves and stems cooked as spinach, in curries, soups, and stir-fries. Seeds used as grain (pseudo-cereal), ground into flour, popped like popcorn, or cooked as porridge. Important food source during famines and droughts due to resilience.\n\nTraditional Medicine: Used for treating digestive disorders, inflammation, respiratory issues, and as a diuretic. Leaf extracts show antioxidant and antimicrobial properties in research studies.',
          uses: 'Leaves consumed as vegetable, seeds used as grain, traditional medicine',
          image: 'assets/images/plants/amaranthus.jpg',
          category: 'weeds',
        ),
        Plant(
          id: '4',
          name: 'Cynodon dactylon',
          botanicalName: 'Cynodon dactylon',
          family: 'Poaceae',
          habitat: 'Lawns, roadsides, fields, gardens, disturbed ground',
          description: 'Scientific Name: Cynodon dactylon (L.) Pers.\n\nCommon Names: Bermuda grass, doob grass, durva grass, devil\'s grass, couch grass, wiregrass, Indian doab, scutch grass\n\nOrigin and Distribution: Believed to be native to Africa, the Middle East, and Mediterranean region, but now cosmopolitan in tropical and warm temperate zones worldwide. Widespread throughout Pakistan including Pakhtunkhwa, occurring from sea level to 2000 meters elevation. One of the most widely distributed grass species globally.\n\nBotanical Characteristics: Perennial grass forming dense mats or tufts with extensive creeping stolons and deep rhizomes. Stems (culms) are slender, wiry, 10-40 cm tall, sometimes rooting at nodes. Leaves are linear, 2-15 cm long, 2-4 mm wide, grayish-green to dark green, rough margins, flat or folded. Flowers in digitate spikes (2-7 spikes), purple-green to gray, wind-pollinated. Seeds are small, oval, straw-colored to reddish-brown.\n\nGrowth and Reproduction: Extremely hardy and aggressive growth habit. Spreads rapidly through stolons above ground and rhizomes below ground. Deep root system extends over 2 meters, making it drought-tolerant. Individual plants can spread several meters per year. Seeds produced but vegetative reproduction is primary spread mechanism.\n\nEcological Significance: Important pioneer species for soil stabilization and erosion control on disturbed sites. Provides ground cover that prevents desertification. Serves as forage for grazing animals, though nutritional value declines with maturity. Host for various insect species and food source for birds.\n\nAgricultural and Horticultural Uses: Most widely used warm-season turfgrass for lawns, parks, sports fields, and golf courses due to durability and low maintenance. Important pasture grass for cattle, sheep, and horses in tropical regions. Used for soil conservation on embankments and slopes.\n\nTraditional Medicine (Ayurveda): Known as durva, considered sacred in Hindu tradition. Used for wound healing, skin disorders, digestive problems, diabetes management, urinary disorders, and as a general tonic. Root system used to treat nosebleeds and excessive bleeding. Research shows anti-inflammatory, antioxidant, and antimicrobial properties.',
          uses: 'Used in traditional medicine (Ayurveda), lawn grass, pasture for livestock, erosion control',
          image: 'assets/images/plants/cynodon.jpg',
          category: 'weeds',
        ),
      ],
      'indigenous': [
        Plant(
          id: '1',
          name: 'Pinus roxburghii',
          botanicalName: 'Pinus roxburghii',
          family: 'Pinaceae',
          habitat: 'Himalayan foothills, Pakhtunkhwa hills',
          description: 'Scientific Name: Pinus roxburghii Sarg.\n\nCommon Names: Chir pine, Chilgoza pine, Indian longleaf pine, Himalayan longleaf pine\n\nOrigin and Distribution: Native to the Himalayas, specifically the western and central Himalayan regions. Found naturally in Afghanistan, Pakistan, India (Himachal Pradesh, Uttarakhand, Kashmir), Nepal, and Bhutan. In Pakistan, it is the dominant conifer species in Pakhtunkhwa province and northern Punjab, growing from 500 to 2,500 meters elevation.\n\nBotanical Characteristics: Large evergreen coniferous tree, 30-50 meters tall, with some specimens reaching 60 meters. Trunk diameter 1-2 meters, with deeply furrowed, reddish-brown bark. Needles are long, slender, three per fascicle, 20-35 cm long, bright green to yellow-green. Cones are large, cylindrical-ovoid, 10-20 cm long, light brown when mature. Seeds are winged, dispersed by wind.\n\nGrowth and Ecology: Fast-growing pine species adapted to subtropical and warm temperate climates. Tolerates poor, shallow soils and drought conditions once established. Forms pure forests or mixed with other conifers and broadleaf species. Important for soil conservation on steep slopes, preventing landslides and erosion. Provides habitat for numerous bird species, small mammals, and insects.\n\nEconomic Importance: Most important timber tree in the western Himalayas. Wood used for construction, furniture, carpentry, pulp and paper production, matchsticks, and packing cases. Resin tapped extensively for turpentine and rosin production - major source of naval stores in the region. Chilgoza pine nuts (seeds) are edible and commercially valuable, though this species produces fewer edible nuts than other pine species.\n\nTraditional Uses: Resin used traditionally for treating skin ailments, wounds, and respiratory issues. Needles used as bedding material and mulch. Wood used for fuel and charcoal production in rural areas.\n\nConservation Status: Widespread and common in its range, but faces threats from over-exploitation for timber and resin, forest fires, and conversion of forest land for agriculture and development. Sustainable management practices increasingly implemented in Pakistan and India.',
          uses: 'Timber, resin for turpentine and rosin, pulpwood, edible pine nuts, traditional medicine',
          image: 'assets/images/plants/pinus.jpg',
          category: 'indigenous',
        ),
        Plant(
          id: '2',
          name: 'Olea cuspidata',
          botanicalName: 'Olea cuspidata',
          family: 'Oleaceae',
          habitat: 'Subtropical dry forests, scrublands, hillsides',
          description: 'Scientific Name: Olea cuspidata Wall. ex G.Don\n\nCommon Names: Indian wild olive, kau olive, Himalayan olive, native olive, kusum\n\nOrigin and Distribution: Native to the Himalayan region, the Indian subcontinent, and parts of Africa. Found naturally in Pakistan (Pakhtunkhwa, Punjab, Balochistan), India, Nepal, Afghanistan, Yemen, Ethiopia, Eritrea, and Somalia. In Pakistan, particularly common in the dry subtropical forests of Pakhtunkhwa and northern Punjab.\n\nBotanical Characteristics: Small to medium evergreen tree or large shrub, 3-10 meters tall. Bark is rough, gray to brown, with deep fissures. Leaves are opposite, simple, lanceolate to elliptic, 3-7 cm long, leathery texture, glossy dark green above, pale beneath with small scales. Flowers are small, white to cream, fragrant, in axillary clusters. Fruits are small olives (drupes), 1-2 cm long, ovoid, green turning purplish-black when ripe, containing a single seed.\n\nGrowth and Ecology: Highly drought-tolerant species adapted to arid and semi-arid conditions. Grows in poor, rocky, well-drained soils. Tolerates high temperatures and seasonal water scarcity. Found in dry deciduous forests, scrublands, and on rocky hillsides. Important component of subtropical broadleaf forests. Provides food and habitat for birds and wildlife.\n\nEconomic and Cultural Uses: Fruits are edible but bitter due to high oleuropein content; oil can be extracted after processing. Wood is hard, durable, and used for furniture, tool handles, agricultural implements, and firewood. Leaves and bark used in traditional medicine for treating fever, diabetes, and skin diseases. Planted for shade, soil conservation, and as a living fence.\n\nTraditional Medicine: Bark and leaves used in traditional systems to treat various ailments including diabetes, hypertension, fever, and intestinal worms. Leaf extracts show antimicrobial and antioxidant properties in research studies. Oil from fruits has traditional uses for skin and hair care.\n\nEcological Significance: Important for rehabilitation of degraded lands and soil conservation on slopes. Serves as host plant for various insects and provides nesting sites for birds. Contributed to maintaining biodiversity in dry subtropical ecosystems.',
          uses: 'Fruit oil extraction, traditional medicine, timber, fuelwood, soil conservation, shade',
          image: 'assets/images/plants/olea.jpg',
          category: 'indigenous',
        ),
        Plant(
          id: '3',
          name: 'Ziziphus jujuba',
          botanicalName: 'Ziziphus jujuba',
          family: 'Rhamnaceae',
          habitat: 'Dry forests, scrublands, hillsides, agricultural boundaries',
          description: 'Scientific Name: Ziziphus jujuba Mill.\n\nCommon Names: Indian jujube, ber, Chinese date, red date, dunks, Indian plum, jujube plum, koon ber\n\nOrigin and Distribution: Native to China and South Asia, with cultivation dating back over 4,000 years. Naturalized throughout tropical and subtropical Asia, including India, Pakistan, Bangladesh, Nepal, and Southeast Asia. In Pakistan, widely distributed across all provinces, especially common in Pakhtunkhwa, Punjab, and Sindh, growing wild and cultivated in rural areas.\n\nBotanical Characteristics: Small to medium deciduous tree or large shrub, 5-12 meters tall, with spreading crown and gnarled, spiny branches. Bark is rough, dark gray to black. Leaves are alternate, simple, ovate to elliptic, 3-7 cm long, glossy green above, whitish beneath with three prominent veins. Small yellow-green flowers appear in leaf axils. Fruits are oval drupes, 2-5 cm long, smooth skin turning from green to yellow, then reddish-brown when ripe, containing a single stone with two seeds.\n\nGrowth and Ecology: Extremely hardy species tolerating drought, heat, salinity, and poor soils. Deep root system accesses groundwater, allowing survival in arid conditions. Found in dry forests, scrublands, ravines, and as a boundary tree in agricultural fields. Important for soil stabilization on eroded lands. Provides food and shelter for birds, small mammals, and beneficial insects.\n\nNutritional and Culinary Uses: Fruits (ber) are highly nutritious, rich in vitamin C, B vitamins, calcium, phosphorus, and iron. Eaten fresh when crisp and apple-like, or dried like dates. Used in traditional desserts, chutneys, pickles, and beverages. Dried fruits stored for year-round consumption. Seeds processed to make flour or roasted as snacks in some regions.\n\nTraditional Medicine (Unani and Ayurveda): One of the most important medicinal plants in traditional Asian medicine. Fruits used to treat digestive disorders, boost immunity, calm nerves, and improve sleep. Bark used for digestive ailments and as a tonic. Leaves applied to wounds and skin conditions. Root used in traditional preparations for fever and diarrhea. Modern research confirms antioxidant, anti-inflammatory, and potential anti-cancer properties.\n\nEconomic Importance: Commercial cultivation in India and Pakistan for fresh and dried fruit markets. Wood is hard, durable, and used for agricultural tools, furniture, and fuel. Leaves provide animal fodder, especially during dry seasons. Honey production from nectar-rich flowers.\n\nCultural Significance: Mentioned in ancient texts including the Quran and traditional Chinese medicine classics. Symbol of prosperity and fertility in various cultures. Fruits offered in religious ceremonies and consumed during festivals.',
          uses: 'Fruit edible fresh or dried, traditional medicine, timber, fodder, honey production, soil conservation',
          image: 'assets/images/plants/ziziphus.jpg',
          category: 'indigenous',
        ),
      ],
      'invasive': [
        Plant(
          id: '1',
          name: 'Lantana camara',
          botanicalName: 'Lantana camara',
          family: 'Verbenaceae',
          habitat: 'Forests, wastelands, roadsides, agricultural fields',
          description: 'Scientific Name: Lantana camara L.\n\nOrigin: Native to tropical regions of the Americas, particularly Central and South America. Originally introduced as an ornamental plant due to its colorful flowers.\n\nSpread: Lantana has spread to over 60 countries worldwide, including Asia, Africa, Australia, and the Pacific Islands. In Pakistan, it was introduced during the colonial era and has since naturalized in Pakhtunkhwa and other provinces.\n\nEnvironmental Impact: Lantana is one of the world\'s worst invasive weeds. It forms dense thickets that smother native vegetation, reduce biodiversity, and alter fire regimes. The plant is toxic to livestock, causing liver damage and photosensitization when ingested.\n\nCharacteristics: Multi-stemmed shrub reaching 2-4 meters in height. Stems are square in cross-section and covered with rough hairs. Leaves are ovate, toothed, and rough-textured, emitting a strong aromatic scent when crushed. Flowers appear in clusters with colors ranging from yellow, orange, pink, red, and purple - often changing colors as they age. Fruits are small, round, green berries turning black when ripe.\n\nControl Methods: Mechanical removal by hand-pulling or cutting, though regrowth from stumps is common. Chemical control using herbicides like glyphosate or triclopyr is effective during active growth. Biological control using natural enemies like the lantana beetle and leaf-mining moths has shown success in some regions. Preventing spread through monitoring and early detection is crucial.',
          uses: 'Some traditional medicinal uses; mainly problematic invasive',
          image: 'assets/images/plants/lantana.jpg',
          category: 'invasive',
        ),
        Plant(
          id: '2',
          name: 'Prosopis juliflora',
          botanicalName: 'Prosopis juliflora',
          family: 'Fabaceae',
          habitat: 'Dry areas, wastelands, riverbanks, agricultural fields',
          description: 'Scientific Name: Prosopis juliflora (Sw.) DC.\n\nOrigin: Native to Central and South America, Mexico, and the Caribbean. Introduced for fuelwood, fodder, and shade in arid regions.\n\nSpread: Widely distributed across Africa, Asia, Australia, and the Middle East. In Pakistan, it was introduced in the late 19th century for dune stabilization and has spread extensively in Sindh, Balochistan, and parts of Pakhtunkhwa.\n\nEnvironmental Impact: Mesquite forms dense impenetrable thickets that displace native vegetation and reduce grazing land. It has deep root systems that access groundwater, lowering water tables. Thorns injure livestock and humans. The species alters soil chemistry and nutrient cycling.\n\nCharacteristics: Small to medium-sized tree or shrub, 3-12 meters tall. Bark is rough, gray-brown with deep fissures. Leaves are bipinnately compound with small leaflets. Thorns are paired, yellowish, and up to 5 cm long. Flowers are pale yellow, fragrant, in cylindrical spikes. Pods are curved, yellowish-brown, sweet-tasting, and contain 10-20 seeds.\n\nControl Methods: Physical removal is labor-intensive due to thorns and resprouting ability. Cutting followed by stump treatment with herbicides is partially effective. Biological control using seed-feeding bruchid beetles helps reduce spread. Integrated management combining mechanical, chemical, and biological methods is most effective. Utilization for charcoal, timber, and fodder provides some economic benefit while controlling spread.',
          uses: 'Fuelwood, charcoal, animal fodder, shade, honey production',
          image: 'assets/images/plants/mesquite.jpg',
          category: 'invasive',
        ),
        Plant(
          id: '3',
          name: 'Water Hyacinth',
          botanicalName: 'Eichhornia crassipes',
          family: 'Pontederiaceae',
          habitat: 'Ponds, lakes, rivers, wetlands, irrigation canals',
          description: 'Scientific Name: Eichhornia crassipes (Mart.) Solms\n\nOrigin: Native to the Amazon River basin in South America. Introduced as an ornamental aquatic plant due to its attractive purple flowers.\n\nSpread: Now present in over 50 countries on five continents. It doubles its population in just 7-14 days under favorable conditions. In Pakistan, it infests the Indus River system, lakes, and irrigation canals throughout Pakhtunkhwa and other provinces.\n\nEnvironmental Impact: Water hyacinth forms dense mats that block sunlight, deplete oxygen, and kill aquatic life. It clogs irrigation systems, disrupts hydroelectric power generation, and provides breeding grounds for mosquitoes that spread malaria and dengue. The mats impede boat navigation and water flow.\n\nCharacteristics: Free-floating aquatic perennial with thick, glossy, rounded leaves on long petioles. Leaves have swollen, spongy petioles that provide buoyancy. Showy lavender-blue flowers with a yellow blotch on the upper petal appear on erect spikes. Roots are feathery, dark purple-black, and hang submerged in water. Reproduces vegetatively and by seeds.\n\nControl Methods: Mechanical removal using machines or manual labor is temporary as fragments regenerate. Chemical control using 2,4-D or glyphosate is effective but risks water contamination. Biological control using weevils Neochetina bruchi and Neochetina eichhorniae has shown success. Utilization for compost, biogas, handicrafts, and animal feed provides economic incentives for removal.',
          uses: 'Compost, biogas production, handicrafts, wastewater treatment',
          image: 'assets/images/plants/water_hyacinth.jpg',
          category: 'invasive',
        ),
        Plant(
          id: '4',
          name: 'Siam Weed',
          botanicalName: 'Chromolaena odorata',
          family: 'Asteraceae',
          habitat: 'Forest edges, roadsides, agricultural areas, disturbed lands',
          description: 'Scientific Name: Chromolaena odorata (L.) R.M. King & H. Rob.\n\nOrigin: Native to the Americas from Florida to northern Argentina. Introduced accidentally and intentionally to tropical regions worldwide.\n\nSpread: Now widespread across tropical Asia, Africa, and the Pacific. In Pakistan, it occurs in the Himalayan foothills and lower elevations of Pakhtunkhwa. It spreads rapidly through wind-dispersed seeds and can colonize disturbed areas within months.\n\nEnvironmental Impact: Siam weed forms dense stands 2-3 meters tall that exclude native vegetation and prevent forest regeneration. It is allelopathic, releasing chemicals that inhibit the growth of other plants. It reduces agricultural productivity, harbors crop pests, and increases fire risk due to its dry biomass.\n\nCharacteristics: Perennial shrub with branched, softly hairy stems. Leaves are triangular to ovate, oppositely arranged, with toothed margins and a distinct odor when crushed. Small lavender-blue or pale violet flowers appear in clusters at stem tips. Seeds are black, 4-5 mm long, with white pappus hairs for wind dispersal. Each plant can produce up to one million seeds annually.\n\nControl Methods: Manual removal is effective for small infestations but must be done before seed set. Slashing stimulates regrowth unless combined with herbicide application. Fire can be used in fire-adapted ecosystems but risks promoting further spread. Biological control using the moth Pareuchaetes pseudoinsulata and gall fly Cecidochares connexa has achieved partial success in some regions.',
          uses: 'Traditional medicine, green manure, compost',
          image: 'assets/images/plants/siam_weed.jpg',
          category: 'invasive',
        ),
        Plant(
          id: '5',
          name: 'Mile-a-Minute Weed',
          botanicalName: 'Mikania micrantha',
          family: 'Asteraceae',
          habitat: 'Forests, plantations, agricultural fields, along water courses',
          description: 'Scientific Name: Mikania micrantha Kunth\n\nOrigin: Native to Central and South America. Accidentally introduced to tropical regions through contaminated agricultural materials and as an ornamental.\n\nSpread: Now invasive across tropical Asia, Pacific islands, and parts of Africa. In Pakistan, it affects forest plantations and agricultural areas in Pakhtunkhwa and northern regions. It grows up to 90 mm per day under ideal conditions, hence its common name.\n\nEnvironmental Impact: This climbing vine smothers crops and native vegetation by forming dense mats that block sunlight. It reduces yields in rubber, oil palm, tea, and forestry plantations by 30-50%. It alters forest structure, reduces biodiversity, and increases the risk of wildfires by creating ladder fuels.\n\nCharacteristics: Fast-growing perennial vine with slender, hairy stems that climb using paired tendrils. Leaves are opposite, heart-shaped to triangular, 4-13 cm long, with pointed tips and toothed margins. Small white or pale lilac flowers in compact heads produce wind-dispersed seeds. Stems break easily and root at nodes, enabling vegetative spread.\n\nControl Methods: Manual removal is labor-intensive and must be thorough as fragments regenerate. Herbicides like glyphosate or 2,4-D are effective but require repeated applications. Classical biological control using the rust fungus Puccinia spegazzinii has shown excellent results in several countries, causing severe defoliation. The fungus specifically targets Mikania without affecting other plants.',
          uses: 'Green manure, compost, traditional medicine in limited quantities',
          image: 'assets/images/plants/mikania.jpg',
          category: 'invasive',
        ),
        Plant(
          id: '6',
          name: 'Billy Goat Weed',
          botanicalName: 'Ageratum conyzoides',
          family: 'Asteraceae',
          habitat: 'Agricultural fields, roadsides, gardens, disturbed areas',
          description: 'Scientific Name: Ageratum conyzoides L.\n\nOrigin: Native to tropical America, particularly Brazil and surrounding regions. Introduced as an ornamental plant and spread through agricultural activities and trade.\n\nSpread: Now naturalized throughout tropical and subtropical regions worldwide. Common in South Asia, Southeast Asia, Africa, and the Pacific. In Pakistan, it infests agricultural lands, roadsides, and gardens across Pakhtunkhwa and other provinces, particularly at lower elevations.\n\nEnvironmental Impact: Billy goat weed competes aggressively with crops for nutrients, water, and light, reducing yields by up to 40% in some studies. It is allelopathic, inhibiting germination and growth of neighboring plants. The species harbors pests and diseases that affect crops. It reduces pasture quality for livestock grazing.\n\nCharacteristics: Annual or short-lived perennial herb, 0.5-1 meter tall. Stems are erect, branched, and covered with fine hairs. Leaves are opposite, ovate, 2-6 cm long, with toothed margins and a strong characteristic odor. Flowers are small, pale blue to lavender or white, clustered in rounded heads. Each plant produces thousands of wind-dispersed seeds that remain viable in soil for several years.\n\nControl Methods: Hand weeding is effective for small infestations before flowering. Cultivation and crop rotation help reduce populations. Pre-emergent and post-emergent herbicides are used in agricultural settings. Mulching suppresses germination in gardens. The plant has developed herbicide resistance in some regions, requiring integrated management approaches.',
          uses: 'Traditional medicine, insect repellent properties',
          image: 'assets/images/plants/ageratum.jpg',
          category: 'invasive',
        ),
        Plant(
          id: '7',
          name: 'Singapore Daisy',
          botanicalName: 'Sphagneticola trilobata',
          family: 'Asteraceae',
          habitat: 'Gardens, roadsides, forest edges, wetlands, coastal areas',
          description: 'Scientific Name: Sphagneticola trilobata (L.) Pruski\n\nOrigin: Native to the Americas, from Mexico to Argentina and the Caribbean. Introduced widely as a ground cover and ornamental plant for its yellow flowers and dense growth habit.\n\nSpread: Escaped cultivation and now invasive in tropical regions worldwide, including Southeast Asia, Pacific islands, and parts of Africa. In Pakistan, it has naturalized in gardens, parks, and disturbed areas in Pakhtunkhwa and other provinces, spreading vegetatively and by seeds.\n\nEnvironmental Impact: Singapore daisy forms dense mats that smother native vegetation and prevent natural regeneration of native species. It invades forest edges, wetlands, and coastal areas, altering ecosystem structure and function. The dense growth excludes native ground cover plants and reduces habitat quality for wildlife. It is difficult to eradicate once established.\n\nCharacteristics: Creeping perennial herb with stems rooting at nodes. Leaves are opposite, fleshy, 2-5 cm long, with three lobes or toothed margins, glossy dark green. Bright yellow daisy-like flowers, 2-3 cm across, appear year-round in tropical climates. Reproduces vegetatively through stem fragments and by seeds. Tolerates a wide range of soil types and moisture conditions.\n\nControl Methods: Manual removal must collect all fragments as even small pieces regenerate. Repeated mowing or slashing reduces vigor but rarely eliminates the plant. Herbicides containing glyphosate or metsulfuron-methyl are effective with repeat applications. In sensitive natural areas, careful spot treatment is necessary to avoid harming native vegetation. Prevention of spread through garden waste disposal education is essential.',
          uses: 'Ornamental ground cover, erosion control (with caution)',
          image: 'assets/images/plants/singapore_daisy.jpg',
          category: 'invasive',
        ),
        Plant(
          id: '8',
          name: 'Parthenium Weed',
          botanicalName: 'Parthenium hysterophorus',
          family: 'Asteraceae',
          habitat: 'Roadsides, wastelands, agricultural fields, urban areas',
          description: 'Scientific Name: Parthenium hysterophorus L.\n\nOrigin: Native to the American tropics, particularly Mexico and the Caribbean region. Accidentally introduced to other regions through contaminated wheat and other grain shipments during the 20th century.\n\nSpread: Now invasive in over 40 countries across Asia, Africa, Australia, and the Pacific. In Pakistan, it is widespread in Pakhtunkhwa, Punjab, and Sindh, particularly in urban areas, roadsides, and agricultural lands. It thrives in disturbed soils and can establish from a single seed.\n\nEnvironmental Impact: Parthenium is one of the most destructive invasive weeds globally. It causes severe allergic reactions including dermatitis, asthma, and hay fever in humans. It is toxic to livestock, causing reduced milk production and meat quality. The plant reduces crop yields by up to 90% in heavily infested areas and displaces native vegetation through allelopathy.\n\nCharacteristics: Annual herb, 0.5-2 meters tall with branched, hairy stems. Leaves are pale green, deeply divided into lobes, covered with soft hairs. Small creamy-white flowers in clusters at stem tips produce thousands of tiny, black, wedge-shaped seeds with white scales. The plant has a strong, unpleasant odor. One plant can produce 15,000-25,000 seeds that remain viable for several years.\n\nControl Methods: Manual removal before flowering is essential but plants must be bagged and destroyed as they can set seed even after uprooting. Competitive planting with species like Cassia and marigold suppresses parthenium growth. Biological control using the beetle Zygogramma bicolorata and moth Epiblema strenuana has shown success in several countries. Chemical control using herbicides is effective but expensive for large areas. Public awareness campaigns help prevent spread.',
          uses: 'None significant; highly toxic and allergenic',
          image: 'assets/images/plants/parthenium.jpg',
          category: 'invasive',
        ),
      ],
      'annual': [
        Plant(
          id: '1',
          name: 'Helianthus annuus',
          botanicalName: 'Helianthus annuus',
          family: 'Asteraceae',
          habitat: 'Agricultural fields, home gardens, commercial farms',
          description: 'Scientific Name: Helianthus annuus L.\n\nCommon Names: Sunflower, common sunflower, mirroring plant, garden sunflower, girasol\n\nOrigin and Distribution: Native to North America, specifically the central and southern regions of the United States and northern Mexico. Domesticated by Native American peoples over 3,000 years ago. Now cultivated worldwide in temperate, subtropical, and tropical regions. Major commercial producers include Ukraine, Russia, Argentina, China, and the United States. In Pakistan, grown in Punjab, Sindh, and Pakhtunkhwa provinces.\n\nBotanical Characteristics: Annual herbaceous plant with erect, rough-hairy stem, 1-3 meters tall, occasionally reaching 5 meters. Leaves are alternate, simple, ovate to cordate, 10-40 cm long, rough-textured with toothed margins. The iconic flower head (capitulum) is 10-30 cm in diameter, with bright yellow ray florets surrounding a central disk of hundreds of tiny brown to black disk florets. The flower head tracks the sun during the day (heliotropism) when young. Fruits are achenes (seeds), 5-15 mm long, gray to black with white stripes.\n\nGrowth and Cultivation: Fast-growing annual completing life cycle in 80-120 days. Requires full sun and well-drained soil. Drought-tolerant once established but benefits from irrigation during flowering and seed development. Major crop for oil production, confectionery seeds, and ornamental purposes. Pollinated primarily by bees and other insects.\n\nEconomic Importance: One of the world\'s most important oilseed crops. Seeds contain 35-55% oil used for cooking oil, margarine, salad dressings, and industrial applications. Confectionery sunflower seeds are popular snack foods worldwide. De-oiled meal is high-protein livestock feed. Cut flowers are major floriculture product globally.\n\nNutritional Value: Seeds are excellent source of vitamin E, B vitamins (especially B1, B6), folate, magnesium, selenium, phosphorus, and healthy fats including linoleic acid. Contain phytosterols that may help lower cholesterol. Popular health food eaten raw, roasted, or as butter.\n\nEcological Benefits: Attracts pollinators and beneficial insects to gardens and farms. Extensive root system improves soil structure and can phytoremediate contaminated soils. Used in agroforestry and intercropping systems. Provides food for birds when left standing after harvest.\n\nCultural Significance: National flower of Ukraine and state flower of Kansas. Symbol of happiness, adoration, and loyalty in many cultures. Important in Native American agriculture and spirituality. Subject of famous Van Gogh paintings that revolutionized modern art.',
          uses: 'Cooking oil production, edible seeds, bird seed, ornamental flowers, livestock feed',
          image: 'assets/images/plants/sunflower.jpg',
          category: 'annual',
        ),
        Plant(
          id: '2',
          name: 'Brassica rapa',
          botanicalName: 'Brassica rapa',
          family: 'Brassicaceae',
          habitat: 'Agricultural fields, kitchen gardens, temperate and subtropical regions',
          description: 'Scientific Name: Brassica rapa L.\n\nCommon Names: Turnip, field mustard, bird rape, keblock, white turnip, summer turnip, navet\n\nOrigin and Distribution: Native to Europe and western Asia, with domestication beginning over 4,000 years ago. Wild populations found throughout Europe, Central Asia, and the Mediterranean. Now cultivated worldwide in temperate and subtropical regions. Major producers include China, India, Russia, Japan, and European countries. In Pakistan and India, grown as both root vegetable and leafy green.\n\nBotanical Characteristics: Biennial or annual herb, highly variable in form depending on cultivar. Root vegetable types form globular, cylindrical, or flattened taproots (hypocotyls), white, yellow, or purple in color, 5-15 cm diameter. Leafy types produce abundant foliage without swollen roots. Stems are erect, branched, glabrous or slightly hairy. Leaves are alternate, simple, lyrate-pinnatifid, lobed, with clasping base, varying from 10-50 cm long. Flowers are bright yellow, four-petaled, cross-shaped (cruciform), in terminal racemes.\n\nVarieties and Uses: Cultivated as three main subspecies - turnip (var. rapa) for roots, Chinese cabbage/bok choy (var. chinensis) for leaves, and oilseed/field mustard (var. oleifera) for oil production. Each has numerous cultivars adapted to specific climates and culinary uses.\n\nCulinary Applications: Roots eaten raw in salads (crisp, sweet, slightly peppery), pickled, boiled, mashed, roasted, or added to stews and soups. Leaves (turnip greens) are nutritious leafy vegetable cooked like spinach, in stir-fries, or added to dal. Popular in Kashmiri, Punjabi, and southern US cuisines. Young tender leaves are best for eating.\n\nNutritional Value: Turnip roots are low in calories (high water content), good source of vitamin C, fiber, and potassium. Turnip greens are exceptional source of vitamins A, C, and K, folate, calcium, and fiber among leafy vegetables. Contains glucosinolates with potential cancer-preventive properties.\n\nAgricultural Significance: Important cover crop and forage for livestock, especially in winter months. Used in crop rotation to break pest and disease cycles. Fast-growing, can be harvested within 40-60 days. Tolerates frost and cool weather, making it valuable for extending growing seasons.\n\nTraditional Medicine: Roots used traditionally for digestive complaints, respiratory issues, and as a diuretic. Leaf poultices applied to bruises and skin inflammations. Modern research supports some antimicrobial and antioxidant properties.',
          uses: 'Root vegetable, leafy greens, vegetable oil production, animal fodder, cover crop',
          image: 'assets/images/plants/brassica.jpg',
          category: 'annual',
        ),
        Plant(
          id: '3',
          name: 'Triticum aestivum',
          botanicalName: 'Triticum aestivum',
          family: 'Poaceae',
          habitat: 'Agricultural fields, plains, temperate and subtropical regions',
          description: 'Scientific Name: Triticum aestivum L.\n\nCommon Names: Common wheat, bread wheat, soft wheat, English wheat, bearded wheat\n\nOrigin and Distribution: Domesticated approximately 10,000 years ago in the Fertile Crescent (modern-day Iraq, Syria, Turkey). Evolved from wild grasses through natural hybridization events. Now cultivated on more land area than any other commercial food crop. Major producers include China, India, Russia, United States, France, Germany, and Australia. In Pakistan, grown extensively in Punjab and Sindh provinces as the major cereal crop.\n\nBotanical Characteristics: Annual grass, 0.6-1.5 meters tall, with hollow, jointed culms (stems). Leaves are linear, alternate, parallel-veined, 10-40 cm long, with auricles clasping the stem. The inflorescence is a terminal spike (ear) bearing 20-50 spikelets, each containing 2-5 flowers. Each flower produces a caryopsis (grain kernel) tightly enclosed in bracts (glumes and lemmas). Awns (bristles) may be present or absent depending on variety. Extensive fibrous root system reaches 1-2 meters deep.\n\nGrowth and Development: Cool-season annual requiring vernalization (cold period) for flowering in winter wheat types. Spring wheat planted in spring and harvested in late summer. Winter wheat planted in autumn, overwinters as seedlings, resumes growth in spring. Total growing period ranges from 90-150 days depending on variety and climate.\n\nEconomic and Food Security Importance: World\'s third most-produced cereal after maize and rice. Provides approximately 20% of global dietary calories and protein. Staple food for over 35% of world population. Grains milled into flour for bread, pasta, noodles, biscuits, cakes, and countless processed foods. Semolina used for couscous and pasta.\n\nNutritional Profile: Excellent source of carbohydrates (starch), protein (10-15% content), B vitamins (especially B1, B3, folate), iron, magnesium, phosphorus, and dietary fiber (in whole wheat). Contains gluten proteins that give bread its characteristic elasticity. Whole wheat provides more nutrients than refined white flour.\n\nCultivation Requirements: Prefers fertile, well-drained loam or clay-loam soils. Requires moderate rainfall or irrigation (500-800 mm annually). Optimal temperatures 15-25°C during growing season. Nitrogen fertilizer essential for high yields. Susceptible to various diseases including rusts, blights, and smuts requiring management.\n\nHistorical and Cultural Significance: Foundation of ancient civilizations in Mesopotamia, Egypt, and Indus Valley. Mentioned in religious texts including Bible, Quran, and ancient Hindu scriptures. Symbol of prosperity, fertility, and life in many cultures. Central to agricultural revolutions that shaped human history.',
          uses: 'Flour for bread and pasta, semolina for couscous, animal feed, straw for bedding and thatch',
          image: 'assets/images/plants/wheat.jpg',
          category: 'annual',
        ),
      ],
      'flora_kpk': [
        Plant(
          id: '1',
          name: 'Himalayan Yew',
          botanicalName: 'Taxus baccata',
          family: 'Taxaceae',
          habitat: 'Himalayan highlands, montane forests, 2000-3500m elevation',
          description: 'Scientific Name: Taxus baccata L. subsp. wallichiana (Zucc.) Pilger\n\nCommon Names: Himalayan yew, Indian yew, barmi, thuner, talispatra\n\nOrigin and Distribution: Native to the Himalayan region including Pakistan (Pakhtunkhwa, Gilgit-Baltistan), India (Himachal Pradesh, Uttarakhand, Kashmir), Nepal, Bhutan, and parts of China and Afghanistan. Found in moist temperate and subalpine forests at elevations from 2,000 to 3,500 meters. In Pakistan, primarily distributed in the upper reaches of Pakhtunkhwa and northern areas.\n\nBotanical Characteristics: Evergreen coniferous tree or large shrub, 5-15 meters tall, occasionally reaching 20 meters. Bark is thin, reddish-brown, scaly, peeling in strips. Leaves are flat, linear, spirally arranged, 2-4 cm long, dark green above with two pale stomatal bands beneath, leathery texture. The plant is dioecious (separate male and female trees). Seeds are partially enclosed in fleshy red arils (berry-like structures), distinguishing feature of yews.\n\nGrowth and Ecology: Slow-growing, shade-tolerant species found in cool, moist environments. Grows under forest canopy or as scattered trees in mixed coniferous and broadleaf forests. Prefers well-drained, acidic to neutral soils. Long-lived species with some specimens estimated over 1,000 years old. Plays important role in high-altitude forest ecosystems as food source for birds that disperse seeds.\n\nMedicinal Importance (Extremely Significant): Source of taxol (paclitaxel), one of the most important anticancer drugs discovered. Bark and needles contain taxane diterpenoids used in chemotherapy for breast, ovarian, and lung cancers. Traditional medicine uses include treatment of asthma, bronchitis, indigestion, and epilepsy. However, most parts of the plant are highly toxic if consumed improperly - all parts except the red aril contain toxic taxine alkaloids.\n\nConservation Status: Listed as Near Threatened by IUCN. Faces severe threats from over-harvesting for medicinal purposes, especially for cancer drug production. Habitat loss due to deforestation and climate change affecting high-altitude forests. Illegal trade and unsustainable collection have severely depleted populations in accessible areas. Protected under various national and international regulations.\n\nTraditional and Cultural Uses: Wood is hard, dense, and valued for carving, furniture, and construction. Used traditionally for making bows and tools. Sacred tree in some Himalayan communities. Red arils (seed coverings) are edible and sweet, though seeds are toxic. Leaves used in traditional incense.\n\nResearch Significance: Continues to be extensively studied for new taxane compounds with anticancer properties. Subject of cultivation research to meet pharmaceutical demand without wild harvesting. Important for understanding high-altitude forest ecology and climate change impacts on mountain ecosystems.',
          uses: 'Medicinal (cancer treatment - taxol/paclitaxel source), traditional medicine, timber, carving, edible arils',
          image: 'assets/images/plants/taxus.jpg',
          category: 'flora_kpk',
        ),
        Plant(
          id: '2',
          name: 'Common Juniper',
          botanicalName: 'Juniperus communis',
          family: 'Cupressaceae',
          habitat: 'Subalpine zone, high altitude meadows, rocky slopes, 2500-4000m',
          description: 'Scientific Name: Juniperus communis L. var. saxatilis Pall.\n\nCommon Names: Common juniper, dwarf juniper, alpine juniper, paver, shur\n\nOrigin and Distribution: Circumboreal distribution across Northern Hemisphere. In the Himalayas, found from Afghanistan through Pakistan, India, Nepal, Bhutan, to China. In Pakistan, occurs in high-altitude regions of Pakhtunkhwa, Gilgit-Baltistan, and northern Punjab at elevations from 2,500 to 4,000 meters. One of the most widely distributed conifers globally.\n\nBotanical Characteristics: Evergreen shrub or small tree, 1-4 meters tall in Himalayan forms (often prostrate at highest elevations). Bark is reddish-brown, fibrous, peeling in thin strips. Leaves are needle-like, sharp-pointed, arranged in whorls of three, 1-2 cm long, green with single white stomatal band above. The plant is dioecious with separate male and female individuals. Cones (berry-like) are globose, 6-10 mm diameter, green turning bluish-black with waxy bloom when mature, taking 2-3 years to ripen.\n\nGrowth and Ecology: Extremely hardy species tolerating harsh conditions including cold, drought, and poor soils. Forms extensive stands in subalpine zones, often marking the tree line. Important pioneer species stabilizing rocky slopes and preventing erosion at high altitudes. Tolerates extreme temperature variations and high UV radiation. Associated with alpine meadows, rhododendron scrub, and coniferous forests.\n\nEconomic and Commercial Uses: Berries (cones) used as spice, particularly for flavoring gin and other spirits. Essential oil extracted from berries and wood used in perfumery, aromatherapy, and pharmaceuticals. Berries used in traditional medicine for digestive and urinary disorders. Wood is aromatic, hard, and used for small crafts, utensils, and fuel.\n\nTraditional Medicine: Berries used in traditional medicine systems worldwide. Diuretic properties used for urinary tract infections and kidney problems. Digestive stimulant used for bloating and indigestion. Antiseptic and antifungal properties used for wound treatment and skin conditions. Steam from boiling berries used for respiratory ailments in traditional Himalayan medicine.\n\nEcological Significance: Important food source for birds and small mammals that disperse seeds. Provides shelter for wildlife in harsh alpine environments. Contributes to soil formation and stabilization at high altitudes. Mycorrhizal associations important for nutrient cycling in nutrient-poor mountain soils.\n\nConservation: Generally stable populations due to wide distribution, though local pressures from over-harvesting of berries and habitat degradation exist. Climate change potentially affecting upper tree line populations. Sustainable harvesting practices needed for medicinal and commercial use.',
          uses: 'Flavoring (gin, spices), essential oils, traditional medicine, timber for crafts, fuel',
          image: 'assets/images/plants/juniperus.jpg',
          category: 'flora_kpk',
        ),
        Plant(
          id: '3',
          name: 'Holm Oak',
          botanicalName: 'Quercus ilex',
          family: 'Fagaceae',
          habitat: 'Mediterranean-type zones, dry subtropical forests, 800-2000m elevation',
          description: 'Scientific Name: Quercus ilex L. subsp. ilex\n\nCommon Names: Holm oak, holly oak, evergreen oak, ilex oak, kermes oak\n\nOrigin and Distribution: Native to the Mediterranean region and parts of the Himalayas. In Pakistan, found in the western Himalayan foothills of Pakhtunkhwa province, particularly in areas with Mediterranean-type climate. Represents an important component of the unique western Himalayan subtropical vegetation found in this region.\n\nBotanical Characteristics: Evergreen broadleaf tree, 15-25 meters tall with dense rounded crown. Bark is dark gray to black, rough, deeply furrowed with age. Leaves are highly variable - typically oval to elliptic, 3-7 cm long, leathery texture, dark glossy green above, pale gray-green beneath, margins entire or spiny-toothed on young plants. Acorns are oval, 2-4 cm long, partially enclosed in scaly cups, ripening in autumn. The evergreen foliage distinguishes it from deciduous oaks.\n\nGrowth and Ecology: Adapted to Mediterranean climate with hot dry summers and mild wet winters. Tolerates drought and poor, rocky soils once established. Grows in mixed forests with other broadleaf species like olive and ash. Important for maintaining vegetation cover in dry subtropical zones. Provides shade and shelter in otherwise sparse landscapes. Supports diverse wildlife including birds, squirrels, and insects dependent on acorns.\n\nEconomic and Practical Uses: Wood is extremely hard, durable, and valued for construction, furniture, and tool handles. High-quality firewood with excellent burning characteristics. Acorns historically used as animal fodder, especially for pigs, and after processing for human consumption. Bark tannins used in traditional tanning processes. Dense growth makes it valuable for windbreaks and erosion control.\n\nHistorical and Cultural Significance: Important tree in Mediterranean cultures for millennia. Symbol of strength and longevity. Used in ancient Greek and Roman culture for religious ceremonies and crown making. Represents the unique biodiversity of Pakistan\'s western Himalayan region where Mediterranean flora reaches its easternmost distribution.\n\nEcological Role in Pakhtunkhwa: Part of the distinctive subtropical vegetation of Pakistan\'s western Himalayas. Provides critical habitat for birds and small mammals. Acorns are important food source for wildlife. Contributes to carbon sequestration in dry subtropical forests. Important for maintaining soil cover and preventing erosion on hillsides.\n\nConservation Status: Habitat loss and over-exploitation for timber pose threats in some areas. Climate change may alter the suitable range for this Mediterranean-adapted species in the Himalayas. Protected in some forest reserves but needs broader conservation attention in Pakistan.',
          uses: 'Timber, cork production potential, fuelwood, acorn fodder, tannin from bark, shade',
          image: 'assets/images/plants/quercus.jpg',
          category: 'flora_kpk',
        ),
      ],
    };

    return sampleData[category] ?? [];
  }

  List<Plant> get filteredPlants {
    if (searchQuery.value.isEmpty) {
      return plants;
    }
    return plants.where((plant) {
      return plant.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
             plant.botanicalName.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void navigateToPlantDetail(Plant plant) {
    Get.toNamed(
      AppRoutes.plantDetail,
      arguments: {'plant': plant},
    );
  }

  Future<void> refreshPlants() async {
    await loadPlants();
  }
}
