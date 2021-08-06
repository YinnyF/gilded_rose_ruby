require_relative 'item'

class GildedRose
  MAX_QUALITY = 50
  # Consider renaming 🤔
  DAYS_TO_CONCERT_CLOSE = 10
  DAYS_TO_CONCERT_CLOSER = 5

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      next if sulfuras?(item)

      decrease_sell_in(item)

      if !brie?(item) and !backstage_pass?(item)
        decrease_quality(item)
      else        
        increase_quality(item)
        
        if backstage_pass?(item)
          if get_sell_in(item) <= DAYS_TO_CONCERT_CLOSE
            increase_quality(item)
          end
          if get_sell_in(item) <= DAYS_TO_CONCERT_CLOSER
            increase_quality(item)
          end
        end

      end

      if passed_sell_by_date?(item)
        if brie?(item)
          increase_quality(item)
        elsif backstage_pass?(item)
          make_quality_0(item)
        else
          decrease_quality(item)
        end
      end

    end
  end

  private

  def get_quality(item)
    item.quality
  end

  def less_than_max_quality(item)
    get_quality(item) < MAX_QUALITY
  end

  def increase_quality(item)
    return unless less_than_max_quality(item)

    item.quality += 1
  end

  def non_zero_quality?(item)
    get_quality(item) > 0
  end

  def decrease_quality(item)
    return unless non_zero_quality?(item)

    item.quality -= 1
  end

  def make_quality_0(item)
    item.quality = 0
  end

  def get_sell_in(item)
    item.sell_in
  end

  def decrease_sell_in(item)
    item.sell_in -= 1
  end

  def passed_sell_by_date?(item)
    get_sell_in(item) < 0
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
