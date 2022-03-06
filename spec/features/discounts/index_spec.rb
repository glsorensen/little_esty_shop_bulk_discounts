require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index' do
  before(:each) do
    @merchant1 = create(:merchant)

    @discount1 = create(:discount, merchant_id: @merchant1.id )
    @discount2 = create(:discount, merchant_id: @merchant1.id )
    @discount3 = create(:discount, merchant_id: @merchant1.id )
    @discount4 = create(:discount, merchant_id: @merchant1.id )
  end

  describe 'User Story 1' do
    it 'I am taken to bulk discounts index and see see all discounts with attributes' do
      visit merchant_discounts_path(@merchant1)
      expect(current_path).to eq(merchant_discounts_path(@merchant1))

      within 'div.discount_list' do
        expect(page).to have_link(@discount1.name)
        expect(page).to have_link(@discount2.name)
        expect(page).to have_link(@discount3.name)
        expect(page).to have_link(@discount4.name)
      end
    end

    it 'I am taken to bulk discounts index and see see all discounts with attributes' do
      visit merchant_discounts_path(@merchant1)
      expect(current_path).to eq(merchant_discounts_path(@merchant1))

      within 'div.discount_list' do
        click_on @discount1.name
      end
      expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))

      within 'div.title' do
        expect(page).to have_content(@discount1.name)
      end
    end
    describe 'User Story 2' do
      describe 'it has a section with a header "Upcoming Holidays" and lists next 3 US holidays' do
        it 'has a section with header "Upcoming Holidays"' do
          visit merchant_discounts_path(@merchant1)
          expect(current_path).to eq(merchant_discounts_path(@merchant1))

          within 'div.upcoming_holidays' do
            expect(page).to have_content("Upcoming Holidays")
          end
        end

        it 'within this section - it lists the next 3 US holidays' do
          visit merchant_discounts_path(@merchant1)
          expect(current_path).to eq(merchant_discounts_path(@merchant1))


          within 'div.holiday_0' do
            expect(page).to have_content(HolidayService.holiday_info[0].name)
            expect(page).to have_content(HolidayService.holiday_info[0].date)
          end

          within 'div.holiday_1' do
            expect(page).to have_content(HolidayService.holiday_info[1].name)
            expect(page).to have_content(HolidayService.holiday_info[1].date)
          end

          within 'div.holiday_2' do
            expect(page).to have_content(HolidayService.holiday_info[2].name)
            expect(page).to have_content(HolidayService.holiday_info[2].date)
            save_and_open_page
          end
        end
      end
    end
  end
end