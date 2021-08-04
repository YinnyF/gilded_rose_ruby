require 'gilded_rose'

describe 'gilded_rose' do
  let(:items) {[
    Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20),
    Item.new(name="Aged Brie", sell_in=2, quality=0),
    Item.new(name="Elixir of the Mongoose", sell_in=5, quality=7),
    Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=0, quality=80),
    Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=-1, quality=80),
    Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=15, quality=20),
    Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=49),
    Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=49),
    # This Conjured item does not work properly yet
    Item.new(name="Conjured Mana Cake", sell_in=3, quality=6), # <-- :O
  ]}

  let(:gilded_rose) { GildedRose.new(items) }
  
  it "amends the sell_in of the item" do
    expect { gilded_rose.update_quality() }.to change { items[0].sell_in }.by(-1)
  end

  it "amends the quality of the item" do
    expect { gilded_rose.update_quality() }.to change { items[0].quality }.by(-1)
  end

end
