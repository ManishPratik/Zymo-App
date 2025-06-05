class ZoomCarModel {
  List<Sections>? sections;
  List? bottomFilters;
  List<FiltersV6>? filtersV6;
  String? ctaText;
  int? starts;
  int? ends;
  List<String>? flags;
  List<String>? experiments;
  Chat? chat;

  ZoomCarModel(
      {this.sections,
      this.bottomFilters,
      this.filtersV6,
      this.ctaText,
      this.starts,
      this.ends,
      this.flags,
      this.experiments,
      this.chat});

  ZoomCarModel.fromJson(Map<String, dynamic> json) {
    if (json['sections'] != null) {
      sections = <Sections>[];
      json['sections'].forEach((v) {
        sections!.add(Sections.fromJson(v));
      });
    }
    if (json['bottom_filters'] != null) {
      // bottomFilters = <Temp>[];
      json['bottom_filters'].forEach((v) {
        // bottomFilters.add(Temp.fromJson(v));
      });
    }
    if (json['filters_v6'] != null) {
      filtersV6 = <FiltersV6>[];
      json['filters_v6'].forEach((v) {
        filtersV6!.add(FiltersV6.fromJson(v));
      });
    }
    ctaText = json['cta_text'];
    starts = json['starts'];
    ends = json['ends'];
    flags = json['flags'] != null ? json['flags'].cast<String>() : null;
    // experiments = json['experiments'].cast<String>();
    // chat = json['chat'] != null ? Chat.fromJson(json['chat']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.sections != null) {
      data['sections'] = this.sections!.map((v) => v.toJson()).toList();
    }
    if (this.bottomFilters != null) {
      data['bottom_filters'] =
          this.bottomFilters!.map((v) => v.toJson()).toList();
    }
    if (this.filtersV6 != null) {
      data['filters_v6'] = this.filtersV6!.map((v) => v.toJson()).toList();
    }
    data['cta_text'] = this.ctaText;
    data['starts'] = this.starts;
    data['ends'] = this.ends;
    data['flags'] = this.flags;
    data['experiments'] = this.experiments;
    if (this.chat != null) {
      data['chat'] = this.chat!.toJson();
    }
    return data;
  }
}

class Sections {
  List<Cards>? cards;

  Sections({this.cards});

