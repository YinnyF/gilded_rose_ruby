require 'gilded_rose'

describe 'gilded_rose' do
  # arguments:   Item.new(name, sell_in, quality)
  let(:item_0) { Item.new("+5 Dexterity Vest", 10, 20) }
  let(:item_1) { Item.new("+5 Dexterity Vest", 0, 20) }
  let(:item_2) { Item.new("Aged Brie", 2, 0) }
  let(:item_3) { Item.new("Sulfuras, Hand of Ragnaros", 0, 80) }
  let(:item_4) { Item.new("Sulfuras, Hand of Ragnaros", -1, 80) }
  let(:item_5) { Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20) }
  let(:item_6) { Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 20) }
  let(:item_7) { Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 20) }
  let(:item_8) { Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 20) }
  let(:item_9) { Item.new("Conjured Mana Cake", 3, 6) }
  
  let(:items) { [item_0, item_1, item_2, item_3, item_4, item_5, item_6, item_7, item_8, item_9] }

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

  xit "Conjured items degrade in Quality twice as fast as normal items" do
    expect { gilded_rose.update_quality() }.to change { items[9].quality }.by(-2)
  end
end
