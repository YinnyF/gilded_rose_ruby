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
    end

  end
end
