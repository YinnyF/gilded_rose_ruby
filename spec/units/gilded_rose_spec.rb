require 'gilded_rose'

describe GildedRose do
  let(:item_0) { double(Item, name: "+5 Dexterity Vest", sell_in: 10, quality: 20) }
  let(:item_1) { double(Item, name: "+5 Dexterity Vest", sell_in: 0, quality: 20) }
  let(:item_2) { double(Item, name: "Aged Brie", sell_in: 2, quality: 0) }
  let(:item_3) { double(Item, name: "Sulfuras, Hand of Ragnaros", sell_in: 0, quality: 80) }
  let(:item_4) { double(Item, name: "Sulfuras, Hand of Ragnaros", sell_in: -1, quality: 80) }
  let(:item_5) { double(Item, name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 15, quality: 20) }
  let(:item_6) { double(Item, name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 10, quality: 20) }
  let(:item_7) { double(Item, name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 5, quality: 20) }
  let(:item_8) { double(Item, name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 0, quality: 20) }
  let(:item_9) { double(Item, name: "Conjured Mana Cake", sell_in: 3, quality: 6) }
  subject { described_class.new(items) }

  describe "#update_quality" do
    it "does not change the name" do
      item = double(Item, name: "foo", sell_in: 0, quality: 0)
      items = [item]
      gilded_rose = GildedRose.new(items)
      allow(item).to receive(:sell_in=)
      gilded_rose.update_quality()
      
      expect(items[0].name).to eq "foo"
    end

  end
end
