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

      it "does not change the quality of an item beyond 50" do
        aged_brie = double(Item, name: "Aged Brie", sell_in: 2, quality: 50, 'sell_in=': 'sell in changed', 'quality=': 'quality changed')
        items = [aged_brie]
        subject = described_class.new(items)
        
        expect(aged_brie).not_to receive(:quality=)
        subject.update_quality()
      end
    end

    context "special item - Sulfuras, Hand of Ragnaros" do
      let(:sulfuras) { double(Item, name: "Sulfuras, Hand of Ragnaros", sell_in: 0, quality: 80, 'sell_in=': 'sell in changed', 'quality=': 'quality changed') }
      let(:items) { [sulfuras] }
      subject { described_class.new(items) }

      it "does not change the sell_in days" do
        expect(sulfuras).not_to receive(:sell_in=)
        subject.update_quality()
      end

      it "does not change the quality" do
        expect(sulfuras).not_to receive(:quality=)
        subject.update_quality()
      end
    end

    context "special item - Backstage passes" do
      it "amends the quality of an item by +1 when the sell_in is greater than 10" do
        backstage_pass = double(Item, name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 15, quality: 20, 'sell_in=': 'sell in changed', 'quality=': 'quality changed')
        items = [backstage_pass]
        subject = described_class.new(items)
        
        expect(backstage_pass).to receive(:quality=).with(backstage_pass.quality + 1)
        subject.update_quality()
      end

      it "amends the quality of an item by +2 when the sell_in is 10" do
        backstage_pass = double(Item, name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 10, 'sell_in=': 'sell in changed', 'quality=': 'quality changed')
        allow(backstage_pass).to receive(:quality).and_return(20, 21)
        items = [backstage_pass]
        subject = described_class.new(items)
        
        expect(backstage_pass).to receive(:quality=).with(22)
        subject.update_quality()
      end

      it "amends the quality of an item by +3 when the sell_in is 5" do
        backstage_pass = double(Item, name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 5, 'sell_in=': 'sell in changed', 'quality=': 'quality changed')
        allow(backstage_pass).to receive(:quality).and_return(20, 21, 22)
        items = [backstage_pass]
        subject = described_class.new(items)
        
        expect(backstage_pass).to receive(:quality=).with(23)
        subject.update_quality()
      end

      it "amends the quality to 0 when the sell_in is 0" do
        backstage_pass = double(Item, name: "Backstage passes to a TAFKAL80ETC concert", quality: 50, 'sell_in=': 'sell in changed', 'quality=': 'quality changed')
        allow(backstage_pass).to receive(:sell_in).and_return(0, -1)
        items = [backstage_pass]
        subject = described_class.new(items)
        
        expect(backstage_pass).to receive(:quality=).with(0)
        subject.update_quality()
      end
    end
  end
end
