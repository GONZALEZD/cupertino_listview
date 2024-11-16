class ConsoleAttribute {
  final String console;
  final String attribute;

  ConsoleAttribute({required this.console, required this.attribute});
}

class Section {
  final String name;
  final List<ConsoleAttribute> attributes;

  int get itemCount => attributes.length;

  ConsoleAttribute operator [](int i) => attributes[i];

  Section({required this.name, required this.attributes});

  static List<Section> allData() {
    final data = {};
    Console.all.forEach((console) {
      console.characteristics.forEach((key, value) {
        final values = data.containsKey(key) ? data[key] : <ConsoleAttribute>[];
        values.add(ConsoleAttribute(console: console.name, attribute: value));
        data[key] = values;
      });
    });
    List<Section> sections =  data
        .map((key, value) =>
            MapEntry(key, Section(name: key, attributes: value)))
        .values
        .toList();
    sections.insert(0, Section(name: "EMPTY SECTION", attributes: List.empty()));
    return sections;
  }
}

class Console {
  final String name;
  final String date;
  final String price;
  final String cpu;
  final String gpu;
  final String hdd;
  final String flashMem;
  final String discPlayer;

  const Console(
      {required this.name,
      required this.date,
      required this.price,
      required this.cpu,
      required this.gpu,
      required this.hdd,
      required this.flashMem,
      required this.discPlayer});

  Map<String, String> get characteristics => {
        'Release date': date,
        'Price': price,
        'CPU': cpu,
        'GPU': gpu,
        'Hard disc': hdd,
        'Flash memory': flashMem,
        'Disc player': discPlayer,
      };

  static final ps5 = Console(
    name: 'PS5',
    date: '12 nov. 2020',
    price: '499,00 \$US',
    cpu: '8-core AMD Zen 2',
    gpu: '10,28 TFLOPS / 2,23 GHz RDNA 2 AMD / 36 CU',
    hdd: '825 GB SSD',
    flashMem: '16 GB GDDR6 SDRAM',
    discPlayer: 'Blu-ray/DVD',
  );

  static final ps5DigitalEdition = Console(
    name: 'PS5 Digital Edition',
    date: '12 nov. 2020',
    price: '399,00 \$US',
    cpu: '8-core AMD Zen 2',
    gpu: '10,28 TFLOPS / 2,23 GHz RDNA 2 AMD / 36 CU',
    hdd: '825 GB SSD',
    flashMem: '16 GB GDDR6 SDRAM',
    discPlayer: ' - ',
  );

  static final xBoxSeriesX = Console(
    name: 'Xbox Series X',
    date: '10 nov. 2020',
    price: '499,99 €',
    cpu: '8-core AMD Zen 2 @ 3.8 GHz',
    gpu: '12 TFLOPS / 1.825 GHz RDNA 2 AMD / 52 CU',
    hdd: '1 TB SSD',
    flashMem: '16 GB GDDR6 SDRAM',
    discPlayer: 'Blu-ray/DVD',
  );

  static final xBoxSeriesS = Console(
    name: 'Xbox Series S',
    date: '10 nov. 2020',
    price: '299,99 €',
    cpu: '8-core AMD Zen 2 @ 3.8 GHz',
    gpu: '4 TFLOPS / 1.55 GHz RDNA 2 AMD / 20 CU',
    hdd: '512 GB SSD (NVME)',
    flashMem: '10 GB GDDR6 SDRAM',
    discPlayer: ' - ',
  );

  static final nintendoSwitch = Console(
    name: 'Switch',
    date: '3 mars 2017',
    price: '299,99 \$US',
    cpu: 'Octa-core (4×ARM Cortex-A57 & 4×ARM Cortex-A53) @ 1.020 GHz',
    gpu:
        'Nvidia GM20B Maxwell-based GPU @ 307.2 - 384 MHz while undocked, 307.2 - 768 MHz while docked',
    hdd: '32 GB Internal flash memory',
    flashMem: '8 GB',
    discPlayer: ' - ',
  );

  static List<Console> get all => [
        Console.ps5,
        Console.ps5DigitalEdition,
        Console.xBoxSeriesX,
        Console.xBoxSeriesS,
        Console.nintendoSwitch,
      ];
}
