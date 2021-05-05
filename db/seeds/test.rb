item = Item.create(name: "XXXXXX XXXX", abbreviation: "XXXX11.SA")

Price.create(item: item, date: Date.today, value: 0, high: 0, low: 0)
CurrentPrice.refresh
