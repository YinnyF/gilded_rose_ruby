require_relative 'item'

class GildedRose
  MAX_QUALITY = 50

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if !brie?(item) and !backstage_pass?(item)
        if get_quality(item) > 0
          if !sulfuras?(item)
            decrease_quality(item)
          end
        end
      else
        if less_than_max_quality(item)
          increase_quality(item)
          if backstage_pass?(item)
            if get_sell_in(item) < 11
              if less_than_max_quality(item)
                increase_quality(item)
              end
            end
            if get_sell_in(item) < 6
              if less_than_max_quality(item)
                increase_quality(item)
              end
            end
          end
        end
      end
      if !sulfuras?(item)
        decrease_sell_in(item)
      end
      if get_sell_in(item) < 0
        if !brie?(item)
          if !backstage_pass?(item)
            if get_quality(item) > 0
              if !sulfuras?(item)
                decrease_quality(item)
              end
            end
          else
            item.quality = 0
          end
        else
          if less_than_max_quality(item)
            increase_quality(item)
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
    item.quality += 1
  end

  def decrease_quality(item)
    item.quality -= 1
  end

  def get_sell_in(item)
    item.sell_in
  end

  def decrease_sell_in(item)
    item.sell_in -= 1
  end

  def less_than_max_quality(item)
    get_quality(item) < MAX_QUALITY
  end

  def brie?(item)
    item.name == "Aged Brie"
  end

  def sulfuras?(item)
    item.name == "Sulfuras, Hand of Ragnaros"
  end

  def backstage_pass?(item)
    item.name == "Backstage passes to a TAFKAL80ETC concert"
  end
end