  Sections.fromJson(Map<String, dynamic> json) {
    if (json['cards'] != null) {
      cards = <Cards>[];
      json['cards'].forEach((v) {
        cards!.add(Cards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.cards != null) {
      data['cards'] = this.cards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cards {
  String? type;
  CarData? carData;
  NotifyMeData? notifyMeData;

  Cards({this.type, this.carData, this.notifyMeData});

  Cards.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    carData =
        json['car_data'] != null ? CarData.fromJson(json['car_data']) : null;
    notifyMeData = json['notify_me_data'] != null
        ? NotifyMeData.fromJson(json['notify_me_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = this.type;
    if (this.carData != null) {
      data['car_data'] = this.carData!.toJson();
    }
    if (this.notifyMeData != null) {
      data['notify_me_data'] = this.notifyMeData!.toJson();
    }
    return data;
  }
}

class CarData {
  int? cargroupId;
  int? carId;
  String? name;
  String? brand;
  String? url;
  String? urlLarge;
  Location? location;
  Pricing? pricing;
  List<String>? accessories;
  Rating? rating;
  List? messages;
  List<String>? imageUrls;
  bool? isOriginalCarImages;

  CarData(
      {this.cargroupId,
      this.carId,
      this.name,
      this.brand,
      this.url,
      this.urlLarge,
      this.location,
      this.pricing,
      this.accessories,
      this.rating,
      this.messages,
      this.imageUrls,
      this.isOriginalCarImages});

  CarData.fromJson(Map<String, dynamic> json) {
    cargroupId = json['cargroup_id'];
    carId = json['car_id'];
    name = json['name'];
    brand = json['brand'];
    url = json['url'];
    urlLarge = json['url_large'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    pricing =
        json['pricing'] != null ? Pricing.fromJson(json['pricing']) : null;
    accessories = json['accessories'].cast<String>();
    rating = json['rating'] != null ? Rating.fromJson(json['rating']) : null;
    if (json['messages'] != null) {
      // messages = <Temp>[];
      json['messages'].forEach((v) {
        // messages.add(Temp.fromJson(v));
      });
    }
    imageUrls = json['image_urls'].cast<String>();
    isOriginalCarImages = json['is_original_car_images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['cargroup_id'] = this.cargroupId;
    data['car_id'] = this.carId;
    data['name'] = this.name;
    data['brand'] = this.brand;
    data['url'] = this.url;
    data['url_large'] = this.urlLarge;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.pricing != null) {
      data['pricing'] = this.pricing!.toJson();
    }
    data['accessories'] = this.accessories;
    if (this.rating != null) {
      data['rating'] = this.rating!.toJson();
    }
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    data['image_urls'] = this.imageUrls;
    data['is_original_car_images'] = this.isOriginalCarImages;
    return data;
  }
}

class Location {
  int? id;
  double? lat;
  double? lng;
  double? distance;
  List? hdIds;
  List? terminalIds;
  dynamic hdUnavailableReason;
  String? zoomAirUnvailableReason;
  String? text;

  Location(
      {this.id,
      this.lat,
      this.lng,
      this.distance,
      this.hdIds,
      this.terminalIds,
      this.hdUnavailableReason,
      this.zoomAirUnvailableReason,
      this.text});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lat = json['lat'];
    lng = json['lng'];
    distance = json['distance'];
    if (json['hd_ids'] != null) {
      // hdIds = <Temp>[];
      json['hd_ids'].forEach((v) {
        // hdIds.add(Temp.fromJson(v));
      });
    }
    if (json['terminal_ids'] != null) {
      // terminalIds = <Temp>[];
      json['terminal_ids'].forEach((v) {
        // terminalIds.add(Temp.fromJson(v));
      });
    }
    hdUnavailableReason = json['hd_unavailable_reason'];
    zoomAirUnvailableReason = json['zoom_air_unvailable_reason'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['distance'] = this.distance;
    if (this.hdIds != null) {
      data['hd_ids'] = this.hdIds!.map((v) => v.toJson()).toList();
    }
    if (this.terminalIds != null) {
      data['terminal_ids'] = this.terminalIds!.map((v) => v.toJson()).toList();
    }
    data['hd_unavailable_reason'] = this.hdUnavailableReason;
    data['zoom_air_unvailable_reason'] = this.zoomAirUnvailableReason;
    data['text'] = this.text;
    return data;
  }
}

class Pricing {
  String? id;
  String? flexiName;
  String? payableAmount;
  int? revenue;

  Pricing({this.id, this.flexiName, this.payableAmount, this.revenue});

  Pricing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    flexiName = json['flexi_name'];
    payableAmount = json['payable_amount'];
    revenue = json['revenue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['flexi_name'] = this.flexiName;
    data['payable_amount'] = this.payableAmount;
    data['revenue'] = this.revenue;
    return data;
  }
}

class Rating {
  String? text;
  String? iconUrl;

  Rating({this.text, this.iconUrl});

  Rating.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    iconUrl = json['icon_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['text'] = this.text;
    data['icon_url'] = this.iconUrl;
    return data;
  }
}

class NotifyMeData {
  String? header;
  String? subHeader;
  String? image;
  String? ctaText;
  String? notifyMeHeader;
  List<String>? carTypes;
  String? placeholderText;
  String? notifyMeCtaText;

  NotifyMeData(
      {this.header,
      this.subHeader,
      this.image,
      this.ctaText,
      this.notifyMeHeader,
      this.carTypes,
      this.placeholderText,
      this.notifyMeCtaText});

  NotifyMeData.fromJson(Map<String, dynamic> json) {
    header = json['header'];
    subHeader = json['sub_header'];
    image = json['image'];
    ctaText = json['cta_text'];
    notifyMeHeader = json['notify_me_header'];
    carTypes = json['car_types'].cast<String>();
    placeholderText = json['placeholder_text'];
    notifyMeCtaText = json['notify_me_cta_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['header'] = this.header;
    data['sub_header'] = this.subHeader;
    data['image'] = this.image;
    data['cta_text'] = this.ctaText;
    data['notify_me_header'] = this.notifyMeHeader;
    data['car_types'] = this.carTypes;
    data['placeholder_text'] = this.placeholderText;
    data['notify_me_cta_text'] = this.notifyMeCtaText;
    return data;
  }
}

class FiltersV6 {
  String? header;
  String? id;
  String? type;
  bool? showSeparator;
  List<FilterItems>? filterItems;
  bool? hideForSpecificSearch;
  String? subHeader;

  FiltersV6(
      {this.header,
      this.id,
      this.type,
      this.showSeparator,
      this.filterItems,
      this.hideForSpecificSearch,
      this.subHeader});

  FiltersV6.fromJson(Map<String, dynamic> json) {
    header = json['header'];
    id = json['id'];
    type = json['type'];
    showSeparator = json['show_separator'];
    if (json['filter_items'] != null) {
      filterItems = <FilterItems>[];
      json['filter_items'].forEach((v) {
        filterItems!.add(FilterItems.fromJson(v));
      });
    }
    hideForSpecificSearch = json['hide_for_specific_search'];
    subHeader = json['sub_header'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['header'] = this.header;
    data['id'] = this.id;
    data['type'] = this.type;
    data['show_separator'] = this.showSeparator;
    if (this.filterItems != null) {
      data['filter_items'] = this.filterItems!.map((v) => v.toJson()).toList();
    }
    data['hide_for_specific_search'] = this.hideForSpecificSearch;
    data['sub_header'] = this.subHeader;
    return data;
  }
}

class FilterItems {
  String? id;
  String? icon;
  String? title;
  bool? isSelected;
  bool? isEnabled;
  String? subTitle;
  Metadata? metadata;

  FilterItems(
      {this.id,
      this.icon,
      this.title,
      this.isSelected,
      this.isEnabled,
      this.subTitle,
      this.metadata});

  FilterItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icon = json['icon'];
    title = json['title'];
    isSelected = json['is_selected'];
    isEnabled = json['is_enabled'];
    subTitle = json['sub_title'];
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['icon'] = this.icon;
    data['title'] = this.title;
    data['is_selected'] = this.isSelected;
    data['is_enabled'] = this.isEnabled;
    data['sub_title'] = this.subTitle;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

class Metadata {
  SearchData? searchData;
  Slider? slider;

  Metadata({this.searchData, this.slider});

  Metadata.fromJson(Map<String, dynamic> json) {
    searchData = json['search_data'] != null
        ? SearchData.fromJson(json['search_data'])
        : null;
    slider = json['slider'] != null ? Slider.fromJson(json['slider']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (searchData != null) {
      data['search_data'] = searchData!.toJson();
    }
    if (slider != null) {
      data['slider'] = slider!.toJson();
    }
    return data;
  }
}

class SearchData {
  String? hint;
  List<Items>? items;
  Disclaimer? disclaimer;

  SearchData({this.hint, this.items, this.disclaimer});

  SearchData.fromJson(Map<String, dynamic> json) {
    hint = json['hint'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    disclaimer = json['disclaimer'] != null
        ? Disclaimer.fromJson(json['disclaimer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['hint'] = this.hint;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.disclaimer != null) {
      data['disclaimer'] = this.disclaimer!.toJson();
    }
    return data;
  }
}

class Items {
  String? id;
  String? name;
  bool? isSelected;

  Items({this.id, this.name, this.isSelected});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isSelected = json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_selected'] = this.isSelected;
    return data;
  }
}

class Disclaimer {
  String? text;
  String? disclaimerStatus;

  Disclaimer({this.text, this.disclaimerStatus});

  Disclaimer.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    disclaimerStatus = json['disclaimer_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['text'] = this.text;
    data['disclaimer_status'] = this.disclaimerStatus;
    return data;
  }
}

class Slider {
  int? min;
  int? max;
  int? precision;
  String? unit;
  int? value;

  Slider({this.min, this.max, this.precision, this.unit, this.value});

  Slider.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    max = json['max'];
    precision = json['precision'];
    unit = json['unit'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['min'] = this.min;
    data['max'] = this.max;
    data['precision'] = this.precision;
    data['unit'] = this.unit;
    data['value'] = this.value;
    return data;
  }
}

class Chat {
  String? image;
  Action? action;

  Chat({this.image, this.action});

  Chat.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    action = json['action'] != null ? Action.fromJson(json['action']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['image'] = this.image;
    if (this.action != null) {
      data['action'] = this.action!.toJson();
    }
    return data;
  }
}

class Action {
  dynamic cta;
  String? type;
  Metadat? metadata;

  Action({this.cta, this.type, this.metadata});

  Action.fromJson(Map<String, dynamic> json) {
    cta = json['cta'];
    type = json['type'];
    metadata =
        json['metadata'] != null ? Metadat.fromJson(json['metadata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['cta'] = this.cta;
    data['type'] = this.type;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

class Metadat {
  String? title;
  String? url;

  Metadat({this.title, this.url});

  Metadat.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this.title;
    data['url'] = this.url;
    return data;
  }
}
