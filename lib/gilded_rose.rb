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

      if brie?(item)
        change_quality_of_brie(item)
      elsif backstage_pass?(item)
        change_quality_of_backstage_pass(item)
      else # regular item
        change_quality_of_regular(item)
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

  def change_quality_of_brie(item)
    increase_quality(item)
    increase_quality(item) if passed_sell_by_date?(item)
  end

  def days_to_concert_less_than_5?(item)
    get_sell_in(item) <= DAYS_TO_CONCERT_CLOSER
  end

  def days_to_concert_less_than_10?(item)
    get_sell_in(item) <= DAYS_TO_CONCERT_CLOSE
  end

  def change_quality_of_backstage_pass(item)
    if passed_sell_by_date?(item)
      make_quality_0(item)
    elsif days_to_concert_less_than_5?(item)
      3.times { increase_quality(item) }
    elsif days_to_concert_less_than_10?(item)
      2.times { increase_quality(item) }
    else # days to concert > 10
      increase_quality(item)
    end
  end

  def change_quality_of_regular(item)
    decrease_quality(item) if passed_sell_by_date?(item)
    decrease_quality(item)
  end
end
