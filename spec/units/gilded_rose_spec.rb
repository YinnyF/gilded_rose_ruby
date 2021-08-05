require 'gilded_rose'

describe GildedRose do

  describe "#update_quality" do
    it "does not change the name" do
      item = double(Item, name: "foo", sell_in: 0, quality: 0)
      items = [item]
      gilded_rose = GildedRose.new(items)
      allow(item).to receive(:sell_in=)
      gilded_rose.update_quality()
      
      expect(items[0].name).to eq "foo"
    end

    context "a regular item (nothing special)" do
      let(:regular_item) { double(Item, name: "+5 Dexterity Vest", sell_in: 10, quality: 20, 'sell_in=': 'sell in changed', 'quality=': 'quality changed') }
      let(:items) { [regular_item] }
      subject { described_class.new(items) }

      it "amends the sell_in value of an item by -1" do
        expect(regular_item).to receive(:sell_in=).with(regular_item.sell_in - 1)
        subject.update_quality()
      end

      it "amends the quality of an item by -1" do
        expect(regular_item).to receive(:quality=).with(regular_item.quality - 1)
        subject.update_quality()
      end

      it "amends the quality of an item by -2 once the sell by date has passed" do
        regular_item_2 = double(Item, name: "+5 Dexterity Vest", sell_in: 0, 'sell_in=': 'sell in changed', 'quality=': 'quality changed')
        allow(regular_item_2).to receive(:quality).and_return(20, 19)
        items_2 = [regular_item_2]
        gilded_rose = GildedRose.new(items_2)

        expect(regular_item_2).to receive(:quality=).with(18)
        gilded_rose.update_quality() 
      end

      it "the quality of an item is not reduced beyond 0" do
        regular_item_3 = double(Item, name: "+5 Dexterity Vest", sell_in: 30, quality: 0, 'sell_in=': 'sell in changed', 'quality=': 'quality changed')
        items_3 = [regular_item_3]
        gilded_rose = GildedRose.new(items_3)

        expect(regular_item_3).not_to receive(:quality=)
        gilded_rose.update_quality() 
      end
    end

    context "special item - Aged Brie" do
      it "amends the quality by +1" do
        aged_brie = double(Item, name: "Aged Brie", sell_in: 2, quality: 0, 'sell_in=': 'sell in changed', 'quality=': 'quality changed')
        items = [aged_brie]
        subject = described_class.new(items)
        
        expect(aged_brie).to receive(:quality=).with(aged_brie.quality + 1)
        subject.update_quality()
      end

      it "the quality of an item is not increased beyond 50" do
        aged_brie = double(Item, name: "Aged Brie", sell_in: 2, quality: 50, 'sell_in=': 'sell in changed', 'quality=': 'quality changed')
        items = [aged_brie]
        subject = described_class.new(items)
        
        expect(aged_brie).not_to receive(:quality=)
        subject.update_quality()
      end
    end

  end
end
