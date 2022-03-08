require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    it "total_revenue" do
      @customer1= create(:customer)

      @merchant1 = create(:merchant)

      @item1 = create(:item, unit_price: 10, merchant_id: @merchant1.id)
      @item2 = create(:item, unit_price: 5, merchant_id: @merchant1.id)

      @invoice1 = create(:invoice, status: 2, customer_id: @customer1.id)

      @invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, unit_price: 10, quantity: 10, status: 2)
      @invoice_item2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item2.id, unit_price: 5, quantity: 5, status: 2)

      expect(@invoice1.total_revenue).to eq(125)
    end
  end

  describe '.discounted_revenue' do
    before(:each) do
      @customer1= create(:customer)

      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)

      @discount1 = create(:discount, merchant_id: @merchant1.id, threshold: 10, percent_discount: 50)
      @discount2 = create(:discount, merchant_id: @merchant1.id, threshold: 5 )
      @discount3 = create(:discount, merchant_id: @merchant1.id, threshold: 20, percent_discount: 60)
      @discount4 = create(:discount, merchant_id: @merchant2.id, threshold: 5, percent_discount: 60)

      @item1 = create(:item, unit_price: 10, merchant_id: @merchant1.id)
      @item2 = create(:item, unit_price: 5, merchant_id: @merchant1.id)
      @item3 = create(:item, unit_price: 10, merchant_id: @merchant2.id)

      @invoice1 = create(:invoice, status: 2, customer_id: @customer1.id)

      
      @invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, unit_price: 10, quantity: 10, status: 2)
      @invoice_item2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item2.id, unit_price: 5, quantity: 5, status: 2)
      @invoice_item3 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item3.id, unit_price: 5, quantity: 5, status: 2)
    end

    it '.merchant_revenue, total revenue without discount per merchant' do
      expect(@invoice1.total_revenue).to eq(150)
      expect(@invoice1.merchant_revenue(@merchant1)).to eq(125)
    end

    it '.discount_off, provides amount to be removed due to discount' do
      expect(@invoice1.merchant_discount(@merchant1)).to eq(55)
    end

    it '.discounted_revenue_for_merchant, discounted revenue if applies' do
      expect(@invoice1.merchant_discounted_revenue(@merchant1)).to eq(70)
    end
  end
end
