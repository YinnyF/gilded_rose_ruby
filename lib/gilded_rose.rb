require_relative 'item'

class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if item.name != "Aged Brie" and item.name != "Backstage passes to a TAFKAL80ETC concert"
        if get_quality(item) > 0
          if item.name != "Sulfuras, Hand of Ragnaros"
            decrease_quality(item)
          end
        end
      else
        if get_quality(item) < 50
          increase_quality(item)
          if item.name == "Backstage passes to a TAFKAL80ETC concert"
            if item.sell_in < 11
              if get_quality(item) < 50
                increase_quality(item)
              end
            end
            if item.sell_in < 6
              if get_quality(item) < 50
                increase_quality(item)
              end
            end
          end
        end
      end
      if item.name != "Sulfuras, Hand of Ragnaros"
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < 0
        if item.name != "Aged Brie"
          if item.name != "Backstage passes to a TAFKAL80ETC concert"
            if get_quality(item) > 0
              if item.name != "Sulfuras, Hand of Ragnaros"
                decrease_quality(item)
              end
            end
          else
            item.quality = get_quality(item) - get_quality(item)
          end
        else
          if item.quality < 50
            increase_quality(item)
          end
        end
      end
    end
  end
end

private

def get_quality(item)
  item.quality
end

def increase_quality(item)
  item.quality = get_quality(item) + 1
end

def decrease_quality(item)
  item.quality = get_quality(item) - 1
end