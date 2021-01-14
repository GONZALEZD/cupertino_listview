
class Section {
  final String name;
  final String ps5;
  final String xboxX;
  final String xboxS;

  Section({this.name, this.ps5, this.xboxX, this.xboxS});

  int get itemCount => 3;

  operator [](int i) => [ps5, xboxX, xboxS][i];

  String consoleFromIndex(int index) {
    switch (index) {
      case 0:
        return "PS5";
      case 1:
        return "XBox X";
      case 2:
        return "XBox S";
      default:
        return "???";
    }
  }

  static List<Section> allData() {
    final data = [
      {
        "name": "Price",
        "data": ["\$499", "\$499", "\$299"]
      },
      {
        "name": "Release Date",
        "data": ["November 19th, 2020", "November 10th, 2020", "November 10th, 2020"]
      },
      {
        "name": "Optical Drive",
        "data": ["4K UHD Blu-Ray Drive", "4K UHD Blu-Ray Drive ", "None"]
      },
      {
        "name": "RAM",
        "data": ["16GB GDDR6 RAM", "16GB GDDR6 RAM", "10GB GDDR6 RAM"]
      },
      {
        "name": "Memory Bandwidth",
        "data": ["448GB/s", "10GB at 560GB/s, 6GB at 335GB/s", "8GB at 224GB/s, 2GB at 56GB/s"]
      },
      {
        "name": "CPU",
        "data": [
          "8x Zen 2 Cores at 3.5HGz ",
          "8x Zen 2 Cores at 3.8GHz",
          "8x Zen 2 Cores at 3.8GHz"
        ]
      },
      {
        "name": "GPU",
        "data": [
          "Custom AMD Radeon RDNA Navi 10.28 Teraflops, 36 CUs at 2.23GHz - (Supports Ray Tracing and 3D Audio via Tempest Engine)",
          " Custom AMD Radeon RDNA Navi 12 Teraflops, 52 CUs at 1.825GHz - (Supports DirectX Ray Tracing)",
          "Custom AMD Radeon RDNA 4 Teraflops, 20 CUs at 1.55GHz - (Supports DirectX Ray Tracing)"
        ]
      },
      {
        "name": "Video Output",
        "data": [
          "4K, 120hz refresh rate, 8K Support",
          "Native 4K, 8K Support, Up to 120hz",
          "1440p, 4K Support through playback or upscaling, 120fps"
        ]
      },
      {
        "name": "Data Transfer Speed (I/O Throughput)",
        "data": [
          "5.5GB/S (Raw), 8-9GB/S (Compressed)",
          "2.4gB/s (Raw), 4.8GB/s (Compressed)",
          "2.4gB/s (Raw), 4.8GB/s (Compressed)"
        ]
      },
      {
        "name": "Storage",
        "data": [
          "	Custom 825GB SSD Storage Drive",
          "1 TB NVMe SSD Storage Drive",
          "512GB NVME SSD Storage Drive"
        ]
      },
      {
        "name": "External Storage",
        "data": [
          "NVMe SSD Slot, USB HDD Support",
          "Seagate Proprietary External 1TB SSD Expansion Card",
          "Seagate Proprietary External 1TB SSD Expansion Card"
        ]
      },
      {
        "name": "Backwards Compatibility",
        "data": [
          "PlayStation 4 Games, PSVR",
          "Xbox 360, Xbox One, Accessories",
          "Xbox 360, Xbox One, Accessories"
        ]
      },
      {
        "name": "A/V Hookups",
        "data": [
          "8K Support",
          "Native 4K, 8K Support, 2 HDMI 2.1 Ports",
          "HDMI 2.1 Port, Upscaled 4K Support"
        ]
      },
    ];
    return data.map((d) {
      final list = d["data"] as List<String>;
      return Section(name: d["name"], ps5: list[0], xboxX: list[1], xboxS: list[2]);
    }).toList();
  }
}
