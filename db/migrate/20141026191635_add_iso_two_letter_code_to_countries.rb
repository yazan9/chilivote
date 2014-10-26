class AddIsoTwoLetterCodeToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :iso_two_letter_code, :string
  end
end
