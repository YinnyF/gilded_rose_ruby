require 'gilded_rose'

describe 'gilded_rose' do
  let(:items) { [
    Item.new(name = "+5 Dexterity Vest", sell_in = 10, quality = 20),
    Item.new(name = "+5 Dexterity Vest", sell_in = 0, quality = 20),
    Item.new(name = "Aged Brie", sell_in = 2, quality = 0),
    Item.new(name = "Sulfuras, Hand of Ragnaros", sell_in = 0, quality = 80),
    Item.new(name = "Sulfuras, Hand of Ragnaros", sell_in = -1, quality = 80),
    Item.new(name = "Backstage passes to a TAFKAL80ETC concert", sell_in = 15, quality = 20),
    Item.new(name = "Backstage passes to a TAFKAL80ETC concert", sell_in = 10, quality = 20),
    Item.new(name = "Backstage passes to a TAFKAL80ETC concert", sell_in = 5, quality = 20),
    Item.new(name = "Backstage passes to a TAFKAL80ETC concert", sell_in = 0, quality = 20),
    # # This Conjured item does not work properly yet
    # Item.new(name = "Conjured Mana Cake", sell_in = 3, quality = 6), # <-- :O
    ]
  }

  let(:gilded_rose) { GildedRose.new(items) }
  
  it "amends the sell_in of the item" do
    expect { gilded_rose.update_quality() }.to change { items[0].sell_in }.by(-1)
  end

  it "amends the quality of the item" do
    expect { gilded_rose.update_quality() }.to change { items[0].quality }.by(-1)
  end

  it "once the sell by date has passed, quality degrades twice as fast" do
    expect { gilded_rose.update_quality() }.to change { items[1].quality }.by(-2)
  end

  it "the Quality of an item can be 0" do
    10.times { gilded_rose.update_quality() }
    expect(items[1].quality).to eq 0
  end

  it "the Quality of an item can never be negative" do
    11.times { gilded_rose.update_quality() }
    expect(items[1].quality).to eq 0
  end

  it "Aged Brie actually increases in Quality the older it gets" do
    expect { gilded_rose.update_quality() }.to change { items[2].quality }.by(1)
  end

  it "the Quality of an item is never more than 50" do
    51.times { gilded_rose.update_quality() }
    expect(items[2].quality).to eq 50
  end

  it "Sulfuras never has to be sold" do
    expect { gilded_rose.update_quality() }.to change { items[3].sell_in }.by(0)
    expect { gilded_rose.update_quality() }.to change { items[4].sell_in }.by(0)
  end

  it "Sulfuras never decreases in Quality" do
    expect { gilded_rose.update_quality() }.to change { items[3].quality }.by(0)
    expect { gilded_rose.update_quality() }.to change { items[4].quality }.by(0)
  end

  it "Backstage passes increases in Quality when sell_in date is greater than 10" do
    expect { gilded_rose.update_quality() }.to change { items[5].quality }.by(1)
  end

  it "Backstage passes increases by 2 Quality when sell_in date is <= 10 but > 5" do
    expect { gilded_rose.update_quality() }.to change { items[6].quality }.by(2)
  end

  it "Backstage passes increases by 3 Quality when sell_in date is <= 5 but > 0" do
    expect { gilded_rose.update_quality() }.to change { items[7].quality }.by(3)
  end 

  it "Backstage passes has 0 Quality when sell_in date is < 0" do
    expect { gilded_rose.update_quality() }.to change { items[8].quality }.by(-20)
  end 
end
