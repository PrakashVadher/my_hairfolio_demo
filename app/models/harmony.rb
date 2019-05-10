class Harmony < ApplicationRecord
  belongs_to :line
  validates_presence_of :line, :name
  has_many :colors

  def ordered_colors
    hash = colors.map { |c|
      {
        id: c.id,
        code: c.code,
        first_digit_or_number: c.code.split(/^([a-zA-Z]{1,}|\d{1,}\.\d{1,}|\d{1,})/).reject { |a| a.empty? }.first,
        last_digit_or_number: c.code.split(/([a-zA-Z]{1,}|\d{1,}\.\d{1,}|\d{1,})$/).reject { |a| a.empty? }.first
      }
    }
    colors_ids = hash.sort_by { |c|
      [c[:first_digit_or_number].to_f, c[:last_digit_or_number].to_f]
    }.reverse.map { |a| a[:id] }

    Color.find(colors_ids).index_by(&:id).slice(*colors_ids).values
  end
end
